@extends('admin.layouts.app')

@section('title', 'Meals (Read-Only)')

@section('content')
<div class="space-y-6">
    <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
        <div>
            <h1 class="text-2xl font-bold text-slate-900">Logged Meals</h1>
            <p class="text-sm text-slate-500">Read-only audit of meal logs, nutritional summaries, and AI photo analyses.</p>
        </div>
        <div class="text-xs bg-slate-100 text-slate-600 px-3 py-1.5 rounded-lg border border-slate-200">
            Read-Only Audit Mode
        </div>
    </div>

    <!-- Filter Form -->
    <div class="bg-white p-4 rounded-xl border border-slate-200 shadow-sm">
        <form method="GET" action="{{ route('admin.meals.index') }}" class="grid grid-cols-1 md:grid-cols-4 gap-4">
            <div>
                <input type="text" name="user" value="{{ request('user') }}" placeholder="Filter by User Name or Email..." class="w-full text-sm border-slate-300 rounded-lg">
            </div>
            <div>
                <select name="type" class="w-full text-sm border-slate-300 rounded-lg">
                    <option value="">All Meal Types</option>
                    <option value="breakfast" {{ request('type') === 'breakfast' ? 'selected' : '' }}>Breakfast</option>
                    <option value="lunch" {{ request('type') === 'lunch' ? 'selected' : '' }}>Lunch</option>
                    <option value="dinner" {{ request('type') === 'dinner' ? 'selected' : '' }}>Dinner</option>
                    <option value="snack" {{ request('type') === 'snack' ? 'selected' : '' }}>Snack</option>
                </select>
            </div>
            <div>
                <input type="date" name="date" value="{{ request('date') }}" class="w-full text-sm border-slate-300 rounded-lg">
            </div>
            <div class="flex gap-2">
                <button type="submit" class="flex-1 px-4 py-2 bg-slate-900 text-white text-sm font-medium rounded-lg hover:bg-slate-800 transition">Filter</button>
                <a href="{{ route('admin.meals.index') }}" class="px-4 py-2 bg-slate-100 text-slate-600 text-sm font-medium rounded-lg hover:bg-slate-200 transition">Reset</a>
            </div>
        </form>
    </div>

    <!-- Meals Table -->
    <div class="bg-white rounded-xl border border-slate-200 shadow-sm overflow-hidden">
        <div class="overflow-x-auto">
            <table class="w-full text-left border-collapse text-sm">
                <thead>
                    <tr class="bg-slate-50 border-b border-slate-200 text-slate-600 font-semibold uppercase text-xs tracking-wider">
                        <th class="py-3 px-4">User</th>
                        <th class="py-3 px-4">Meal Type / Title</th>
                        <th class="py-3 px-4">Logged At</th>
                        <th class="py-3 px-4">Calories</th>
                        <th class="py-3 px-4">Items Count</th>
                        <th class="py-3 px-4">Photo / AI</th>
                        <th class="py-3 px-4 text-right">View</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-100">
                    @forelse($meals as $meal)
                    <tr class="hover:bg-slate-50 transition">
                        <td class="py-3.5 px-4">
                            <div class="font-medium text-slate-900">{{ $meal->user?->name ?? 'Deleted User' }}</div>
                            <div class="text-xs text-slate-400">{{ $meal->user?->email }}</div>
                        </td>
                        <td class="py-3.5 px-4">
                            <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-semibold bg-emerald-50 text-emerald-700 capitalize">
                                {{ $meal->type }}
                            </span>
                            @if($meal->notes)
                            <p class="text-xs text-slate-500 mt-1 truncate max-w-xs">{{ $meal->notes }}</p>
                            @endif
                        </td>
                        <td class="py-3.5 px-4 text-slate-600 text-xs">
                            {{ $meal->logged_at ? $meal->logged_at->format('M d, Y H:i') : $meal->created_at->format('M d, Y H:i') }}
                        </td>
                        <td class="py-3.5 px-4 font-semibold text-slate-900">
                            {{ number_format($meal->total_calories ?? $meal->items->sum('calories'), 0) }} kcal
                        </td>
                        <td class="py-3.5 px-4 text-slate-600">
                            {{ $meal->items->count() }} items
                        </td>
                        <td class="py-3.5 px-4">
                            @if($meal->photo_url)
                                <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-semibold bg-blue-50 text-blue-700">
                                    📷 Photo Logged
                                </span>
                            @else
                                <span class="text-slate-400 text-xs">Manual Entry</span>
                            @endif
                        </td>
                        <td class="py-3.5 px-4 text-right">
                            <a href="{{ route('admin.meals.show', $meal->id) }}" class="text-emerald-600 hover:text-emerald-800 font-semibold text-xs">Inspect &rarr;</a>
                        </td>
                    </tr>
                    @empty
                    <tr>
                        <td colspan="7" class="py-8 text-center text-slate-500">No meals logged yet matching criteria.</td>
                    </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
        @if($meals->hasPages())
        <div class="p-4 border-t border-slate-100">
            {{ $meals->links() }}
        </div>
        @endif
    </div>
</div>
@endsection
