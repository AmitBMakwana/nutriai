<?php

namespace Database\Factories;

use App\Models\WeightLog;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<WeightLog>
 */
class WeightLogFactory extends Factory
{
    protected $model = WeightLog::class;

    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'user_id' => \App\Models\User::factory(),
            'weight_kg' => fake()->randomFloat(1, 55, 95),
            'logged_at' => now(),
        ];
    }
}
