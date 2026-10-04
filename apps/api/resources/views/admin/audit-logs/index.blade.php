@extends('admin.layouts.app')

@section('title', 'Admin Audit Logs')

@section('content')
<div class="space-y-6">
    <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
        <div>
            <h1 class="text-2xl font-bold text-slate-900">Audit Trail</h1>
            <p class="text-sm text-slate-500">Immutable record of all administrative operations, settings changes, user status toggles, and data modifications.</p>
        </div>
        <div class="text-xs bg-slate-100 text-slate-700 px-3 py-1.5 rounded-lg border border-slate-200">
            Security & Compliance Log
        </div>
    </div>

    <!-- Filter Form -->
    <div class="bg-white p-4 rounded-xl border border-slate-200 shadow-sm">
        <form method="GET" action="{{ route('admin.audit-logs.index') }}" class="grid grid-cols-1 md:grid-cols-4 gap-4">
            <div>
                <input type="text" name="action" value="{{ request('action') }}" placeholder="Filter by action (e.g. settings.ai_updated)..." class="w-full text-sm border-slate-300 rounded-lg">
            </div>
            <div>
                <input type="text" name="admin" value="{{ request('admin') }}" placeholder="Admin user name or ID..." class="w-full text-sm border-slate-300 rounded-lg">
            </div>
            <div>
                <input type="date" name="date" value="{{ request('date') }}" class="w-full text-sm border-slate-300 rounded-lg">
            </div>
            <div class="flex gap-2">
                <button type="submit" class="flex-1 px-4 py-2 bg-slate-900 text-white text-sm font-medium rounded-lg hover:bg-slate-800 transition">Filter</button>
                <a href="{{ route('admin.audit-logs.index') }}" class="px-4 py-2 bg-slate-100 text-slate-600 text-sm font-medium rounded-lg hover:bg-slate-200 transition">Reset</a>
            </div>
        </form>
    </div>

    <!-- Audit Logs Table -->
    <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
        <div class="overflow-x-auto">
            <table class="w-full text-left border-collapse text-sm">
                <thead>
                    <tr class="text-xs uppercase font-semibold text-slate-500 border-b border-slate-200 bg-slate-50">
                        <th class="py-3 px-4">Timestamp</th>
                        <th class="py-3 px-4">Admin User</th>
                        <th class="py-3 px-4">Action</th>
                        <th class="py-3 px-4">Target Entity</th>
                        <th class="py-3 px-4">IP Address</th>
                        <th class="py-3 px-4">Details / Payload</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-100 font-mono text-xs">
                    @forelse($logs as $log)
                    <tr class="hover:bg-slate-50 transition">
                        <td class="py-3 px-4 text-slate-500 font-sans whitespace-nowrap">
                            {{ $log->created_at->format('M d, Y H:i:s') }}
                        </td>
                        <td class="py-3 px-4 font-sans font-medium text-slate-900">
                            {{ $log->user?->name ?? 'Admin #' . $log->user_id }}
                        </td>
                        <td class="py-3 px-4">
                            <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-semibold uppercase bg-emerald-50 text-emerald-700">
                                {{ $log->action }}
                            </span>
                        </td>
                        <td class="py-3 px-4 text-slate-700">
                            {{ $log->target_type ? class_basename($log->target_type) . ' #' . $log->target_id : '—' }}
                        </td>
                        <td class="py-3 px-4 text-slate-500">
                            {{ $log->ip_address ?? '—' }}
                        </td>
                        <td class="py-3 px-4 text-slate-600 truncate max-w-xs font-mono" title="{{ json_encode($log->details) }}">
                            {{ json_encode($log->details) }}
                        </td>
                    </tr>
                    @empty
                    <tr>
                        <td colspan="6" class="py-8 text-center text-slate-400 font-sans">No audit records found.</td>
                    </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
        @if(method_exists($logs, 'hasPages') && $logs->hasPages())
        <div class="p-4 border-t border-slate-100 font-sans">
            {{ $logs->links() }}
        </div>
        @endif
    </div>
</div>
@endsection
