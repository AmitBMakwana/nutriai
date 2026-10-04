<?php

namespace App\Services\AI\Providers;

use App\Services\AI\Contracts\FoodAnalysisProvider;
use App\Services\AI\Prompts\FoodAnalysisPrompt;
use App\Services\AI\Validators\AIResponseValidator;
use Illuminate\Support\Facades\Http;
use RuntimeException;

class GeminiFoodAnalysisProvider implements FoodAnalysisProvider
{
    protected array $config;
    protected AIResponseValidator $validator;

    public function __construct(array $config, ?AIResponseValidator $validator = null)
    {
        $this->config = $config;
        $this->validator = $validator ?? new AIResponseValidator();
    }

    public function analyze(string $imagePath): array
    {
        $apiKey = $this->config['api_key'] ?? null;
        if (empty($apiKey)) {
            throw new RuntimeException('Gemini API key is not configured in config/ai.php or .env (GEMINI_API_KEY).');
        }

        if (!file_exists($imagePath)) {
            throw new RuntimeException("Image file not found at path: {$imagePath}");
        }

        $imageContents = file_get_contents($imagePath);
        if ($imageContents === false || $imageContents === '') {
            throw new RuntimeException("Could not read image file or file is empty at: {$imagePath}");
        }

        $mimeType = $this->detectMimeType($imagePath);
        $base64Image = base64_encode($imageContents);

        $endpoint = rtrim($this->config['endpoint'] ?? 'https://generativelanguage.googleapis.com/v1beta/models', '/');
        $model = $this->config['model'] ?? 'gemini-1.5-flash';
        $timeout = (int) ($this->config['timeout'] ?? 30);
        $temperature = (float) ($this->config['temperature'] ?? 0.2);
        $maxTokens = (int) ($this->config['max_tokens'] ?? 2048);

        $url = "{$endpoint}/{$model}:generateContent?key={$apiKey}";

        $requestPayload = [
            'system_instruction' => [
                'parts' => [
                    ['text' => FoodAnalysisPrompt::getSystemInstruction()],
                ],
            ],
            'contents' => [
                [
                    'role' => 'user',
                    'parts' => [
                        ['text' => FoodAnalysisPrompt::getUserMessage()],
                        [
                            'inline_data' => [
                                'mime_type' => $mimeType,
                                'data' => $base64Image,
                            ],
                        ],
                    ],
                ],
            ],
            'generationConfig' => [
                'temperature' => $temperature,
                'maxOutputTokens' => $maxTokens,
                'responseMimeType' => 'application/json',
            ],
        ];

        $response = Http::timeout($timeout)
            ->withHeaders(['Content-Type' => 'application/json'])
            ->post($url, $requestPayload);

        if (!$response->successful()) {
            throw new RuntimeException(
                "Gemini API error (HTTP {$response->status()}): {$response->body()}"
            );
        }

        $data = $response->json();
        $text = $data['candidates'][0]['content']['parts'][0]['text'] ?? null;

        if ($text === null) {
            throw new RuntimeException('Gemini API response did not contain candidates or text content.');
        }

        return $this->validator->validateAndNormalize($text);
    }

    protected function detectMimeType(string $path): string
    {
        $extension = strtolower(pathinfo($path, PATHINFO_EXTENSION));
        return match ($extension) {
            'png' => 'image/png',
            'webp' => 'image/webp',
            'gif' => 'image/gif',
            default => 'image/jpeg',
        };
    }
}
