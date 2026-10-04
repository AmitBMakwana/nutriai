<?php

namespace Tests\Unit;

use App\Services\AI\Exceptions\AIValidationException;
use App\Services\AI\Validators\AIResponseValidator;
use PHPUnit\Framework\TestCase;

class AIResponseValidatorTest extends TestCase
{
    protected AIResponseValidator $validator;

    protected function setUp(): void
    {
        parent::setUp();
        $this->validator = new AIResponseValidator();
    }

    public function test_validates_and_normalizes_valid_json_payload(): void
    {
        $payload = json_encode([
            'is_food' => true,
            'meal_name' => 'Chicken Salad',
            'confidence' => 0.95,
            'estimated_items' => [
                [
                    'name' => 'Grilled Chicken',
                    'quantity' => 150,
                    'unit' => 'g',
                    'calories' => 240,
                    'protein' => 45.0,
                    'carbs' => 0.0,
                    'fat' => 5.0,
                    'confidence' => 0.95,
                ],
                [
                    'name' => 'Mixed Greens',
                    'quantity' => 100,
                    'unit' => 'g',
                    'calories' => 25,
                    'protein' => 1.5,
                    'carbs' => 4.0,
                    'fat' => 0.5,
                    'confidence' => 0.90,
                ],
            ],
            'notes' => 'Healthy lunch',
        ]);

        $result = $this->validator->validateAndNormalize($payload);

        $this->assertTrue($result['is_food']);
        $this->assertEquals('Chicken Salad', $result['meal_name']);
        $this->assertEquals(0.95, $result['confidence']);
        $this->assertCount(2, $result['estimated_items']);
        $this->assertEquals(265, $result['total_calories']);
        $this->assertEquals(46.5, $result['total_protein']);
        $this->assertEquals(4.0, $result['total_carbs']);
        $this->assertEquals(5.5, $result['total_fat']);
        $this->assertEquals('Healthy lunch', $result['notes']);
    }

    public function test_strips_markdown_code_fences_and_comments(): void
    {
        $raw = "Here is the nutritional breakdown you requested:\n```json\n" . json_encode([
            'is_food' => true,
            'meal_name' => 'Avocado Toast',
            'confidence' => 0.9,
            'estimated_items' => [
                [
                    'name' => 'Sourdough Bread',
                    'quantity' => 1,
                    'unit' => 'slice',
                    'calories' => 120,
                    'protein' => 4.0,
                    'carbs' => 22.0,
                    'fat' => 1.0,
                ],
            ],
        ]) . "\n```\nHope this helps!";

        $result = $this->validator->validateAndNormalize($raw);

        $this->assertTrue($result['is_food']);
        $this->assertEquals('Avocado Toast', $result['meal_name']);
        $this->assertEquals(120, $result['total_calories']);
    }

    public function test_rejects_malformed_json_syntax(): void
    {
        $this->expectException(AIValidationException::class);
        $this->expectExceptionMessage('Invalid JSON syntax');

        $this->validator->validateAndNormalize('{ "is_food": true, "meal_name": "Incomplete');
    }

    public function test_rejects_empty_payload(): void
    {
        $this->expectException(AIValidationException::class);
        $this->expectExceptionMessage('empty');

        $this->validator->validateAndNormalize('   ');
    }

    public function test_rejects_missing_is_food_attribute(): void
    {
        $this->expectException(AIValidationException::class);
        $this->expectExceptionMessage("Missing or non-boolean 'is_food'");

        $this->validator->validateAndNormalize(json_encode([
            'meal_name' => 'Burger',
            'estimated_items' => [],
        ]));
    }

    public function test_rejects_negative_numbers_in_items(): void
    {
        $this->expectException(AIValidationException::class);
        $this->expectExceptionMessage('negative value for');

        $this->validator->validateAndNormalize(json_encode([
            'is_food' => true,
            'meal_name' => 'Invalid Negative Food',
            'estimated_items' => [
                [
                    'name' => 'Strange Protein Bar',
                    'quantity' => 50,
                    'unit' => 'g',
                    'calories' => 200,
                    'protein' => -10.0, // Negative!
                    'carbs' => 20.0,
                    'fat' => 5.0,
                ],
            ],
        ]));
    }

    public function test_rejects_missing_required_fields_in_item(): void
    {
        $this->expectException(AIValidationException::class);
        $this->expectExceptionMessage("missing required field 'carbs'");

        $this->validator->validateAndNormalize(json_encode([
            'is_food' => true,
            'meal_name' => 'Incomplete Item Food',
            'estimated_items' => [
                [
                    'name' => 'Apple',
                    'quantity' => 1,
                    'unit' => 'piece',
                    'calories' => 95,
                    'protein' => 0.5,
                    // missing carbs
                    'fat' => 0.3,
                ],
            ],
        ]));
    }

    public function test_rejects_empty_estimated_items_for_food_image(): void
    {
        $this->expectException(AIValidationException::class);
        $this->expectExceptionMessage('at least one item');

        $this->validator->validateAndNormalize(json_encode([
            'is_food' => true,
            'meal_name' => 'Empty Meal',
            'estimated_items' => [],
        ]));
    }

    public function test_rejects_numbers_exceeding_sane_upper_bounds(): void
    {
        $this->expectException(AIValidationException::class);
        $this->expectExceptionMessage('exceeds maximum calorie bound');

        $this->validator->validateAndNormalize(json_encode([
            'is_food' => true,
            'meal_name' => 'Supernova Food',
            'estimated_items' => [
                [
                    'name' => 'Massive Cake',
                    'quantity' => 500,
                    'unit' => 'g',
                    'calories' => 99999, // Way over 5000 kcal limit
                    'protein' => 20.0,
                    'carbs' => 100.0,
                    'fat' => 50.0,
                ],
            ],
        ]));
    }

    public function test_handles_non_food_payload(): void
    {
        $payload = json_encode([
            'is_food' => false,
            'meal_name' => 'Living Room Couch',
            'confidence' => 0.99,
            'notes' => 'A photo of interior furniture without any food.',
        ]);

        $result = $this->validator->validateAndNormalize($payload);

        $this->assertFalse($result['is_food']);
        $this->assertEquals('Living Room Couch', $result['meal_name']);
        $this->assertEquals(0.99, $result['confidence']);
        $this->assertEmpty($result['estimated_items']);
        $this->assertEquals(0, $result['total_calories']);
        $this->assertEquals(0.0, $result['total_protein']);
        $this->assertEquals(0.0, $result['total_carbs']);
        $this->assertEquals(0.0, $result['total_fat']);
        $this->assertStringContainsString('interior furniture', $result['notes']);
    }

    public function test_recomputes_totals_server_side_ignoring_ai_totals(): void
    {
        // AI gives bad math: total_calories = 1000, but items sum to 300
        $payload = json_encode([
            'is_food' => true,
            'meal_name' => 'Oatmeal',
            'total_calories' => 1000, // Fabricated or hallucinated
            'total_protein' => 99.0,
            'total_carbs' => 99.0,
            'total_fat' => 99.0,
            'estimated_items' => [
                [
                    'name' => 'Rolled Oats',
                    'quantity' => 50,
                    'unit' => 'g',
                    'calories' => 190,
                    'protein' => 7.0,
                    'carbs' => 32.0,
                    'fat' => 3.0,
                ],
                [
                    'name' => 'Almond Milk',
                    'quantity' => 150,
                    'unit' => 'ml',
                    'calories' => 30,
                    'protein' => 1.0,
                    'carbs' => 1.5,
                    'fat' => 2.5,
                ],
            ],
        ]);

        $result = $this->validator->validateAndNormalize($payload);

        $this->assertEquals(220, $result['total_calories']);
        $this->assertEquals(8.0, $result['total_protein']);
        $this->assertEquals(33.5, $result['total_carbs']);
        $this->assertEquals(5.5, $result['total_fat']);
    }
}
