<?php

use App\Http\Controllers\Admin\AdminAuthController;
use App\Http\Controllers\Admin\AdminController;
use App\Http\Controllers\Admin\AiSettingController;
use App\Http\Controllers\Admin\AiUsageController;
use App\Http\Controllers\Admin\AuditLogController;
use App\Http\Controllers\Admin\DashboardController;
use App\Http\Controllers\Admin\FoodController;
use App\Http\Controllers\Admin\MealController;
use App\Http\Controllers\Admin\SubscriptionController;
use App\Http\Controllers\Admin\SystemSettingController;
use App\Http\Controllers\Admin\UserController;
use App\Http\Middleware\AdminAuthenticate;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return redirect('/admin');
});

Route::get('/health', [\App\Http\Controllers\Api\HealthCheckController::class, 'check']);

// Admin Authentication Routes
Route::prefix('admin')->group(function () {
    Route::get('/login', [AdminAuthController::class, 'showLoginForm'])->name('admin.login');
    Route::post('/login', [AdminAuthController::class, 'login'])->name('admin.login.submit');
    Route::post('/logout', [AdminAuthController::class, 'logout'])->name('admin.logout');
});

// Protected Admin Portal Area
Route::prefix('admin')->middleware(['web', AdminAuthenticate::class])->name('admin.')->group(function () {
    Route::get('/', [DashboardController::class, 'index'])->name('dashboard');

    // Users
    Route::get('/users', [UserController::class, 'index'])->name('users.index');
    Route::get('/users/{id}', [UserController::class, 'show'])->name('users.show');
    Route::post('/users/{id}/toggle-status', [UserController::class, 'toggleStatus'])->name('users.toggle-status');

    // Foods Management
    Route::get('/foods', [FoodController::class, 'index'])->name('foods.index');
    Route::get('/foods/create', [FoodController::class, 'create'])->name('foods.create');
    Route::post('/foods', [FoodController::class, 'store'])->name('foods.store');
    Route::get('/foods/{id}/edit', [FoodController::class, 'edit'])->name('foods.edit');
    Route::put('/foods/{id}', [FoodController::class, 'update'])->name('foods.update');
    Route::delete('/foods/{id}', [FoodController::class, 'destroy'])->name('foods.destroy');
    Route::post('/foods/{id}/verify', [FoodController::class, 'verify'])->name('foods.verify');
    Route::post('/foods/import-csv', [FoodController::class, 'importCsv'])->name('foods.import-csv');

    // Meals (Read-Only)
    Route::get('/meals', [MealController::class, 'index'])->name('meals.index');
    Route::get('/meals/{id}', [MealController::class, 'show'])->name('meals.show');

    // AI Usage & Telemetry
    Route::get('/ai/usage', [AiUsageController::class, 'index'])->name('ai.usage');

    // AI Settings (Stored in DB, cached, read by API)
    Route::get('/ai/settings', [AiSettingController::class, 'index'])->name('ai.settings');
    Route::post('/ai/settings', [AiSettingController::class, 'update'])->name('ai.settings.update');

    // Subscriptions & Revenue
    Route::get('/subscriptions', [SubscriptionController::class, 'index'])->name('subscriptions.index');

    // System Settings & Maintenance
    Route::get('/system/settings', [SystemSettingController::class, 'index'])->name('system.settings');
    Route::post('/system/settings', [SystemSettingController::class, 'update'])->name('system.settings.update');
    Route::post('/system/clear-cache', [SystemSettingController::class, 'clearCache'])->name('system.clear-cache');

    // Audit Trail
    Route::get('/audit-logs', [AuditLogController::class, 'index'])->name('audit-logs.index');
});
