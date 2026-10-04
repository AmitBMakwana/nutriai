<?php

namespace App\Services\Nutrition;

class MacroCalculator
{
    /**
     * Calculates protein, carbohydrate, and fat targets in grams based on daily calories,
     * goal preset, and optional diet overrides.
     * Protein & carbs: 4 kcal/g, Fat: 9 kcal/g.
     */
    public function calculateMacros(int $dailyCalories, string $goal = 'maintain', ?string $dietType = null): array
    {
        $goalNormalized = strtolower($goal);
        $dietNormalized = $dietType ? strtolower($dietType) : null;

        $macros = config('nutrition.default_macros', [
            'protein' => 30,
            'carbs' => 40,
            'fat' => 30,
        ]);

        if ($dietNormalized && config("nutrition.diet_macros.{$dietNormalized}")) {
            $macros = config("nutrition.diet_macros.{$dietNormalized}");
        } elseif (config("nutrition.goal_macros.{$goalNormalized}")) {
            $macros = config("nutrition.goal_macros.{$goalNormalized}");
        }

        $proteinPct = $macros['protein'] ?? 30;
        $carbsPct = $macros['carbs'] ?? 40;
        $fatPct = $macros['fat'] ?? 30;

        $proteinKcalPerG = config('nutrition.energy_density.protein', 4);
        $carbsKcalPerG = config('nutrition.energy_density.carbs', 4);
        $fatKcalPerG = config('nutrition.energy_density.fat', 9);

        $proteinGrams = (int) round(($dailyCalories * ($proteinPct / 100.0)) / $proteinKcalPerG);
        $carbsGrams = (int) round(($dailyCalories * ($carbsPct / 100.0)) / $carbsKcalPerG);
        $fatGrams = (int) round(($dailyCalories * ($fatPct / 100.0)) / $fatKcalPerG);

        return [
            'protein_grams' => $proteinGrams,
            'carbs_grams' => $carbsGrams,
            'fat_grams' => $fatGrams,
            'percentages' => [
                'protein' => $proteinPct,
                'carbs' => $carbsPct,
                'fat' => $fatPct,
            ],
        ];
    }
}
