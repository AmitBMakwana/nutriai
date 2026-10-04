<?php

namespace App\Services\Nutrition;

use App\Models\NutritionGoal;
use App\Models\User;
use App\Models\UserProfile;
use Carbon\Carbon;

class NutritionGoalService
{
    public function __construct(
        private readonly CalorieCalculator $calorieCalculator,
        private readonly MacroCalculator $macroCalculator,
        private readonly WaterCalculator $waterCalculator
    ) {}

    /**
     * Calculates nutrition plan from parameters without saving (for preview).
     */
    public function calculatePreview(array $params): array
    {
        $weightKg = (float) ($params['weight_kg'] ?? 70.0);
        $heightCm = (float) ($params['height_cm'] ?? 170.0);

        $ageYears = 28;
        if (!empty($params['date_of_birth'])) {
            $ageYears = Carbon::parse($params['date_of_birth'])->age;
        }

        $gender = $params['gender'] ?? 'male';
        if ($gender instanceof \BackedEnum) {
            $gender = $gender->value;
        }

        $activityLevel = $params['activity_level'] ?? 'sedentary';
        if ($activityLevel instanceof \BackedEnum) {
            $activityLevel = $activityLevel->value;
        }

        $goal = $params['goal'] ?? 'maintain';
        if ($goal instanceof \BackedEnum) {
            $goal = $goal->value;
        }

        $dietType = $params['diet_type'] ?? null;
        if ($dietType instanceof \BackedEnum) {
            $dietType = $dietType->value;
        }

        $bmr = $this->calorieCalculator->calculateBmr($weightKg, $heightCm, $ageYears, $gender);
        $tdee = $this->calorieCalculator->calculateTdee($bmr, $activityLevel);
        $calories = $this->calorieCalculator->calculateTargetCalories($tdee, $goal, $gender);
        $macros = $this->macroCalculator->calculateMacros($calories, $goal, $dietType);
        $water = $this->waterCalculator->calculateWaterTarget($weightKg);

        return [
            'bmr' => round($bmr, 1),
            'tdee' => round($tdee, 1),
            'daily_calories' => $calories,
            'protein_grams' => $macros['protein_grams'],
            'carbs_grams' => $macros['carbs_grams'],
            'fat_grams' => $macros['fat_grams'],
            'water_ml' => $water,
            'macro_split' => $macros['percentages'],
        ];
    }

    /**
     * Calculates and persists a new nutrition_goals row for the user.
     */
    public function calculateAndPersist(User $user, ?UserProfile $profile = null): NutritionGoal
    {
        $profile = $profile ?? $user->profile;

        if (!$profile) {
            throw new \RuntimeException("Cannot calculate nutrition goal without a user profile.");
        }

        $calculated = $this->calculatePreview([
            'weight_kg' => $profile->weight_kg,
            'height_cm' => $profile->height_cm,
            'date_of_birth' => $profile->date_of_birth?->format('Y-m-d'),
            'gender' => $profile->gender,
            'activity_level' => $profile->activity_level,
            'goal' => $profile->goal,
            'diet_type' => $profile->diet_type,
        ]);

        return $user->nutritionGoals()->create([
            'daily_calories' => $calculated['daily_calories'],
            'protein_grams' => $calculated['protein_grams'],
            'carbs_grams' => $calculated['carbs_grams'],
            'fat_grams' => $calculated['fat_grams'],
            'water_ml' => $calculated['water_ml'],
            'effective_from' => now()->toDateString(),
        ]);
    }

    /**
     * Returns the active (latest) nutrition goal for the user.
     */
    public function getActiveGoal(User $user): ?NutritionGoal
    {
        return $user->nutritionGoals()
            ->where(function ($query) {
                $query->whereNull('effective_from')
                    ->orWhereDate('effective_from', '<=', now()->toDateString());
            })
            ->latest('id')
            ->first();
    }

    /**
     * Manual override of nutrition goals.
     */
    public function overrideGoal(User $user, array $data): NutritionGoal
    {
        return $user->nutritionGoals()->create([
            'daily_calories' => $data['daily_calories'],
            'protein_grams' => $data['protein_grams'],
            'carbs_grams' => $data['carbs_grams'],
            'fat_grams' => $data['fat_grams'],
            'water_ml' => $data['water_ml'],
            'effective_from' => $data['effective_from'] ?? now()->toDateString(),
        ]);
    }
}
