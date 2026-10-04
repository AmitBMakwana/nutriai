<?php

namespace Database\Factories;

use App\Models\NutritionGoal;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<NutritionGoal>
 */
class NutritionGoalFactory extends Factory
{
    protected $model = NutritionGoal::class;

    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'user_id' => User::factory(),
            'daily_calories' => 2000,
            'protein_grams' => 150,
            'carbs_grams' => 200,
            'fat_grams' => 67,
            'water_ml' => 2500,
            'effective_from' => now()->toDateString(),
        ];
    }
}
