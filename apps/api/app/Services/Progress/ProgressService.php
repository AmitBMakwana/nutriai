<?php

namespace App\Services\Progress;

use App\Models\DailySummary;
use App\Models\NutritionGoal;
use App\Models\User;
use App\Models\WeightLog;
use App\Services\Dashboard\DashboardService;
use Carbon\Carbon;
use Carbon\CarbonPeriod;
use Illuminate\Support\Collection;

class ProgressService
{
    public function __construct(private readonly DashboardService $dashboardService) {}

    /**
     * Return progress data for the requested range.
     *
     * @param  User   $user
     * @param  string $range  7d | 30d | 3m | 6m | 1y
     */
    public function getProgress(User $user, string $range): array
    {
        [$startDate, $endDate] = $this->rangeToDates($range, $user->timezone ?: 'UTC');

        $summaries = $this->fetchSummaries($user->id, $startDate, $endDate);
        $goal      = $this->activeGoal($user, $endDate);
        $weights   = $this->fetchWeights($user->id, $startDate, $endDate);

        $calTarget = $goal?->daily_calories ?? 2000;
        $points    = $this->buildDailyPoints($summaries, $startDate, $endDate);

        $daysOnTarget = $points->filter(fn ($p) => $p['calories'] >= $calTarget * 0.85
            && $p['calories'] <= $calTarget * 1.15
            && $p['calories'] > 0
        )->count();

        $activeDays = $points->filter(fn ($p) => $p['calories'] > 0)->count();
        $streak     = $this->calculateStreak($user->id, $endDate, $user->timezone ?: 'UTC');

        return [
            'range'    => $range,
            'start'    => $startDate->toDateString(),
            'end'      => $endDate->toDateString(),
            'calories' => [
                'daily'   => $points->map(fn ($p) => [
                    'date'     => $p['date'],
                    'consumed' => $p['calories'],
                    'target'   => $calTarget,
                ])->values()->all(),
                'average' => $activeDays > 0
                    ? (int) round($points->sum('calories') / $activeDays)
                    : 0,
                'target'  => $calTarget,
            ],
            'macros' => [
                'average' => $this->macroAverages($points, $activeDays),
                'target'  => [
                    'protein' => $goal?->protein_grams ?? 150,
                    'carbs'   => $goal?->carbs_grams ?? 200,
                    'fat'     => $goal?->fat_grams ?? 67,
                ],
            ],
            'weight' => [
                'series'        => $weights->map(fn ($w) => [
                    'date'      => Carbon::parse($w->logged_at)->toDateString(),
                    'weight_kg' => (float) $w->weight_kg,
                ])->values()->all(),
                'start_kg'      => $weights->first()?->weight_kg,
                'current_kg'    => $weights->last()?->weight_kg,
                'target_kg'     => $user->profile?->target_weight_kg ?? null,
                'change_kg'     => $this->weightChange($weights),
            ],
            'meals_tracked'  => (int) $points->sum('meals_count'),
            'days_on_target' => $daysOnTarget,
            'active_days'    => $activeDays,
            'streak'         => $streak,
        ];
    }

    public function getWeeklySummary(User $user): array
    {
        $tz         = $user->timezone ?: 'UTC';
        $endDate    = Carbon::now($tz)->startOfDay();
        $startDate  = $endDate->copy()->subDays(6);

        $summaries = $this->fetchSummaries($user->id, $startDate, $endDate);
        $points    = $this->buildDailyPoints($summaries, $startDate, $endDate);
        $goal      = $this->activeGoal($user, $endDate);

        return [
            'week_start'    => $startDate->toDateString(),
            'week_end'      => $endDate->toDateString(),
            'days'          => $points->values()->all(),
            'totals'        => [
                'calories' => (int) $points->sum('calories'),
                'protein'  => round($points->sum('protein'), 1),
                'carbs'    => round($points->sum('carbs'), 1),
                'fat'      => round($points->sum('fat'), 1),
            ],
            'averages'      => $this->macroAverages($points, $points->filter(fn ($p) => $p['calories'] > 0)->count()),
            'calorie_target' => $goal?->daily_calories ?? 2000,
        ];
    }

    public function getMonthlySummary(User $user, int $year, int $month): array
    {
        $tz        = $user->timezone ?: 'UTC';
        $startDate = Carbon::createFromDate($year, $month, 1, $tz)->startOfDay();
        $endDate   = $startDate->copy()->endOfMonth()->startOfDay();

        $summaries = $this->fetchSummaries($user->id, $startDate, $endDate);
        $points    = $this->buildDailyPoints($summaries, $startDate, $endDate);
        $goal      = $this->activeGoal($user, $endDate);

        $activeDays = $points->filter(fn ($p) => $p['calories'] > 0)->count();
        $calTarget  = $goal?->daily_calories ?? 2000;

        return [
            'year'           => $year,
            'month'          => $month,
            'days'           => $points->values()->all(),
            'averages'       => $this->macroAverages($points, $activeDays),
            'calorie_target' => $calTarget,
            'days_on_target' => $points->filter(fn ($p) => $p['calories'] >= $calTarget * 0.85
                && $p['calories'] <= $calTarget * 1.15
                && $p['calories'] > 0
            )->count(),
            'active_days'    => $activeDays,
        ];
    }

    // ─── Helpers ────────────────────────────────────────────────────────────────

    private function rangeToDates(string $range, string $tz): array
    {
        $end   = Carbon::now($tz)->startOfDay();
        $start = match ($range) {
            '7d'  => $end->copy()->subDays(6),
            '30d' => $end->copy()->subDays(29),
            '3m'  => $end->copy()->subMonths(3)->addDay(),
            '6m'  => $end->copy()->subMonths(6)->addDay(),
            '1y'  => $end->copy()->subYear()->addDay(),
            default => $end->copy()->subDays(6),
        };

        return [$start, $end];
    }

    private function fetchSummaries(int $userId, Carbon $start, Carbon $end): Collection
    {
        return DailySummary::where('user_id', $userId)
            ->whereBetween('summary_date', [$start->toDateString(), $end->toDateString()])
            ->orderBy('summary_date')
            ->get()
            ->keyBy(fn ($s) => Carbon::parse($s->summary_date)->toDateString());
    }

    private function fetchWeights(int $userId, Carbon $start, Carbon $end): Collection
    {
        return WeightLog::where('user_id', $userId)
            ->whereBetween('logged_at', [$start->startOfDay(), $end->endOfDay()])
            ->orderBy('logged_at')
            ->get();
    }

    private function activeGoal(User $user, Carbon $date): ?NutritionGoal
    {
        return NutritionGoal::where('user_id', $user->id)
            ->whereDate('effective_from', '<=', $date->toDateString())
            ->latest('effective_from')
            ->latest('id')
            ->first();
    }

    private function buildDailyPoints(Collection $summaries, Carbon $start, Carbon $end): Collection
    {
        $period = CarbonPeriod::create($start, $end);
        $points = collect();

        foreach ($period as $day) {
            $dateStr = $day->toDateString();
            $summary = $summaries->get($dateStr);

            $points->push([
                'date'        => $dateStr,
                'calories'    => (int) ($summary?->calories ?? 0),
                'protein'     => (float) ($summary?->protein ?? 0),
                'carbs'       => (float) ($summary?->carbs ?? 0),
                'fat'         => (float) ($summary?->fat ?? 0),
                'fiber'       => (float) ($summary?->fiber ?? 0),
                'water_ml'    => (int) ($summary?->water_ml ?? 0),
                'meals_count' => 0,  // augmented below if needed
            ]);
        }

        return $points;
    }

    private function macroAverages(Collection $points, int $activeDays): array
    {
        if ($activeDays === 0) {
            return ['protein' => 0, 'carbs' => 0, 'fat' => 0, 'calories' => 0];
        }

        return [
            'calories' => (int) round($points->sum('calories') / $activeDays),
            'protein'  => round($points->sum('protein') / $activeDays, 1),
            'carbs'    => round($points->sum('carbs') / $activeDays, 1),
            'fat'      => round($points->sum('fat') / $activeDays, 1),
        ];
    }

    private function weightChange(Collection $weights): ?float
    {
        if ($weights->count() < 2) {
            return null;
        }

        return round((float) $weights->last()->weight_kg - (float) $weights->first()->weight_kg, 2);
    }

    private function calculateStreak(int $userId, Carbon $endDate, string $tz): int
    {
        $streak = 0;
        $day    = $endDate->copy();

        while (true) {
            $exists = DailySummary::where('user_id', $userId)
                ->whereDate('summary_date', $day->toDateString())
                ->where('calories', '>', 0)
                ->exists();

            if (!$exists) {
                break;
            }

            $streak++;
            $day->subDay();
        }

        return $streak;
    }
}
