<?php

namespace Tests\Feature;

use App\Enums\AiAnalysisStatus;
use App\Enums\SubscriptionStatus;
use App\Models\AiAnalysis;
use App\Models\Subscription;
use App\Models\User;
use App\Models\WebhookEvent;
use App\Services\Subscription\EntitlementService;
use Carbon\Carbon;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Config;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class SubscriptionTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        Config::set('subscriptions.revenuecat.webhook_secret', 'secret_webhook_123');
    }

    public function test_get_subscription_requires_authentication(): void
    {
        $response = $this->getJson('/api/v1/subscription');
        $response->assertStatus(401);
    }

    public function test_free_user_has_default_free_plan_and_quota(): void
    {
        $user = User::factory()->create();
        Sanctum::actingAs($user);

        $response = $this->getJson('/api/v1/subscription');

        $response->assertStatus(200)
            ->assertJsonPath('success', true)
            ->assertJsonPath('data.plan', 'free')
            ->assertJsonPath('data.is_pro', false)
            ->assertJsonPath('data.is_premium', false)
            ->assertJsonPath('data.quota', 5)
            ->assertJsonPath('data.used_scans', 0)
            ->assertJsonPath('data.remaining_scans', 5);
    }

    public function test_scan_usage_increments_used_scans_and_decrements_remaining(): void
    {
        $user = User::factory()->create();

        // Create 2 completed scans this month
        AiAnalysis::factory()->count(2)->create([
            'user_id' => $user->id,
            'status' => AiAnalysisStatus::COMPLETED,
            'created_at' => now(),
        ]);

        // Create 1 failed scan this month (should not count towards quota)
        AiAnalysis::factory()->create([
            'user_id' => $user->id,
            'status' => AiAnalysisStatus::FAILED,
            'created_at' => now(),
        ]);

        Sanctum::actingAs($user);

        $response = $this->getJson('/api/v1/subscription');

        $response->assertStatus(200)
            ->assertJsonPath('data.quota', 5)
            ->assertJsonPath('data.used_scans', 2)
            ->assertJsonPath('data.remaining_scans', 3);
    }

    public function test_pro_user_has_pro_plan_and_100_scans_quota(): void
    {
        $user = User::factory()->create();
        Subscription::create([
            'user_id' => $user->id,
            'provider' => 'revenuecat',
            'provider_subscription_id' => 'sub_pro_123',
            'plan' => 'pro',
            'status' => SubscriptionStatus::ACTIVE,
            'starts_at' => now()->subDay(),
            'ends_at' => now()->addMonth(),
        ]);

        Sanctum::actingAs($user);

        $response = $this->getJson('/api/v1/subscription');

        $response->assertStatus(200)
            ->assertJsonPath('data.plan', 'pro')
            ->assertJsonPath('data.is_pro', true)
            ->assertJsonPath('data.is_premium', false)
            ->assertJsonPath('data.quota', 100)
            ->assertJsonPath('data.remaining_scans', 100);
    }

    public function test_premium_user_has_premium_plan_and_500_scans_quota(): void
    {
        $user = User::factory()->create();
        Subscription::create([
            'user_id' => $user->id,
            'provider' => 'revenuecat',
            'provider_subscription_id' => 'sub_prem_123',
            'plan' => 'premium',
            'status' => SubscriptionStatus::ACTIVE,
            'starts_at' => now()->subDay(),
            'ends_at' => now()->addYear(),
        ]);

        Sanctum::actingAs($user);

        $response = $this->getJson('/api/v1/subscription');

        $response->assertStatus(200)
            ->assertJsonPath('data.plan', 'premium')
            ->assertJsonPath('data.is_pro', true)
            ->assertJsonPath('data.is_premium', true)
            ->assertJsonPath('data.quota', 500)
            ->assertJsonPath('data.remaining_scans', 500);
    }

    public function test_webhook_rejects_missing_or_invalid_signature(): void
    {
        $payload = [
            'event' => [
                'id' => 'evt_test_1',
                'type' => 'INITIAL_PURCHASE',
                'app_user_id' => '1',
            ],
        ];

        // No header
        $res1 = $this->postJson('/api/v1/subscription/webhook', $payload);
        $res1->assertStatus(401);

        // Wrong header
        $res2 = $this->postJson('/api/v1/subscription/webhook', $payload, [
            'Authorization' => 'wrong_secret',
        ]);
        $res2->assertStatus(401);
    }

    public function test_webhook_handles_initial_purchase_and_activates_subscription(): void
    {
        $user = User::factory()->create();

        $payload = [
            'event' => [
                'id' => 'evt_initial_001',
                'type' => 'INITIAL_PURCHASE',
                'app_user_id' => (string) $user->id,
                'product_id' => 'nutriai_pro_monthly',
                'purchased_at_ms' => now()->getTimestampMs(),
                'expiration_at_ms' => now()->addMonth()->getTimestampMs(),
            ],
        ];

        $response = $this->postJson('/api/v1/subscription/webhook', $payload, [
            'Authorization' => 'secret_webhook_123',
        ]);

        $response->assertStatus(200)
            ->assertJsonPath('success', true);

        $this->assertDatabaseHas('subscriptions', [
            'user_id' => $user->id,
            'plan' => 'pro',
            'status' => 'active',
        ]);

        $this->assertDatabaseHas('webhook_events', [
            'event_id' => 'evt_initial_001',
            'event_type' => 'INITIAL_PURCHASE',
        ]);

        // User should now be pro on backend
        $user->refresh();
        $this->assertTrue($user->isPro());
        $this->assertEquals(100, $user->getMonthlyScanQuota());
    }

    public function test_webhook_idempotency_ignores_duplicate_event(): void
    {
        $user = User::factory()->create();

        $payload = [
            'event' => [
                'id' => 'evt_duplicate_001',
                'type' => 'INITIAL_PURCHASE',
                'app_user_id' => (string) $user->id,
                'product_id' => 'nutriai_pro_monthly',
                'purchased_at_ms' => now()->getTimestampMs(),
                'expiration_at_ms' => now()->addMonth()->getTimestampMs(),
            ],
        ];

        // First call
        $first = $this->postJson('/api/v1/subscription/webhook', $payload, [
            'Authorization' => 'Bearer secret_webhook_123',
        ]);
        $first->assertStatus(200);

        // Second call with same event ID
        $second = $this->postJson('/api/v1/subscription/webhook', $payload, [
            'Authorization' => 'Bearer secret_webhook_123',
        ]);
        $second->assertStatus(200)
            ->assertJsonPath('idempotent', true);

        // Webhook events should only contain 1 record
        $this->assertEquals(1, WebhookEvent::where('event_id', 'evt_duplicate_001')->count());
    }

    public function test_webhook_cancellation_marks_subscription_canceled(): void
    {
        $user = User::factory()->create();
        Subscription::create([
            'user_id' => $user->id,
            'provider' => 'revenuecat',
            'provider_subscription_id' => 'sub_cancel_1',
            'plan' => 'pro',
            'status' => SubscriptionStatus::ACTIVE,
            'starts_at' => now()->subDay(),
            'ends_at' => now()->addMonth(),
        ]);

        $payload = [
            'event' => [
                'id' => 'evt_cancel_001',
                'type' => 'CANCELLATION',
                'app_user_id' => (string) $user->id,
                'product_id' => 'nutriai_pro_monthly',
                'expiration_at_ms' => now()->addMonth()->getTimestampMs(),
            ],
        ];

        $response = $this->postJson('/api/v1/subscription/webhook', $payload, [
            'Authorization' => 'secret_webhook_123',
        ]);

        $response->assertStatus(200);

        $this->assertDatabaseHas('subscriptions', [
            'user_id' => $user->id,
            'status' => 'canceled',
        ]);
    }

    public function test_webhook_expiration_marks_subscription_expired_and_reverts_quota_to_free(): void
    {
        $user = User::factory()->create();
        $sub = Subscription::create([
            'user_id' => $user->id,
            'provider' => 'revenuecat',
            'provider_subscription_id' => 'sub_exp_1',
            'plan' => 'pro',
            'status' => SubscriptionStatus::ACTIVE,
            'starts_at' => now()->subMonth(),
            'ends_at' => now()->addDay(),
        ]);

        $payload = [
            'event' => [
                'id' => 'evt_expire_001',
                'type' => 'EXPIRATION',
                'app_user_id' => (string) $user->id,
                'product_id' => 'nutriai_pro_monthly',
                'expiration_at_ms' => now()->subMinute()->getTimestampMs(),
            ],
        ];

        $response = $this->postJson('/api/v1/subscription/webhook', $payload, [
            'Authorization' => 'secret_webhook_123',
        ]);

        $response->assertStatus(200);

        $sub->refresh();
        $this->assertEquals(SubscriptionStatus::EXPIRED, $sub->status);

        // Entitlement checks should revert to free
        $entitlementService = app(EntitlementService::class);
        $this->assertFalse($entitlementService->isPro($user));
        $this->assertEquals('free', $entitlementService->getPlan($user));
        $this->assertEquals(5, $entitlementService->getMonthlyScanQuota($user));
    }

    public function test_ai_scan_blocked_when_monthly_quota_exhausted(): void
    {
        $user = User::factory()->create();

        // 5 scans for free user (quota = 5)
        AiAnalysis::factory()->count(5)->create([
            'user_id' => $user->id,
            'status' => AiAnalysisStatus::COMPLETED,
            'created_at' => now(),
        ]);

        Sanctum::actingAs($user);

        $image = UploadedFile::fake()->image('salad.jpg', 600, 600);

        $response = $this->postJson('/api/v1/meals/analyze', [
            'image' => $image,
            'meal_type' => 'lunch',
        ]);

        $response->assertStatus(429)
            ->assertJsonPath('success', false)
            ->assertJsonPath('data.used', 5)
            ->assertJsonPath('data.quota', 5)
            ->assertJsonPath('data.plan', 'free');
    }
}
