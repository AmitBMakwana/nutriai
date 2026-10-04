@extends('admin.layouts.app')

@section('title', 'System Settings & Operations')

@section('content')
<div class="max-w-4xl mx-auto space-y-6">
    <div class="flex items-center justify-between">
        <div>
            <h1 class="text-2xl font-bold text-slate-900">System Settings & Maintenance</h1>
            <p class="text-sm text-slate-500">Configure global application variables, maintenance flags, and operational actions.</p>
        </div>
    </div>

    <!-- General Settings Form -->
    <div class="bg-white p-6 rounded-2xl border border-slate-200 shadow-sm space-y-4">
        <h2 class="text-base font-bold text-slate-900 border-b border-slate-100 pb-2">Global Settings</h2>
        
        <form action="{{ route('admin.system.settings.update') }}" method="POST" class="space-y-4">
            @csrf

            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <label class="block text-xs font-semibold text-slate-700 uppercase tracking-wider mb-1">Application Name</label>
                    <input type="text" name="app_name" value="{{ old('app_name', $settings['app_name'] ?? 'NutriAI') }}" required class="w-full text-sm border-slate-300 rounded-lg">
                </div>

                <div>
                    <label class="block text-xs font-semibold text-slate-700 uppercase tracking-wider mb-1">Support Email</label>
                    <input type="email" name="support_email" value="{{ old('support_email', $settings['support_email'] ?? 'support@nutriai.app') }}" required class="w-full text-sm border-slate-300 rounded-lg">
                </div>

                <div class="md:col-span-2 pt-2">
                    <label class="inline-flex items-center gap-3">
                        <input type="hidden" name="maintenance_mode" value="0">
                        <input type="checkbox" name="maintenance_mode" value="1" {{ !empty($settings['maintenance_mode']) ? 'checked' : '' }} class="rounded border-slate-300 text-rose-600 focus:ring-rose-500">
                        <div>
                            <span class="text-sm font-semibold text-slate-900">Enable Maintenance Mode</span>
                            <p class="text-xs text-slate-500">When enabled, mobile client will receive service unavailable alerts.</p>
                        </div>
                    </label>
                </div>
            </div>

            <div class="flex justify-end pt-3">
                <button type="submit" class="px-5 py-2 bg-emerald-600 hover:bg-emerald-700 text-white rounded-lg text-sm font-semibold transition">
                    Save System Settings
                </button>
            </div>
        </form>
    </div>

    <!-- Operations & Cache Purging -->
    <div class="bg-white p-6 rounded-2xl border border-slate-200 shadow-sm space-y-4">
        <h2 class="text-base font-bold text-slate-900 border-b border-slate-100 pb-2">Cache & Operational Actions</h2>
        
        <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 py-2">
            <div>
                <h4 class="text-sm font-semibold text-slate-800">Clear Application & Settings Cache</h4>
                <p class="text-xs text-slate-500">Flushes all cached Redis/file settings, forcing models and API controllers to reload fresh DB values.</p>
            </div>
            <form action="{{ route('admin.system.clear-cache') }}" method="POST">
                @csrf
                <button type="submit" class="px-4 py-2 bg-slate-100 hover:bg-slate-200 text-slate-700 font-semibold rounded-lg text-sm transition">
                    Purge All Caches
                </button>
            </form>
        </div>
    </div>
</div>
@endsection
