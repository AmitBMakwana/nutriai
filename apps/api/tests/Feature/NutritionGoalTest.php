<?php

namespace Tests\Feature;

use App\Models\User;
use App\Models\UserProfile;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class NutritionGoalTest extends TestCase
{
    use RefreshDatabase;

    public function test_onboarding_automatically_creates_initial_nutrition_goal(): void
    {
        $user = User::factory()->create();
        Sanctum::actingAs($user);

        $payload = [
            'goal' => 'lose_weight',
            'gender' => 'male',
            'date_of_birth' => '1995-06-15',
            'height_cm' => 175,
            'weight_kg' => 75.0,
            'target_weight_kg' => 70.0,
            'activity_level' => 'moderately_active',
            'diet_type' => 'everything',
            'unit_system' => 'metric',
        ];

        $response = $this->postJson('/api/v1/onboarding', $payload);
        $response->assertStatus(200);

        // Check nutrition_goals row was created
        $this->assertDatabaseHas('nutrition_goals', [
            'user_id' => $user->id,
            'daily_calories' => 2125, // 75kg, 175cm, ~31yo, moderate activity, lose (-500)
        ]);

        $goal = $user->nutritionGoals()->first();
        $this->assertNotNull($goal);
        $this->assertGreaterThan(0, $goal->protein_grams);
        $this->assertGreaterThan(0, $goal->carbs_grams);
        $this->assertGreaterThan(0, $goal->fat_grams);
        $this->assertGreaterThan(0, $goal->water_ml);
    }

    public function test_get_goals_returns_active_goal(): void
    {
        $user = User::factory()->create();
        $user->nutritionGoals()->create([
            'daily_calories' => 2200,
            'protein_grams' => 165,
            'carbs_grams' => 220,
            'fat_grams' => 73,
            'water_ml' => 2500,
            'effective_from' => now()->toDateString(),
        ]);

        Sanctum::actingAs($user);

        $response = $this->getJson('/api/v1/goals');

        $response->assertStatus(200)
            ->assertJson([
                'success' => true,
                'data' => [
                    'daily_calories' => 2200,
                    'protein_grams' => 165,
                    'carbs_grams' => 220,
                    'fat_grams' => 73,
                    'water_ml' => 2500,
                ],
            ]);
    }

    public function test_post_goals_calculate_previews_without_saving(): void
    {
        $user = User::factory()->create();
        Sanctum::actingAs($user);

        $initialGoalsCount = $user->nutritionGoals()->count();

        $response = $this->postJson('/api/v1/goals/calculate', [
            'weight_kg' => 80.0,
            'height_cm' => 180.0,
            'date_of_birth' => '1996-01-01',
            'gender' => 'female',
            'activity_level' => 'very_active',
            'goal' => 'build_muscle',
        ]);

        $response->assertStatus(200)
            ->assertJsonStructure([
                'success',
                'data' => [
                    'bmr',
                    'tdee',
                    'daily_calories',
                    'protein_grams',
                    'carbs_grams',
                    'fat_grams',
                    'water_ml',
                    'macro_split',
                ],
            ]);

        // Verifies no record was saved into database
        $this->assertEquals($initialGoalsCount, $user->nutritionGoals()->count());
    }

    public function test_put_goals_overrides_goals(): void
    {
        $user = User::factory()->create();
        Sanctum::actingAs($user);

        $response = $this->putJson('/api/v1/goals', [
            'daily_calories' => 2400,
            'protein_grams' => 180,
            'carbs_grams' => 240,
            'fat_grams' => 80,
            'water_ml' => 3000,
        ]);

        $response->assertStatus(200)
            ->assertJson([
                'success' => true,
                'data' => [
                    'daily_calories' => 2400,
                    'protein_grams' => 180,
                    'carbs_grams' => 240,
                    'fat_grams' => 80,
                    'water_ml' => 3000,
                ],
            ]);

        $this->assertDatabaseHas('nutrition_goals', [
            'user_id' => $user->id,
            'daily_calories' => 2400,
            'protein_grams' => 180,
        ]);
    }

    public function test_put_goals_validates_inputs(): void
    {
        $user = User::factory()->create();
        Sanctum::actingAs($user);

        $response = $this->putJson('/api/v1/goals', [
            'daily_calories' => 100, // too low, minimum is 800
            'protein_grams' => 0,
        ]);

        $response->assertStatus(422)
            ->assertJsonValidationErrors(['daily_calories', 'protein_grams', 'carbs_grams', 'fat_grams', 'water_ml']);
    }
}
