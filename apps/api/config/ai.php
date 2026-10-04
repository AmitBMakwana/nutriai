<?php

return [

    /*
    |--------------------------------------------------------------------------
    | Default AI Provider
    |--------------------------------------------------------------------------
    |
    | This option controls the default AI provider used for meal image
    | recognition and nutritional analysis. Supported: "gemini", "claude",
    | "openai", "fake".
    |
    */

    'default' => env('AI_PROVIDER', 'gemini'),

    /*
    |--------------------------------------------------------------------------
    | AI Providers Configuration
    |--------------------------------------------------------------------------
    */

    'providers' => [

        'gemini' => [
            'api_key' => env('GEMINI_API_KEY'),
            'model' => env('GEMINI_MODEL', 'gemini-1.5-flash'),
            'timeout' => (int) env('GEMINI_TIMEOUT', 30),
            'max_tokens' => (int) env('GEMINI_MAX_TOKENS', 2048),
            'temperature' => (float) env('GEMINI_TEMPERATURE', 0.2),
            'endpoint' => env(
                'GEMINI_ENDPOINT',
                'https://generativelanguage.googleapis.com/v1beta/models'
            ),
        ],

        'claude' => [
            'api_key' => env('ANTHROPIC_API_KEY'),
            'model' => env('CLAUDE_MODEL', 'claude-3-5-sonnet-20241022'),
            'timeout' => (int) env('CLAUDE_TIMEOUT', 30),
            'max_tokens' => (int) env('CLAUDE_MAX_TOKENS', 2048),
            'temperature' => (float) env('CLAUDE_TEMPERATURE', 0.2),
        ],

        'openai' => [
            'api_key' => env('OPENAI_API_KEY'),
            'model' => env('OPENAI_MODEL', 'gpt-4o-mini'),
            'timeout' => (int) env('OPENAI_TIMEOUT', 30),
            'max_tokens' => (int) env('OPENAI_MAX_TOKENS', 2048),
            'temperature' => (float) env('OPENAI_TEMPERATURE', 0.2),
        ],

        'fake' => [
            'default_meal' => env('AI_FAKE_MEAL', 'indian_thali'),
        ],

    ],

    'storage' => [
        'disk' => env('AI_STORAGE_DISK', env('FILESYSTEM_DISK', 'local')),
        'directory' => env('AI_STORAGE_DIR', 'meal-uploads'),
        'signed_url_ttl' => (int) env('AI_SIGNED_URL_TTL', 60), // in minutes
    ],

    /*
    |--------------------------------------------------------------------------
    | Monthly AI Scan Quota
    |--------------------------------------------------------------------------
    |
    | Number of allowed meal photo AI scans per calendar month per tier.
    |
    */

    'quota' => [
        'free' => (int) env('AI_QUOTA_FREE', 5),
        'pro' => (int) env('AI_QUOTA_PRO', 100),
    ],

];
