<?php

namespace App\Http\Controllers\Admin;

use App\Enums\AiAnalysisStatus;
use App\Http\Controllers\Controller;
use App\Models\AiAnalysis;
use App\Models\Food;
use App\Models\Meal;
use App\Models\Subscription;
use App\Models\User;
use Illuminate\Http\Request;

class DashboardController extends Controller
{
    public function index()
    {
        // 1. User stats
        $totalUsers = User::count();
        $newUsersThisWeek = User::where('created_at', '>=', now()->subDays(7))->count();
        $disabledUsers = User::where('is_disabled', true)->count();

        // 2. Meal stats
        $totalMeals = Meal::count();
        $mealsToday = Meal::whereDate('meal_date', today())->count();

        // 3. AI Scan stats & success rate
        $totalScans = AiAnalysis::count();
        $completedScans = AiAnalysis::where('status', AiAnalysisStatus::COMPLETED)->count();
        $failedScans = AiAnalysis::where('status', AiAnalysisStatus::FAILED)->count();
        $aiSuccessRate = $totalScans > 0 ? round(($completedScans / $totalScans) * 100, 1) : 100.0;

        // 4. Subscriptions & Revenue placeholder
        $activeProSubs = Subscription::where('status', 'active')->where('plan', 'pro')->count();
        $activePremiumSubs = Subscription::where('status', 'active')->where('plan', 'premium')->count();
        $mrrPlaceholder = ($activeProSubs * 9.99) + ($activePremiumSubs * 19.99);

        // 5. Recent items
        $recentUsers = User::latest()->take(5)->get();
        $recentScans = AiAnalysis::with('user')->latest()->take(5)->get();

        return view('admin.dashboard', compact(
            'totalUsers',
            'newUsersThisWeek',
            'disabledUsers',
            'totalMeals',
            'mealsToday',
            'totalScans',
            'completedScans',
            'failedScans',
            'aiSuccessRate',
            'activeProSubs',
            'activePremiumSubs',
            'mrrPlaceholder',
            'recentUsers',
            'recentScans'
        ));
    }
}
