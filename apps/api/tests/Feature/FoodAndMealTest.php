<?php

namespace Tests\Feature;

use App\Enums\MealType;
use App\Models\DailySummary;
use App\Models\FavoriteFood;
use App\Models\Food;
use App\Models\Meal;
use App\Models\User;
use App\Services\Meal\MealCalculationService;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class FoodAndMealTest extends TestCase
{
    use RefreshDatabase;

    public function test_meal_calculation_service_computes_exact_totals(): void
    {
        $food1 = Food::factory()->create([
            'name' => 'Chicken Breast',
            'serving_size' => 100.0,
            'serving_unit' => 'g',
            'calories' => 165,
            'protein' => 31.0,
            'carbs' => 0.0,
            'fat' => 3.6,
            'fiber' => 0.0,
        ]);

        $food2 = Food::factory()->create([
            'name' => 'Brown Rice',
            'serving_size' => 50.0,
            'serving_unit' => 'g',
            'calories' => 170,
            'protein' => 3.5,
            'carbs' => 36.0,
            'fat' => 1.5,
            'fiber' => 2.0,
        ]);

        $service = new MealCalculationService();

        // 200g chicken (2x serving) + 100g rice (2x serving)
        $result = $service->calculate([
            [
                'food_id' => $food1->id,
                'quantity' => 200,
                'unit' => 'g',
            ],
            [
                'food_id' => $food2->id,
                'quantity' => 100,
                'unit' => 'g',
            ],
        ]);

        $totals = $result['totals'];
        // Chicken 2x: 330 kcal, 62g P, 0g C, 7.2g F, 0g fiber
        // Rice 2x: 340 kcal, 7g P, 72g C, 3g F, 4g fiber
        $this->assertEquals(670, $totals['total_calories']);
        $this->assertEquals(69.0, $totals['total_protein']);
        $this->assertEquals(72.0, $totals['total_carbs']);
        $this->assertEquals(10.2, $totals['total_fat']);
        $this->assertEquals(4.0, $totals['total_fiber']);
    }

    public function test_food_search_returns_verified_and_user_custom_foods_only(): void
    {
        $user1 = User::factory()->create();
        $user2 = User::factory()->create();

        $verifiedFood = Food::factory()->create([
            'name' => 'Organic Rolled Oats',
            'is_verified' => true,
            'user_id' => null,
        ]);

        $user1CustomFood = Food::factory()->custom($user1->id)->create([
            'name' => 'User 1 Special Oats Bowl',
        ]);

        $user2CustomFood = Food::factory()->custom($user2->id)->create([
            'name' => 'User 2 Secret Oats',
        ]);

        Sanctum::actingAs($user1);

        $response = $this->getJson('/api/v1/foods/search?q=Oats');

        $response->assertStatus(200)
            ->assertJsonPath('success', true);

        $foodNames = collect($response->json('data.data'))->pluck('name')->toArray();

        $this->assertContains('Organic Rolled Oats', $foodNames);
        $this->assertContains('User 1 Special Oats Bowl', $foodNames);
        $this->assertNotContains('User 2 Secret Oats', $foodNames);
    }

    public function test_user_can_create_custom_food(): void
    {
        $user = User::factory()->create();
        Sanctum::actingAs($user);

        $response = $this->postJson('/api/v1/foods/custom', [
            'name' => 'Homemade Protein Shake',
            'brand' => 'Kitchen',
            'serving_size' => 350,
            'serving_unit' => 'ml',
            'calories' => 320,
            'protein' => 35.5,
            'carbs' => 25.0,
            'fat' => 6.0,
            'fiber' => 4.0,
        ]);

        $response->assertStatus(201)
            ->assertJsonPath('data.name', 'Homemade Protein Shake')
            ->assertJsonPath('data.is_verified', false)
            ->assertJsonPath('data.user_id', $user->id);

        $this->assertDatabaseHas('foods', [
            'name' => 'Homemade Protein Shake',
            'user_id' => $user->id,
            'is_verified' => false,
        ]);
    }

    public function test_user_can_toggle_food_favorite(): void
    {
        $user = User::factory()->create();
        $food = Food::factory()->create(['is_verified' => true]);

        Sanctum::actingAs($user);

        // Add favorite
        $response1 = $this->postJson("/api/v1/foods/{$food->id}/favorite");
        $response1->assertStatus(200)
            ->assertJsonPath('data.is_favorite', true);

        $this->assertDatabaseHas('favorite_foods', [
            'user_id' => $user->id,
            'food_id' => $food->id,
        ]);

        // Remove favorite
        $response2 = $this->postJson("/api/v1/foods/{$food->id}/favorite");
        $response2->assertStatus(200)
            ->assertJsonPath('data.is_favorite', false);

        $this->assertDatabaseMissing('favorite_foods', [
            'user_id' => $user->id,
            'food_id' => $food->id,
        ]);
    }

    public function test_meal_creation_ignores_client_totals_and_updates_daily_summary(): void
    {
        $user = User::factory()->create(['timezone' => 'UTC']);
        $date = '2026-10-02';

        $food = Food::factory()->create([
            'serving_size' => 100,
            'calories' => 200,
            'protein' => 20,
            'carbs' => 10,
            'fat' => 5,
        ]);

        Sanctum::actingAs($user);

        // Client attempts to pass fake low calories (100) instead of actual 400 (for 200g)
        $response = $this->postJson('/api/v1/meals', [
            'meal_type' => 'lunch',
            'meal_date' => $date,
            'meal_time' => '13:00:00',
            'total_calories' => 100, // Should be ignored
            'items' => [
                [
                    'food_id' => $food->id,
                    'food_name' => $food->name,
                    'quantity' => 200, // 2x serving
                    'unit' => 'g',
                ],
            ],
        ]);

        $response->assertStatus(201)
            ->assertJsonPath('data.total_calories', 400)
            ->assertJsonPath('data.total_protein', 40)
            ->assertJsonPath('data.total_carbs', 20)
            ->assertJsonPath('data.total_fat', 10);

        // DailySummary cache was updated by MealObserver
        $summary = DailySummary::where('user_id', $user->id)->whereDate('summary_date', $date)->first();
        $this->assertNotNull($summary);
        $this->assertEquals(400, $summary->calories);
    }

    public function test_user_cannot_access_or_modify_another_users_meal(): void
    {
        $owner = User::factory()->create();
        $otherUser = User::factory()->create();

        $meal = Meal::factory()->create([
            'user_id' => $owner->id,
            'meal_date' => '2026-10-02',
            'meal_type' => MealType::DINNER,
            'total_calories' => 500,
        ]);

        Sanctum::actingAs($otherUser);

        // Show should be forbidden (403)
        $this->getJson("/api/v1/meals/{$meal->id}")
            ->assertStatus(403);

        // Update should be forbidden (403)
        $this->putJson("/api/v1/meals/{$meal->id}", [
            'meal_type' => 'snack',
        ])->assertStatus(403);

        // Delete should be forbidden (403)
        $this->deleteJson("/api/v1/meals/{$meal->id}")
            ->assertStatus(403);

        // Meal should remain untouched
        $this->assertDatabaseHas('meals', ['id' => $meal->id]);
    }

    public function test_meal_delete_removes_meal_and_updates_daily_summary(): void
    {
        $user = User::factory()->create();
        $date = '2026-10-02';

        $meal = Meal::factory()->create([
            'user_id' => $user->id,
            'meal_date' => $date,
            'total_calories' => 600,
        ]);

        $summary = DailySummary::where('user_id', $user->id)->whereDate('summary_date', $date)->first();
        $this->assertNotNull($summary);
        $this->assertEquals(600, $summary->calories);

        Sanctum::actingAs($user);

        $response = $this->deleteJson("/api/v1/meals/{$meal->id}");
        $response->assertStatus(200);

        $this->assertDatabaseMissing('meals', ['id' => $meal->id]);

        $summary->refresh();
        $this->assertEquals(0, $summary->calories);
    }
}
