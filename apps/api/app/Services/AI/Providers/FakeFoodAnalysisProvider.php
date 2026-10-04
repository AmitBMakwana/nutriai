<?php

namespace App\Services\AI\Providers;

use App\Services\AI\Contracts\FoodAnalysisProvider;
use App\Services\AI\Validators\AIResponseValidator;

class FakeFoodAnalysisProvider implements FoodAnalysisProvider
{
    protected AIResponseValidator $validator;
    protected ?array $customResponse;

    public function __construct(?AIResponseValidator $validator = null, ?array $customResponse = null)
    {
        $this->validator = $validator ?? new AIResponseValidator();
        $this->customResponse = $customResponse;
    }

    /**
     * Set a custom response payload for testing edge cases.
     */
    public function setCustomResponse(?array $response): self
    {
        $this->customResponse = $response;
        return $this;
    }

    public function analyze(string $imagePath): array
    {
        if ($this->customResponse !== null) {
            return $this->validator->validateAndNormalize(json_encode($this->customResponse));
        }

        // Check if test image simulates non-food
        if (str_contains(strtolower($imagePath), 'non-food') || str_contains(strtolower($imagePath), 'non_food')) {
            $nonFoodPayload = [
                'is_food' => false,
                'meal_name' => 'Non-food item',
                'confidence' => 0.98,
                'estimated_items' => [],
                'total_calories' => 0,
                'total_protein' => 0.0,
                'total_carbs' => 0.0,
                'total_fat' => 0.0,
                'notes' => 'No recognizable food or beverages detected in the provided image.',
            ];

            return $this->validator->validateAndNormalize(json_encode($nonFoodPayload));
        }

        // Realistic Indian vegetarian thali meal data
        $indianMealPayload = [
            'is_food' => true,
            'meal_name' => 'North Indian Thali (Dal Makhani, Roti & Rice)',
            'confidence' => 0.94,
            'estimated_items' => [
                [
                    'name' => 'Dal Makhani',
                    'quantity' => 150.0,
                    'unit' => 'g',
                    'calories' => 230,
                    'protein' => 8.5,
                    'carbs' => 24.0,
                    'fat' => 11.5,
                    'confidence' => 0.95,
                ],
                [
                    'name' => 'Whole Wheat Roti',
                    'quantity' => 2.0,
                    'unit' => 'piece',
                    'calories' => 210,
                    'protein' => 6.2,
                    'carbs' => 40.0,
                    'fat' => 2.8,
                    'confidence' => 0.96,
                ],
                [
                    'name' => 'Steamed Basmati Rice',
                    'quantity' => 120.0,
                    'unit' => 'g',
                    'calories' => 156,
                    'protein' => 3.2,
                    'carbs' => 34.0,
                    'fat' => 0.5,
                    'confidence' => 0.92,
                ],
                [
                    'name' => 'Cucumber & Tomato Salad',
                    'quantity' => 50.0,
                    'unit' => 'g',
                    'calories' => 16,
                    'protein' => 0.6,
                    'carbs' => 3.4,
                    'fat' => 0.2,
                    'confidence' => 0.90,
                ],
            ],
            // Raw total will be recomputed by AIResponseValidator
            'total_calories' => 612,
            'total_protein' => 18.5,
            'total_carbs' => 101.4,
            'total_fat' => 15.0,
            'notes' => 'Balanced Indian vegetarian meal with wholesome grains, legumes, and fresh salad.',
        ];

        return $this->validator->validateAndNormalize(json_encode($indianMealPayload));
    }
}
