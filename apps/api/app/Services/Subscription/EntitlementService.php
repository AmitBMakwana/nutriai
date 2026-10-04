<?php

namespace App\Services\Subscription;

use App\Enums\AiAnalysisStatus;
use App\Enums\SubscriptionStatus;
use App\Models\Subscription;
use App\Models\User;

class EntitlementService
{
    /**
     * Get the currently active subscription for the given user, if any.
     */
    public function getActiveSubscription(User $user): ?Subscription
    {
        return $user->subscriptions()
            ->whereIn('status', [SubscriptionStatus::ACTIVE->value, 'active', SubscriptionStatus::TRIALING->value, 'trialing'])
            ->where(function ($query) {
                $query->whereNull('ends_at')->orWhere('ends_at', '>', now());
            })
            ->orderByDesc('id')
            ->first();
    }

    /**
     * Get the active plan key ('free', 'pro', or 'premium').
     */
    public function getPlan(User $user): string
    {
        $activeSub = $this->getActiveSubscription($user);
        if ($activeSub && !empty($activeSub->plan)) {
            $plan = strtolower($activeSub->plan);
            if (config("subscriptions.plans.{$plan}")) {
                return $plan;
            }
        }

        return 'free';
    }

    /**
     * Determine if the user has a Pro or higher subscription.
     */
    public function isPro(User $user): bool
    {
        $plan = $this->getPlan($user);
        return in_array($plan, ['pro', 'premium'], true);
    }

    /**
     * Determine if the user has a Premium subscription.
     */
    public function isPremium(User $user): bool
    {
        return $this->getPlan($user) === 'premium';
    }

    /**
     * Get the monthly AI scan quota for the user's plan.
     */
    public function getMonthlyScanQuota(User $user): int
    {
        $plan = $this->getPlan($user);
        $dbQuota = \App\Models\AppSetting::get("ai.quota_{$plan}");
        if ($dbQuota !== null && is_numeric($dbQuota)) {
            return (int) $dbQuota;
        }

        return (int) config("subscriptions.plans.{$plan}.monthly_scan_quota", 5);
    }

    /**
     * Get the number of successful or in-progress AI scans the user has performed this month.
     */
    public function getUsedScansThisMonth(User $user): int
    {
        return $user->aiAnalyses()
            ->whereBetween('created_at', [now()->startOfMonth(), now()->endOfMonth()])
            ->where('status', '!=', AiAnalysisStatus::FAILED)
            ->count();
    }

    /**
     * Get the remaining scans for this month.
     */
    public function getRemainingScans(User $user): int
    {
        $quota = $this->getMonthlyScanQuota($user);
        $used = $this->getUsedScansThisMonth($user);
        return max(0, $quota - $used);
    }

    /**
     * Check whether the user can perform an AI scan.
     */
    public function canPerformAiScan(User $user): bool
    {
        return $this->getUsedScansThisMonth($user) < $this->getMonthlyScanQuota($user);
    }

    /**
     * Get comprehensive subscription and entitlement status.
     */
    public function getSubscriptionStatus(User $user): array
    {
        $activeSub = $this->getActiveSubscription($user);
        $plan = $this->getPlan($user);
        $quota = $this->getMonthlyScanQuota($user);
        $used = $this->getUsedScansThisMonth($user);
        $remaining = max(0, $quota - $used);

        $statusStr = 'none';
        if ($activeSub) {
            $statusStr = $activeSub->status instanceof SubscriptionStatus
                ? $activeSub->status->value
                : (string) $activeSub->status;
        }

        return [
            'plan' => $plan,
            'status' => $statusStr,
            'is_pro' => $this->isPro($user),
            'is_premium' => $this->isPremium($user),
            'quota' => $quota,
            'used_scans' => $used,
            'remaining_scans' => $remaining,
            'starts_at' => $activeSub?->starts_at?->toIso8601String(),
            'ends_at' => $activeSub?->ends_at?->toIso8601String(),
            'features' => config("subscriptions.plans.{$plan}.features", []),
            'all_plans' => config('subscriptions.plans', []),
        ];
    }
}
