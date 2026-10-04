<?php

namespace Tests\Feature;

use App\Models\User;
use App\Models\UserProfile;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class OnboardingAndProfileTest extends TestCase
{
    use RefreshDatabase;

    public function test_onboarding_requires_authentication(): void
    {
        $response = $this->postJson('/api/v1/onboarding', []);

        $response->assertStatus(401);
    }

    public function test_onboarding_success_saves_all_profile_fields_and_marks_completed(): void
    {
        $user = User::factory()->create();
        $user->profile()->create(['is_completed' => false]);
        Sanctum::actingAs($user);

        $payload = [
            'goal' => 'lose_weight',
            'gender' => 'male',
            'date_of_birth' => '1995-06-15',
            'height_cm' => 178,
            'weight_kg' => 82.5,
            'target_weight_kg' => 75.0,
            'activity_level' => 'moderately_active',
            'diet_type' => 'everything',
            'unit_system' => 'metric',
        ];

        $response = $this->postJson('/api/v1/onboarding', $payload);

        $response->assertStatus(200)
            ->assertJson([
                'success' => true,
                'message' => 'Onboarding completed successfully',
                'data' => [
                    'profile' => [
                        'goal' => 'lose_weight',
                        'gender' => 'male',
                        'date_of_birth' => '1995-06-15',
                        'height_cm' => 178,
                        'weight_kg' => 82.5,
                        'target_weight_kg' => 75.0,
                        'activity_level' => 'moderately_active',
                        'diet_type' => 'everything',
                        'unit_system' => 'metric',
                        'is_completed' => true,
                    ],
                    'user' => [
                        'id' => $user->id,
                        'is_onboarding_completed' => true,
                    ],
                ],
            ]);

        $this->assertDatabaseHas('user_profiles', [
            'user_id' => $user->id,
            'is_completed' => true,
            'height_cm' => 178,
            'goal' => 'lose_weight',
        ]);

        $this->assertDatabaseHas('weight_logs', [
            'user_id' => $user->id,
            'weight_kg' => 82.5,
        ]);
    }

    public function test_onboarding_validation_fails_for_unrealistic_ranges(): void
    {
        $user = User::factory()->create();
        Sanctum::actingAs($user);

        $invalidPayloads = [
            // Height too small (< 50)
            [
                'payload' => [
                    'goal' => 'lose_weight',
                    'gender' => 'male',
                    'date_of_birth' => '1995-06-15',
                    'height_cm' => 20,
                    'weight_kg' => 70,
                    'target_weight_kg' => 65,
                    'activity_level' => 'sedentary',
                    'diet_type' => 'everything',
                    'unit_system' => 'metric',
                ],
                'expected_field' => 'height_cm',
            ],
            // Height too tall (> 300)
            [
                'payload' => [
                    'goal' => 'lose_weight',
                    'gender' => 'female',
                    'date_of_birth' => '1995-06-15',
                    'height_cm' => 350,
                    'weight_kg' => 70,
                    'target_weight_kg' => 65,
                    'activity_level' => 'sedentary',
                    'diet_type' => 'everything',
                    'unit_system' => 'metric',
                ],
                'expected_field' => 'height_cm',
            ],
            // Weight too small (< 20)
            [
                'payload' => [
                    'goal' => 'gain_weight',
                    'gender' => 'other',
                    'date_of_birth' => '1995-06-15',
                    'height_cm' => 170,
                    'weight_kg' => 10,
                    'target_weight_kg' => 60,
                    'activity_level' => 'lightly_active',
                    'diet_type' => 'vegan',
                    'unit_system' => 'metric',
                ],
                'expected_field' => 'weight_kg',
            ],
            // Target weight too large (> 500)
            [
                'payload' => [
                    'goal' => 'maintain',
                    'gender' => 'prefer_not_to_say',
                    'date_of_birth' => '1995-06-15',
                    'height_cm' => 170,
                    'weight_kg' => 70,
                    'target_weight_kg' => 600,
                    'activity_level' => 'very_active',
                    'diet_type' => 'keto',
                    'unit_system' => 'metric',
                ],
                'expected_field' => 'target_weight_kg',
            ],
            // Future date of birth
            [
                'payload' => [
                    'goal' => 'build_muscle',
                    'gender' => 'male',
                    'date_of_birth' => '2099-01-01',
                    'height_cm' => 180,
                    'weight_kg' => 75,
                    'target_weight_kg' => 80,
                    'activity_level' => 'extremely_active',
                    'diet_type' => 'pescatarian',
                    'unit_system' => 'metric',
                ],
                'expected_field' => 'date_of_birth',
            ],
            // Invalid enum for goal
            [
                'payload' => [
                    'goal' => 'become_superman',
                    'gender' => 'male',
                    'date_of_birth' => '1995-06-15',
                    'height_cm' => 180,
                    'weight_kg' => 75,
                    'target_weight_kg' => 80,
                    'activity_level' => 'moderately_active',
                    'diet_type' => 'everything',
                    'unit_system' => 'metric',
                ],
                'expected_field' => 'goal',
            ],
        ];

        foreach ($invalidPayloads as $case) {
            $response = $this->postJson('/api/v1/onboarding', $case['payload']);
            $response->assertStatus(422)
                ->assertJsonStructure(['success', 'message', 'errors'])
                ->assertJsonValidationErrors([$case['expected_field']]);
        }
    }

    public function test_get_profile_returns_authenticated_user_profile(): void
    {
        $user = User::factory()->create();
        $user->profile()->create([
            'goal' => 'build_muscle',
            'gender' => 'male',
            'date_of_birth' => '1998-04-12',
            'height_cm' => 182,
            'weight_kg' => 78.0,
            'target_weight_kg' => 83.0,
            'activity_level' => 'very_active',
            'diet_type' => 'vegetarian',
            'unit_system' => 'metric',
            'is_completed' => true,
        ]);

        Sanctum::actingAs($user);

        $response = $this->getJson('/api/v1/profile');

        $response->assertStatus(200)
            ->assertJson([
                'success' => true,
                'data' => [
                    'goal' => 'build_muscle',
                    'gender' => 'male',
                    'height_cm' => 182,
                    'weight_kg' => 78.0,
                    'diet_type' => 'vegetarian',
                    'is_completed' => true,
                ],
            ]);
    }

    public function test_update_profile_updates_fields_and_validates(): void
    {
        $user = User::factory()->create(['name' => 'Original Name']);
        $user->profile()->create([
            'goal' => 'maintain',
            'height_cm' => 170,
            'weight_kg' => 65.0,
            'is_completed' => true,
        ]);

        Sanctum::actingAs($user);

        // Valid update
        $updateResponse = $this->putJson('/api/v1/profile', [
            'name' => 'Updated Name',
            'weight_kg' => 67.5,
            'goal' => 'build_muscle',
        ]);

        $updateResponse->assertStatus(200)
            ->assertJson([
                'success' => true,
                'data' => [
                    'user' => [
                        'name' => 'Updated Name',
                    ],
                    'profile' => [
                        'weight_kg' => 67.5,
                        'goal' => 'build_muscle',
                    ],
                ],
            ]);

        $this->assertEquals('Updated Name', $user->fresh()->name);
        $this->assertEquals(67.5, $user->fresh()->profile->weight_kg);

        // Invalid update fails validation
        $invalidResponse = $this->putJson('/api/v1/profile', [
            'height_cm' => 10, // too small
        ]);

        $invalidResponse->assertStatus(422)
            ->assertJsonValidationErrors(['height_cm']);
    }
}
