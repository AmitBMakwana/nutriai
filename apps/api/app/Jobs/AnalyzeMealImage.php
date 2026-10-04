<?php

namespace App\Jobs;

use App\Enums\AiAnalysisStatus;
use App\Models\AiAnalysis;
use App\Services\AI\AIProviderManager;
use App\Services\AI\Exceptions\AIValidationException;
use App\Services\AI\ImageStorageService;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\Log;
use Throwable;

class AnalyzeMealImage implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    public int $aiAnalysisId;
    public string $imagePath;
    public ?string $providerName;
    public int $maxAttempts;

    /**
     * Create a new job instance.
     */
    public function __construct(
        int $aiAnalysisId,
        string $imagePath,
        ?string $providerName = null,
        int $maxAttempts = 3
    ) {
        $this->aiAnalysisId = $aiAnalysisId;
        $this->imagePath = $imagePath;
        $this->providerName = $providerName;
        $this->maxAttempts = $maxAttempts;
    }

    /**
     * Execute the job.
     *
     * @return array The validated nutrition analysis result.
     * @throws Throwable
     */
    public function handle(AIProviderManager $manager, ImageStorageService $storageService): array
    {
        $analysis = AiAnalysis::find($this->aiAnalysisId);
        if (!$analysis) {
            throw new \RuntimeException("AiAnalysis record [{$this->aiAnalysisId}] not found.");
        }

        $analysis->update([
            'status' => AiAnalysisStatus::PROCESSING,
        ]);

        $localPath = $this->resolveLocalPath($storageService);
        $provider = $manager->driver($this->providerName ?: $analysis->provider);

        $attempt = 1;
        $lastException = null;
        $startTime = microtime(true);

        while ($attempt <= $this->maxAttempts) {
            try {
                $result = $provider->analyze($localPath);
                $durationMs = (int) round((microtime(true) - $startTime) * 1000);

                $analysis->update([
                    'status' => AiAnalysisStatus::COMPLETED,
                    'parsed_response' => $result,
                    'confidence' => $result['confidence'] ?? null,
                    'processing_time_ms' => $durationMs,
                    'error_message' => null,
                ]);

                return $result;
            } catch (AIValidationException $e) {
                // Non-transient validation error: do not retry
                $durationMs = (int) round((microtime(true) - $startTime) * 1000);
                Log::warning("AI vision validation failure for analysis ID {$analysis->id}: {$e->getMessage()}");

                $analysis->update([
                    'status' => AiAnalysisStatus::FAILED,
                    'raw_response' => $e->getRawPayload() ? ['raw' => $e->getRawPayload()] : null,
                    'error_message' => $e->getMessage(),
                    'processing_time_ms' => $durationMs,
                ]);

                throw $e;
            } catch (Throwable $e) {
                $lastException = $e;
                Log::warning("AI vision provider attempt {$attempt}/{$this->maxAttempts} failed: {$e->getMessage()}");

                if ($attempt < $this->maxAttempts) {
                    // Exponential backoff: 200ms, 400ms
                    usleep((int) (pow(2, $attempt - 1) * 200000));
                }
                $attempt++;
            }
        }

        // Exhausted retries
        $durationMs = (int) round((microtime(true) - $startTime) * 1000);
        Log::error("AI vision provider exhausted all {$this->maxAttempts} retries for analysis ID {$analysis->id}: " . $lastException?->getMessage());

        $analysis->update([
            'status' => AiAnalysisStatus::FAILED,
            'error_message' => $lastException?->getMessage() ?? 'Unknown AI provider error',
            'processing_time_ms' => $durationMs,
        ]);

        throw ($lastException ?? new \RuntimeException('AI meal analysis failed.'));
    }

    /**
     * Resolve a readable local file path for image analysis.
     */
    protected function resolveLocalPath(ImageStorageService $storageService): string
    {
        if (file_exists($this->imagePath)) {
            return $this->imagePath;
        }

        try {
            $abs = $storageService->getAbsolutePath($this->imagePath);
            if (file_exists($abs)) {
                return $abs;
            }
        } catch (\Throwable $_) {}

        // Fallback for cloud/virtual storage: write to system temp file
        $tempPath = sys_get_temp_dir() . DIRECTORY_SEPARATOR . 'meal_' . uniqid() . '.jpg';
        $contents = \Illuminate\Support\Facades\Storage::disk($storageService->getDisk())->get($this->imagePath);
        file_put_contents($tempPath, $contents);

        return $tempPath;
    }
}
