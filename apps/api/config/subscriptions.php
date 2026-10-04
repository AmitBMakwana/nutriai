<?php

return [

    /*
    |--------------------------------------------------------------------------
    | Subscription Plans & Quotas
    |--------------------------------------------------------------------------
    |
    | Defines the tier limits and feature entitlements for each plan.
    |
    */

    'plans' => [
        'free' => [
            'name' => 'Free',
            'monthly_scan_quota' => (int) env('SCAN_QUOTA_FREE', 5),
            'features' => [
                '5 AI meal scans per month',
                'Calorie & macronutrient tracking',
                'Water & body weight tracking',
                '7-day progress history',
            ],
        ],
        'pro' => [
            'name' => 'Pro',
            'monthly_scan_quota' => (int) env('SCAN_QUOTA_PRO', 100),
            'features' => [
                '100 AI meal scans per month',
                'Advanced macro goal customizations',
                'Full progress history & analytics',
                'Export nutrition reports',
                'Priority AI processing',
            ],
        ],
        'premium' => [
            'name' => 'Premium',
            'monthly_scan_quota' => (int) env('SCAN_QUOTA_PREMIUM', 500),
            'features' => [
                '500 AI meal scans per month',
                'Everything in Pro',
                'Custom recipe nutrient breakdown',
                'Early access to AI Coach',
                'Dedicated 24/7 support',
            ],
        ],
    ],

    /*
    |--------------------------------------------------------------------------
    | RevenueCat Integration
    |--------------------------------------------------------------------------
    */

    'revenuecat' => [
        'webhook_secret' => env('REVENUECAT_WEBHOOK_SECRET', 'rc_test_secret_key_123'),
        'product_mapping' => [
            'nutriai_pro_monthly' => 'pro',
            'nutriai_pro_yearly' => 'pro',
            'nutriai_pro_annual' => 'pro',
            'nutriai_premium_monthly' => 'premium',
            'nutriai_premium_yearly' => 'premium',
            'nutriai_premium_annual' => 'premium',
        ],
    ],

];
