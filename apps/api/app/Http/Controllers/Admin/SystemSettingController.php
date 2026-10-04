<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\AppSetting;
use App\Models\AuditLog;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class SystemSettingController extends Controller
{
    public function index()
    {
        $settings = [
            'app_name' => AppSetting::get('system.app_name', 'NutriAI'),
            'support_email' => AppSetting::get('system.support_email', 'support@nutriai.app'),
            'maintenance_mode' => (bool) AppSetting::get('system.maintenance_mode', false),
        ];

        // System environment info
        $phpVersion = PHP_VERSION;
        $laravelVersion = app()->version();
        $dbConnection = config('database.default');
        $dbStatus = 'Connected';
        try {
            DB::connection()->getPdo();
        } catch (\Throwable $e) {
            $dbStatus = 'Error: ' . $e->getMessage();
        }

        return view('admin.system.settings', compact(
            'settings',
            'phpVersion',
            'laravelVersion',
            'dbConnection',
            'dbStatus'
        ));
    }

    public function update(Request $request)
    {
        $validated = $request->validate([
            'app_name' => ['required', 'string', 'max:100'],
            'support_email' => ['required', 'email'],
            'maintenance_mode' => ['nullable', 'boolean'],
        ]);

        $maintenance = $request->boolean('maintenance_mode');

        AppSetting::set('system.app_name', $validated['app_name'], 'string', 'system', 'Application Name');
        AppSetting::set('system.support_email', $validated['support_email'], 'string', 'system', 'Support Email Address');
        AppSetting::set('system.maintenance_mode', $maintenance, 'boolean', 'system', 'Maintenance mode state');

        AuditLog::record(
            Auth::id(),
            'update_system_settings',
            'AppSetting',
            null,
            $validated
        );

        return back()->with('success', 'System settings updated successfully.');
    }

    public function clearCache()
    {
        Artisan::call('cache:clear');
        Artisan::call('config:clear');

        AuditLog::record(
            Auth::id(),
            'clear_system_cache',
            'System',
            null,
            ['status' => 'success']
        );

        return back()->with('success', 'Application cache and configuration cache cleared successfully.');
    }
}
