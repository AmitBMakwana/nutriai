<?php

namespace App\Services\AI\Contracts;

interface FoodAnalysisProvider
{
    /**
     * Analyze an uploaded meal photo and return structured food items and macronutrients.
     *
     * @param string $imagePath Local absolute file path or storage path of the meal photo.
     * @return array Standardized, validated nutrition analysis result.
     * @throws \App\Services\AI\Exceptions\AIValidationException
     * @throws \RuntimeException
     */
    public function analyze(string $imagePath): array;
}
