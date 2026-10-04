@extends('admin.layouts.app')

@section('title', 'Edit Food: ' . $food->name)

@section('content')
<div class="max-w-2xl mx-auto space-y-6">
    <div class="flex items-center justify-between">
        <div>
            <h1 class="text-2xl font-bold text-slate-900">Edit Food</h1>
            <p class="text-sm text-slate-500">Update nutritional values or verification status.</p>
        </div>
        <a href="{{ route('admin.foods.index') }}" class="text-sm text-slate-600 hover:text-slate-900 font-medium">
            &larr; Back to Foods
        </a>
    </div>

    <div class="bg-white p-6 rounded-2xl border border-slate-200 shadow-sm">
        <form action="{{ route('admin.foods.update', $food->id) }}" method="POST" class="space-y-4">
            @csrf
            @method('PUT')

            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div class="md:col-span-2">
                    <label class="block text-xs font-semibold text-slate-700 uppercase tracking-wider mb-1">Food Name *</label>
                    <input type="text" name="name" value="{{ old('name', $food->name) }}" required class="w-full text-sm border-slate-300 rounded-lg focus:ring-emerald-500 focus:border-emerald-500">
                    @error('name')<p class="text-xs text-rose-500 mt-1">{{ $message }}</p>@enderror
                </div>

                <div>
                    <label class="block text-xs font-semibold text-slate-700 uppercase tracking-wider mb-1">Brand</label>
                    <input type="text" name="brand" value="{{ old('brand', $food->brand) }}" class="w-full text-sm border-slate-300 rounded-lg">
                </div>

                <div>
                    <label class="block text-xs font-semibold text-slate-700 uppercase tracking-wider mb-1">Barcode</label>
                    <input type="text" name="barcode" value="{{ old('barcode', $food->barcode) }}" class="w-full text-sm border-slate-300 rounded-lg">
                </div>

                <div>
                    <label class="block text-xs font-semibold text-slate-700 uppercase tracking-wider mb-1">Serving Size *</label>
                    <input type="number" step="0.1" name="serving_size" value="{{ old('serving_size', $food->serving_size) }}" required class="w-full text-sm border-slate-300 rounded-lg">
                </div>

                <div>
                    <label class="block text-xs font-semibold text-slate-700 uppercase tracking-wider mb-1">Serving Unit *</label>
                    <input type="text" name="serving_unit" value="{{ old('serving_unit', $food->serving_unit) }}" required class="w-full text-sm border-slate-300 rounded-lg">
                </div>

                <div>
                    <label class="block text-xs font-semibold text-slate-700 uppercase tracking-wider mb-1">Calories (kcal) *</label>
                    <input type="number" step="0.1" name="calories" value="{{ old('calories', $food->calories) }}" required class="w-full text-sm border-slate-300 rounded-lg">
                </div>

                <div>
                    <label class="block text-xs font-semibold text-slate-700 uppercase tracking-wider mb-1">Protein (g) *</label>
                    <input type="number" step="0.1" name="protein" value="{{ old('protein', $food->protein) }}" required class="w-full text-sm border-slate-300 rounded-lg">
                </div>

                <div>
                    <label class="block text-xs font-semibold text-slate-700 uppercase tracking-wider mb-1">Carbs (g) *</label>
                    <input type="number" step="0.1" name="carbs" value="{{ old('carbs', $food->carbs) }}" required class="w-full text-sm border-slate-300 rounded-lg">
                </div>

                <div>
                    <label class="block text-xs font-semibold text-slate-700 uppercase tracking-wider mb-1">Fat (g) *</label>
                    <input type="number" step="0.1" name="fat" value="{{ old('fat', $food->fat) }}" required class="w-full text-sm border-slate-300 rounded-lg">
                </div>

                <div class="md:col-span-2 pt-2">
                    <label class="inline-flex items-center gap-2">
                        <input type="checkbox" name="is_verified" value="1" {{ old('is_verified', $food->is_verified) ? 'checked' : '' }} class="rounded border-slate-300 text-emerald-600 focus:ring-emerald-500">
                        <span class="text-sm font-medium text-slate-700">Mark as Verified Standard Food</span>
                    </label>
                </div>
            </div>

            <div class="flex justify-end gap-3 pt-4 border-t border-slate-100">
                <a href="{{ route('admin.foods.index') }}" class="px-4 py-2 border border-slate-300 text-slate-700 rounded-lg text-sm font-medium hover:bg-slate-50">Cancel</a>
                <button type="submit" class="px-5 py-2 bg-emerald-600 text-white rounded-lg text-sm font-semibold hover:bg-emerald-700 transition">Update Food</button>
            </div>
        </form>
    </div>
</div>
@endsection
