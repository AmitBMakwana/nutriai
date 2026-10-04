<?php

namespace App\Services\AI\Validators;

use App\Services\AI\Exceptions\AIValidationException;

class AIResponseValidator
{
    public const MAX_ITEM_CALORIES = 5000;
    public const MAX_ITEM_MACRO_GRAMS = 1000.0;
    public const MAX_ITEM_QUANTITY = 10000.0;

    /**
     * Clean, parse, validate, and normalize raw AI vision output.
     *
     * @param string $rawOutput Raw text or JSON string from AI model.
     * @return array Standardized and verified nutrition analysis array.
     * @throws AIValidationException
     */
    public function validateAndNormalize(string $rawOutput): array
    {
        $cleaned = $this->stripMarkdownFences($rawOutput);

        if (trim($cleaned) === '') {
            throw new AIValidationException('AI response payload is empty.', $rawOutput);
        }

        $decoded = json_decode($cleaned, true);
        if (json_last_error() !== JSON_ERROR_NONE || !is_array($decoded)) {
            throw new AIValidationException(
                'Malformed AI response: Invalid JSON syntax (' . json_last_error_msg() . ').',
                $rawOutput
            );
        }

        return $this->validateSchema($decoded, $rawOutput);
    }

    /**
     * Strip markdown code blocks and extract JSON content.
     */
    public function stripMarkdownFences(string $text): string
    {
        $text = trim($text);

        // Remove starting ```json or ```
        $text = preg_replace('/^```(?:json)?\s*/i', '', $text);
        // Remove trailing ```
        $text = preg_replace('/\s*```$/', '', $text);

        $text = trim($text);

        // Extract JSON bracket range if surrounded by commentary
        $firstBrace = strpos($text, '{');
        $lastBrace = strrpos($text, '}');

        if ($firstBrace !== false && $lastBrace !== false && $lastBrace > $firstBrace) {
            $text = substr($text, $firstBrace, $lastBrace - $firstBrace + 1);
        }

        return trim($text);
    }

    /**
     * Validate data schema and normalize values.
     */
    protected function validateSchema(array $data, string $rawPayload): array
    {
        if (!array_key_exists('is_food', $data) || !is_bool($data['is_food'])) {
            throw new AIValidationException("Missing or non-boolean 'is_food' attribute.", $rawPayload);
        }

        // Case 1: Non-food image detected
        if ($data['is_food'] === false) {
            return [
                'is_food' => false,
                'meal_name' => is_string($data['meal_name'] ?? null) && trim($data['meal_name']) !== ''
                    ? trim($data['meal_name'])
                    : 'Non-food item',
                'confidence' => $this->clampConfidence($data['confidence'] ?? 1.0),
                'estimated_items' => [],
                'total_calories' => 0,
                'total_protein' => 0.0,
                'total_carbs' => 0.0,
                'total_fat' => 0.0,
                'notes' => is_string($data['notes'] ?? null) ? trim($data['notes']) : 'No food detected in image.',
            ];
        }

        // Case 2: Food image detected
        if (!isset($data['meal_name']) || !is_string($data['meal_name']) || trim($data['meal_name']) === '') {
            throw new AIValidationException("Missing or empty 'meal_name' for recognized food.", $rawPayload);
        }

        if (!isset($data['estimated_items']) || !is_array($data['estimated_items']) || empty($data['estimated_items'])) {
            throw new AIValidationException("Recognized food must contain at least one item in 'estimated_items'.", $rawPayload);
        }

        $normalizedItems = [];
        $totalCalories = 0;
        $totalProtein = 0.0;
        $totalCarbs = 0.0;
        $totalFat = 0.0;

        foreach ($data['estimated_items'] as $index => $item) {
            if (!is_array($item)) {
                throw new AIValidationException("Item at index $index is not a valid JSON object.", $rawPayload);
            }

            $normalizedItem = $this->validateItem($item, $index, $rawPayload);
            $normalizedItems[] = $normalizedItem;

            $totalCalories += $normalizedItem['calories'];
            $totalProtein += $normalizedItem['protein'];
            $totalCarbs += $normalizedItem['carbs'];
            $totalFat += $normalizedItem['fat'];
        }

        $overallConfidence = isset($data['confidence']) && is_numeric($data['confidence'])
            ? $this->clampConfidence((float) $data['confidence'])
            : $this->calculateAverageConfidence($normalizedItems);

        return [
            'is_food' => true,
            'meal_name' => trim($data['meal_name']),
            'confidence' => $overallConfidence,
            'estimated_items' => $normalizedItems,
            // Server-side recomputed totals: never trust client or AI totals directly
            'total_calories' => (int) round($totalCalories),
            'total_protein' => round($totalProtein, 1),
            'total_carbs' => round($totalCarbs, 1),
            'total_fat' => round($totalFat, 1),
            'notes' => is_string($data['notes'] ?? null) ? trim($data['notes']) : null,
        ];
    }

    /**
     * Validate an individual food item.
     */
    protected function validateItem(array $item, int $index, string $rawPayload): array
    {
        // Required fields
        $requiredFields = ['name', 'quantity', 'unit', 'calories', 'protein', 'carbs', 'fat'];
        foreach ($requiredFields as $field) {
            if (!array_key_exists($field, $item)) {
                throw new AIValidationException("Item at index $index is missing required field '$field'.", $rawPayload);
            }
        }

        // Name
        if (!is_string($item['name']) || trim($item['name']) === '') {
            throw new AIValidationException("Item at index $index has invalid or empty 'name'.", $rawPayload);
        }

        // Quantity
        if (!is_numeric($item['quantity']) || $item['quantity'] <= 0) {
            throw new AIValidationException("Item at index $index must have a positive numeric 'quantity'.", $rawPayload);
        }
        if ($item['quantity'] > self::MAX_ITEM_QUANTITY) {
            throw new AIValidationException("Item at index $index exceeds sane quantity bound (" . self::MAX_ITEM_QUANTITY . ").", $rawPayload);
        }

        // Unit
        if (!is_string($item['unit']) || trim($item['unit']) === '') {
            throw new AIValidationException("Item at index $index has invalid or empty 'unit'.", $rawPayload);
        }

        // Numeric non-negative macro values
        $macros = ['calories', 'protein', 'carbs', 'fat'];
        foreach ($macros as $macro) {
            if (!is_numeric($item[$macro])) {
                throw new AIValidationException("Item at index $index has non-numeric value for '$macro'.", $rawPayload);
            }
            if ($item[$macro] < 0) {
                throw new AIValidationException("Item at index $index has negative value for '$macro' ({$item[$macro]}).", $rawPayload);
            }
        }

        // Sane upper bounds
        if ($item['calories'] > self::MAX_ITEM_CALORIES) {
            throw new AIValidationException("Item at index $index exceeds maximum calorie bound (" . self::MAX_ITEM_CALORIES . " kcal).", $rawPayload);
        }
        if ($item['protein'] > self::MAX_ITEM_MACRO_GRAMS || $item['carbs'] > self::MAX_ITEM_MACRO_GRAMS || $item['fat'] > self::MAX_ITEM_MACRO_GRAMS) {
            throw new AIValidationException("Item at index $index exceeds maximum macro bound (" . self::MAX_ITEM_MACRO_GRAMS . " g).", $rawPayload);
        }

        $confidence = isset($item['confidence']) && is_numeric($item['confidence'])
            ? $this->clampConfidence((float) $item['confidence'])
            : 0.85;

        return [
            'name' => trim($item['name']),
            'quantity' => round((float) $item['quantity'], 1),
            'unit' => strtolower(trim($item['unit'])),
            'calories' => (int) round((float) $item['calories']),
            'protein' => round((float) $item['protein'], 1),
            'carbs' => round((float) $item['carbs'], 1),
            'fat' => round((float) $item['fat'], 1),
            'confidence' => $confidence,
        ];
    }

    /**
     * Clamp confidence score strictly between 0.0 and 1.0.
     */
    protected function clampConfidence(float $confidence): float
    {
        if ($confidence < 0.0) {
            return 0.0;
        }
        if ($confidence > 1.0) {
            return 1.0;
        }
        return round($confidence, 2);
    }

    /**
     * Calculate average confidence from items.
     */
    protected function calculateAverageConfidence(array $items): float
    {
        if (empty($items)) {
            return 0.9;
        }
        $sum = array_sum(array_column($items, 'confidence'));
        return round($sum / count($items), 2);
    }
}
