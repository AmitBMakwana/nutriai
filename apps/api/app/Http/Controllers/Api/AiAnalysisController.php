<?php

namespace App\Http\Controllers\Api;

use App\Enums\AiAnalysisStatus;
use App\Http\Controllers\Controller;
use App\Jobs\AnalyzeMealImage;
use App\Models\AiAnalysis;
use App\Services\AI\AIProviderManager;
use App\Services\AI\Exceptions\AIValidationException;
use App\Services\AI\ImageStorageService;
use App\Services\Subscription\EntitlementService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Throwable;

class AiAnalysisController extends Controller
{
    protected AIProviderManager $manager;
    protected ImageStorageService $storageService;
    protected EntitlementService $entitlementService;

    public function __construct(
        AIProviderManager $manager,
        ImageStorageService $storageService,
        EntitlementService $entitlementService
    ) {
        $this->manager = $manager;
        $this->storageService = $storageService;
        $this->entitlementService = $entitlementService;
    }

    /**
     * Analyze an uploaded meal photo using AI vision.
     * POST /api/v1/meals/analyze
     */
    public function analyze(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'image' => ['required', 'file', 'image', 'mimes:jpg,jpeg,png,webp', 'max:5120'], // Max 5 MB, real image magic-bytes inspection
            'meal_type' => ['nullable', 'string', 'in:breakfast,lunch,dinner,snack'],
        ]);

        $file = $request->file('image');
        $realMime = $file ? $file->getMimeType() : null;
        if (!in_array($realMime, ['image/jpeg', 'image/png', 'image/webp'], true)) {
            return response()->json([
                'success' => false,
                'message' => 'The uploaded file is not a valid image format (JPEG, PNG, WebP required).',
                'errors' => ['image' => ['The uploaded file content does not match a supported image type.']],
            ], 422);
        }

        $user = $request->user();
        $mealType = $validated['meal_type'] ?? 'lunch';

        // 1. Enforce monthly scan quota via EntitlementService
        if (!$this->entitlementService->canPerformAiScan($user)) {
            $usedCount = $this->entitlementService->getUsedScansThisMonth($user);
            $quota = $this->entitlementService->getMonthlyScanQuota($user);
            $plan = $this->entitlementService->getPlan($user);

            return response()->json([
                'success' => false,
                'message' => "Monthly AI scan quota exceeded ({$usedCount}/{$quota} scans used). Upgrade to Pro for more scans.",
                'data' => [
                    'used' => $usedCount,
                    'quota' => $quota,
                    'plan' => $plan,
                ],
            ], 429);
        }

        // 2. Determine provider and model (reads from AppSetting with config fallback)
        $provider = $this->manager->getDefaultDriver();
        $dbModel = \App\Models\AppSetting::get('ai.model');
        $model = !empty($dbModel) ? (string) $dbModel : (string) config("ai.providers.{$provider}.model", 'default');

        // 3. Store the uploaded image to private storage
        $imagePath = $this->storageService->storeUpload($request->file('image'), $user->id);

        // 4. Create AiAnalysis record in pending state
        $analysis = AiAnalysis::create([
            'user_id' => $user->id,
            'provider' => $provider,
            'model' => $model,
            'image_path' => $imagePath,
            'status' => AiAnalysisStatus::PENDING,
        ]);

        // 5. Run synchronously with 30s timeout via AnalyzeMealImage job
        try {
            $job = new AnalyzeMealImage($analysis->id, $imagePath, $provider);
            $result = $job->handle($this->manager, $this->storageService);

            $imageUrl = $this->storageService->getTemporaryUrl($imagePath);
            $refreshed = $analysis->fresh();

            return response()->json([
                'success' => true,
                'message' => 'Meal analyzed successfully',
                'data' => [
                    'analysis_id' => $analysis->id,
                    'status' => 'completed',
                    'is_food' => (bool) ($result['is_food'] ?? true),
                    'meal_name' => $result['meal_name'] ?? 'Unknown Meal',
                    'meal_type' => $mealType,
                    'confidence' => (float) ($result['confidence'] ?? 0.9),
                    'items' => $result['estimated_items'] ?? [],
                    'total' => [
                        'calories' => (int) ($result['total_calories'] ?? 0),
                        'protein' => (float) ($result['total_protein'] ?? 0.0),
                        'carbs' => (float) ($result['total_carbs'] ?? 0.0),
                        'fat' => (float) ($result['total_fat'] ?? 0.0),
                    ],
                    'notes' => $result['notes'] ?? null,
                    'image_url' => $imageUrl,
                    'processing_time_ms' => $refreshed->processing_time_ms,
                ],
            ], 200);
        } catch (AIValidationException $e) {
            Log::warning("AI validation failure for user {$user->id}: {$e->getMessage()}");

            return response()->json([
                'success' => false,
                'message' => 'The meal image could not be recognized clearly. Please try again with a clearer photo.',
                'data' => [
                    'analysis_id' => $analysis->id,
                    'status' => 'failed',
                    'error' => 'validation_error',
                ],
            ], 422);
        } catch (Throwable $e) {
            // Log internally without leaking raw error/stack trace to the client
            Log::error("AI meal analysis failed for user {$user->id}: {$e->getMessage()}", [
                'analysis_id' => $analysis->id,
                'provider' => $provider,
            ]);

            return response()->json([
                'success' => false,
                'message' => 'AI vision service is temporarily unavailable. Please try again in a few moments.',
                'data' => [
                    'analysis_id' => $analysis->id,
                    'status' => 'failed',
                ],
            ], 502);
        }
    }

    /**
     * Retrieve analysis status and results.
     * GET /api/v1/ai-analysis/{id}
     */
    public function show(Request $request, int $id): JsonResponse
    {
        $analysis = AiAnalysis::findOrFail($id);

        // Enforce ownership policy
        if ($analysis->user_id !== $request->user()->id) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized access to meal analysis.',
            ], 403);
        }

        $imageUrl = $this->storageService->getTemporaryUrl($analysis->image_path);
        $parsed = $analysis->parsed_response ?? [];

        return response()->json([
            'success' => true,
            'message' => 'Analysis retrieved successfully',
            'data' => [
                'analysis_id' => $analysis->id,
                'status' => $analysis->status->value,
                'is_food' => (bool) ($parsed['is_food'] ?? false),
                'meal_name' => $parsed['meal_name'] ?? null,
                'confidence' => $analysis->confidence,
                'items' => $parsed['estimated_items'] ?? [],
                'total' => [
                    'calories' => (int) ($parsed['total_calories'] ?? 0),
                    'protein' => (float) ($parsed['total_protein'] ?? 0.0),
                    'carbs' => (float) ($parsed['total_carbs'] ?? 0.0),
                    'fat' => (float) ($parsed['total_fat'] ?? 0.0),
                ],
                'notes' => $parsed['notes'] ?? null,
                'image_url' => $imageUrl,
                'processing_time_ms' => $analysis->processing_time_ms,
                'created_at' => $analysis->created_at?->toIso8601String(),
            ],
        ], 200);
    }
}
