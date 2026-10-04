<?php

namespace App\Services\Profile;

use App\Models\User;
use App\Models\UserProfile;
use App\Services\Nutrition\NutritionGoalService;
use Illuminate\Support\Arr;

class ProfileService
{
    public function __construct(
        private readonly NutritionGoalService $nutritionGoalService
    ) {}

    public function saveOnboarding(User $user, array $data): UserProfile
    {
        $profileData = Arr::only($data, [
            'goal',
            'gender',
            'date_of_birth',
            'height_cm',
            'weight_kg',
            'target_weight_kg',
            'activity_level',
            'diet_type',
            'unit_system',
        ]);

        $profileData['is_completed'] = true;

        $profile = $user->profile()->updateOrCreate(
            ['user_id' => $user->id],
            $profileData
        );

        if (isset($data['weight_kg'])) {
            $user->weightLogs()->create([
                'weight_kg' => $data['weight_kg'],
                'logged_at' => now(),
            ]);
        }

        // Create initial nutrition goal
        $this->nutritionGoalService->calculateAndPersist($user, $profile);

        return $profile;
    }

    public function getProfile(User $user): UserProfile
    {
        return $user->profile ?? $user->profile()->create(['is_completed' => false]);
    }

    public function updateProfile(User $user, array $data): UserProfile
    {
        $userData = Arr::only($data, ['name', 'timezone', 'avatar']);
        if (!empty($userData)) {
            $user->update($userData);
        }

        $profileData = Arr::only($data, [
            'goal',
            'gender',
            'date_of_birth',
            'height_cm',
            'weight_kg',
            'target_weight_kg',
            'activity_level',
            'diet_type',
            'unit_system',
            'is_completed',
        ]);

        $profile = $user->profile()->updateOrCreate(
            ['user_id' => $user->id],
            $profileData
        );

        if (!empty($data['recalculate_goals'])) {
            $this->nutritionGoalService->calculateAndPersist($user, $profile);
        }

        return $profile;
    }

    public function deleteAccount(User $user): void
    {
        $aiDisk = config('ai.storage.disk', config('filesystems.default', 'local'));
        $aiDir = config('ai.storage.directory', 'meal-uploads');
        \Illuminate\Support\Facades\Storage::disk($aiDisk)->deleteDirectory("{$aiDir}/user_{$user->id}");

        // Check any individual meal image paths
        foreach ($user->meals as $meal) {
            if ($meal->image_path && \Illuminate\Support\Facades\Storage::disk($aiDisk)->exists($meal->image_path)) {
                \Illuminate\Support\Facades\Storage::disk($aiDisk)->delete($meal->image_path);
            }
        }

        // Check any individual ai analysis image paths
        foreach ($user->aiAnalyses as $analysis) {
            if ($analysis->image_path && \Illuminate\Support\Facades\Storage::disk($aiDisk)->exists($analysis->image_path)) {
                \Illuminate\Support\Facades\Storage::disk($aiDisk)->delete($analysis->image_path);
            }
        }

        // Delete avatar from public storage if applicable
        if ($user->avatar) {
            if (str_contains($user->avatar, '/storage/')) {
                $relative = str_replace('/storage/', '', parse_url($user->avatar, PHP_URL_PATH));
                \Illuminate\Support\Facades\Storage::disk('public')->delete($relative);
            } elseif (\Illuminate\Support\Facades\Storage::disk('public')->exists($user->avatar)) {
                \Illuminate\Support\Facades\Storage::disk('public')->delete($user->avatar);
            }
        }

        \Illuminate\Support\Facades\DB::transaction(function () use ($user) {
            foreach ($user->meals as $meal) {
                $meal->items()->delete();
                $meal->delete();
            }

            foreach ($user->aiAnalyses as $analysis) {
                $analysis->delete();
            }

            $user->waterLogs()->delete();
            $user->weightLogs()->delete();
            $user->dailySummaries()->delete();
            $user->nutritionGoals()->delete();
            $user->favoriteFoods()->delete();
            $user->favoriteMeals()->delete();
            $user->subscriptions()->delete();
            $user->profile()?->delete();
            $user->tokens()->delete();
            $user->delete();
        });
    }
}

