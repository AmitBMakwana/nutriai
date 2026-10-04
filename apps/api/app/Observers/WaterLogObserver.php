<?php

namespace App\Observers;

use App\Models\WaterLog;
use App\Services\Dashboard\DashboardService;
use Carbon\Carbon;

class WaterLogObserver
{
    public function __construct(protected DashboardService $dashboardService) {}

    public function saved(WaterLog $waterLog): void
    {
        $timezone = $waterLog->user?->timezone ?: 'UTC';
        $date = Carbon::parse($waterLog->logged_at)->setTimezone($timezone)->toDateString();
        if ($waterLog->user_id) {
            $this->dashboardService->refreshDailySummary($waterLog->user_id, $date);
        }
    }

    public function deleted(WaterLog $waterLog): void
    {
        $timezone = $waterLog->user?->timezone ?: 'UTC';
        $date = Carbon::parse($waterLog->logged_at)->setTimezone($timezone)->toDateString();
        if ($waterLog->user_id) {
            $this->dashboardService->refreshDailySummary($waterLog->user_id, $date);
        }
    }
}
