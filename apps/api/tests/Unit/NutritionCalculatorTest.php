<?php

namespace Tests\Unit;

use App\Services\Nutrition\CalorieCalculator;
use App\Services\Nutrition\MacroCalculator;
use App\Services\Nutrition\WaterCalculator;
use Tests\TestCase;

class NutritionCalculatorTest extends TestCase
{
    private CalorieCalculator $calorieCalculator;
    private MacroCalculator $macroCalculator;
    private WaterCalculator $waterCalculator;

    protected function setUp(): void
    {
        parent::setUp();
        $this->calorieCalculator = new CalorieCalculator();
        $this->macroCalculator = new MacroCalculator();
        $this->waterCalculator = new WaterCalculator();
    }

    public function test_mifflin_st_jeor_bmr_calculation_known_values(): void
    {
        // Reference: 30M, 175cm, 75kg
        // BMR = 10*75 + 6.25*175 - 5*30 + 5 = 750 + 1093.75 - 150 + 5 = 1698.75
        $bmr = $this->calorieCalculator->calculateBmr(75.0, 175.0, 30, 'male');
        $this->assertEquals(1698.75, $bmr);
    }

    public function test_female_bmr_calculation(): void
    {
        // Reference: 30F, 165cm, 60kg
        // BMR = 10*60 + 6.25*165 - 5*30 - 161 = 600 + 1031.25 - 150 - 161 = 1320.25
        $bmr = $this->calorieCalculator->calculateBmr(60.0, 165.0, 30, 'female');
        $this->assertEquals(1320.25, $bmr);
    }

    public function test_prefer_not_to_say_gender_uses_average_offset(): void
    {
        // Offset is (5 - 161) / 2 = -78.0
        // 30 yo, 170cm, 65kg:
        // BMR = 10*65 + 6.25*170 - 5*30 - 78 = 650 + 1062.5 - 150 - 78 = 1484.5
        $bmr = $this->calorieCalculator->calculateBmr(65.0, 170.0, 30, 'prefer_not_to_say');
        $this->assertEquals(1484.5, $bmr);
    }

    public function test_tdee_activity_multipliers(): void
    {
        $bmr = 1698.75;

        // Sedentary (1.2)
        $this->assertEqualsWithDelta(2038.5, $this->calorieCalculator->calculateTdee($bmr, 'sedentary'), 0.1);

        // Lightly active (1.375)
        $this->assertEqualsWithDelta(2335.78, $this->calorieCalculator->calculateTdee($bmr, 'lightly_active'), 0.1);

        // Moderately active (1.55)
        $this->assertEqualsWithDelta(2633.06, $this->calorieCalculator->calculateTdee($bmr, 'moderately_active'), 0.1);

        // Very active (1.725)
        $this->assertEqualsWithDelta(2930.34, $this->calorieCalculator->calculateTdee($bmr, 'very_active'), 0.1);

        // Extremely active (1.9)
        $this->assertEqualsWithDelta(3227.63, $this->calorieCalculator->calculateTdee($bmr, 'extremely_active'), 0.1);
    }

    public function test_goal_adjustments(): void
    {
        $tdee = 2633.06;

        // Lose: -500 -> 2133
        $this->assertEquals(2133, $this->calorieCalculator->calculateTargetCalories($tdee, 'lose_weight', 'male'));

        // Maintain: 2633
        $this->assertEquals(2633, $this->calorieCalculator->calculateTargetCalories($tdee, 'maintain', 'male'));

        // Gain: +300 -> 2933
        $this->assertEquals(2933, $this->calorieCalculator->calculateTargetCalories($tdee, 'gain_weight', 'male'));

        // Muscle: +250 -> 2883
        $this->assertEquals(2883, $this->calorieCalculator->calculateTargetCalories($tdee, 'build_muscle', 'male'));
    }

    public function test_safety_floor_prevents_dangerous_caloric_deficits(): void
    {
        // Low TDEE of 1400 kcal
        $lowTdee = 1400.0;

        // Female floor is 1200 kcal (1400 - 500 = 900 -> clamped to 1200)
        $femaleTarget = $this->calorieCalculator->calculateTargetCalories($lowTdee, 'lose_weight', 'female');
        $this->assertEquals(1200, $femaleTarget);

        // Male floor is 1500 kcal (1400 - 500 = 900 -> clamped to 1500)
        $maleTarget = $this->calorieCalculator->calculateTargetCalories($lowTdee, 'lose_weight', 'male');
        $this->assertEquals(1500, $maleTarget);
    }

    public function test_macro_calculator_splits_and_energy_density(): void
    {
        // 2000 kcal with 30% protein, 40% carbs, 30% fat:
        // Protein: 2000 * 0.30 / 4 = 150 g
        // Carbs:   2000 * 0.40 / 4 = 200 g
        // Fat:     2000 * 0.30 / 9 = 66.67 -> 67 g
        $macros = $this->macroCalculator->calculateMacros(2000, 'maintain');

        $this->assertEquals(150, $macros['protein_grams']);
        $this->assertEquals(200, $macros['carbs_grams']);
        $this->assertEquals(67, $macros['fat_grams']);
    }

    public function test_water_calculator_rounds_to_250ml(): void
    {
        // 70 kg * 35 = 2450 ml -> round(2450 / 250) * 250 = 10 * 250 = 2500 ml
        $this->assertEquals(2500, $this->waterCalculator->calculateWaterTarget(70.0));

        // 60 kg * 35 = 2100 ml -> round(2100 / 250) * 250 = 8 * 250 = 2000 ml
        $this->assertEquals(2000, $this->waterCalculator->calculateWaterTarget(60.0));

        // 80 kg * 35 = 2800 ml -> round(2800 / 250) * 250 = 11 * 250 = 2750 ml
        $this->assertEquals(2750, $this->waterCalculator->calculateWaterTarget(80.0));
    }
}
