<?php

namespace Database\Factories;

use App\Models\User;
use App\Models\WaterLog;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<WaterLog>
 */
class WaterLogFactory extends Factory
{
    protected $model = WaterLog::class;

    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'user_id' => User::factory(),
            'amount_ml' => fake()->randomElement([250, 500, 750]),
            'logged_at' => now(),
        ];
    }
}
