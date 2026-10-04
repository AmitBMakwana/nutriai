<?php

namespace Tests\Feature;

use App\Models\AiAnalysis;
use App\Models\DailySummary;
use App\Models\Meal;
use App\Models\MealItem;
use App\Models\NutritionGoal;
use App\Models\User;
use App\Models\UserProfile;
use App\Models\WaterLog;
use App\Models\WeightLog;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Storage;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class AccountDeletionTest extends TestCase
{
    use RefreshDatabase;

    public function test_delete_account_requires_authentication(): void
    {
        $response = $this->deleteJson('/api/v1/account', [
            'confirmation' => true,
        ]);

        $response->assertStatus(401);
    }

    public function test_delete_account_requires_confirmation_or_valid_password(): void
    {
        $user = User::factory()->create([
            'password' => Hash::make('Secret123!'),
        ]);
        Sanctum::actingAs($user);

        // Neither provided
        $response = $this->deleteJson('/api/v1/account', []);
        $response->assertStatus(422)
            ->assertJsonValidationErrors(['confirmation', 'password']);

        // Wrong password
        $response = $this->deleteJson('/api/v1/account', [
            'password' => 'WrongPassword!',
        ]);
        $response->assertStatus(422)
            ->assertJsonValidationErrors(['password']);
    }

    public function test_delete_account_removes_all_user_data_and_stored_images(): void
    {
        Storage::fake('public');
        Storage::fake('local');

        $user = User::factory()->create([
            'password' => Hash::make('ValidPass123!'),
            'avatar' => '/storage/avatars/user_test_avatar.jpg',
        ]);
        Sanctum::actingAs($user);

        // Put a fake avatar in public storage
        Storage::disk('public')->put('avatars/user_test_avatar.jpg', 'fake avatar content');

        // Create user profile
        $profile = UserProfile::create([
            'user_id' => $user->id,
            'goal' => 'lose_weight',
            'gender' => 'female',
            'date_of_birth' => '1992-04-10',
            'height_cm' => 165,
            'weight_kg' => 68.0,
            'target_weight_kg' => 60.0,
            'activity_level' => 'moderately_active',
            'diet_type' => 'vegetarian',
            'unit_system' => 'metric',
            'is_completed' => true,
        ]);

        // Create nutrition goal
        $goal = NutritionGoal::create([
            'user_id' => $user->id,
            'daily_calories' => 1800,
            'protein_grams' => 110,
            'carbs_grams' => 200,
            'fat_grams' => 55,
            'water_ml' => 2500,
            'effective_from' => now()->toDateString(),
            'is_custom' => false,
        ]);

        // Create stored meal with image
        $mealImagePath = "meal-uploads/user_{$user->id}/2026-10-03/meal_1.jpg";
        Storage::disk('local')->put($mealImagePath, 'fake meal image content');

        $meal = Meal::create([
            'user_id' => $user->id,
            'meal_type' => 'lunch',
            'meal_date' => now()->toDateString(),
            'meal_time' => '12:30:00',
            'source' => 'ai',
            'image_path' => $mealImagePath,
            'total_calories' => 500,
            'total_protein_g' => 30,
            'total_carbs_g' => 50,
            'total_fat_g' => 15,
        ]);

        MealItem::create([
            'meal_id' => $meal->id,
            'food_name' => 'Paneer Tikka',
            'quantity' => 150,
            'unit' => 'g',
            'calories' => 350,
            'protein_g' => 20,
            'carbs_g' => 10,
            'fat_g' => 15,
        ]);

        // Create AI analysis
        $aiImagePath = "meal-uploads/user_{$user->id}/2026-10-03/scan_1.jpg";
        Storage::disk('local')->put($aiImagePath, 'fake scan image content');

        $analysis = AiAnalysis::create([
            'user_id' => $user->id,
            'provider' => 'gemini',
            'model' => 'gemini-1.5-flash',
            'image_path' => $aiImagePath,
            'status' => \App\Enums\AiAnalysisStatus::COMPLETED,
        ]);

        // Create logs
        WaterLog::create([
            'user_id' => $user->id,
            'amount_ml' => 500,
            'logged_at' => now(),
        ]);

        WeightLog::create([
            'user_id' => $user->id,
            'weight_kg' => 68.0,
            'logged_at' => now(),
        ]);

        // Verify rows and files exist before delete
        $this->assertDatabaseHas('users', ['id' => $user->id]);
        $this->assertDatabaseHas('user_profiles', ['user_id' => $user->id]);
        $this->assertDatabaseHas('meals', ['user_id' => $user->id]);
        $this->assertDatabaseHas('meal_items', ['meal_id' => $meal->id]);
        $this->assertDatabaseHas('ai_analyses', ['user_id' => $user->id]);
        $this->assertDatabaseHas('water_logs', ['user_id' => $user->id]);
        $this->assertDatabaseHas('weight_logs', ['user_id' => $user->id]);
        $this->assertDatabaseHas('daily_summaries', ['user_id' => $user->id]);
        Storage::disk('public')->assertExists('avatars/user_test_avatar.jpg');
        Storage::disk('local')->assertExists($mealImagePath);
        Storage::disk('local')->assertExists($aiImagePath);

        // Act: Delete account with confirmation
        $response = $this->deleteJson('/api/v1/account', [
            'confirmation' => true,
        ]);

        $response->assertStatus(200)
            ->assertJson([
                'success' => true,
                'message' => 'Account and all associated data deleted successfully',
            ]);

        // Assert: Database records are completely removed
        $this->assertDatabaseMissing('users', ['id' => $user->id]);
        $this->assertDatabaseMissing('user_profiles', ['user_id' => $user->id]);
        $this->assertDatabaseMissing('meals', ['id' => $meal->id]);
        $this->assertDatabaseMissing('meal_items', ['meal_id' => $meal->id]);
        $this->assertDatabaseMissing('ai_analyses', ['id' => $analysis->id]);
        $this->assertDatabaseMissing('water_logs', ['user_id' => $user->id]);
        $this->assertDatabaseMissing('weight_logs', ['user_id' => $user->id]);
        $this->assertDatabaseMissing('daily_summaries', ['user_id' => $user->id]);

        // Assert: Files are deleted from storage
        Storage::disk('public')->assertMissing('avatars/user_test_avatar.jpg');
        Storage::disk('local')->assertMissing($mealImagePath);
        Storage::disk('local')->assertMissing($aiImagePath);
    }

    public function test_avatar_upload_and_replacement(): void
    {
        Storage::fake('public');

        $user = User::factory()->create();
        Sanctum::actingAs($user);

        $file = UploadedFile::fake()->image('profile_pic.png', 400, 400);

        $response = $this->postJson('/api/v1/profile/avatar', [
            'avatar' => $file,
        ]);

        $response->assertStatus(200)
            ->assertJson([
                'success' => true,
                'message' => 'Avatar uploaded successfully',
            ]);

        $user->refresh();
        $this->assertNotNull($user->avatar);
        $this->assertStringContainsString('avatars/avatar_' . $user->id, $user->avatar);
    }

    public function test_change_password_validates_and_updates(): void
    {
        $user = User::factory()->create([
            'password' => Hash::make('OldPassword123!'),
        ]);
        Sanctum::actingAs($user);

        // Wrong old password
        $failResponse = $this->postJson('/api/v1/password/change', [
            'current_password' => 'WrongPassword!',
            'password' => 'NewPassword123!',
            'password_confirmation' => 'NewPassword123!',
        ]);
        $failResponse->assertStatus(422)
            ->assertJsonValidationErrors(['current_password']);

        // Success
        $successResponse = $this->postJson('/api/v1/password/change', [
            'current_password' => 'OldPassword123!',
            'password' => 'NewPassword123!',
            'password_confirmation' => 'NewPassword123!',
        ]);
        $successResponse->assertStatus(200)
            ->assertJson([
                'success' => true,
                'message' => 'Password changed successfully',
            ]);

        $user->refresh();
        $this->assertTrue(Hash::check('NewPassword123!', $user->password));
    }

    public function test_profile_update_recalculates_nutrition_goals_when_requested(): void
    {
        $user = User::factory()->create();
        $profile = UserProfile::create([
            'user_id' => $user->id,
            'goal' => 'maintain',
            'gender' => 'male',
            'date_of_birth' => '1995-01-01',
            'height_cm' => 175,
            'weight_kg' => 70,
            'target_weight_kg' => 70,
            'activity_level' => 'sedentary',
            'diet_type' => 'everything',
            'unit_system' => 'metric',
            'is_completed' => true,
        ]);
        Sanctum::actingAs($user);

        // Initial goal
        $goalService = app(\App\Services\Nutrition\NutritionGoalService::class);
        $initialGoal = $goalService->calculateAndPersist($user, $profile);
        $initialCalories = $initialGoal->daily_calories;

        // Update profile with higher weight and activity and recalculate_goals: true
        $response = $this->putJson('/api/v1/profile', [
            'weight_kg' => 90,
            'activity_level' => 'very_active',
            'recalculate_goals' => true,
        ]);

        $response->assertStatus(200);

        $newGoal = $goalService->getActiveGoal($user);
        $this->assertNotNull($newGoal);
        $this->assertGreaterThan($initialCalories, $newGoal->daily_calories);
    }
}
