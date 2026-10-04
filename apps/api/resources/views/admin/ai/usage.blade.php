@extends('admin.layouts.app')

@section('title', 'AI Usage & Analytics')

@section('content')
<div class="space-y-6">
    <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
        <div>
            <h1 class="text-2xl font-bold text-slate-900">AI Usage & Cost Telemetry</h1>
            <p class="text-sm text-slate-500">Live breakdown of AI model executions, latencies, success rates, and token expenditures.</p>
        </div>
        <div class="flex items-center space-x-2">
            <span class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-semibold bg-emerald-100 text-emerald-800">
                <span class="w-1.5 h-1.5 rounded-full bg-emerald-500 mr-1.5 animate-pulse"></span>
                Telemetry Active
            </span>
        </div>
    </div>

    <!-- Top KPI Cards -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm">
            <span class="text-xs font-semibold text-slate-400 uppercase tracking-wider">Total Scans</span>
            <div class="text-2xl font-bold text-slate-900 mt-1">{{ number_format($totalScans) }}</div>
            <p class="text-xs text-slate-500 mt-1">Lifetime vision analyses</p>
        </div>
        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm">
            <span class="text-xs font-semibold text-slate-400 uppercase tracking-wider">Success Rate</span>
            <div class="text-2xl font-bold text-emerald-600 mt-1">{{ $overallSuccessRate }}%</div>
            <p class="text-xs text-slate-500 mt-1">Successful vs failed attempts</p>
        </div>
        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm">
            <span class="text-xs font-semibold text-slate-400 uppercase tracking-wider">Avg Latency</span>
            <div class="text-2xl font-bold text-blue-600 mt-1">{{ $avgLatencyMs }} <span class="text-sm font-normal text-slate-500">ms</span></div>
            <p class="text-xs text-slate-500 mt-1">End-to-end model response</p>
        </div>
        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm">
            <span class="text-xs font-semibold text-slate-400 uppercase tracking-wider">Estimated Cost</span>
            <div class="text-2xl font-bold text-slate-900 mt-1">${{ number_format($estimatedCost, 2) }}</div>
            <p class="text-xs text-slate-500 mt-1">Token pricing across providers</p>
        </div>
    </div>

    <!-- Breakdown By Provider & Model -->
    <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
        <div class="p-4 border-b border-slate-100 bg-slate-50 flex items-center justify-between">
            <h3 class="font-bold text-slate-900 text-sm">Usage by Provider & Model</h3>
            <span class="text-xs text-slate-500">Auto-aggregated from scan logs</span>
        </div>
        <div class="overflow-x-auto">
            <table class="w-full text-left border-collapse text-sm">
                <thead>
                    <tr class="text-xs uppercase font-semibold text-slate-500 border-b border-slate-200 bg-white">
                        <th class="py-3 px-4">Provider</th>
                        <th class="py-3 px-4">Model</th>
                        <th class="py-3 px-4">Total Requests</th>
                        <th class="py-3 px-4">Success / Failure</th>
                        <th class="py-3 px-4">Success Rate</th>
                        <th class="py-3 px-4">Avg Latency</th>
                        <th class="py-3 px-4 text-right">Est. Cost</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-100">
                    @forelse($providerStats as $stat)
                    <tr class="hover:bg-slate-50 transition">
                        <td class="py-3 px-4 font-semibold text-slate-900 uppercase text-xs">
                            {{ $stat['provider'] }}
                        </td>
                        <td class="py-3 px-4 text-slate-700 font-mono text-xs">
                            {{ $stat['model'] }}
                        </td>
                        <td class="py-3 px-4 font-medium text-slate-900">
                            {{ number_format($stat['total']) }}
                        </td>
                        <td class="py-3 px-4 text-xs">
                            <span class="text-emerald-600 font-semibold">{{ $stat['success'] }}</span> / 
                            <span class="text-rose-600 font-semibold">{{ $stat['failed'] }}</span>
                        </td>
                        <td class="py-3 px-4">
                            <div class="flex items-center gap-2">
                                <div class="w-16 bg-slate-100 rounded-full h-2">
                                    <div class="bg-emerald-500 h-2 rounded-full" style="width: {{ $stat['success_rate'] }}%"></div>
                                </div>
                                <span class="text-xs font-semibold text-slate-700">{{ $stat['success_rate'] }}%</span>
                            </div>
                        </td>
                        <td class="py-3 px-4 text-slate-600 font-mono text-xs">
                            {{ $stat['avg_latency_ms'] }} ms
                        </td>
                        <td class="py-3 px-4 text-right font-semibold text-slate-900">
                            ${{ number_format($stat['estimated_cost'], 4) }}
                        </td>
                    </tr>
                    @empty
                    <tr>
                        <td colspan="7" class="py-8 text-center text-slate-400">No AI usage metrics recorded yet.</td>
                    </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
    </div>

    <!-- Recent Execution Logs -->
    <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
        <div class="p-4 border-b border-slate-100 bg-slate-50">
            <h3 class="font-bold text-slate-900 text-sm">Recent AI Scan Attempts</h3>
        </div>
        <div class="overflow-x-auto">
            <table class="w-full text-left border-collapse text-sm">
                <thead>
                    <tr class="text-xs uppercase font-semibold text-slate-500 border-b border-slate-200 bg-white">
                        <th class="py-3 px-4">Time</th>
                        <th class="py-3 px-4">User</th>
                        <th class="py-3 px-4">Provider / Model</th>
                        <th class="py-3 px-4">Status</th>
                        <th class="py-3 px-4">Latency</th>
                        <th class="py-3 px-4">Tokens (In / Out)</th>
                        <th class="py-3 px-4 text-right">Cost</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-100">
                    @forelse($recentScans as $scan)
                    <tr class="hover:bg-slate-50 transition">
                        <td class="py-3 px-4 text-xs text-slate-500">
                            {{ $scan->created_at->diffForHumans() }}
                        </td>
                        <td class="py-3 px-4">
                            <span class="text-slate-900 font-medium text-xs">{{ $scan->user?->name ?? 'User #' . $scan->user_id }}</span>
                        </td>
                        <td class="py-3 px-4 text-xs">
                            <span class="font-medium text-slate-800">{{ $scan->provider }}</span>
                            <span class="text-slate-400">({{ $scan->model }})</span>
                        </td>
                        <td class="py-3 px-4">
                            @if($scan->status === 'success' || $scan->status === 'completed')
                                <span class="px-2 py-0.5 rounded text-xs font-semibold bg-emerald-50 text-emerald-700">Success</span>
                            @else
                                <span class="px-2 py-0.5 rounded text-xs font-semibold bg-rose-50 text-rose-700">{{ $scan->status }}</span>
                            @endif
                        </td>
                        <td class="py-3 px-4 text-xs font-mono text-slate-600">
                            {{ $scan->latency_ms ?? 0 }} ms
                        </td>
                        <td class="py-3 px-4 text-xs text-slate-600">
                            {{ $scan->prompt_tokens ?? 0 }} / {{ $scan->completion_tokens ?? 0 }}
                        </td>
                        <td class="py-3 px-4 text-right text-xs font-semibold text-slate-900">
                            ${{ number_format($scan->estimated_cost ?? 0, 4) }}
                        </td>
                    </tr>
                    @empty
                    <tr>
                        <td colspan="7" class="py-8 text-center text-slate-400">No recent AI scans found.</td>
                    </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
        @if(method_exists($recentScans, 'hasPages') && $recentScans->hasPages())
        <div class="p-4 border-t border-slate-100">
            {{ $recentScans->links() }}
        </div>
        @endif
    </div>
</div>
@endsection
