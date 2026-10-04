<?php

namespace App\Http\Controllers\Admin;

use App\Enums\AiAnalysisStatus;
use App\Http\Controllers\Controller;
use App\Models\AiAnalysis;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class AiUsageController extends Controller
{
    public function index(Request $request)
    {
        // 1. Overall stats
        $totalScans = AiAnalysis::count();
        $completedScans = AiAnalysis::where('status', AiAnalysisStatus::COMPLETED)->count();
        $failedScans = AiAnalysis::where('status', AiAnalysisStatus::FAILED)->count();
        $avgLatencyMs = (int) AiAnalysis::whereNotNull('processing_time_ms')->avg('processing_time_ms');

        // 2. Per Provider stats
        $providerStats = AiAnalysis::select(
            'provider',
            DB::raw('count(*) as total'),
            DB::raw("sum(case when status = 'completed' then 1 else 0 end) as completed"),
            DB::raw("sum(case when status = 'failed' then 1 else 0 end) as failed"),
            DB::raw('avg(processing_time_ms) as avg_latency')
        )
        ->groupBy('provider')
        ->get();

        // 3. Per Model stats
        $modelStats = AiAnalysis::select(
            'model',
            'provider',
            DB::raw('count(*) as total'),
            DB::raw("sum(case when status = 'completed' then 1 else 0 end) as completed"),
            DB::raw("sum(case when status = 'failed' then 1 else 0 end) as failed"),
            DB::raw('avg(processing_time_ms) as avg_latency')
        )
        ->groupBy('model', 'provider')
        ->get();

        $overallSuccessRate = $totalScans > 0 ? round(($completedScans / $totalScans) * 100, 1) : 100;

        $formattedProviderStats = [];
        foreach ($providerStats as $stat) {
            $total = (int) $stat->total;
            $success = (int) $stat->completed;
            $failed = (int) $stat->failed;
            $rate = $total > 0 ? round(($success / $total) * 100, 1) : 100;
            $costPerCall = str_contains(strtolower($stat->provider ?? ''), 'openai') ? 0.005 : 0.00015;

            $formattedProviderStats[] = [
                'provider' => $stat->provider ?? 'Unknown',
                'model' => 'default',
                'total' => $total,
                'success' => $success,
                'failed' => $failed,
                'success_rate' => $rate,
                'avg_latency_ms' => (int) round($stat->avg_latency ?? 0),
                'estimated_cost' => $success * $costPerCall,
            ];
        }

        $estimatedCost = (float) array_sum(array_column($formattedProviderStats, 'estimated_cost'));

        $scans = AiAnalysis::with('user')
            ->latest()
            ->paginate(15)
            ->withQueryString();

        $recentScans = $scans;

        return view('admin.ai.usage', [
            'totalScans' => $totalScans,
            'completedScans' => $completedScans,
            'failedScans' => $failedScans,
            'overallSuccessRate' => $overallSuccessRate,
            'avgLatencyMs' => $avgLatencyMs,
            'providerStats' => $formattedProviderStats,
            'modelStats' => $modelStats,
            'estimatedCost' => $estimatedCost,
            'recentScans' => $recentScans,
            'scans' => $scans,
        ]);
    }
}
