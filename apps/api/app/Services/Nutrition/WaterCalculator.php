<?php

namespace App\Services\Nutrition;

class WaterCalculator
{
    /**
     * Calculates water target (~35 ml per kg body weight) rounded to nearest 250 ml.
     */
    public function calculateWaterTarget(float $weightKg): int
    {
        $mlPerKg = config('nutrition.water_ml_per_kg', 35);
        $roundTo = config('nutrition.water_round_to', 250);

        $raw = $weightKg * $mlPerKg;
        return (int) (round($raw / $roundTo) * $roundTo);
    }
}
