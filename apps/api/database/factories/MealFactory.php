<?php

namespace Database\Factories;

use App\Enums\MealType;
use App\Models\Meal;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<Meal>
 */
class MealFactory extends Factory
{
    protected $model = Meal::class;

    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'user_id' => User::factory(),
            'meal_type' => fake()->randomElement(MealType::cases()),
            'meal_date' => now()->toDateString(),
            'meal_time' => fake()->time('H:i:s'),
            'image_path' => null,
            'total_calories' => fake()->numberBetween(250, 800),
            'total_protein' => fake()->randomFloat(1, 10, 50),
            'total_carbs' => fake()->randomFloat(1, 20, 80),
            'total_fat' => fake()->randomFloat(1, 5, 30),
            'total_fiber' => fake()->randomFloat(1, 2, 10),
            'source' => 'manual',
        ];
    }
}
