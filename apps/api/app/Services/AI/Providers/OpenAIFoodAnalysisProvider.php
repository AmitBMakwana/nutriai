<?php

namespace App\Services\AI\Providers;

use App\Services\AI\Contracts\FoodAnalysisProvider;
use RuntimeException;

class OpenAIFoodAnalysisProvider implements FoodAnalysisProvider
{
    protected array $config;

    public function __construct(array $config = [])
    {
        $this->config = $config;
    }

    public function analyze(string $imagePath): array
    {
        throw new RuntimeException('OpenAI food analysis provider is not yet implemented.');
    }
}
