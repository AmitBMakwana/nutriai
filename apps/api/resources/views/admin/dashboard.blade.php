@extends('admin.layouts.app')

@section('content')
<div class="space-y-8">
    <!-- Page Header -->
    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
            <h1 class="text-2xl font-bold text-white tracking-tight">System Dashboard</h1>
            <p class="text-sm text-slate-400 mt-1">Real-time telemetry, user adoption, AI pipeline performance, and platform health.</p>
        </div>
        <div class="flex items-center gap-3">
            <a href="{{ route('admin.ai.settings') }}" class="px-3.5 py-2 rounded-xl bg-slate-800 hover:bg-slate-700 text-sm font-medium text-slate-200 border border-slate-700 transition flex items-center gap-2">
                <svg class="w-4 h-4 text-emerald-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6V4m0 2a2 2 0 100 4m0-4a2 2 0 110 4m-6 8a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4m6 6v10m6-2a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4"/></svg>
                AI Settings
            </a>
            <a href="{{ route('admin.foods.create') }}" class="px-3.5 py-2 rounded-xl bg-emerald-500 hover:bg-emerald-600 text-sm font-semibold text-white transition shadow-lg shadow-emerald-500/20 flex items-center gap-2">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/></svg>
                Add Food
            </a>
        </div>
    </div>

    <!-- KPI Metric Cards Grid -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-5">
        <!-- Users Card -->
        <div class="bg-slate-900 border border-slate-800 rounded-2xl p-5 shadow-sm">
            <div class="flex items-center justify-between text-slate-400 mb-3">
                <span class="text-xs font-semibold uppercase tracking-wider">Total Users</span>
                <div class="w-8 h-8 rounded-lg bg-blue-500/10 text-blue-400 flex items-center justify-center">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/></svg>
                </div>
            </div>
            <div class="text-2xl font-extrabold text-white">{{ number_format($totalUsers) }}</div>
            <div class="mt-2 text-xs text-slate-400 flex items-center gap-1">
                <span class="text-emerald-400 font-semibold">+{{ $newUsersThisWeek }}</span> this week
                @if($disabledUsers > 0)
                    <span class="ml-auto text-rose-400 font-semibold">{{ $disabledUsers }} disabled</span>
                @endif
            </div>
        </div>

        <!-- Meals Card -->
        <div class="bg-slate-900 border border-slate-800 rounded-2xl p-5 shadow-sm">
            <div class="flex items-center justify-between text-slate-400 mb-3">
                <span class="text-xs font-semibold uppercase tracking-wider">Meals Logged</span>
                <div class="w-8 h-8 rounded-lg bg-emerald-500/10 text-emerald-400 flex items-center justify-center">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"/></svg>
                </div>
            </div>
            <div class="text-2xl font-extrabold text-white">{{ number_format($totalMeals) }}</div>
            <div class="mt-2 text-xs text-slate-400">
                <span class="text-emerald-400 font-semibold">{{ $mealsToday }}</span> logged today
            </div>
        </div>

        <!-- AI Scans Card -->
        <div class="bg-slate-900 border border-slate-800 rounded-2xl p-5 shadow-sm">
            <div class="flex items-center justify-between text-slate-400 mb-3">
                <span class="text-xs font-semibold uppercase tracking-wider">AI Scans</span>
                <div class="w-8 h-8 rounded-lg bg-purple-500/10 text-purple-400 flex items-center justify-center">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z"/></svg>
                </div>
            </div>
            <div class="text-2xl font-extrabold text-white">{{ number_format($totalScans) }}</div>
            <div class="mt-2 text-xs text-slate-400 flex items-center gap-1">
                <span>{{ $completedScans }} completed</span>
                @if($failedScans > 0)
                    <span class="text-rose-400">({{ $failedScans }} err)</span>
                @endif
            </div>
        </div>

        <!-- AI Success Rate -->
        <div class="bg-slate-900 border border-slate-800 rounded-2xl p-5 shadow-sm">
            <div class="flex items-center justify-between text-slate-400 mb-3">
                <span class="text-xs font-semibold uppercase tracking-wider">AI Success Rate</span>
                <div class="w-8 h-8 rounded-lg bg-emerald-500/10 text-emerald-400 flex items-center justify-center">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                </div>
            </div>
            <div class="text-2xl font-extrabold text-white">{{ $aiSuccessRate }}%</div>
            <div class="mt-2 text-xs text-slate-400">
                Vision API response reliability
            </div>
        </div>

        <!-- Revenue Placeholder -->
        <div class="bg-slate-900 border border-slate-800 rounded-2xl p-5 shadow-sm">
            <div class="flex items-center justify-between text-slate-400 mb-3">
                <span class="text-xs font-semibold uppercase tracking-wider">MRR (Est.)</span>
                <div class="w-8 h-8 rounded-lg bg-amber-500/10 text-amber-400 flex items-center justify-center">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                </div>
            </div>
            <div class="text-2xl font-extrabold text-white">${{ number_format($mrrPlaceholder, 2) }}</div>
            <div class="mt-2 text-xs text-slate-400">
                <span class="text-amber-400 font-semibold">{{ $activeProSubs }} Pro</span>, {{ $activePremiumSubs }} Premium
            </div>
        </div>
    </div>

    <!-- Quick Overview Tables Grid -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <!-- Recent Users -->
        <div class="bg-slate-900 border border-slate-800 rounded-2xl p-6">
            <div class="flex items-center justify-between mb-4">
                <h2 class="text-base font-bold text-white">Recent Users</h2>
                <a href="{{ route('admin.users.index') }}" class="text-xs font-semibold text-emerald-400 hover:text-emerald-300">View All &rarr;</a>
            </div>
            <div class="divide-y divide-slate-800">
                @forelse($recentUsers as $user)
                    <div class="py-3 flex items-center justify-between">
                        <div class="flex items-center gap-3">
                            <div class="w-8 h-8 rounded-full bg-slate-800 text-slate-300 flex items-center justify-center font-bold text-xs">
                                {{ strtoupper(substr($user->name, 0, 1)) }}
                            </div>
                            <div>
                                <p class="text-sm font-semibold text-white">{{ $user->name }}</p>
                                <p class="text-xs text-slate-400">{{ $user->email }}</p>
                            </div>
                        </div>
                        <div class="flex items-center gap-2">
                            <span class="px-2 py-0.5 text-[11px] rounded-full {{ $user->is_disabled ? 'bg-rose-500/10 text-rose-400' : 'bg-emerald-500/10 text-emerald-400' }}">
                                {{ $user->is_disabled ? 'Disabled' : 'Active' }}
                            </span>
                            <a href="{{ route('admin.users.show', $user->id) }}" class="p-1 text-slate-400 hover:text-white">
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/></svg>
                            </a>
                        </div>
                    </div>
                @empty
                    <p class="py-4 text-sm text-slate-500 text-center">No users registered yet.</p>
                @endforelse
            </div>
        </div>

        <!-- Recent AI Scans -->
        <div class="bg-slate-900 border border-slate-800 rounded-2xl p-6">
            <div class="flex items-center justify-between mb-4">
                <h2 class="text-base font-bold text-white">Recent AI Meal Scans</h2>
                <a href="{{ route('admin.ai.usage') }}" class="text-xs font-semibold text-emerald-400 hover:text-emerald-300">View All Scans &rarr;</a>
            </div>
            <div class="divide-y divide-slate-800">
                @forelse($recentScans as $scan)
                    <div class="py-3 flex items-center justify-between">
                        <div>
                            <div class="flex items-center gap-2">
                                <span class="text-sm font-semibold text-white">{{ $scan->user->name ?? 'User #' . $scan->user_id }}</span>
                                <span class="text-[10px] font-mono px-1.5 py-0.5 rounded bg-slate-800 text-slate-400">{{ $scan->provider }}</span>
                            </div>
                            <p class="text-xs text-slate-400 mt-0.5">{{ $scan->created_at->diffForHumans() }} &bull; {{ $scan->processing_time_ms ? $scan->processing_time_ms . 'ms' : 'pending' }}</p>
                        </div>
                        <div>
                            @if($scan->status->value === 'completed')
                                <span class="px-2 py-0.5 text-[11px] rounded-full bg-emerald-500/10 text-emerald-400 font-medium">Completed</span>
                            @elseif($scan->status->value === 'failed')
                                <span class="px-2 py-0.5 text-[11px] rounded-full bg-rose-500/10 text-rose-400 font-medium">Failed</span>
                            @else
                                <span class="px-2 py-0.5 text-[11px] rounded-full bg-amber-500/10 text-amber-400 font-medium">Processing</span>
                            @endif
                        </div>
                    </div>
                @empty
                    <p class="py-4 text-sm text-slate-500 text-center">No scans executed yet.</p>
                @endforelse
            </div>
        </div>
    </div>
</div>
@endsection
