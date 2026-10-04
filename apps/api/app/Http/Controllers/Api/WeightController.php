<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\WeightLog;
use App\Traits\ApiResponse;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class WeightController extends Controller
{
    use ApiResponse;

    /**
     * GET /api/v1/weight
     */
    public function index(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'start_date' => ['nullable', 'date_format:Y-m-d'],
            'end_date' => ['nullable', 'date_format:Y-m-d'],
            'limit' => ['nullable', 'integer', 'min:1', 'max:365'],
        ]);

        if ($validator->fails()) {
            return $this->error('Validation failed', $validator->errors()->toArray(), 422);
        }

        $user = $request->user();
        $timezone = $user->timezone ?: 'UTC';
        $limit = (int) $request->query('limit', 100);

        $query = WeightLog::where('user_id', $user->id);

        if ($request->filled('start_date')) {
            $start = Carbon::parse($request->query('start_date'), $timezone)->startOfDay()->utc();
            $query->where('logged_at', '>=', $start);
        }

        if ($request->filled('end_date')) {
            $end = Carbon::parse($request->query('end_date'), $timezone)->endOfDay()->utc();
            $query->where('logged_at', '<=', $end);
        }

        // Retrieve sorted chronologically for graphs
        $logs = $query->orderBy('logged_at', 'asc')
            ->orderBy('id', 'asc')
            ->take($limit)
            ->get();

        $profile = $user->profile;
        $currentWeight = $profile?->weight_kg ?? ($logs->last()?->weight_kg ?? null);
        $targetWeight = $profile?->target_weight_kg ?? null;
        $unitSystem = $profile?->unit_system ?? 'metric';

        return $this->success([
            'current_weight_kg' => $currentWeight !== null ? (float) $currentWeight : null,
            'target_weight_kg' => $targetWeight !== null ? (float) $targetWeight : null,
            'unit_system' => $unitSystem,
            'logs' => $logs->map(fn (WeightLog $l) => [
                'id' => $l->id,
                'weight_kg' => (float) $l->weight_kg,
                'logged_at' => $l->logged_at->toIso8601String(),
                'date' => Carbon::parse($l->logged_at)->setTimezone($timezone)->toDateString(),
            ])->values(),
        ], 'Weight logs retrieved successfully');
    }

    /**
     * POST /api/v1/weight
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'weight_kg' => ['required', 'numeric', 'min:20', 'max:500'],
            'logged_at' => ['nullable', 'date'],
            'date' => ['nullable', 'date_format:Y-m-d'],
            'sync_profile' => ['nullable', 'boolean'],
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

        $weightKg = round((float) $request->input('weight_kg'), 2);

        $weightLog = WeightLog::create([
            'user_id' => $user->id,
            'weight_kg' => $weightKg,
            'logged_at' => $loggedAt,
        ]);

        // Optionally sync to user_profiles.weight_kg if this is the newest entry
        $syncProfile = $request->boolean('sync_profile', true);
        if ($syncProfile) {
            $hasNewer = WeightLog::where('user_id', $user->id)
                ->where('logged_at', '>', $weightLog->logged_at)
                ->exists();

            if (!$hasNewer && $user->profile) {
                $user->profile->update(['weight_kg' => $weightKg]);
            }
        }

        return $this->success([
            'id' => $weightLog->id,
            'weight_kg' => (float) $weightLog->weight_kg,
            'logged_at' => $weightLog->logged_at->toIso8601String(),
            'date' => Carbon::parse($weightLog->logged_at)->setTimezone($timezone)->toDateString(),
            'synced_to_profile' => $syncProfile,
        ], 'Weight logged successfully', 201);
    }

    /**
     * DELETE /api/v1/weight/{id}
     */
    public function destroy(Request $request, int $id)
    {
        $user = $request->user();
        $weightLog = WeightLog::find($id);

        if (!$weightLog) {
            return $this->error('Weight log not found', [], 404);
        }

        if ($weightLog->user_id !== $user->id) {
            return $this->error('You are not authorized to delete this weight log', [], 403);
        }

        // Check if this was the latest entry
        $isLatest = !WeightLog::where('user_id', $user->id)
            ->where('logged_at', '>', $weightLog->logged_at)
            ->where('id', '!=', $weightLog->id)
            ->exists();

        $weightLog->delete();

        // If the latest entry was deleted, sync profile to the new latest entry
        if ($isLatest && $user->profile) {
            $newLatest = WeightLog::where('user_id', $user->id)
                ->latest('logged_at')
                ->latest('id')
                ->first();

            if ($newLatest) {
                $user->profile->update(['weight_kg' => $newLatest->weight_kg]);
            }
        }

        return $this->success([], 'Weight log deleted successfully');
    }
}
