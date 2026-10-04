<?php

namespace App\Observers;

use App\Models\Meal;
use App\Services\Dashboard\DashboardService;

class MealObserver
{
    public function __construct(protected DashboardService $dashboardService) {}

    public function saved(Meal $meal): void
    {
        $date = $meal->meal_date?->toDateString();
        if ($date && $meal->user_id) {
            $this->dashboardService->refreshDailySummary($meal->user_id, $date);
        }
    }

    public function deleted(Meal $meal): void
    {
        $date = $meal->meal_date?->toDateString();
        if ($date && $meal->user_id) {
            $this->dashboardService->refreshDailySummary($meal->user_id, $date);
        }
    }
}
