@extends('admin.layouts.app')

@section('content')
<div class="space-y-6">
    <!-- Header -->
    <div class="flex items-center justify-between">
        <div class="flex items-center gap-4">
            <a href="{{ route('admin.users.index') }}" class="p-2 rounded-xl bg-slate-800 hover:bg-slate-700 text-slate-400 hover:text-white transition">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/></svg>
            </a>
            <div>
                <h1 class="text-2xl font-bold text-white tracking-tight">{{ $user->name }}</h1>
                <p class="text-xs text-slate-400">User ID: #{{ $user->id }} &bull; Member since {{ $user->created_at->format('M d, Y') }}</p>
            </div>
        </div>
        <form method="POST" action="{{ route('admin.users.toggle-status', $user->id) }}">
            @csrf
            <button type="submit" class="px-4 py-2 rounded-xl text-sm font-semibold transition {{ $user->is_disabled ? 'bg-emerald-500 hover:bg-emerald-600 text-white' : 'bg-rose-500/20 text-rose-400 hover:bg-rose-500/30 border border-rose-500/30' }}">
                {{ $user->is_disabled ? 'Enable Account' : 'Disable Account' }}
            </button>
        </form>
    </div>

    <!-- User Overview Cards Grid -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        <!-- Account Info -->
        <div class="bg-slate-900 border border-slate-800 rounded-2xl p-6 space-y-4">
            <h3 class="text-sm font-bold text-white uppercase tracking-wider text-slate-400">Account Details</h3>
            <div class="space-y-2 text-sm">
                <div class="flex justify-between py-1 border-b border-slate-800"><span class="text-slate-400">Email</span><span class="text-white font-medium">{{ $user->email }}</span></div>
                <div class="flex justify-between py-1 border-b border-slate-800"><span class="text-slate-400">Timezone</span><span class="text-white font-medium">{{ $user->timezone }}</span></div>
                <div class="flex justify-between py-1 border-b border-slate-800"><span class="text-slate-400">Status</span><span class="font-semibold {{ $user->is_disabled ? 'text-rose-400' : 'text-emerald-400' }}">{{ $user->is_disabled ? 'Disabled' : 'Active' }}</span></div>
                <div class="flex justify-between py-1 border-b border-slate-800"><span class="text-slate-400">Plan</span><span class="text-amber-400 font-bold uppercase">{{ $user->isPro() ? 'Pro' : 'Free' }}</span></div>
                <div class="flex justify-between py-1"><span class="text-slate-400">Monthly Scans</span><span class="text-white">{{ $user->getMonthlyScanCount() }} / {{ $user->getMonthlyScanQuota() }}</span></div>
            </div>
        </div>

        <!-- Biometrics & Profile -->
        <div class="bg-slate-900 border border-slate-800 rounded-2xl p-6 space-y-4">
            <h3 class="text-sm font-bold text-white uppercase tracking-wider text-slate-400">Profile & Biometrics</h3>
            @if($user->profile)
                <div class="space-y-2 text-sm">
                    <div class="flex justify-between py-1 border-b border-slate-800"><span class="text-slate-400">Goal</span><span class="text-white font-medium">{{ ucfirst(str_replace('_', ' ', $user->profile->goal)) }}</span></div>
                    <div class="flex justify-between py-1 border-b border-slate-800"><span class="text-slate-400">Current Weight</span><span class="text-white font-medium">{{ $user->profile->weight_kg }} kg</span></div>
                    <div class="flex justify-between py-1 border-b border-slate-800"><span class="text-slate-400">Target Weight</span><span class="text-white font-medium">{{ $user->profile->target_weight_kg }} kg</span></div>
                    <div class="flex justify-between py-1 border-b border-slate-800"><span class="text-slate-400">Height</span><span class="text-white font-medium">{{ $user->profile->height_cm }} cm</span></div>
                    <div class="flex justify-between py-1"><span class="text-slate-400">Activity Level</span><span class="text-white font-medium">{{ ucfirst(str_replace('_', ' ', $user->profile->activity_level)) }}</span></div>
                </div>
            @else
                <p class="text-sm text-slate-500 py-4">Onboarding incomplete. No biometrics recorded.</p>
            @endif
        </div>

        <!-- Nutrition Goals -->
        <div class="bg-slate-900 border border-slate-800 rounded-2xl p-6 space-y-4">
            <h3 class="text-sm font-bold text-white uppercase tracking-wider text-slate-400">Active Goals</h3>
            @php $goal = $user->nutritionGoals->first(); @endphp
            @if($goal)
                <div class="space-y-2 text-sm">
                    <div class="flex justify-between py-1 border-b border-slate-800"><span class="text-slate-400">Daily Calories</span><span class="text-emerald-400 font-bold">{{ $goal->daily_calories }} kcal</span></div>
                    <div class="flex justify-between py-1 border-b border-slate-800"><span class="text-slate-400">Protein</span><span class="text-blue-400 font-semibold">{{ $goal->protein_grams }}g</span></div>
                    <div class="flex justify-between py-1 border-b border-slate-800"><span class="text-slate-400">Carbohydrates</span><span class="text-emerald-400 font-semibold">{{ $goal->carbs_grams }}g</span></div>
                    <div class="flex justify-between py-1 border-b border-slate-800"><span class="text-slate-400">Fat</span><span class="text-rose-400 font-semibold">{{ $goal->fat_grams }}g</span></div>
                    <div class="flex justify-between py-1"><span class="text-slate-400">Water Target</span><span class="text-cyan-400 font-semibold">{{ $goal->water_ml }} ml</span></div>
                </div>
            @else
                <p class="text-sm text-slate-500 py-4">No active nutrition goal recorded.</p>
            @endif
        </div>
    </div>

    <!-- Recent Meals and Scans -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <!-- Meals Logged -->
        <div class="bg-slate-900 border border-slate-800 rounded-2xl p-6">
            <h3 class="text-sm font-bold text-white mb-4">Recent Meals Logged</h3>
            <div class="divide-y divide-slate-800">
                @forelse($user->meals as $meal)
                    <div class="py-3 flex items-center justify-between text-sm">
                        <div>
                            <span class="font-semibold text-white capitalize">{{ $meal->meal_type }}</span>
                            <p class="text-xs text-slate-400">{{ $meal->meal_date }} &bull; {{ $meal->total_calories }} kcal</p>
                        </div>
                        <a href="{{ route('admin.meals.show', $meal->id) }}" class="text-xs text-emerald-400 hover:text-emerald-300">View &rarr;</a>
                    </div>
                @empty
                    <p class="text-sm text-slate-500 py-4">No meals logged yet.</p>
                @endforelse
            </div>
        </div>

        <!-- Recent AI Scans -->
        <div class="bg-slate-900 border border-slate-800 rounded-2xl p-6">
            <h3 class="text-sm font-bold text-white mb-4">Recent AI Scans</h3>
            <div class="divide-y divide-slate-800">
                @forelse($user->aiAnalyses as $scan)
                    <div class="py-3 flex items-center justify-between text-sm">
                        <div>
                            <span class="font-mono text-xs px-1.5 py-0.5 rounded bg-slate-800 text-slate-300">{{ $scan->provider }} ({{ $scan->model }})</span>
                            <p class="text-xs text-slate-400 mt-1">{{ $scan->created_at->diffForHumans() }} &bull; {{ $scan->processing_time_ms }}ms</p>
                        </div>
                        <span class="px-2 py-0.5 rounded-full text-xs font-semibold {{ $scan->status->value === 'completed' ? 'bg-emerald-500/10 text-emerald-400' : 'bg-rose-500/10 text-rose-400' }}">
                            {{ ucfirst($scan->status->value) }}
                        </span>
                    </div>
                @empty
                    <p class="text-sm text-slate-500 py-4">No AI scans performed yet.</p>
                @endforelse
            </div>
        </div>
    </div>
</div>
@endsection
