<?php

namespace App\Console\Commands;

use App\Models\User;
use App\Services\Dashboard\DashboardService;
use Carbon\Carbon;
use Carbon\CarbonPeriod;
use Illuminate\Console\Command;

class RebuildDailySummaries extends Command
{
    protected $signature = 'summaries:rebuild
                            {--days=30 : Number of past days to rebuild}
                            {--user= : Rebuild for a single user ID}
                            {--date= : Rebuild for a single date (Y-m-d)}';

    protected $description = 'Rebuild missing or stale daily_summaries rows from meals and water logs.';

    public function __construct(private readonly DashboardService $dashboardService)
    {
        parent::__construct();
    }

    public function handle(): int
    {
        $days   = (int) $this->option('days');
        $userId = $this->option('user');
        $date   = $this->option('date');

        $query = User::query();
        if ($userId) {
            $query->where('id', $userId);
        }

        $users = $query->get();
        $rebuilt = 0;

        foreach ($users as $user) {
            $tz = $user->timezone ?: 'UTC';

            if ($date) {
                $this->dashboardService->refreshDailySummary($user->id, $date);
                $rebuilt++;
                continue;
            }

            $end   = Carbon::now($tz)->startOfDay();
            $start = $end->copy()->subDays($days - 1);

            $period = CarbonPeriod::create($start, $end);

            foreach ($period as $day) {
                $this->dashboardService->refreshDailySummary($user->id, $day->toDateString());
                $rebuilt++;
            }
        }

        $this->info("Rebuilt {$rebuilt} summary row(s).");

        return self::SUCCESS;
    }
}
