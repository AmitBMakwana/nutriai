<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Services\Dashboard\DashboardService;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class DashboardController extends Controller
{
    use ApiResponse;

    public function __construct(
        protected DashboardService $dashboardService
    ) {}

    /**
     * GET /api/v1/dashboard?date=YYYY-MM-DD
     */
    public function index(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'date' => ['nullable', 'date_format:Y-m-d'],
        ]);

        if ($validator->fails()) {
            return $this->error('Invalid date format. Expected YYYY-MM-DD.', $validator->errors()->toArray(), 422);
        }

        $date = $request->query('date');
        $data = $this->dashboardService->getDashboardData($request->user(), $date);

        return $this->success($data, 'Dashboard data retrieved successfully');
    }
}
