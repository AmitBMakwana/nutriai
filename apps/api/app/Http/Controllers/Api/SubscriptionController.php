<?php

namespace App\Http\Controllers\Api;

use App\Enums\SubscriptionStatus;
use App\Http\Controllers\Controller;
use App\Models\Subscription;
use App\Models\User;
use App\Models\WebhookEvent;
use App\Services\Subscription\EntitlementService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\Log;

class SubscriptionController extends Controller
{
    protected EntitlementService $entitlementService;

    public function __construct(EntitlementService $entitlementService)
    {
        $this->entitlementService = $entitlementService;
    }

    /**
     * Get user's current subscription, plan, and scan quota status.
     * GET /api/v1/subscription
     */
    public function show(Request $request): JsonResponse
    {
        $status = $this->entitlementService->getSubscriptionStatus($request->user());

        return response()->json([
            'success' => true,
            'data' => $status,
        ]);
    }

    /**
     * Handle incoming webhooks from RevenueCat.
     * POST /api/v1/subscription/webhook
     */
    public function webhook(Request $request): JsonResponse
    {
        // 1. Signature / Authorization header verification (timing-attack safe)
        $authHeader = (string) $request->header('Authorization', '');
        $expectedSecret = (string) config('subscriptions.revenuecat.webhook_secret', '');

        $isValid = !empty($expectedSecret) && (
            hash_equals($expectedSecret, $authHeader) ||
            hash_equals("Bearer {$expectedSecret}", $authHeader)
        );

        if (!$isValid) {
            Log::warning('RevenueCat webhook rejected: Invalid authorization header', [
                'header_present' => !empty($authHeader),
                'ip' => $request->ip(),
            ]);
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized webhook secret',
            ], 401);
        }

        // 2. Extract event data
        $payload = $request->all();
        $event = $payload['event'] ?? $payload;

        $eventId = (string) ($event['id'] ?? $request->input('id') ?? md5(json_encode($payload)));
        $eventType = strtoupper((string) ($event['type'] ?? 'UNKNOWN'));
        $appUserId = $event['app_user_id'] ?? null;
        $productId = $event['product_id'] ?? null;
        $purchasedAtMs = $event['purchased_at_ms'] ?? null;
        $expirationAtMs = $event['expiration_at_ms'] ?? null;
        $originalTransactionId = $event['original_transaction_id'] ?? $eventId;

        // 3. Idempotency check
        if (WebhookEvent::where('provider', 'revenuecat')->where('event_id', $eventId)->exists()) {
            Log::info("RevenueCat webhook {$eventId} already processed (idempotent skipped)");
            return response()->json([
                'success' => true,
                'message' => 'Event already processed',
                'idempotent' => true,
            ], 200);
        }

        // 4. Resolve user
        $user = null;
        if ($appUserId !== null) {
            $user = is_numeric($appUserId)
                ? User::find((int) $appUserId)
                : User::where('email', (string) $appUserId)->first();
        }

        // 5. Determine plan
        $plan = config("subscriptions.revenuecat.product_mapping.{$productId}");
        if (!$plan) {
            if ($productId && str_contains(strtolower($productId), 'premium')) {
                $plan = 'premium';
            } else {
                $plan = 'pro';
            }
        }

        // Timestamps
        $startsAt = $purchasedAtMs ? Carbon::createFromTimestampMs($purchasedAtMs) : now();
        $endsAt = $expirationAtMs ? Carbon::createFromTimestampMs($expirationAtMs) : null;

        // 6. Apply state transitions based on event type
        if ($user) {
            switch ($eventType) {
                case 'INITIAL_PURCHASE':
                case 'RENEWAL':
                    $subscription = Subscription::firstOrNew([
                        'user_id' => $user->id,
                        'provider' => 'revenuecat',
                    ]);
                    $subscription->provider_customer_id = $event['original_app_user_id'] ?? (string) $appUserId;
                    $subscription->provider_subscription_id = (string) $originalTransactionId;
                    $subscription->plan = $plan;
                    $subscription->status = SubscriptionStatus::ACTIVE;
                    $subscription->starts_at = $startsAt;
                    $subscription->ends_at = $endsAt;
                    $subscription->save();
                    break;

                case 'PRODUCT_CHANGE':
                    $subscription = Subscription::where('user_id', $user->id)
                        ->where('provider', 'revenuecat')
                        ->latest('id')
                        ->first();
                    if ($subscription) {
                        $subscription->plan = $plan;
                        if ($endsAt) {
                            $subscription->ends_at = $endsAt;
                        }
                        $subscription->status = SubscriptionStatus::ACTIVE;
                        $subscription->save();
                    }
                    break;

                case 'CANCELLATION':
                    $subscription = Subscription::where('user_id', $user->id)
                        ->where('provider', 'revenuecat')
                        ->latest('id')
                        ->first();
                    if ($subscription) {
                        $subscription->status = SubscriptionStatus::CANCELED;
                        if ($endsAt) {
                            $subscription->ends_at = $endsAt;
                        }
                        $subscription->save();
                    }
                    break;

                case 'EXPIRATION':
                    $subscription = Subscription::where('user_id', $user->id)
                        ->where('provider', 'revenuecat')
                        ->latest('id')
                        ->first();
                    if ($subscription) {
                        $subscription->status = SubscriptionStatus::EXPIRED;
                        $subscription->ends_at = $endsAt ?? now();
                        $subscription->save();
                    }
                    break;

                default:
                    Log::info("Unhandled RevenueCat event type: {$eventType}", ['event_id' => $eventId]);
                    break;
            }
        } else {
            Log::warning("RevenueCat webhook: user not found for app_user_id {$appUserId}", ['event_id' => $eventId]);
        }

        // 7. Persist WebhookEvent for idempotency
        WebhookEvent::create([
            'provider' => 'revenuecat',
            'event_id' => $eventId,
            'event_type' => $eventType,
            'payload' => $payload,
        ]);

        return response()->json([
            'success' => true,
            'message' => "Webhook event {$eventType} processed successfully",
        ]);
    }
}
