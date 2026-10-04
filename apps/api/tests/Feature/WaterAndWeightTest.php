<?php

namespace Tests\Feature;

use App\Models\DailySummary;
use App\Models\User;
use App\Models\UserProfile;
use App\Models\WaterLog;
use App\Models\WeightLog;
use Carbon\Carbon;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class WaterAndWeightTest extends TestCase
{
    use RefreshDatabase;

    protected User $user;

    protected function setUp(): void
    {
        parent::setUp();
        $this->user = User::factory()->create([
            'timezone' => 'UTC',
        ]);
        UserProfile::factory()->create([
            'user_id' => $this->user->id,
            'weight_kg' => 75.0,
            'target_weight_kg' => 70.0,
            'unit_system' => 'metric',
            'is_completed' => true,
        ]);
        Sanctum::actingAs($this->user);
    }

    public function test_get_water_returns_daily_logs_and_total(): void
    {
        $today = now()->format('Y-m-d');
        WaterLog::factory()->create([
            'user_id' => $this->user->id,
            'amount_ml' => 250,
            'logged_at' => now()->startOfDay()->addHours(8),
        ]);
        WaterLog::factory()->create([
            'user_id' => $this->user->id,
            'amount_ml' => 500,
            'logged_at' => now()->startOfDay()->addHours(12),
        ]);

        $response = $this->getJson("/api/v1/water?date={$today}");

        $response->assertStatus(200)
            ->assertJsonPath('success', true)
            ->assertJsonPath('data.total_ml', 750)
            ->assertJsonCount(2, 'data.logs');
    }

    public function test_post_water_validates_and_updates_daily_summary(): void
    {
        $today = now()->format('Y-m-d');

        // Validation error
        $this->postJson('/api/v1/water', ['amount_ml' => 0])
            ->assertStatus(422)
            ->assertJsonPath('success', false);

        // Valid log
        $response = $this->postJson('/api/v1/water', [
            'amount_ml' => 500,
            'date' => $today,
        ]);

        $response->assertStatus(201)
            ->assertJsonPath('success', true)
            ->assertJsonPath('data.log.amount_ml', 500)
            ->assertJsonPath('data.total_ml', 500);

        // Verify DailySummary cache was updated by observer
        $summary = DailySummary::where('user_id', $this->user->id)
            ->whereDate('summary_date', $today)
            ->first();

        $this->assertNotNull($summary);
        $this->assertEquals(500, $summary->water_ml);
    }

    public function test_delete_water_with_id_and_undo_last_entry(): void
    {
        $today = now()->format('Y-m-d');
        $log1 = WaterLog::factory()->create([
            'user_id' => $this->user->id,
            'amount_ml' => 250,
            'logged_at' => now()->startOfDay()->addHours(9),
        ]);
        $log2 = WaterLog::factory()->create([
            'user_id' => $this->user->id,
            'amount_ml' => 500,
            'logged_at' => now()->startOfDay()->addHours(14),
        ]);

        // Delete specific log1
        $this->deleteJson("/api/v1/water/{$log1->id}")
            ->assertStatus(200)
            ->assertJsonPath('data.total_ml', 500);

        $this->assertDatabaseMissing('water_logs', ['id' => $log1->id]);

        // Undo last entry (log2) without ID parameter
        $this->deleteJson("/api/v1/water?date={$today}")
            ->assertStatus(200)
            ->assertJsonPath('data.deleted_log.id', $log2->id)
            ->assertJsonPath('data.total_ml', 0);

        $this->assertDatabaseMissing('water_logs', ['id' => $log2->id]);
    }

    public function test_user_cannot_delete_another_users_water_log(): void
    {
        $otherUser = User::factory()->create();
        $otherLog = WaterLog::factory()->create([
            'user_id' => $otherUser->id,
            'amount_ml' => 500,
        ]);

        $this->deleteJson("/api/v1/water/{$otherLog->id}")
            ->assertStatus(403);

        $this->assertDatabaseHas('water_logs', ['id' => $otherLog->id]);
    }

    public function test_get_weight_returns_history_and_targets(): void
    {
        WeightLog::factory()->create([
            'user_id' => $this->user->id,
            'weight_kg' => 76.5,
            'logged_at' => now()->subDays(5),
        ]);
        WeightLog::factory()->create([
            'user_id' => $this->user->id,
            'weight_kg' => 75.0,
            'logged_at' => now()->subDay(),
        ]);

        $response = $this->getJson('/api/v1/weight');

        $response->assertStatus(200)
            ->assertJsonPath('success', true)
            ->assertJsonCount(2, 'data.logs');

        $this->assertEquals(70.0, $response->json('data.target_weight_kg'));
    }

    public function test_post_weight_validates_and_syncs_latest_to_user_profile(): void
    {
        // Validation error
        $this->postJson('/api/v1/weight', ['weight_kg' => 15.0]) // Below min 20kg
            ->assertStatus(422);

        // Valid new weight
        $response = $this->postJson('/api/v1/weight', [
            'weight_kg' => 74.2,
            'date' => now()->format('Y-m-d'),
            'sync_profile' => true,
        ]);

        $response->assertStatus(201)
            ->assertJsonPath('success', true)
            ->assertJsonPath('data.weight_kg', 74.2);

        // Check user_profiles.weight_kg synced
        $this->assertEquals(74.2, $this->user->fresh()->profile->weight_kg);

        // Add older weight entry with sync_profile=true: should NOT overwrite newer profile weight
        $this->postJson('/api/v1/weight', [
            'weight_kg' => 78.0,
            'logged_at' => now()->subDays(10)->toIso8601String(),
            'sync_profile' => true,
        ])->assertStatus(201);

        $this->assertEquals(74.2, $this->user->fresh()->profile->weight_kg);
    }

    public function test_delete_weight_updates_profile_to_previous_latest(): void
    {
        $oldLog = WeightLog::factory()->create([
            'user_id' => $this->user->id,
            'weight_kg' => 75.0,
            'logged_at' => now()->subDays(2),
        ]);

        $latestLog = WeightLog::factory()->create([
            'user_id' => $this->user->id,
            'weight_kg' => 74.0,
            'logged_at' => now(),
        ]);
        $this->user->profile->update(['weight_kg' => 74.0]);

        // Delete latest
        $this->deleteJson("/api/v1/weight/{$latestLog->id}")
            ->assertStatus(200);

        $this->assertDatabaseMissing('weight_logs', ['id' => $latestLog->id]);

        // Profile should revert to oldLog weight (75.0)
        $this->assertEquals(75.0, $this->user->fresh()->profile->weight_kg);
    }
}
