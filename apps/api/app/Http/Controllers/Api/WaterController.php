<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\WaterLog;
use App\Traits\ApiResponse;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class WaterController extends Controller
{
    use ApiResponse;

    /**
     * GET /api/v1/water?date=YYYY-MM-DD
     */
    public function index(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'date' => ['nullable', 'date_format:Y-m-d'],
        ]);

        if ($validator->fails()) {
            return $this->error('Validation failed', $validator->errors()->toArray(), 422);
        }

        $user = $request->user();
        $timezone = $user->timezone ?: 'UTC';
        $date = $request->query('date', Carbon::now($timezone)->toDateString());

        $startOfDay = Carbon::parse($date, $timezone)->startOfDay()->utc();
        $endOfDay = Carbon::parse($date, $timezone)->endOfDay()->utc();

        $logs = WaterLog::where('user_id', $user->id)
            ->whereBetween('logged_at', [$startOfDay, $endOfDay])
            ->orderBy('logged_at', 'desc')
            ->orderBy('id', 'desc')
            ->get();

        $totalMl = (int) $logs->sum('amount_ml');

        return $this->success([
            'date' => $date,
            'total_ml' => $totalMl,
            'logs' => $logs->map(fn (WaterLog $log) => [
                'id' => $log->id,
                'amount_ml' => $log->amount_ml,
                'logged_at' => $log->logged_at->toIso8601String(),
            ])->values(),
        ], 'Water logs retrieved successfully');
    }

    /**
     * POST /api/v1/water
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'amount_ml' => ['required', 'integer', 'min:1', 'max:5000'],
            'logged_at' => ['nullable', 'date'],
            'date' => ['nullable', 'date_format:Y-m-d'],
        ]);

        if ($validator->fails()) {
            return $this->error('Validation failed', $validator->errors()->toArray(), 422);
        }

        $user = $request->user();
        $timezone = $user->timezone ?: 'UTC';

        if ($request->filled('logged_at')) {
            $loggedAt = Carbon::parse($request->input('logged_at'))->utc();
        } elseif ($request->filled('date')) {
            $currentTime = Carbon::now($timezone)->format('H:i:s');
            $loggedAt = Carbon::parse($request->input('date') . ' ' . $currentTime, $timezone)->utc();
        } else {
            $loggedAt = Carbon::now('UTC');
        }

        $waterLog = WaterLog::create([
            'user_id' => $user->id,
            'amount_ml' => $request->input('amount_ml'),
            'logged_at' => $loggedAt,
        ]);

        $logDate = Carbon::parse($waterLog->logged_at)->setTimezone($timezone)->toDateString();
        $startOfDay = Carbon::parse($logDate, $timezone)->startOfDay()->utc();
        $endOfDay = Carbon::parse($logDate, $timezone)->endOfDay()->utc();

        $totalMl = (int) WaterLog::where('user_id', $user->id)
            ->whereBetween('logged_at', [$startOfDay, $endOfDay])
            ->sum('amount_ml');

        return $this->success([
            'log' => [
                'id' => $waterLog->id,
                'amount_ml' => $waterLog->amount_ml,
                'logged_at' => $waterLog->logged_at->toIso8601String(),
            ],
            'date' => $logDate,
            'total_ml' => $totalMl,
        ], 'Water logged successfully', 201);
    }

    /**
     * DELETE /api/v1/water/{id?}
     */
    public function destroy(Request $request, ?int $id = null)
    {
        $user = $request->user();
        $timezone = $user->timezone ?: 'UTC';

        // Check if id was passed in request parameter or query/body
        $targetId = $id ?? $request->input('id') ?? $request->query('id');

        if ($targetId) {
            $waterLog = WaterLog::find($targetId);

            if (!$waterLog) {
                return $this->error('Water log not found', [], 404);
            }

            if ($waterLog->user_id !== $user->id) {
                return $this->error('You are not authorized to delete this water log', [], 403);
            }
        } else {
            // Undo last entry: find the latest entry for user (optionally on date)
            $query = WaterLog::where('user_id', $user->id);

            if ($request->has('date')) {
                $date = $request->input('date');
                $startOfDay = Carbon::parse($date, $timezone)->startOfDay()->utc();
                $endOfDay = Carbon::parse($date, $timezone)->endOfDay()->utc();
                $query->whereBetween('logged_at', [$startOfDay, $endOfDay]);
            }

            $waterLog = $query->latest('logged_at')->latest('id')->first();

            if (!$waterLog) {
                return $this->error('No water logs found to delete', [], 404);
            }
        }

        $logDate = Carbon::parse($waterLog->logged_at)->setTimezone($timezone)->toDateString();
        $deletedData = [
            'id' => $waterLog->id,
            'amount_ml' => $waterLog->amount_ml,
            'logged_at' => $waterLog->logged_at->toIso8601String(),
        ];

        $waterLog->delete();

        $startOfDay = Carbon::parse($logDate, $timezone)->startOfDay()->utc();
        $endOfDay = Carbon::parse($logDate, $timezone)->endOfDay()->utc();
        $newTotalMl = (int) WaterLog::where('user_id', $user->id)
            ->whereBetween('logged_at', [$startOfDay, $endOfDay])
            ->sum('amount_ml');

        return $this->success([
            'deleted_log' => $deletedData,
            'date' => $logDate,
            'total_ml' => $newTotalMl,
        ], 'Water log removed successfully');
    }
}
