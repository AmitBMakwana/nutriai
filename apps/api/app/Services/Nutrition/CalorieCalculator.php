<?php

namespace App\Services\Nutrition;

class CalorieCalculator
{
    /**
     * Calculates Basal Metabolic Rate (BMR) using the Mifflin-St Jeor equation.
     * BMR = 10 * weight(kg) + 6.25 * height(cm) - 5 * age(y) + s
     * s = +5 for male, -161 for female, -78 for other / prefer not to say (average).
     */
    public function calculateBmr(float $weightKg, float $heightCm, int $ageYears, string $gender): float
    {
        $genderNormalized = strtolower($gender);
        $genderOffset = match ($genderNormalized) {
            'male' => 5.0,
            'female' => -161.0,
            default => (5.0 + -161.0) / 2.0, // -78.0 average
        };

        return (10.0 * $weightKg) + (6.25 * $heightCm) - (5.0 * $ageYears) + $genderOffset;
    }

    /**
     * Calculates Total Daily Energy Expenditure (TDEE) from BMR and activity level.
     */
    public function calculateTdee(float $bmr, string $activityLevel): float
    {
        $multipliers = config('nutrition.activity_multipliers', [
            'sedentary' => 1.2,
            'lightly_active' => 1.375,
            'moderately_active' => 1.55,
            'very_active' => 1.725,
            'extra_active' => 1.9,
            'extremely_active' => 1.9,
        ]);

        $multiplier = $multipliers[strtolower($activityLevel)] ?? 1.2;

        return $bmr * $multiplier;
    }

    /**
     * Applies goal adjustment with safety floor protection.
     * lose = TDEE - 500 (never below 1200 kcal women / 1500 kcal men / 1350 average)
     * maintain = TDEE
     * gain = TDEE + 300
     * muscle = TDEE + 250
     */
    public function calculateTargetCalories(float $tdee, string $goal, string $gender): int
    {
        $offsets = config('nutrition.goal_offsets', [
            'lose_weight' => -500,
            'maintain' => 0,
            'gain_weight' => 300,
            'build_muscle' => 250,
        ]);

        $goalNormalized = strtolower($goal);
        $offset = $offsets[$goalNormalized] ?? 0;
        $target = $tdee + $offset;

        // Apply gender safety floors
        $floors = config('nutrition.safety_floor', [
            'female' => 1200,
            'male' => 1500,
            'prefer_not_to_say' => 1350,
            'other' => 1350,
        ]);

        $genderNormalized = strtolower($gender);
        $safetyFloor = $floors[$genderNormalized] ?? 1200;

        return (int) round(max($target, $safetyFloor));
    }
}
