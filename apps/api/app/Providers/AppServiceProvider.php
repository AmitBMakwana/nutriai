<?php

namespace App\Providers;

use App\Models\Meal;
use App\Models\WaterLog;
use App\Observers\MealObserver;
use App\Observers\WaterLogObserver;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        $this->app->singleton(\App\Services\AI\AIProviderManager::class, function ($app) {
            return new \App\Services\AI\AIProviderManager($app);
        });

        $this->app->bind(\App\Services\AI\Contracts\FoodAnalysisProvider::class, function ($app) {
            return $app->make(\App\Services\AI\AIProviderManager::class)->driver();
        });

        $this->app->singleton(\App\Services\AI\ImageStorageService::class, function ($app) {
            return new \App\Services\AI\ImageStorageService();
        });
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        Meal::observe(MealObserver::class);
        WaterLog::observe(WaterLogObserver::class);
    }
}
