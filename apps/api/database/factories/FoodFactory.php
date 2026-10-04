<?php

namespace Database\Factories;

use App\Models\Food;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<Food>
 */
class FoodFactory extends Factory
{
    protected $model = Food::class;

    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'name' => fake()->words(2, true),
            'brand' => fake()->optional()->company(),
            'serving_size' => 100.0,
            'serving_unit' => 'g',
            'calories' => fake()->numberBetween(50, 600),
            'protein' => fake()->randomFloat(1, 0, 40),
            'carbs' => fake()->randomFloat(1, 0, 60),
            'fat' => fake()->randomFloat(1, 0, 30),
            'fiber' => fake()->randomFloat(1, 0, 10),
            'sugar' => fake()->randomFloat(1, 0, 20),
            'sodium' => fake()->randomFloat(1, 0, 500),
            'is_verified' => true,
            'user_id' => null,
        ];
    }

    public function custom(?int $userId = null): static
    {
        return $this->state(fn (array $attributes) => [
            'is_verified' => false,
            'user_id' => $userId,
        ]);
    }
}
