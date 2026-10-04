<?php

namespace Database\Seeders;

use App\Models\AppSetting;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Spatie\Permission\Models\Role;

class AdminRoleSeeder extends Seeder
{
    public function run(): void
    {
        // 1. Ensure 'admin' role exists
        $adminRole = Role::firstOrCreate(['name' => 'admin', 'guard_name' => 'web']);
        Role::firstOrCreate(['name' => 'user', 'guard_name' => 'web']);

        // 2. Ensure default admin user exists
        $admin = User::firstOrCreate(
            ['email' => 'admin@nutriai.app'],
            [
                'name' => 'NutriAI Administrator',
                'password' => Hash::make('AdminSecret123!'),
                'timezone' => 'UTC',
            ]
        );

        if (!$admin->hasRole('admin')) {
            $admin->assignRole($adminRole);
        }

        // 3. Seed default AI settings
        AppSetting::set('ai.provider', 'gemini', 'string', 'ai', 'Default AI vision provider (gemini, openai, claude)');
        AppSetting::set('ai.model', 'gemini-1.5-flash', 'string', 'ai', 'Default vision model name');
        AppSetting::set('ai.temperature', 0.2, 'float', 'ai', 'Model sampling temperature');
        AppSetting::set('ai.max_tokens', 2048, 'integer', 'ai', 'Maximum output tokens generated');
        AppSetting::set('ai.prompt', 'You are an expert nutritionist. Analyze this meal photo and return exact calories and macronutrients in JSON.', 'string', 'ai', 'System prompt passed to vision analysis');
        AppSetting::set('ai.quota_free', 5, 'integer', 'ai', 'Monthly meal scans for free plan users');
        AppSetting::set('ai.quota_pro', 100, 'integer', 'ai', 'Monthly meal scans for pro plan users');
        AppSetting::set('ai.quota_premium', 500, 'integer', 'ai', 'Monthly meal scans for premium plan users');

        // 4. Seed default system settings
        AppSetting::set('system.app_name', 'NutriAI', 'string', 'system', 'Application name');
        AppSetting::set('system.support_email', 'support@nutriai.app', 'string', 'system', 'Support contact email');
        AppSetting::set('system.maintenance_mode', false, 'boolean', 'system', 'Platform maintenance mode');
    }
}
