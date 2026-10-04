<?php

namespace Tests\Feature;

use App\Models\DailySummary;
use App\Models\Meal;
use App\Models\NutritionGoal;
use App\Models\User;
use App\Models\UserProfile;
use App\Models\WeightLog;
use Carbon\Carbon;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class ProgressTest extends TestCase
{
    use RefreshDatabase;

    protected User $user;

    protected function setUp(): void
    {
        parent::setUp();

        $this->user = User::factory()->create(['timezone' => 'UTC']);

        UserProfile::factory()->create([
            'user_id'          => $this->user->id,
            'weight_kg'        => 80.0,
            'target_weight_kg' => 75.0,
            'unit_system'      => 'metric',
            'is_completed'     => true,
        ]);

        NutritionGoal::factory()->create([
            'user_id'        => $this->user->id,
            'daily_calories' => 2000,
            'protein_grams'  => 150,
            'carbs_grams'    => 200,
            'fat_grams'      => 67,
            'water_ml'       => 2500,
            'effective_from' => now()->subYear(),
        ]);

        Sanctum::actingAs($this->user);
    }

    // ─── Seed helpers ────────────────────────────────────────────────────────

    private function seedSummaries(int $days, int $baseCalories = 1800): void
    {
        for ($i = $days - 1; $i >= 0; $i--) {
            DailySummary::create([
                'user_id'      => $this->user->id,
                'summary_date' => now()->subDays($i)->toDateString(),
                'calories'     => $baseCalories + ($i * 10),
                'protein'      => 140.0,
                'carbs'        => 190.0,
                'fat'          => 60.0,
                'fiber'        => 20.0,
                'water_ml'     => 2200,
            ]);
        }
    }

    private function seedWeights(): void
    {
        WeightLog::create([
            'user_id'   => $this->user->id,
            'weight_kg' => 80.5,
            'logged_at' => now()->subDays(6),
        ]);
        WeightLog::create([
            'user_id'   => $this->user->id,
            'weight_kg' => 79.8,
            'logged_at' => now()->subDays(3),
        ]);
        WeightLog::create([
            'user_id'   => $this->user->id,
            'weight_kg' => 79.2,
            'logged_at' => now(),
        ]);
    }

    // ─── Tests: GET /progress ────────────────────────────────────────────────

    public function test_progress_default_range_is_7d(): void
    {
        $this->seedSummaries(7);

        $response = $this->getJson('/api/v1/progress');

        $response->assertOk()
            ->assertJsonStructure([
                'success',
                'data' => [
                    'range',
                    'start',
                    'end',
                    'calories' => ['daily', 'average', 'target'],
                    'macros'   => ['average', 'target'],
                    'weight'   => ['series', 'start_kg', 'current_kg', 'target_kg', 'change_kg'],
                    'meals_tracked',
                    'days_on_target',
                    'active_days',
                    'streak',
                ],
            ]);

        $this->assertEquals('7d', $response->json('data.range'));
        $this->assertCount(7, $response->json('data.calories.daily'));
    }

    public function test_progress_30d_range_returns_30_days(): void
    {
        $this->seedSummaries(30);

        $response = $this->getJson('/api/v1/progress?range=30d');

        $response->assertOk();
        $this->assertCount(30, $response->json('data.calories.daily'));
        $this->assertEquals('30d', $response->json('data.range'));
    }

    public function test_progress_returns_macro_averages_correctly(): void
    {
        // All 7 days with the same macros for easy assertion
        for ($i = 6; $i >= 0; $i--) {
            DailySummary::create([
                'user_id'      => $this->user->id,
                'summary_date' => now()->subDays($i)->toDateString(),
                'calories'     => 2000,
                'protein'      => 150.0,
                'carbs'        => 200.0,
                'fat'          => 67.0,
                'fiber'        => 25.0,
                'water_ml'     => 2500,
            ]);
        }

        $response = $this->getJson('/api/v1/progress?range=7d');

        $response->assertOk();
        $averages = $response->json('data.macros.average');
        $this->assertEquals(2000, $averages['calories']);
        $this->assertEquals(150.0, $averages['protein']);
        $this->assertEquals(200.0, $averages['carbs']);
        $this->assertEquals(67.0, $averages['fat']);
    }

    public function test_progress_weight_series_is_returned(): void
    {
        $this->seedSummaries(7);
        $this->seedWeights();

        $response = $this->getJson('/api/v1/progress?range=7d');

        $response->assertOk();
        $weight = $response->json('data.weight');
        $this->assertCount(3, $weight['series']);
        $this->assertEquals(80.5, $weight['start_kg']);
        $this->assertEquals(79.2, $weight['current_kg']);
        $this->assertEquals(-1.3, round($weight['change_kg'], 1));
        $this->assertEquals(75.0, $weight['target_kg']);
    }

    public function test_progress_invalid_range_returns_422(): void
    {
        $this->getJson('/api/v1/progress?range=invalid')
            ->assertStatus(422);
    }

    public function test_progress_empty_for_new_user_returns_zeroes(): void
    {
        $response = $this->getJson('/api/v1/progress');

        $response->assertOk();
        $this->assertEquals(0, $response->json('data.calories.average'));
        $this->assertEquals(0, $response->json('data.active_days'));
        $this->assertEquals(0, $response->json('data.streak'));
    }

    public function test_progress_unauthenticated_returns_401(): void
    {
        $this->app['auth']->forgetGuards();

        $this->getJson('/api/v1/progress')->assertStatus(401);
    }

    // ─── Tests: GET /progress/weekly ─────────────────────────────────────────

    public function test_weekly_returns_7_day_summary(): void
    {
        $this->seedSummaries(7);

        $response = $this->getJson('/api/v1/progress/weekly');

        $response->assertOk()
            ->assertJsonStructure([
                'data' => [
                    'week_start',
                    'week_end',
                    'days',
                    'totals'   => ['calories', 'protein', 'carbs', 'fat'],
                    'averages' => ['calories', 'protein', 'carbs', 'fat'],
                    'calorie_target',
                ],
            ]);

        $this->assertCount(7, $response->json('data.days'));
        $this->assertEquals(2000, $response->json('data.calorie_target'));
    }

    // ─── Tests: GET /progress/monthly ────────────────────────────────────────

    public function test_monthly_returns_correct_days_for_month(): void
    {
        $this->seedSummaries(31);

        $response = $this->getJson('/api/v1/progress/monthly?year=' . now()->year . '&month=' . now()->month);

        $response->assertOk()
            ->assertJsonStructure([
                'data' => [
                    'year',
                    'month',
                    'days',
                    'averages',
                    'calorie_target',
                    'days_on_target',
                    'active_days',
                ],
            ]);

        $expectedDays = now()->daysInMonth;
        $this->assertCount($expectedDays, $response->json('data.days'));
    }

    public function test_monthly_invalid_month_returns_422(): void
    {
        $this->getJson('/api/v1/progress/monthly?month=13')
            ->assertStatus(422);
    }

    // ─── Tests: aggregation timezone correctness ──────────────────────────────

    public function test_streak_counts_consecutive_days_correctly(): void
    {
        // 3 consecutive days ending today
        for ($i = 2; $i >= 0; $i--) {
            DailySummary::create([
                'user_id'      => $this->user->id,
                'summary_date' => now()->subDays($i)->toDateString(),
                'calories'     => 1800,
                'protein'      => 0,
                'carbs'        => 0,
                'fat'          => 0,
                'fiber'        => 0,
                'water_ml'     => 0,
            ]);
        }

        $response = $this->getJson('/api/v1/progress?range=7d');

        $response->assertOk();
        $this->assertEquals(3, $response->json('data.streak'));
    }

    // ─── Tests: RebuildDailySummaries command ─────────────────────────────────

    public function test_rebuild_command_creates_summaries(): void
    {
        // Create a meal for yesterday
        Meal::factory()->create([
            'user_id'        => $this->user->id,
            'meal_date'      => now()->subDay()->toDateString(),
            'total_calories' => 1500,
            'total_protein'  => 100,
            'total_carbs'    => 180,
            'total_fat'      => 50,
            'total_fiber'    => 15,
        ]);

        $this->assertDatabaseMissing('daily_summaries', [
            'user_id'      => $this->user->id,
            'summary_date' => now()->subDay()->toDateString(),
        ]);

        $this->artisan('summaries:rebuild', ['--days' => 2, '--user' => $this->user->id])
            ->assertExitCode(0);

        $this->assertDatabaseHas('daily_summaries', [
            'user_id'  => $this->user->id,
            'calories' => 1500,
        ]);
    }
}
