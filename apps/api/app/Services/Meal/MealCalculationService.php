<?php

namespace App\Services\Meal;

use App\Models\Food;

class MealCalculationService
{
    /**
     * Calculate item values and overall meal totals based on foods and quantities.
     * Totals are always computed server-side and never trusted from the client.
     */
    public function calculate(array $rawItems): array
    {
        $computedItems = [];
        $totalCalories = 0;
        $totalProtein = 0.0;
        $totalCarbs = 0.0;
        $totalFat = 0.0;
        $totalFiber = 0.0;

        // Preload any referenced foods to avoid N+1 queries
        $foodIds = array_filter(array_column($rawItems, 'food_id'));
        $foods = !empty($foodIds) ? Food::whereIn('id', $foodIds)->get()->keyBy('id') : collect();

        foreach ($rawItems as $item) {
            $foodId = $item['food_id'] ?? null;
            $quantity = (float) ($item['quantity'] ?? 1.0);
            $unit = $item['unit'] ?? 'serving';
            $foodName = $item['food_name'] ?? '';

            if ($foodId && isset($foods[$foodId])) {
                $food = $foods[$foodId];
                $foodName = $foodName ?: $food->name;
                $servingSize = (float) ($food->serving_size > 0 ? $food->serving_size : 1.0);
                $ratio = $quantity / $servingSize;

                $calories = (int) round($food->calories * $ratio);
                $protein = round((float) $food->protein * $ratio, 1);
                $carbs = round((float) $food->carbs * $ratio, 1);
                $fat = round((float) $food->fat * $ratio, 1);
                $fiber = round((float) ($food->fiber ?? 0) * $ratio, 1);
            } else {
                // Custom one-off item without a predefined food reference
                $calories = (int) ($item['calories'] ?? 0);
                $protein = round((float) ($item['protein'] ?? 0.0), 1);
                $carbs = round((float) ($item['carbs'] ?? 0.0), 1);
                $fat = round((float) ($item['fat'] ?? 0.0), 1);
                $fiber = round((float) ($item['fiber'] ?? 0.0), 1);
            }

            $computedItem = [
                'food_id' => $foodId,
                'food_name' => $foodName,
                'quantity' => $quantity,
                'unit' => $unit,
                'calories' => $calories,
                'protein' => $protein,
                'carbs' => $carbs,
                'fat' => $fat,
                'fiber' => $fiber,
                'confidence' => $item['confidence'] ?? null,
            ];

            $computedItems[] = $computedItem;

            $totalCalories += $calories;
            $totalProtein += $protein;
            $totalCarbs += $carbs;
            $totalFat += $fat;
            $totalFiber += $fiber;
        }

        return [
            'totals' => [
                'total_calories' => $totalCalories,
                'total_protein' => round($totalProtein, 1),
                'total_carbs' => round($totalCarbs, 1),
                'total_fat' => round($totalFat, 1),
                'total_fiber' => round($totalFiber, 1),
            ],
            'items' => $computedItems,
        ];
    }
}
