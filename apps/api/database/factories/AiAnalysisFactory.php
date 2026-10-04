<?php

namespace Database\Factories;

use App\Models\AiAnalysis;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<AiAnalysis>
 */
class AiAnalysisFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'user_id' => \App\Models\User::factory(),
            'meal_id' => null,
            'provider' => 'gemini',
            'model' => 'gemini-1.5-flash',
            'image_path' => 'meals/fake.jpg',
            'status' => \App\Enums\AiAnalysisStatus::COMPLETED->value,
            'confidence' => 0.95,
            'processing_time_ms' => 1200,
        ];
    }
}
