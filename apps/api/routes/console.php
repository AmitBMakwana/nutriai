<?php

use App\Console\Commands\RebuildDailySummaries;
use Illuminate\Foundation\Inspiring;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\Schedule;

Artisan::command('inspire', function () {
    $this->comment(Inspiring::quote());
})->purpose('Display an inspiring quote');

// Nightly rebuild of daily_summaries for all users to fill gaps
Schedule::command(RebuildDailySummaries::class, ['--days=2'])
    ->dailyAt('01:00')
    ->withoutOverlapping()
    ->runInBackground();
