<?php

namespace Tests\Feature;

use App\Enums\AiAnalysisStatus;
use App\Models\AiAnalysis;
use App\Models\Subscription;
use App\Models\User;
use App\Services\AI\AIProviderManager;
use App\Services\AI\Contracts\FoodAnalysisProvider;
use App\Services\AI\Providers\FakeFoodAnalysisProvider;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\Storage;
use Laravel\Sanctum\Sanctum;
use RuntimeException;
use Tests\TestCase;

class MealAnalysisTest extends TestCase
{
    use RefreshDatabase;

    protected User $user;

    protected function setUp(): void
    {
        parent::setUp();
        Storage::fake('local');
        Config::set('ai.default', 'fake');
        Config::set('ai.storage.disk', 'local');

        $this->user = User::factory()->create();
        Sanctum::actingAs($this->user);
    }

    public function test_authenticated_user_can_analyze_meal_successfully(): void
    {
        $file = UploadedFile::fake()->image('healthy_salad.jpg', 800, 600);

        $response = $this->postJson('/api/v1/meals/analyze', [
            'image' => $file,
            'meal_type' => 'lunch',
        ]);

        $response->assertStatus(200)
            ->assertJson([
                'success' => true,
                'message' => 'Meal analyzed successfully',
                'data' => [
                    'status' => 'completed',
                    'is_food' => true,
                    'meal_type' => 'lunch',
                ],
            ])
            ->assertJsonStructure([
                'data' => [
                    'analysis_id',
                    'status',
                    'is_food',
                    'meal_name',
                    'confidence',
                    'items' => [
                        '*' => ['name', 'quantity', 'unit', 'calories', 'protein', 'carbs', 'fat', 'confidence'],
                    ],
                    'total' => ['calories', 'protein', 'carbs', 'fat'],
                    'image_url',
                    'processing_time_ms',
                ],
            ]);

        $analysisId = $response->json('data.analysis_id');
        $this->assertDatabaseHas('ai_analyses', [
            'id' => $analysisId,
            'user_id' => $this->user->id,
            'status' => AiAnalysisStatus::COMPLETED->value,
        ]);
    }

    public function test_invalid_ai_output_marks_analysis_failed_and_returns_friendly_error(): void
    {
        // Bind a custom provider returning invalid negative numbers
        $manager = $this->app->make(AIProviderManager::class);
        $manager->extend('fake', function () {
            $fake = new FakeFoodAnalysisProvider();
            $fake->setCustomResponse([
                'is_food' => true,
                'meal_name' => 'Bad Math Food',
                'estimated_items' => [
                    [
                        'name' => 'Ghost Food',
                        'quantity' => 100,
                        'unit' => 'g',
                        'calories' => 100,
                        'protein' => -50.0, // Invalid!
                        'carbs' => 0,
                        'fat' => 0,
                    ],
                ],
            ]);
            return $fake;
        });

        $file = UploadedFile::fake()->image('corrupt.jpg', 400, 400);

        $response = $this->postJson('/api/v1/meals/analyze', [
            'image' => $file,
        ]);

        $response->assertStatus(422)
            ->assertJson([
                'success' => false,
                'data' => [
                    'status' => 'failed',
                ],
            ]);

        $this->assertDatabaseHas('ai_analyses', [
            'user_id' => $this->user->id,
            'status' => AiAnalysisStatus::FAILED->value,
        ]);
    }

    public function test_provider_transient_failure_exhausts_retries_and_returns_502(): void
    {
        $manager = $this->app->make(AIProviderManager::class);
        $manager->extend('fake', function () {
            return new class implements FoodAnalysisProvider {
                public function analyze(string $imagePath): array
                {
                    throw new RuntimeException('Connection timed out to vision API.');
                }
            };
        });

        $file = UploadedFile::fake()->image('lunch.jpg', 600, 600);

        $response = $this->postJson('/api/v1/meals/analyze', [
            'image' => $file,
        ]);

        $response->assertStatus(502)
            ->assertJson([
                'success' => false,
                'message' => 'AI vision service is temporarily unavailable. Please try again in a few moments.',
                'data' => [
                    'status' => 'failed',
                ],
            ]);

        $this->assertDatabaseHas('ai_analyses', [
            'user_id' => $this->user->id,
            'status' => AiAnalysisStatus::FAILED->value,
        ]);
    }

    public function test_handles_non_food_image_gracefully(): void
    {
        $file = UploadedFile::fake()->image('non-food-living-room.jpg', 600, 600);

        $response = $this->postJson('/api/v1/meals/analyze', [
            'image' => $file,
        ]);

        $response->assertStatus(200)
            ->assertJson([
                'success' => true,
                'data' => [
                    'is_food' => false,
                    'meal_name' => 'Non-food item',
                    'items' => [],
                    'total' => [
                        'calories' => 0,
                    ],
                ],
            ]);
    }

    public function test_enforces_monthly_scan_quota_for_free_users(): void
    {
        Config::set('ai.quota.free', 5);

        // Seed 5 completed analyses for user this month
        for ($i = 0; $i < 5; $i++) {
            AiAnalysis::create([
                'user_id' => $this->user->id,
                'provider' => 'fake',
                'model' => 'default',
                'image_path' => "meal-uploads/past_{$i}.jpg",
                'status' => AiAnalysisStatus::COMPLETED,
                'created_at' => now(),
            ]);
        }

        $file = UploadedFile::fake()->image('sixth_meal.jpg', 600, 600);

        // 6th scan should be rejected with 429
        $response = $this->postJson('/api/v1/meals/analyze', [
            'image' => $file,
        ]);

        $response->assertStatus(429)
            ->assertJson([
                'success' => false,
                'data' => [
                    'used' => 5,
                    'quota' => 5,
                    'plan' => 'free',
                ],
            ]);
    }

    public function test_pro_user_can_exceed_free_quota(): void
    {
        Config::set('ai.quota.free', 5);
        Config::set('ai.quota.pro', 100);

        // Make user Pro
        Subscription::create([
            'user_id' => $this->user->id,
            'provider' => 'stripe',
            'plan' => 'pro',
            'status' => 'active',
            'starts_at' => now()->subDay(),
        ]);

        // Seed 5 completed analyses
        for ($i = 0; $i < 5; $i++) {
            AiAnalysis::create([
                'user_id' => $this->user->id,
                'provider' => 'fake',
                'model' => 'default',
                'image_path' => "meal-uploads/past_{$i}.jpg",
                'status' => AiAnalysisStatus::COMPLETED,
                'created_at' => now(),
            ]);
        }

        $file = UploadedFile::fake()->image('sixth_meal.jpg', 600, 600);

        // Pro user can proceed past 5
        $response = $this->postJson('/api/v1/meals/analyze', [
            'image' => $file,
        ]);

        $response->assertStatus(200)
            ->assertJson([
                'success' => true,
                'data' => [
                    'status' => 'completed',
                ],
            ]);
    }

    public function test_owner_can_view_analysis(): void
    {
        $analysis = AiAnalysis::create([
            'user_id' => $this->user->id,
            'provider' => 'fake',
            'model' => 'default',
            'image_path' => 'meal-uploads/user_1/sample.jpg',
            'status' => AiAnalysisStatus::COMPLETED,
            'confidence' => 0.95,
            'parsed_response' => [
                'is_food' => true,
                'meal_name' => 'Paneer Butter Masala',
                'estimated_items' => [
                    ['name' => 'Paneer', 'quantity' => 150, 'unit' => 'g', 'calories' => 380, 'protein' => 18, 'carbs' => 8, 'fat' => 30],
                ],
                'total_calories' => 380,
                'total_protein' => 18,
                'total_carbs' => 8,
                'total_fat' => 30,
            ],
            'processing_time_ms' => 450,
        ]);

        $response = $this->getJson("/api/v1/ai-analysis/{$analysis->id}");

        $response->assertStatus(200)
            ->assertJson([
                'success' => true,
                'data' => [
                    'analysis_id' => $analysis->id,
                    'status' => 'completed',
                    'meal_name' => 'Paneer Butter Masala',
                    'total' => [
                        'calories' => 380,
                    ],
                ],
            ]);
    }

    public function test_unauthorized_user_cannot_view_another_users_analysis(): void
    {
        $otherUser = User::factory()->create();
        $analysis = AiAnalysis::create([
            'user_id' => $otherUser->id,
            'provider' => 'fake',
            'model' => 'default',
            'image_path' => 'meal-uploads/other/sample.jpg',
            'status' => AiAnalysisStatus::COMPLETED,
        ]);

        $response = $this->getJson("/api/v1/ai-analysis/{$analysis->id}");

        $response->assertStatus(403)
            ->assertJson([
                'success' => false,
                'message' => 'Unauthorized access to meal analysis.',
            ]);
    }

    public function test_analyze_validates_mimetype_and_size(): void
    {
        $badFile = UploadedFile::fake()->create('document.pdf', 1000, 'application/pdf');

        $response = $this->postJson('/api/v1/meals/analyze', [
            'image' => $badFile,
        ]);

        $response->assertStatus(422)
            ->assertJsonValidationErrors(['image']);
    }
}
