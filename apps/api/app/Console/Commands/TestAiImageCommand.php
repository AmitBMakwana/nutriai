<?php

namespace App\Console\Commands;

use App\Services\AI\AIProviderManager;
use Illuminate\Console\Command;
use Throwable;

class TestAiImageCommand extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'ai:test-image 
                            {path : Path to the local meal image file} 
                            {--provider= : AI vision provider (gemini, fake, claude, openai)} 
                            {--meal-type=lunch : Meal type (breakfast, lunch, dinner, snack)}';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Analyze a meal image file using AI vision provider and output nutritional breakdown';

    /**
     * Execute the console command.
     */
    public function handle(AIProviderManager $manager): int
    {
        $path = $this->argument('path');

        if (!file_exists($path)) {
            $this->error("Image file does not exist at path: {$path}");
            return self::FAILURE;
        }

        $providerName = $this->option('provider') ?: config('ai.default', 'gemini');
        $mealType = $this->option('meal-type') ?: 'lunch';

        $this->info("--------------------------------------------------");
        $this->info("NutriAI - AI Vision Meal Analysis");
        $this->info("Image:    {$path}");
        $this->info("Provider: {$providerName}");
        $this->info("Meal:     {$mealType}");
        $this->info("--------------------------------------------------");
        $this->comment("Sending image for AI nutritional recognition...");

        $startTime = microtime(true);

        try {
            $provider = $manager->driver($providerName);
            $result = $provider->analyze($path);
            $durationMs = (int) round((microtime(true) - $startTime) * 1000);

            $this->newLine();
            $this->info("Analysis Completed in {$durationMs} ms!");
            $this->line("Food Detected: " . ($result['is_food'] ? '<info>YES</info>' : '<comment>NO</comment>'));
            $this->line("Meal Name:     <options=bold>{$result['meal_name']}</>");
            $this->line("Confidence:    " . round($result['confidence'] * 100, 1) . "%");

            if (!empty($result['notes'])) {
                $this->line("Notes:         {$result['notes']}");
            }

            if (!empty($result['estimated_items'])) {
                $this->newLine();
                $this->comment("Detected Food Items & Portions:");

                $headers = ['Item Name', 'Portion', 'Calories (kcal)', 'Protein (g)', 'Carbs (g)', 'Fat (g)', 'Confidence'];
                $rows = [];

                foreach ($result['estimated_items'] as $item) {
                    $rows[] = [
                        $item['name'],
                        "{$item['quantity']} {$item['unit']}",
                        $item['calories'],
                        $item['protein'],
                        $item['carbs'],
                        $item['fat'],
                        round(($item['confidence'] ?? 0.9) * 100, 0) . '%',
                    ];
                }

                $this->table($headers, $rows);

                $this->comment("Recomputed Meal Totals:");
                $this->table(
                    ['Total Calories', 'Total Protein', 'Total Carbs', 'Total Fat'],
                    [[
                        "{$result['total_calories']} kcal",
                        "{$result['total_protein']} g",
                        "{$result['total_carbs']} g",
                        "{$result['total_fat']} g",
                    ]]
                );
            }

            $this->newLine();
            return self::SUCCESS;
        } catch (Throwable $e) {
            $durationMs = (int) round((microtime(true) - $startTime) * 1000);
            $this->newLine();
            $this->error("AI Analysis Failed after {$durationMs} ms:");
            $this->error($e->getMessage());

            if ($this->output->isVerbose()) {
                $this->line($e->getTraceAsString());
            }

            return self::FAILURE;
        }
    }
}
