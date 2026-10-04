@extends('admin.layouts.app')

@section('title', 'Meal Details #' . $meal->id)

@section('content')
<div class="max-w-4xl mx-auto space-y-6">
    <div class="flex items-center justify-between">
        <div>
            <h1 class="text-2xl font-bold text-slate-900">Meal Inspection #{{ $meal->id }}</h1>
            <p class="text-sm text-slate-500">Read-only view of meal log by {{ $meal->user?->name ?? 'User' }} on {{ $meal->logged_at ? $meal->logged_at->format('M d, Y H:i') : $meal->created_at->format('M d, Y H:i') }}</p>
        </div>
        <a href="{{ route('admin.meals.index') }}" class="text-sm text-slate-600 hover:text-slate-900 font-medium">
            &larr; Back to Meals
        </a>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        <!-- Summary Cards -->
        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm space-y-3">
            <h2 class="text-xs font-semibold text-slate-400 uppercase tracking-wider">Nutrition Summary</h2>
            <div class="text-3xl font-bold text-slate-900">
                {{ number_format($meal->total_calories ?? $meal->items->sum('calories'), 0) }} <span class="text-sm font-normal text-slate-500">kcal</span>
            </div>
            <div class="grid grid-cols-3 gap-2 pt-2 border-t border-slate-100 text-center">
                <div class="p-2 bg-blue-50 rounded-lg">
                    <span class="block text-xs text-blue-600 font-medium">Protein</span>
                    <span class="font-bold text-blue-900 text-sm">{{ number_format($meal->items->sum('protein'), 1) }}g</span>
                </div>
                <div class="p-2 bg-amber-50 rounded-lg">
                    <span class="block text-xs text-amber-600 font-medium">Carbs</span>
                    <span class="font-bold text-amber-900 text-sm">{{ number_format($meal->items->sum('carbs'), 1) }}g</span>
                </div>
                <div class="p-2 bg-rose-50 rounded-lg">
                    <span class="block text-xs text-rose-600 font-medium">Fat</span>
                    <span class="font-bold text-rose-900 text-sm">{{ number_format($meal->items->sum('fat'), 1) }}g</span>
                </div>
            </div>
        </div>

        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm space-y-3">
            <h2 class="text-xs font-semibold text-slate-400 uppercase tracking-wider">User & Session</h2>
            <div>
                <a href="{{ route('admin.users.show', $meal->user_id) }}" class="text-emerald-600 hover:text-emerald-700 font-semibold text-base block">
                    {{ $meal->user?->name }}
                </a>
                <span class="text-xs text-slate-500">{{ $meal->user?->email }}</span>
            </div>
            <div class="text-xs text-slate-600 space-y-1 pt-2 border-t border-slate-100">
                <div><span class="text-slate-400">Meal Type:</span> <strong class="capitalize">{{ $meal->type }}</strong></div>
                <div><span class="text-slate-400">Logged At:</span> {{ $meal->logged_at ? $meal->logged_at->format('Y-m-d H:i:s') : 'N/A' }}</div>
            </div>
        </div>

        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm flex flex-col justify-center items-center text-center">
            @if($meal->photo_url)
                <img src="{{ $meal->photo_url }}" alt="Meal Photo" class="h-32 w-full object-cover rounded-lg border border-slate-200 mb-2">
                <span class="text-xs text-slate-500">AI / User Photo</span>
            @else
                <div class="h-24 w-24 rounded-full bg-slate-100 flex items-center justify-center text-slate-400 text-2xl mb-2">🍽️</div>
                <span class="text-xs text-slate-400">No Photo Logged</span>
            @endif
        </div>
    </div>

    <!-- Meal Items -->
    <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
        <div class="p-4 border-b border-slate-100 bg-slate-50">
            <h3 class="font-bold text-slate-900 text-sm">Meal Items ({{ $meal->items->count() }})</h3>
        </div>
        <div class="overflow-x-auto">
            <table class="w-full text-left border-collapse text-sm">
                <thead>
                    <tr class="text-xs uppercase font-semibold text-slate-500 border-b border-slate-200 bg-white">
                        <th class="py-3 px-4">Item Name</th>
                        <th class="py-3 px-4">Quantity / Serving</th>
                        <th class="py-3 px-4">Calories</th>
                        <th class="py-3 px-4">Protein</th>
                        <th class="py-3 px-4">Carbs</th>
                        <th class="py-3 px-4">Fat</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-100">
                    @forelse($meal->items as $item)
                    <tr>
                        <td class="py-3 px-4 font-medium text-slate-900">
                            {{ $item->name ?? $item->food?->name ?? 'Custom Item' }}
                        </td>
                        <td class="py-3 px-4 text-slate-600">
                            {{ $item->quantity ?? 1 }} {{ $item->serving_unit ?? 'serving' }}
                        </td>
                        <td class="py-3 px-4 font-semibold text-slate-900">{{ number_format($item->calories, 0) }} kcal</td>
                        <td class="py-3 px-4 text-blue-600">{{ number_format($item->protein, 1) }}g</td>
                        <td class="py-3 px-4 text-amber-600">{{ number_format($item->carbs, 1) }}g</td>
                        <td class="py-3 px-4 text-rose-600">{{ number_format($item->fat, 1) }}g</td>
                    </tr>
                    @empty
                    <tr>
                        <td colspan="6" class="py-6 text-center text-slate-400">No items listed under this meal.</td>
                    </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
    </div>
</div>
@endsection
