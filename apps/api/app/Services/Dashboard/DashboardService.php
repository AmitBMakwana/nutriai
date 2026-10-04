<?php

namespace App\Services\Dashboard;

use App\Enums\MealType;
use App\Models\DailySummary;
use App\Models\Meal;
use App\Models\NutritionGoal;
use App\Models\User;
use App\Models\WaterLog;
use Carbon\Carbon;

class DashboardService
{
    /**
     * Get aggregated dashboard data for the user on a specific date.
     */
    public function getDashboardData(User $user, ?string $date = null): array
    {
        $timezone = $user->timezone ?: 'UTC';

        // Normalize date in user's timezone if null or invalid
        if (!$date || !Carbon::hasFormat($date, 'Y-m-d')) {
            $date = Carbon::now($timezone)->toDateString();
        } else {
            $date = Carbon::parse($date)->toDateString();
        }

        // Retrieve cached summary or compute if not existing
        $summary = DailySummary::where('user_id', $user->id)
            ->whereDate('summary_date', $date)
            ->first();

        if (!$summary) {
            $summary = $this->refreshDailySummary($user->id, $date);
        }

        // Active nutrition goal for date
        $goal = NutritionGoal::where('user_id', $user->id)
            ->whereDate('effective_from', '<=', $date)
            ->latest('effective_from')
            ->latest('id')
            ->first();

        $calorieTarget = $goal ? $goal->daily_calories : 2000;
        $proteinTarget = $goal ? $goal->protein_grams : 150;
        $carbsTarget = $goal ? $goal->carbs_grams : 200;
        $fatTarget = $goal ? $goal->fat_grams : 67;
        $waterTarget = $goal ? $goal->water_ml : 2500;

        $caloriesConsumed = (int) ($summary->calories ?? 0);
        $proteinConsumed = (float) ($summary->protein ?? 0);
        $carbsConsumed = (float) ($summary->carbs ?? 0);
        $fatConsumed = (float) ($summary->fat ?? 0);
        $waterConsumed = (int) ($summary->water_ml ?? 0);

        // Fetch meals for date grouped by meal type
        $meals = Meal::with('items')
            ->where('user_id', $user->id)
            ->whereDate('meal_date', $date)
            ->orderBy('meal_time')
            ->get();

        $groupedMeals = [];
        foreach (MealType::cases() as $type) {
            $typeKey = $type->value;
            $typeMeals = $meals->where('meal_type', $type);

            $groupedMeals[$typeKey] = [
                'type' => $typeKey,
                'calories' => (int) $typeMeals->sum('total_calories'),
                'protein' => round((float) $typeMeals->sum('total_protein'), 1),
                'carbs' => round((float) $typeMeals->sum('total_carbs'), 1),
                'fat' => round((float) $typeMeals->sum('total_fat'), 1),
                'meals' => $typeMeals->values()->map(function (Meal $m) {
                    return [
                        'id' => $m->id,
                        'meal_type' => $m->meal_type->value ?? $m->meal_type,
                        'meal_date' => $m->meal_date->toDateString(),
                        'meal_time' => $m->meal_time,
                        'total_calories' => $m->total_calories,
                        'total_protein' => (float) $m->total_protein,
                        'total_carbs' => (float) $m->total_carbs,
                        'total_fat' => (float) $m->total_fat,
                        'total_fiber' => (float) $m->total_fiber,
                        'source' => $m->source,
                        'image_path' => $m->image_path,
                        'items' => $m->items,
                    ];
                })->toArray(),
            ];
        }

        return [
            'date' => $date,
            'calories' => [
                'target' => $calorieTarget,
                'consumed' => $caloriesConsumed,
                'remaining' => $calorieTarget - $caloriesConsumed,
                'percentage' => $calorieTarget > 0 ? round(($caloriesConsumed / $calorieTarget) * 100, 1) : 0.0,
            ],
            'macros' => [
                'protein' => [
                    'target' => $proteinTarget,
                    'consumed' => $proteinConsumed,
                    'remaining' => max(0.0, round($proteinTarget - $proteinConsumed, 1)),
                    'percentage' => $proteinTarget > 0 ? round(($proteinConsumed / $proteinTarget) * 100, 1) : 0.0,
                ],
                'carbs' => [
                    'target' => $carbsTarget,
                    'consumed' => $carbsConsumed,
                    'remaining' => max(0.0, round($carbsTarget - $carbsConsumed, 1)),
                    'percentage' => $carbsTarget > 0 ? round(($carbsConsumed / $carbsTarget) * 100, 1) : 0.0,
                ],
                'fat' => [
                    'target' => $fatTarget,
                    'consumed' => $fatConsumed,
                    'remaining' => max(0.0, round($fatTarget - $fatConsumed, 1)),
                    'percentage' => $fatTarget > 0 ? round(($fatConsumed / $fatTarget) * 100, 1) : 0.0,
                ],
            ],
            'water' => [
                'target' => $waterTarget,
                'consumed' => $waterConsumed,
                'remaining' => max(0, $waterTarget - $waterConsumed),
                'percentage' => $waterTarget > 0 ? round(($waterConsumed / $waterTarget) * 100, 1) : 0.0,
            ],
            'meals' => $groupedMeals,
        ];
    }

    /**
     * Recalculate and update the daily_summaries cache row for a given user and date.
     */
    public function refreshDailySummary(int $userId, string $dateString): DailySummary
    {
        $user = User::find($userId);
        $timezone = $user?->timezone ?: 'UTC';

        // Calculate water for date within user's timezone
        $startOfDay = Carbon::createFromFormat('Y-m-d', $dateString, $timezone)->startOfDay()->setTimezone('UTC');
        $endOfDay = Carbon::createFromFormat('Y-m-d', $dateString, $timezone)->endOfDay()->setTimezone('UTC');

        $waterConsumed = (int) WaterLog::where('user_id', $userId)
            ->whereBetween('logged_at', [$startOfDay, $endOfDay])
            ->sum('amount_ml');

        $meals = Meal::where('user_id', $userId)
            ->whereDate('meal_date', $dateString)
            ->get();

        $calories = (int) $meals->sum('total_calories');
        $protein = round((float) $meals->sum('total_protein'), 1);
        $carbs = round((float) $meals->sum('total_carbs'), 1);
        $fat = round((float) $meals->sum('total_fat'), 1);
        $fiber = round((float) $meals->sum('total_fiber'), 1);

        $summary = DailySummary::where('user_id', $userId)
            ->whereDate('summary_date', $dateString)
            ->first();

        if (!$summary) {
            $summary = new DailySummary();
            $summary->user_id = $userId;
            $summary->summary_date = $dateString;
        }

        $summary->calories = $calories;
        $summary->protein = $protein;
        $summary->carbs = $carbs;
        $summary->fat = $fat;
        $summary->fiber = $fiber;
        $summary->water_ml = $waterConsumed;
        $summary->save();

        return $summary;
    }
}
