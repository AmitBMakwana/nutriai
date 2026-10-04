<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\Api\CalculateGoalRequest;
use App\Http\Requests\Api\OverrideGoalRequest;
use App\Http\Resources\Api\NutritionGoalResource;
use App\Services\Nutrition\NutritionGoalService;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;

class NutritionGoalController extends Controller
{
    use ApiResponse;

    public function __construct(
        private readonly NutritionGoalService $goalService
    ) {}

    /**
     * GET /api/v1/goals
     */
    public function index(Request $request)
    {
        $user = $request->user();
        $goal = $this->goalService->getActiveGoal($user);

        if (!$goal && $user->profile && $user->profile->is_completed) {
            $goal = $this->goalService->calculateAndPersist($user);
        }

        if (!$goal) {
            return $this->error('No active nutrition goal found. Please complete onboarding.', [], 404);
        }

        return $this->success(
            new NutritionGoalResource($goal),
            'Active nutrition goal retrieved successfully'
        );
    }

    /**
     * POST /api/v1/goals/calculate
     * Preview calculation without persistence.
     */
    public function calculate(CalculateGoalRequest $request)
    {
        $params = $request->validated();

        // Fall back to authenticated user profile values if missing
        if ($request->user() && $request->user()->profile) {
            $profile = $request->user()->profile;
            $params['weight_kg'] ??= $profile->weight_kg;
            $params['height_cm'] ??= $profile->height_cm;
            $params['date_of_birth'] ??= $profile->date_of_birth?->format('Y-m-d');
            $params['gender'] ??= $profile->gender;
            $params['activity_level'] ??= $profile->activity_level;
            $params['goal'] ??= $profile->goal;
            $params['diet_type'] ??= $profile->diet_type;
        }

        $result = $this->goalService->calculatePreview($params);

        return $this->success($result, 'Nutrition goals calculated successfully');
    }

    /**
     * PUT /api/v1/goals
     * Manual override of goals.
     */
    public function update(OverrideGoalRequest $request)
    {
        $goal = $this->goalService->overrideGoal(
            $request->user(),
            $request->validated()
        );

        return $this->success(
            new NutritionGoalResource($goal),
            'Nutrition goals updated successfully'
        );
    }
}
