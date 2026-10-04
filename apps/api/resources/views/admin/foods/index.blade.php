@extends('admin.layouts.app')

@section('title', 'Foods Management')

@section('content')
<div class="space-y-6">
    <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
        <div>
            <h1 class="text-2xl font-bold text-slate-900">Foods Database</h1>
            <p class="text-sm text-slate-500">Manage standard verified foods, review user custom items, or import in bulk.</p>
        </div>
        <div class="flex items-center space-x-3">
            <button onclick="document.getElementById('importModal').classList.remove('hidden')" class="px-4 py-2 bg-slate-100 hover:bg-slate-200 text-slate-700 text-sm font-medium rounded-lg transition-colors flex items-center gap-2">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-8l-4-4m0 0L8 8m4-4v12"/></svg>
                Import CSV
            </button>
            <a href="{{ route('admin.foods.create') }}" class="px-4 py-2 bg-emerald-600 hover:bg-emerald-700 text-white text-sm font-semibold rounded-lg shadow-sm transition-colors flex items-center gap-2">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/></svg>
                Add Food
            </a>
        </div>
    </div>

    <!-- Filters & Search -->
    <div class="bg-white p-4 rounded-xl border border-slate-200 shadow-sm">
        <form method="GET" action="{{ route('admin.foods.index') }}" class="grid grid-cols-1 md:grid-cols-4 gap-4">
            <div class="md:col-span-2">
                <input type="text" name="search" value="{{ request('search') }}" placeholder="Search by name, brand or barcode..." class="w-full text-sm border-slate-300 rounded-lg focus:ring-emerald-500 focus:border-emerald-500">
            </div>
            <div>
                <select name="type" class="w-full text-sm border-slate-300 rounded-lg focus:ring-emerald-500 focus:border-emerald-500">
                    <option value="">All Types (Verified & Custom)</option>
                    <option value="verified" {{ request('type') === 'verified' ? 'selected' : '' }}>Verified Only</option>
                    <option value="unverified" {{ request('type') === 'unverified' ? 'selected' : '' }}>Pending Verification (Custom)</option>
                </select>
            </div>
            <div class="flex gap-2">
                <button type="submit" class="flex-1 px-4 py-2 bg-slate-900 text-white text-sm font-medium rounded-lg hover:bg-slate-800 transition">Filter</button>
                <a href="{{ route('admin.foods.index') }}" class="px-4 py-2 bg-slate-100 text-slate-600 text-sm font-medium rounded-lg hover:bg-slate-200 transition">Reset</a>
            </div>
        </form>
    </div>

    <!-- Foods Table -->
    <div class="bg-white rounded-xl border border-slate-200 shadow-sm overflow-hidden">
        <div class="overflow-x-auto">
            <table class="w-full text-left border-collapse text-sm">
                <thead>
                    <tr class="bg-slate-50 border-b border-slate-200 text-slate-600 font-semibold uppercase text-xs tracking-wider">
                        <th class="py-3 px-4">Food</th>
                        <th class="py-3 px-4">Serving</th>
                        <th class="py-3 px-4">Calories</th>
                        <th class="py-3 px-4">P / C / F (g)</th>
                        <th class="py-3 px-4">Status</th>
                        <th class="py-3 px-4 text-right">Actions</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-100">
                    @forelse($foods as $food)
                    <tr class="hover:bg-slate-50 transition">
                        <td class="py-3.5 px-4">
                            <div class="font-medium text-slate-900">{{ $food->name }}</div>
                            <div class="text-xs text-slate-400">
                                {{ $food->brand ?: 'Standard' }} 
                                @if($food->barcode) • Barcode: {{ $food->barcode }} @endif
                            </div>
                        </td>
                        <td class="py-3.5 px-4 text-slate-600">
                            {{ $food->serving_size }} {{ $food->serving_unit }}
                        </td>
                        <td class="py-3.5 px-4 font-semibold text-slate-900">
                            {{ number_format($food->calories, 0) }} kcal
                        </td>
                        <td class="py-3.5 px-4 text-slate-600">
                            <span class="text-blue-600 font-medium">{{ $food->protein }}p</span> / 
                            <span class="text-amber-600 font-medium">{{ $food->carbs }}c</span> / 
                            <span class="text-rose-600 font-medium">{{ $food->fat }}f</span>
                        </td>
                        <td class="py-3.5 px-4">
                            @if($food->is_verified)
                                <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-semibold bg-emerald-100 text-emerald-800">
                                    Verified
                                </span>
                            @else
                                <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-semibold bg-amber-100 text-amber-800">
                                    Custom (Unverified)
                                </span>
                            @endif
                        </td>
                        <td class="py-3.5 px-4 text-right space-x-2">
                            @if(!$food->is_verified)
                            <form action="{{ route('admin.foods.verify', $food->id) }}" method="POST" class="inline">
                                @csrf
                                <button type="submit" class="px-2.5 py-1 text-xs font-semibold bg-emerald-50 text-emerald-700 hover:bg-emerald-100 rounded border border-emerald-200">
                                    Verify
                                </button>
                            </form>
                            @endif
                            <a href="{{ route('admin.foods.edit', $food->id) }}" class="text-slate-600 hover:text-slate-900 font-medium text-xs">Edit</a>
                            <form action="{{ route('admin.foods.destroy', $food->id) }}" method="POST" class="inline" onsubmit="return confirm('Delete this food?');">
                                @csrf
                                @method('DELETE')
                                <button type="submit" class="text-rose-600 hover:text-rose-800 font-medium text-xs">Delete</button>
                            </form>
                        </td>
                    </tr>
                    @empty
                    <tr>
                        <td colspan="6" class="py-8 text-center text-slate-500">No foods found matching criteria.</td>
                    </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
        @if($foods->hasPages())
        <div class="p-4 border-t border-slate-100">
            {{ $foods->links() }}
        </div>
        @endif
    </div>
</div>

<!-- CSV Import Modal -->
<div id="importModal" class="hidden fixed inset-0 z-50 overflow-y-auto bg-slate-900/50 backdrop-blur-sm flex items-center justify-center p-4">
    <div class="bg-white rounded-2xl max-w-lg w-full p-6 shadow-xl space-y-4">
        <div class="flex justify-between items-center pb-2 border-b border-slate-100">
            <h3 class="text-lg font-bold text-slate-900">Import Foods via CSV</h3>
            <button onclick="document.getElementById('importModal').classList.add('hidden')" class="text-slate-400 hover:text-slate-600">&times;</button>
        </div>
        <p class="text-xs text-slate-500">CSV file must include header columns: <code>name, serving_size, serving_unit, calories, protein, carbs, fat, brand, barcode</code>.</p>
        <form action="{{ route('admin.foods.import-csv') }}" method="POST" enctype="multipart/form-data" class="space-y-4">
            @csrf
            <div>
                <input type="file" name="file" accept=".csv,.txt" required class="block w-full text-sm text-slate-500 file:mr-4 file:py-2 file:px-4 file:rounded-lg file:border-0 file:text-sm file:font-semibold file:bg-emerald-50 file:text-emerald-700 hover:file:bg-emerald-100">
            </div>
            <div class="flex justify-end space-x-2 pt-2">
                <button type="button" onclick="document.getElementById('importModal').classList.add('hidden')" class="px-4 py-2 bg-slate-100 text-slate-600 rounded-lg text-sm font-medium hover:bg-slate-200">Cancel</button>
                <button type="submit" class="px-4 py-2 bg-emerald-600 text-white rounded-lg text-sm font-medium hover:bg-emerald-700">Upload & Import</button>
            </div>
        </form>
    </div>
</div>
@endsection
