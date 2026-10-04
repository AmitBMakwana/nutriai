@extends('admin.layouts.app')

@section('title', 'AI Engine Configuration')

@section('content')
<div class="max-w-4xl mx-auto space-y-6">
    <div class="flex items-center justify-between">
        <div>
            <h1 class="text-2xl font-bold text-slate-900">AI Engine Settings</h1>
            <p class="text-sm text-slate-500">Configure vision model parameters, system prompts, and tier scan quotas. Changes are instantly cached and consumed by the API.</p>
        </div>
        <div class="flex items-center space-x-2 text-xs bg-emerald-50 text-emerald-700 px-3 py-1.5 rounded-lg border border-emerald-200">
            <svg class="w-4 h-4 text-emerald-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"/></svg>
            Active Cache Sync
        </div>
    </div>

    <form action="{{ route('admin.ai.settings.update') }}" method="POST" class="space-y-6">
        @csrf

        <!-- Provider & Model -->
        <div class="bg-white p-6 rounded-2xl border border-slate-200 shadow-sm space-y-4">
            <h2 class="text-base font-bold text-slate-900 border-b border-slate-100 pb-2">Active AI Provider & Model</h2>
            
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <label class="block text-xs font-semibold text-slate-700 uppercase tracking-wider mb-1">Provider Driver</label>
                    <select name="provider" class="w-full text-sm border-slate-300 rounded-lg focus:ring-emerald-500 focus:border-emerald-500">
                        <option value="gemini" {{ old('provider', $settings['provider'] ?? 'gemini') === 'gemini' ? 'selected' : '' }}>Google Gemini Vision</option>
                        <option value="openai" {{ old('provider', $settings['provider'] ?? 'gemini') === 'openai' ? 'selected' : '' }}>OpenAI GPT-4o Vision</option>
                        <option value="claude" {{ old('provider', $settings['provider'] ?? 'gemini') === 'claude' ? 'selected' : '' }}>Anthropic Claude 3.5 Sonnet</option>
                        <option value="mock" {{ old('provider', $settings['provider'] ?? 'gemini') === 'mock' ? 'selected' : '' }}>Mock Provider (Local Testing)</option>
                    </select>
                    <p class="text-xs text-slate-400 mt-1">Changes the default driver used by <code>AIProviderManager</code>.</p>
                </div>

                <div>
                    <label class="block text-xs font-semibold text-slate-700 uppercase tracking-wider mb-1">Model Name / Identifier</label>
                    <input type="text" name="model" value="{{ old('model', $settings['model'] ?? 'gemini-1.5-flash') }}" required class="w-full text-sm border-slate-300 rounded-lg focus:ring-emerald-500 focus:border-emerald-500 font-mono">
                    <p class="text-xs text-slate-400 mt-1">e.g. <code>gemini-1.5-flash</code>, <code>gpt-4o</code>, <code>claude-3-5-sonnet-20241022</code></p>
                </div>

                <div>
                    <label class="block text-xs font-semibold text-slate-700 uppercase tracking-wider mb-1">Temperature (0.0 to 1.0)</label>
                    <input type="number" step="0.05" min="0" max="1" name="temperature" value="{{ old('temperature', $settings['temperature'] ?? 0.2) }}" required class="w-full text-sm border-slate-300 rounded-lg font-mono">
                    <p class="text-xs text-slate-400 mt-1">Lower temperatures (0.1 - 0.3) provide more deterministic nutrition extraction.</p>
                </div>

                <div>
                    <label class="block text-xs font-semibold text-slate-700 uppercase tracking-wider mb-1">Max Tokens</label>
                    <input type="number" step="1" min="100" max="16384" name="max_tokens" value="{{ old('max_tokens', $settings['max_tokens'] ?? 2048) }}" required class="w-full text-sm border-slate-300 rounded-lg font-mono">
                    <p class="text-xs text-slate-400 mt-1">Maximum token output budget for the vision response.</p>
                </div>
            </div>
        </div>

        <!-- Plan Scan Quotas -->
        <div class="bg-white p-6 rounded-2xl border border-slate-200 shadow-sm space-y-4">
            <h2 class="text-base font-bold text-slate-900 border-b border-slate-100 pb-2">Monthly Tier Scan Quotas</h2>
            <p class="text-xs text-slate-500">Overridden quotas immediately apply to <code>EntitlementService::getMonthlyScanQuota()</code>.</p>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div>
                    <label class="block text-xs font-semibold text-slate-700 uppercase tracking-wider mb-1">Free Tier Quota</label>
                    <input type="number" min="0" name="quota_free" value="{{ old('quota_free', $settings['quota_free'] ?? 5) }}" required class="w-full text-sm border-slate-300 rounded-lg font-mono">
                    <span class="text-xs text-slate-400">Default: 5 scans/month</span>
                </div>

                <div>
                    <label class="block text-xs font-semibold text-slate-700 uppercase tracking-wider mb-1">Pro Tier Quota</label>
                    <input type="number" min="0" name="quota_pro" value="{{ old('quota_pro', $settings['quota_pro'] ?? 100) }}" required class="w-full text-sm border-slate-300 rounded-lg font-mono">
                    <span class="text-xs text-slate-400">Default: 100 scans/month</span>
                </div>

                <div>
                    <label class="block text-xs font-semibold text-slate-700 uppercase tracking-wider mb-1">Premium Tier Quota</label>
                    <input type="number" min="-1" name="quota_premium" value="{{ old('quota_premium', $settings['quota_premium'] ?? -1) }}" required class="w-full text-sm border-slate-300 rounded-lg font-mono">
                    <span class="text-xs text-slate-400">-1 for unlimited scans</span>
                </div>
            </div>
        </div>

        <!-- System Prompt -->
        <div class="bg-white p-6 rounded-2xl border border-slate-200 shadow-sm space-y-3">
            <h2 class="text-base font-bold text-slate-900 border-b border-slate-100 pb-2">Vision Analysis System Prompt</h2>
            <p class="text-xs text-slate-500">Instructions passed to the vision model when analyzing uploaded food photos.</p>

            <div>
                <textarea name="prompt" rows="6" class="w-full text-xs font-mono border-slate-300 rounded-lg focus:ring-emerald-500 focus:border-emerald-500">{{ old('prompt', $settings['prompt'] ?? "Analyze this meal photo. Identify all individual food items, estimate their portions in grams, and calculate total calories, protein, carbs, and fat in valid JSON format.") }}</textarea>
            </div>
        </div>

        <div class="flex justify-end gap-3">
            <button type="submit" class="px-6 py-2.5 bg-emerald-600 text-white rounded-xl text-sm font-semibold hover:bg-emerald-700 transition shadow-sm">
                Save & Cache Settings
            </button>
        </div>
    </form>
</div>
@endsection
