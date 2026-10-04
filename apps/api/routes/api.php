<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\DashboardController;
use App\Http\Controllers\Api\FoodController;
use App\Http\Controllers\Api\MealController;
use App\Http\Controllers\Api\NutritionGoalController;
use App\Http\Controllers\Api\ProfileController;
use App\Http\Controllers\Api\ProgressController;
use App\Http\Controllers\Api\WaterController;
use App\Http\Controllers\Api\WeightController;
use App\Http\Controllers\Api\HealthCheckController;

Route::prefix('v1')->group(function () {
    Route::get('/health', [HealthCheckController::class, 'check']);

    Route::middleware('throttle:6,1')->group(function () {
        Route::post('/register', [AuthController::class, 'register']);
        Route::post('/login', [AuthController::class, 'login']);
        Route::post('/password/forgot', [AuthController::class, 'forgotPassword']);
        Route::post('/password/reset', [AuthController::class, 'resetPassword']);
    });

    Route::middleware(['auth:sanctum', \App\Http\Middleware\EnsureUserNotDisabled::class, 'throttle:120,1'])->group(function () {
        Route::get('/me', [AuthController::class, 'me']);
        Route::post('/logout', [AuthController::class, 'logout']);

        Route::post('/onboarding', [ProfileController::class, 'onboarding']);
        Route::get('/profile', [ProfileController::class, 'show']);
        Route::put('/profile', [ProfileController::class, 'update']);
        Route::post('/profile/avatar', [ProfileController::class, 'uploadAvatar']);
        Route::post('/password/change', [ProfileController::class, 'changePassword']);
        Route::put('/password', [ProfileController::class, 'changePassword']);
        Route::delete('/account', [ProfileController::class, 'deleteAccount']);

        Route::get('/goals', [NutritionGoalController::class, 'index']);
        Route::post('/goals/calculate', [NutritionGoalController::class, 'calculate']);
        Route::put('/goals', [NutritionGoalController::class, 'update']);

        Route::get('/dashboard', [DashboardController::class, 'index']);

        // Foods
        Route::get('/foods/search', [FoodController::class, 'search']);
        Route::get('/foods/favorites', [FoodController::class, 'favorites']);
        Route::post('/foods/custom', [FoodController::class, 'storeCustom']);
        Route::post('/foods/{id}/favorite', [FoodController::class, 'toggleFavorite']);

        // Meals
        Route::get('/meals', [MealController::class, 'index']);
        Route::post('/meals', [MealController::class, 'store']);
        Route::post('/meals/analyze', [\App\Http\Controllers\Api\AiAnalysisController::class, 'analyze'])->middleware('throttle:15,1');
        Route::get('/meals/{id}', [MealController::class, 'show']);
        Route::put('/meals/{id}', [MealController::class, 'update']);
        Route::delete('/meals/{id}', [MealController::class, 'destroy']);

        // AI Analysis
        Route::get('/ai-analysis/{id}', [\App\Http\Controllers\Api\AiAnalysisController::class, 'show']);

        // Water
        Route::get('/water', [WaterController::class, 'index']);
        Route::post('/water', [WaterController::class, 'store']);
        Route::delete('/water/{id?}', [WaterController::class, 'destroy']);

        // Weight
        Route::get('/weight', [WeightController::class, 'index']);
        Route::post('/weight', [WeightController::class, 'store']);
        Route::delete('/weight/{id}', [WeightController::class, 'destroy']);

        // Progress
        Route::get('/progress/weekly', [ProgressController::class, 'weekly']);
        Route::get('/progress/monthly', [ProgressController::class, 'monthly']);
        Route::get('/progress', [ProgressController::class, 'index']);

        // Subscription
        Route::get('/subscription', [\App\Http\Controllers\Api\SubscriptionController::class, 'show']);
    });

    // Public Webhooks (Rate limited)
    Route::post('/subscription/webhook', [\App\Http\Controllers\Api\SubscriptionController::class, 'webhook'])->middleware('throttle:120,1');
});

// Non-v1 aliases for webhook & subscription
Route::post('/subscription/webhook', [\App\Http\Controllers\Api\SubscriptionController::class, 'webhook']);
Route::middleware('auth:sanctum')->get('/subscription', [\App\Http\Controllers\Api\SubscriptionController::class, 'show']);

