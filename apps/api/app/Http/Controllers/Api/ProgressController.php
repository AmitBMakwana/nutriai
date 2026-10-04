<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Services\Progress\ProgressService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ProgressController extends Controller
{
    public function __construct(private readonly ProgressService $progressService) {}

    /**
     * GET /progress?range=7d|30d|3m|6m|1y
     */
    public function index(Request $request): JsonResponse
    {
        $request->validate([
            'range' => ['sometimes', 'string', 'in:7d,30d,3m,6m,1y'],
        ]);

        $range = $request->input('range', '7d');
        $data  = $this->progressService->getProgress(Auth::user(), $range);

        return response()->json(['success' => true, 'data' => $data]);
    }

    /**
     * GET /progress/weekly — last 7 days summary
     */
    public function weekly(): JsonResponse
    {
        $data = $this->progressService->getWeeklySummary(Auth::user());

        return response()->json(['success' => true, 'data' => $data]);
    }

    /**
     * GET /progress/monthly?year=&month=
     */
    public function monthly(Request $request): JsonResponse
    {
        $request->validate([
            'year'  => ['sometimes', 'integer', 'min:2020', 'max:2099'],
            'month' => ['sometimes', 'integer', 'min:1', 'max:12'],
        ]);

        $year  = (int) $request->input('year', now()->year);
        $month = (int) $request->input('month', now()->month);

        $data = $this->progressService->getMonthlySummary(Auth::user(), $year, $month);

        return response()->json(['success' => true, 'data' => $data]);
    }
}
