<?php

namespace Tests\Feature;

use App\Enums\MealType;
use App\Models\DailySummary;
use App\Models\Meal;
use App\Models\NutritionGoal;
use App\Models\User;
use App\Models\WaterLog;
use Carbon\Carbon;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class DashboardTest extends TestCase
{
    use RefreshDatabase;

    public function test_dashboard_requires_authentication(): void
    {
        $response = $this->getJson('/api/v1/dashboard');
        $response->assertStatus(401);
    }

    public function test_dashboard_returns_zero_consumed_when_no_logs_exist(): void
    {
        $user = User::factory()->create(['timezone' => 'UTC']);
        NutritionGoal::factory()->create([
            'user_id' => $user->id,
            'daily_calories' => 2000,
            'protein_grams' => 150,
            'carbs_grams' => 200,
            'fat_grams' => 67,
            'water_ml' => 2500,
            'effective_from' => '2026-10-01',
        ]);

        Sanctum::actingAs($user);

        $response = $this->getJson('/api/v1/dashboard?date=2026-10-02');

        $response->assertStatus(200)
            ->assertJsonPath('success', true)
            ->assertJsonPath('data.date', '2026-10-02')
            ->assertJsonPath('data.calories.target', 2000)
            ->assertJsonPath('data.calories.consumed', 0)
            ->assertJsonPath('data.calories.remaining', 2000)
            ->assertJsonPath('data.water.target', 2500)
            ->assertJsonPath('data.water.consumed', 0)
            ->assertJsonPath('data.meals.breakfast.calories', 0)
            ->assertJsonPath('data.meals.lunch.calories', 0)
            ->assertJsonPath('data.meals.dinner.calories', 0)
            ->assertJsonPath('data.meals.snack.calories', 0);
    }

    public function test_dashboard_aggregates_seeded_meals_and_water(): void
    {
        $user = User::factory()->create(['timezone' => 'UTC']);
        NutritionGoal::factory()->create([
            'user_id' => $user->id,
            'daily_calories' => 2100,
            'protein_grams' => 160,
            'carbs_grams' => 210,
            'fat_grams' => 70,
            'water_ml' => 2750,
            'effective_from' => '2026-10-01',
        ]);

        $date = '2026-10-02';

        // Seed meals
        Meal::factory()->create([
            'user_id' => $user->id,
            'meal_type' => MealType::BREAKFAST,
            'meal_date' => $date,
            'total_calories' => 450,
            'total_protein' => 30.0,
            'total_carbs' => 50.0,
            'total_fat' => 15.0,
            'total_fiber' => 5.0,
        ]);

        Meal::factory()->create([
            'user_id' => $user->id,
            'meal_type' => MealType::LUNCH,
            'meal_date' => $date,
            'total_calories' => 650,
            'total_protein' => 45.0,
            'total_carbs' => 60.0,
            'total_fat' => 22.0,
            'total_fiber' => 6.0,
        ]);

        Meal::factory()->create([
            'user_id' => $user->id,
            'meal_type' => MealType::SNACK,
            'meal_date' => $date,
            'total_calories' => 200,
            'total_protein' => 15.0,
            'total_carbs' => 20.0,
            'total_fat' => 5.0,
            'total_fiber' => 2.0,
        ]);

        // Seed water logs
        WaterLog::factory()->create([
            'user_id' => $user->id,
            'amount_ml' => 500,
            'logged_at' => Carbon::parse("$date 09:00:00", 'UTC'),
        ]);

        WaterLog::factory()->create([
            'user_id' => $user->id,
            'amount_ml' => 750,
            'logged_at' => Carbon::parse("$date 14:00:00", 'UTC'),
        ]);

        Sanctum::actingAs($user);

        $response = $this->getJson("/api/v1/dashboard?date=$date");

        $response->assertStatus(200)
            ->assertJsonPath('data.calories.target', 2100)
            ->assertJsonPath('data.calories.consumed', 1300) // 450 + 650 + 200
            ->assertJsonPath('data.calories.remaining', 800)
            ->assertJsonPath('data.macros.protein.consumed', 90) // 30 + 45 + 15
            ->assertJsonPath('data.macros.carbs.consumed', 130) // 50 + 60 + 20
            ->assertJsonPath('data.macros.fat.consumed', 42) // 15 + 22 + 5
            ->assertJsonPath('data.water.target', 2750)
            ->assertJsonPath('data.water.consumed', 1250) // 500 + 750
            ->assertJsonPath('data.water.remaining', 1500)
            ->assertJsonPath('data.meals.breakfast.calories', 450)
            ->assertJsonPath('data.meals.lunch.calories', 650)
            ->assertJsonPath('data.meals.snack.calories', 200)
            ->assertJsonPath('data.meals.dinner.calories', 0);

        // Verify DailySummary cache was created/synced by observers
        $summary = DailySummary::where('user_id', $user->id)->whereDate('summary_date', $date)->first();
        $this->assertNotNull($summary);
        $this->assertEquals(1300, $summary->calories);
        $this->assertEquals(1250, $summary->water_ml);
    }

    public function test_observers_update_daily_summary_cache_on_meal_and_water_changes(): void
    {
        $user = User::factory()->create(['timezone' => 'UTC']);
        $date = '2026-10-02';

        // Create meal
        $meal = Meal::factory()->create([
            'user_id' => $user->id,
            'meal_type' => MealType::DINNER,
            'meal_date' => $date,
            'total_calories' => 500,
            'total_protein' => 40.0,
            'total_carbs' => 30.0,
            'total_fat' => 10.0,
            'total_fiber' => 4.0,
        ]);

        $summary = DailySummary::where('user_id', $user->id)->whereDate('summary_date', $date)->first();
        $this->assertNotNull($summary);
        $this->assertEquals(500, $summary->calories);

        // Update meal
        $meal->update(['total_calories' => 650]);
        $summary->refresh();
        $this->assertEquals(650, $summary->calories);

        // Log water
        $water = WaterLog::factory()->create([
            'user_id' => $user->id,
            'amount_ml' => 350,
            'logged_at' => Carbon::parse("$date 12:00:00", 'UTC'),
        ]);

        $summary->refresh();
        $this->assertEquals(350, $summary->water_ml);

        // Delete meal
        $meal->delete();
        $summary->refresh();
        $this->assertEquals(0, $summary->calories);

        // Delete water
        $water->delete();
        $summary->refresh();
        $this->assertEquals(0, $summary->water_ml);
    }

    public function test_invalid_date_format_returns_422(): void
    {
        $user = User::factory()->create();
        Sanctum::actingAs($user);

        $response = $this->getJson('/api/v1/dashboard?date=invalid-date');
        $response->assertStatus(422)
            ->assertJsonPath('success', false)
            ->assertJsonValidationErrors(['date']);
    }
}
