<?php

namespace Tests\Feature;

use App\Models\AiAnalysis;
use App\Models\Food;
use App\Models\Meal;
use App\Models\User;
use App\Services\AI\Providers\FakeFoodAnalysisProvider;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\Storage;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class AiScanE2EScenarioTest extends TestCase
{
    use RefreshDatabase;

    public function test_full_ai_scan_e2e_scenario(): void
    {
        // 1. Arrange & Authenticate User
        Storage::fake('local');
        Config::set('ai.default', 'fake');
        Config::set('ai.storage.disk', 'local');

        $user = User::factory()->create([
            'timezone' => 'Asia/Kolkata',
        ]);
        Sanctum::actingAs($user);

        // Verify initial dashboard consumption is 0
        $initialDash = $this->getJson('/api/v1/dashboard')->assertStatus(200)->json('data');
        $this->assertEquals(0, $initialDash['calories']['consumed']);

        // 2. Upload image to POST /api/v1/meals/analyze
        $image = UploadedFile::fake()->image('lunch_platter.jpg', 1280, 960);
        $analyzeResponse = $this->postJson('/api/v1/meals/analyze', [
            'image' => $image,
            'meal_type' => 'lunch',
        ]);

        $analyzeResponse->assertStatus(200)
            ->assertJsonPath('success', true)
            ->assertJsonPath('data.status', 'completed')
            ->assertJsonPath('data.is_food', true);

        $analysisId = $analyzeResponse->json('data.analysis_id');
        $detectedItems = $analyzeResponse->json('data.items');
        $this->assertNotEmpty($detectedItems);

        // 3. User adjustments on Review Screen:
        // - Rescale first item portion proportionally
        $first = $detectedItems[0];
        $ratio = 1.5;
        $newQty = $first['quantity'] * $ratio;
        $rescaledCalories = (int) round($first['calories'] * $ratio);
        $rescaledProtein = round($first['protein'] * $ratio, 1);
        $rescaledCarbs = round($first['carbs'] * $ratio, 1);
        $rescaledFat = round($first['fat'] * $ratio, 1);

        $itemsToSave = [];
        $itemsToSave[] = [
            'food_name' => $first['name'],
            'quantity' => $newQty,
            'unit' => $first['unit'],
            'calories' => $rescaledCalories,
            'protein' => $rescaledProtein,
            'carbs' => $rescaledCarbs,
            'fat' => $rescaledFat,
        ];

        // - Add a verified food item
        $addedFood = Food::factory()->create([
            'name' => 'Greek Yogurt',
            'serving_size' => 100,
            'calories' => 100,
            'protein' => 10.0,
            'carbs' => 4.0,
            'fat' => 5.0,
        ]);
        $itemsToSave[] = [
            'food_id' => $addedFood->id,
            'food_name' => $addedFood->name,
            'quantity' => 150,
            'unit' => 'g',
            'calories' => 150,
            'protein' => 15.0,
            'carbs' => 6.0,
            'fat' => 7.5,
        ];

        // 4. Save Meal via POST /api/v1/meals with source=ai and analysis_id
        $saveResponse = $this->postJson('/api/v1/meals', [
            'meal_type' => 'lunch',
            'meal_date' => now()->format('Y-m-d'),
            'meal_time' => '13:30:00',
            'source' => 'ai',
            'analysis_id' => $analysisId,
            'items' => $itemsToSave,
        ]);

        $saveResponse->assertStatus(201)
            ->assertJsonPath('success', true)
            ->assertJsonPath('data.source', 'ai');

        $mealId = $saveResponse->json('data.id');

        // 5. Verify analysis is linked to meal
        $analysis = AiAnalysis::find($analysisId);
        $this->assertEquals($mealId, $analysis->meal_id);

        // 6. Verify dashboard refreshes with newly logged AI meal
        $refreshedDash = $this->getJson('/api/v1/dashboard')->assertStatus(200)->json('data');
        $this->assertGreaterThan(0, $refreshedDash['calories']['consumed']);
        $this->assertGreaterThan(0, $refreshedDash['macros']['protein']['consumed']);
        $this->assertEquals($saveResponse->json('data.total_calories'), $refreshedDash['meals']['lunch']['calories']);
    }

    /**
     * Critical E2E Scenario:
     * register -> onboarding -> dashboard -> scan -> edit -> save -> updates -> logout -> login -> meal persists
     */
    public function test_full_critical_e2e_scenario(): void
    {
        Storage::fake('local');
        Config::set('ai.default', 'fake');
        Config::set('ai.storage.disk', 'local');

        // 1. Register
        $userEmail = 'e2e_user_' . uniqid() . '@nutriai.test';
        $userPassword = 'SecureP@ssw0rd!';

        $registerResponse = $this->postJson('/api/v1/register', [
            'name' => 'E2E Test User',
            'email' => $userEmail,
            'password' => $userPassword,
            'password_confirmation' => $userPassword,
        ]);

        $registerResponse->assertStatus(201)
            ->assertJsonPath('success', true);

        // 2. Initial Login to acquire auth token
        $loginResponse1 = $this->postJson('/api/v1/login', [
            'email' => $userEmail,
            'password' => $userPassword,
        ]);
        $loginResponse1->assertStatus(200)
            ->assertJsonPath('success', true);
        $token1 = $loginResponse1->json('data.token');
        $this->assertNotEmpty($token1);

        $authHeader1 = ['Authorization' => "Bearer {$token1}"];

        // 3. Onboarding
        $onboardingResponse = $this->postJson('/api/v1/onboarding', [
            'goal' => 'lose_weight',
            'gender' => 'female',
            'date_of_birth' => '1995-05-15',
            'height_cm' => 168.0,
            'weight_kg' => 70.0,
            'target_weight_kg' => 62.0,
            'activity_level' => 'moderately_active',
            'diet_type' => 'standard',
            'unit_system' => 'metric',
        ], $authHeader1);

        $onboardingResponse->assertStatus(200)
            ->assertJsonPath('success', true);

        // 4. Dashboard
        $dashResponse = $this->getJson('/api/v1/dashboard', $authHeader1);
        $dashResponse->assertStatus(200)
            ->assertJsonPath('data.calories.consumed', 0);
        $this->assertGreaterThan(0, $dashResponse->json('data.calories.target'));

        // 5. Scan
        $image = UploadedFile::fake()->image('lunch_scan.png', 800, 600);
        $scanResponse = $this->postJson('/api/v1/meals/analyze', [
            'image' => $image,
            'meal_type' => 'lunch',
        ], $authHeader1);

        $scanResponse->assertStatus(200)
            ->assertJsonPath('success', true)
            ->assertJsonPath('data.is_food', true);

        $analysisId = $scanResponse->json('data.analysis_id');
        $detectedItems = $scanResponse->json('data.items');
        $this->assertNotEmpty($detectedItems);

        // 6. Edit portions
        $editedItems = [];
        foreach ($detectedItems as $item) {
            $editedItems[] = [
                'food_name' => $item['name'] . ' (Adjusted)',
                'quantity' => round($item['quantity'] * 1.2, 1),
                'unit' => $item['unit'],
                'calories' => (int) round($item['calories'] * 1.2),
                'protein' => round($item['protein'] * 1.2, 1),
                'carbs' => round($item['carbs'] * 1.2, 1),
                'fat' => round($item['fat'] * 1.2, 1),
            ];
        }

        // 7. Save meal
        $saveResponse = $this->postJson('/api/v1/meals', [
            'meal_type' => 'lunch',
            'meal_date' => now()->format('Y-m-d'),
            'meal_time' => '12:45:00',
            'source' => 'ai',
            'analysis_id' => $analysisId,
            'items' => $editedItems,
        ], $authHeader1);

        $saveResponse->assertStatus(201)
            ->assertJsonPath('success', true);
        $savedMealId = $saveResponse->json('data.id');
        $savedTotalCalories = $saveResponse->json('data.total_calories');

        // 8. Updates (Dashboard reflects updates)
        $dashAfterSave = $this->getJson('/api/v1/dashboard', $authHeader1);
        $dashAfterSave->assertStatus(200);
        $this->assertEquals($savedTotalCalories, $dashAfterSave->json('data.calories.consumed'));
        $this->assertEquals($savedTotalCalories, $dashAfterSave->json('data.meals.lunch.calories'));

        // 9. Logout
        $logoutResponse = $this->postJson('/api/v1/logout', [], $authHeader1);
        $logoutResponse->assertStatus(200)
            ->assertJsonPath('success', true);

        // Reset in-memory guard cache to verify token revocation against DB
        $this->app['auth']->forgetGuards();

        // Verify token1 is revoked
        $this->getJson('/api/v1/dashboard', $authHeader1)->assertStatus(401);

        // 10. Login
        $loginResponse2 = $this->postJson('/api/v1/login', [
            'email' => $userEmail,
            'password' => $userPassword,
        ]);
        $loginResponse2->assertStatus(200)
            ->assertJsonPath('success', true);
        $token2 = $loginResponse2->json('data.token');
        $this->assertNotEmpty($token2);
        $authHeader2 = ['Authorization' => "Bearer {$token2}"];

        // 11. Meal Persists
        $getMealResponse = $this->getJson("/api/v1/meals/{$savedMealId}", $authHeader2);
        $getMealResponse->assertStatus(200)
            ->assertJsonPath('success', true)
            ->assertJsonPath('data.id', $savedMealId)
            ->assertJsonPath('data.total_calories', $savedTotalCalories);

        $dashAfterLogin = $this->getJson('/api/v1/dashboard', $authHeader2);
        $dashAfterLogin->assertStatus(200);
        $this->assertEquals($savedTotalCalories, $dashAfterLogin->json('data.calories.consumed'));
        $this->assertEquals($savedTotalCalories, $dashAfterLogin->json('data.meals.lunch.calories'));
    }
}
