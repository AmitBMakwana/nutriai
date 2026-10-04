<?php

namespace Tests\Feature;

use App\Models\AiAnalysis;
use App\Models\Meal;
use App\Models\User;
use App\Models\WaterLog;
use App\Models\WeightLog;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Tests\TestCase;

class SecurityTest extends TestCase
{
    use RefreshDatabase;

    protected User $userA;
    protected User $userB;
    protected string $tokenA;
    protected string $tokenB;

    protected function setUp(): void
    {
        parent::setUp();

        $this->userA = User::factory()->create([
            'email' => 'usera@example.com',
            'is_disabled' => false,
        ]);
        $this->tokenA = $this->userA->createToken('test_token_a')->plainTextToken;

        $this->userB = User::factory()->create([
            'email' => 'userb@example.com',
            'is_disabled' => false,
        ]);
        $this->tokenB = $this->userB->createToken('test_token_b')->plainTextToken;
    }

    public function test_cross_user_meal_view_is_forbidden(): void
    {
        $meal = Meal::create([
            'user_id' => $this->userA->id,
            'meal_type' => 'lunch',
            'meal_date' => '2026-10-03',
            'meal_time' => '12:30:00',
            'total_calories' => 500,
        ]);

        // User B tries to view User A's meal
        $response = $this->withHeader('Authorization', "Bearer {$this->tokenB}")
            ->getJson("/api/v1/meals/{$meal->id}");

        $response->assertStatus(403);
    }

    public function test_cross_user_meal_update_is_forbidden(): void
    {
        $meal = Meal::create([
            'user_id' => $this->userA->id,
            'meal_type' => 'lunch',
            'meal_date' => '2026-10-03',
            'meal_time' => '12:30:00',
            'total_calories' => 500,
        ]);

        // User B tries to update User A's meal
        $response = $this->withHeader('Authorization', "Bearer {$this->tokenB}")
            ->putJson("/api/v1/meals/{$meal->id}", [
                'meal_type' => 'dinner',
            ]);

        $response->assertStatus(403);
    }

    public function test_cross_user_water_deletion_is_forbidden(): void
    {
        $waterLog = WaterLog::create([
            'user_id' => $this->userA->id,
            'amount_ml' => 250,
            'logged_at' => now(),
        ]);

        // User B attempts to delete User A's water log
        $response = $this->withHeader('Authorization', "Bearer {$this->tokenB}")
            ->deleteJson("/api/v1/water/{$waterLog->id}");

        $response->assertStatus(403);
    }

    public function test_cross_user_weight_deletion_is_forbidden(): void
    {
        $weightLog = WeightLog::create([
            'user_id' => $this->userA->id,
            'weight_kg' => 75.5,
            'logged_at' => now(),
        ]);

        // User B attempts to delete User A's weight log
        $response = $this->withHeader('Authorization', "Bearer {$this->tokenB}")
            ->deleteJson("/api/v1/weight/{$weightLog->id}");

        $response->assertStatus(403);
    }

    public function test_cross_user_ai_analysis_view_is_forbidden(): void
    {
        $analysis = AiAnalysis::create([
            'user_id' => $this->userA->id,
            'provider' => 'mock',
            'model' => 'mock-vision',
            'image_path' => 'meal-uploads/user_1/test.jpg',
            'status' => 'completed',
            'parsed_response' => ['total_calories' => 450],
        ]);

        // User B attempts to view User A's AI analysis
        $response = $this->withHeader('Authorization', "Bearer {$this->tokenB}")
            ->getJson("/api/v1/ai-analysis/{$analysis->id}");

        $response->assertStatus(403);
    }

    public function test_disabled_user_cannot_access_api_with_active_token(): void
    {
        // Disable user A
        $this->userA->update(['is_disabled' => true]);

        $response = $this->withHeader('Authorization', "Bearer {$this->tokenA}")
            ->getJson('/api/v1/me');

        $response->assertStatus(403)
            ->assertJsonPath('message', 'Your account has been suspended by an administrator. Please contact support.');
    }

    public function test_disabled_user_cannot_login(): void
    {
        $user = User::factory()->create([
            'email' => 'disabled@nutriai.app',
            'password' => 'Secret123!',
            'is_disabled' => true,
        ]);

        $response = $this->postJson('/api/v1/login', [
            'email' => 'disabled@nutriai.app',
            'password' => 'Secret123!',
        ]);

        $response->assertStatus(422)
            ->assertJsonValidationErrors(['email']);
    }

    public function test_forgot_password_does_not_leak_user_existence(): void
    {
        // Non-existent email
        $response = $this->postJson('/api/v1/password/forgot', [
            'email' => 'doesnotexist999@example.com',
        ]);

        $response->assertOk()
            ->assertJsonPath('success', true);
    }

    public function test_webhook_rejects_unauthorized_or_timing_attacked_requests(): void
    {
        config(['subscriptions.revenuecat.webhook_secret' => 'super_secret_webhook_key_123']);

        $response = $this->withHeader('Authorization', 'wrong_secret')
            ->postJson('/api/v1/subscription/webhook', [
                'event' => [
                    'id' => 'evt_123',
                    'type' => 'INITIAL_PURCHASE',
                ],
            ]);

        $response->assertStatus(401);
    }

    public function test_upload_validation_rejects_non_image_files(): void
    {
        $fakePhpScript = UploadedFile::fake()->create('malicious.pdf', 50, 'application/pdf');

        $response = $this->withHeader('Authorization', "Bearer {$this->tokenA}")
            ->postJson('/api/v1/meals/analyze', [
                'image' => $fakePhpScript,
            ]);

        $response->assertStatus(422);
    }
}
