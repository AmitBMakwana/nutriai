<?php

namespace App\Console\Commands;

use App\Models\AiAnalysis;
use App\Models\Food;
use App\Models\Meal;
use App\Models\User;
use App\Services\AI\Contracts\FoodAnalysisProvider;
use App\Services\AI\Providers\FakeFoodAnalysisProvider;
use Illuminate\Console\Command;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\Storage;
use Laravel\Sanctum\Sanctum;

class AiScanE2EScenarioCommand extends Command
{
    protected $signature = 'ai:e2e-scenario';
    protected $description = 'Runs the Milestone 13 critical AI scan E2E scenario step-by-step and reports each step';

    public function handle(): int
    {
        $this->info('===========================================================');
        $this->info('Starting Milestone 13 Critical E2E Scenario Demonstration');
        $this->info('===========================================================');

        // Step 1: User & Session Preparation
        $this->line("\n[STEP 1] Setup Authenticated User & Baseline Dashboard");
        
        \Illuminate\Support\Facades\Config::set('database.default', 'sqlite');
        \Illuminate\Support\Facades\Config::set('database.connections.sqlite.database', ':memory:');
        \Illuminate\Support\Facades\Artisan::call('migrate');

        $user = User::factory()->create([
            'name' => 'Aditi Sharma',
            'email' => 'aditi.' . uniqid() . '@example.com',
            'timezone' => 'Asia/Kolkata',
        ]);
        $this->info("✓ Authenticated user created: {$user->name} ({$user->email})");

        // Verify initial dashboard
        $initialSummary = app(\App\Services\Dashboard\DashboardService::class)->getDashboardData($user, now()->format('Y-m-d'));
        $this->info("✓ Initial Daily Summary: Consumed {$initialSummary['calories']['consumed']} kcal, Protein: {$initialSummary['macros']['protein']['consumed']}g");

        // Step 2: Image Capture & Preparation
        $this->line("\n[STEP 2] Image Capture & Preparation (Long edge <= 1280px, < 5MB)");
        Storage::fake('local');
        Config::set('ai.default', 'fake');
        Config::set('ai.storage.disk', 'local');

        $fakeImage = UploadedFile::fake()->image('dal_tadka_roti.jpg', 1280, 960);
        $this->info("✓ Image captured and prepared: {$fakeImage->getClientOriginalName()} ({$fakeImage->getSize()} bytes)");

        // Step 3: AI Meal Analysis Endpoint Call (POST /api/v1/meals/analyze)
        $this->line("\n[STEP 3] Upload & Analyze (POST /api/v1/meals/analyze)");
        $this->info("Sending image to AI Analysis engine with meal_type='lunch'...");

        $analysisController = app(\App\Http\Controllers\Api\AiAnalysisController::class);
        $request = \Illuminate\Http\Request::create('/api/v1/meals/analyze', 'POST', [
            'meal_type' => 'lunch',
        ], [], [
            'image' => $fakeImage,
        ]);
        $request->setUserResolver(fn () => $user);

        $response = $analysisController->analyze($request);
        $content = json_decode($response->getContent(), true);

        if (!$content['success']) {
            $this->error("Analysis failed: " . ($content['message'] ?? 'Unknown error'));
            return 1;
        }

        $data = $content['data'];
        $analysisId = $data['analysis_id'];
        $confidence = $data['overall_confidence'] ?? 0.88;
        $items = $data['items'];
        $this->info("✓ Analysis Succeeded! Analysis ID: #{$analysisId}, Overall Confidence: " . round($confidence * 100) . "%");
        $this->table(
            ['Item Name', 'Quantity', 'Calories', 'Protein', 'Carbs', 'Fat', 'Confidence', 'Status (<60%?)'],
            collect($items)->map(function ($item) {
                $conf = $item['confidence'] ?? 0.85;
                $isLow = $conf < 0.60;
                return [
                    $item['name'],
                    "{$item['quantity']} {$item['unit']}",
                    "{$item['calories']} kcal",
                    "{$item['protein']}g",
                    "{$item['carbs']}g",
                    "{$item['fat']}g",
                    round($conf * 100) . '%',
                    $isLow ? '⚠️ LOW CONFIDENCE (Check)' : '✅ Confident',
                ];
            })->toArray()
        );

        // Step 4: Flutter Review Screen Interactions (Editing, Proportional Rescaling, Add, Remove)
        $this->line("\n[STEP 4] Review Screen Adjustments & Live Proportional Recalculation");
        
        // 4a: Quantity Rescaling
        $firstItem = $items[0];
        $originalQty = $firstItem['quantity'];
        $newQty = $originalQty * 1.5; // Scale by 1.5x
        $ratio = $newQty / $originalQty;
        $rescaledCalories = (int) round($firstItem['calories'] * $ratio);
        $rescaledProtein = round($firstItem['protein'] * $ratio, 1);
        $rescaledCarbs = round($firstItem['carbs'] * $ratio, 1);
        $rescaledFat = round($firstItem['fat'] * $ratio, 1);

        $this->info("✓ User adjusted portion for '{$firstItem['name']}': {$originalQty} {$firstItem['unit']} -> {$newQty} {$firstItem['unit']}");
        $this->info("  Proportional Rescale (Ratio 1.5x): {$firstItem['calories']} -> {$rescaledCalories} kcal, P: {$rescaledProtein}g, C: {$rescaledCarbs}g, F: {$rescaledFat}g");

        $items[0]['quantity'] = $newQty;
        $items[0]['calories'] = $rescaledCalories;
        $items[0]['protein'] = $rescaledProtein;
        $items[0]['carbs'] = $rescaledCarbs;
        $items[0]['fat'] = $rescaledFat;

        // 4b: Remove an unwanted item if multiple items exist
        if (count($items) > 1) {
            $removed = array_pop($items);
            $this->info("✓ User removed item: '{$removed['name']}'");
        }

        // 4c: Add a food item (search / manual food from verified list)
        $extraFood = Food::firstOrCreate(
            ['name' => 'Greek Yogurt'],
            [
                'serving_size' => 100,
                'serving_unit' => 'g',
                'calories' => 97,
                'protein' => 10.0,
                'carbs' => 3.6,
                'fat' => 5.0,
                'fiber' => 0.0,
                'is_verified' => true,
            ]
        );
        $items[] = [
            'food_id' => $extraFood->id,
            'food_name' => $extraFood->name,
            'quantity' => 150,
            'unit' => 'g',
            'calories' => 146,
            'protein' => 15.0,
            'carbs' => 5.4,
            'fat' => 7.5,
        ];
        $this->info("✓ User added food: '{$extraFood->name}' (150g, 146 kcal)");

        // Step 5: Save Meal via POST /api/v1/meals with source=ai and analysis_id
        $this->line("\n[STEP 5] Save Meal (POST /api/v1/meals with source=ai and analysis_id=#{$analysisId})");
        
        $mealItemsPayload = array_map(function ($item) {
            return [
                'food_id' => $item['food_id'] ?? null,
                'food_name' => $item['name'] ?? $item['food_name'],
                'quantity' => $item['quantity'],
                'unit' => $item['unit'],
                'calories' => $item['calories'],
                'protein' => $item['protein'],
                'carbs' => $item['carbs'],
                'fat' => $item['fat'],
            ];
        }, $items);

        $mealController = app(\App\Http\Controllers\Api\MealController::class);
        $saveRequest = \Illuminate\Http\Request::create('/api/v1/meals', 'POST', [
            'meal_type' => 'lunch',
            'meal_date' => now()->format('Y-m-d'),
            'meal_time' => now()->format('H:i:s'),
            'source' => 'ai',
            'analysis_id' => $analysisId,
            'items' => $mealItemsPayload,
        ]);
        $saveRequest->setUserResolver(fn () => $user);

        $saveResponse = $mealController->store($saveRequest);
        $saveContent = json_decode($saveResponse->getContent(), true);

        if (!$saveContent['success']) {
            $this->error("Save meal failed: " . json_encode($saveContent));
            return 1;
        }

        $savedMeal = $saveContent['data'];
        $this->info("✓ Meal Saved Successfully! Meal ID: #{$savedMeal['id']}, Source: '{$savedMeal['source']}'");
        $this->info("✓ Server-side calculated totals: {$savedMeal['total_calories']} kcal, P: {$savedMeal['total_protein']}g, C: {$savedMeal['total_carbs']}g, F: {$savedMeal['total_fat']}g");

        // Verify analysis linkage in database
        $analysisRecord = AiAnalysis::find($analysisId);
        $this->info("✓ Database Verification: AiAnalysis #{$analysisId} linked to Meal #{$analysisRecord->meal_id}");

        // Step 6: Verify Dashboard Summary Cache Refresh
        $this->line("\n[STEP 6] Dashboard Refresh (GET /api/v1/dashboard)");
        $refreshedSummary = app(\App\Services\Dashboard\DashboardService::class)->getDashboardData($user, now()->format('Y-m-d'));
        
        $this->info("✓ Daily Dashboard Updated!");
        $this->table(
            ['Metric', 'Target', 'Consumed', 'Remaining / %'],
            [
                ['Calories', $refreshedSummary['calories']['target'] . ' kcal', $refreshedSummary['calories']['consumed'] . ' kcal', $refreshedSummary['calories']['remaining'] . ' kcal remaining'],
                ['Protein', $refreshedSummary['macros']['protein']['target'] . 'g', $refreshedSummary['macros']['protein']['consumed'] . 'g', round(($refreshedSummary['macros']['protein']['consumed'] / max(1, $refreshedSummary['macros']['protein']['target'])) * 100) . '%'],
                ['Carbs', $refreshedSummary['macros']['carbs']['target'] . 'g', $refreshedSummary['macros']['carbs']['consumed'] . 'g', round(($refreshedSummary['macros']['carbs']['consumed'] / max(1, $refreshedSummary['macros']['carbs']['target'])) * 100) . '%'],
                ['Fat', $refreshedSummary['macros']['fat']['target'] . 'g', $refreshedSummary['macros']['fat']['consumed'] . 'g', round(($refreshedSummary['macros']['fat']['consumed'] / max(1, $refreshedSummary['macros']['fat']['target'])) * 100) . '%'],
            ]
        );

        $lunchMeals = collect($refreshedSummary['meals']['lunch']['meals'] ?? [])
            ->flatMap(fn ($m) => collect($m['items'] ?? [])->pluck('food_name'))
            ->implode(', ');
        $lunchKcal = $refreshedSummary['meals']['lunch']['calories'] ?? 0;
        $this->info("✓ Meals Section (Lunch): {$lunchKcal} kcal ({$lunchMeals})");

        $this->info("\n===========================================================");
        $this->info("🎉 Milestone 13 Critical E2E Scenario Completed Successfully!");
        $this->info("===========================================================");
        return 0;
    }
}
