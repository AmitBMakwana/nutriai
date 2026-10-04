<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\AppSetting;
use App\Models\AuditLog;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class AiSettingController extends Controller
{
    public function index()
    {
        $settings = [
            'provider' => AppSetting::get('ai.provider', 'gemini'),
            'model' => AppSetting::get('ai.model', 'gemini-1.5-flash'),
            'temperature' => (float) AppSetting::get('ai.temperature', 0.2),
            'max_tokens' => (int) AppSetting::get('ai.max_tokens', 2048),
            'prompt' => AppSetting::get('ai.prompt', 'You are an expert nutritionist. Analyze this meal photo and return exact calories and macronutrients in JSON.'),
            'quota_free' => (int) AppSetting::get('ai.quota_free', 5),
            'quota_pro' => (int) AppSetting::get('ai.quota_pro', 100),
            'quota_premium' => (int) AppSetting::get('ai.quota_premium', 500),
        ];

        return view('admin.ai.settings', compact('settings'));
    }

    public function update(Request $request)
    {
        $validated = $request->validate([
            'provider' => ['required', 'string', 'in:gemini,openai,claude,mock'],
            'model' => ['required', 'string', 'max:100'],
            'temperature' => ['required', 'numeric', 'min:0', 'max:2'],
            'max_tokens' => ['required', 'integer', 'min:128', 'max:8192'],
            'prompt' => ['required', 'string'],
            'quota_free' => ['required', 'integer', 'min:1', 'max:1000'],
            'quota_pro' => ['required', 'integer', 'min:1', 'max:5000'],
            'quota_premium' => ['required', 'integer', 'min:-1', 'max:10000'],
        ]);

        $oldSettings = [
            'provider' => AppSetting::get('ai.provider'),
            'model' => AppSetting::get('ai.model'),
            'temperature' => AppSetting::get('ai.temperature'),
            'max_tokens' => AppSetting::get('ai.max_tokens'),
            'quota_free' => AppSetting::get('ai.quota_free'),
            'quota_pro' => AppSetting::get('ai.quota_pro'),
            'quota_premium' => AppSetting::get('ai.quota_premium'),
        ];

        // Save each setting to DB with cache invalidation
        AppSetting::set('ai.provider', $validated['provider'], 'string', 'ai', 'Active AI vision provider');
        AppSetting::set('ai.model', $validated['model'], 'string', 'ai', 'Model name');
        AppSetting::set('ai.temperature', (float) $validated['temperature'], 'float', 'ai', 'Sampling temperature');
        AppSetting::set('ai.max_tokens', (int) $validated['max_tokens'], 'integer', 'ai', 'Max generation tokens');
        AppSetting::set('ai.prompt', $validated['prompt'], 'string', 'ai', 'System vision analysis prompt');
        AppSetting::set('ai.quota_free', (int) $validated['quota_free'], 'integer', 'ai', 'Monthly scans quota for free tier');
        AppSetting::set('ai.quota_pro', (int) $validated['quota_pro'], 'integer', 'ai', 'Monthly scans quota for pro tier');
        AppSetting::set('ai.quota_premium', (int) $validated['quota_premium'], 'integer', 'ai', 'Monthly scans quota for premium tier');

        // Audit log
        AuditLog::record(
            Auth::id(),
            'update_ai_settings',
            'AppSetting',
            null,
            ['old' => $oldSettings, 'new' => $validated]
        );

        return back()->with('success', 'AI settings updated successfully. Changes are cached and active across all API requests.');
    }
}
