@extends('admin.layouts.app')

@section('title', 'Subscriptions Management')

@section('content')
<div class="space-y-6">
    <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
        <div>
            <h1 class="text-2xl font-bold text-slate-900">Subscriptions & Revenue</h1>
            <p class="text-sm text-slate-500">Live entitlement distribution, active subscriptions, and RevenueCat webhook history.</p>
        </div>
        <div class="flex items-center space-x-2">
            <span class="text-xs bg-slate-100 text-slate-700 px-3 py-1.5 rounded-lg border border-slate-200">
                Single Source of Truth: Backend DB
            </span>
        </div>
    </div>

    <!-- Tier Breakdown Cards -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm">
            <span class="text-xs font-semibold text-slate-400 uppercase tracking-wider">Free Tier Users</span>
            <div class="text-2xl font-bold text-slate-700 mt-1">{{ number_format($tierCounts['free'] ?? 0) }}</div>
            <p class="text-xs text-slate-400 mt-1">Default 5 scans/mo</p>
        </div>

        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm">
            <span class="text-xs font-semibold text-emerald-600 uppercase tracking-wider">Pro Subscribers</span>
            <div class="text-2xl font-bold text-emerald-600 mt-1">{{ number_format($tierCounts['pro'] ?? 0) }}</div>
            <p class="text-xs text-slate-400 mt-1">$9.99/mo tier</p>
        </div>

        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm">
            <span class="text-xs font-semibold text-purple-600 uppercase tracking-wider">Premium Subscribers</span>
            <div class="text-2xl font-bold text-purple-600 mt-1">{{ number_format($tierCounts['premium'] ?? 0) }}</div>
            <p class="text-xs text-slate-400 mt-1">Unlimited scans & coaching</p>
        </div>

        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm">
            <span class="text-xs font-semibold text-slate-400 uppercase tracking-wider">Est. Monthly MRR</span>
            <div class="text-2xl font-bold text-slate-900 mt-1">${{ number_format($estimatedMrr, 2) }}</div>
            <p class="text-xs text-slate-400 mt-1">Active subscriptions value</p>
        </div>
    </div>

    <!-- Subscriptions List -->
    <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
        <div class="p-4 border-b border-slate-100 bg-slate-50 flex items-center justify-between">
            <h3 class="font-bold text-slate-900 text-sm">Active & Recent Subscriptions</h3>
            <span class="text-xs text-slate-500">Managed via RevenueCat</span>
        </div>
        <div class="overflow-x-auto">
            <table class="w-full text-left border-collapse text-sm">
                <thead>
                    <tr class="text-xs uppercase font-semibold text-slate-500 border-b border-slate-200 bg-white">
                        <th class="py-3 px-4">User</th>
                        <th class="py-3 px-4">Plan</th>
                        <th class="py-3 px-4">Status</th>
                        <th class="py-3 px-4">Store / Gateway</th>
                        <th class="py-3 px-4">Expires At</th>
                        <th class="py-3 px-4 text-right">Updated</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-100">
                    @forelse($subscriptions as $sub)
                    <tr class="hover:bg-slate-50 transition">
                        <td class="py-3.5 px-4">
                            <a href="{{ route('admin.users.show', $sub->user_id) }}" class="font-medium text-slate-900 hover:text-emerald-600">
                                {{ $sub->user?->name ?? 'User #' . $sub->user_id }}
                            </a>
                            <div class="text-xs text-slate-400">{{ $sub->user?->email }}</div>
                        </td>
                        <td class="py-3.5 px-4">
                            <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-semibold uppercase
                                {{ $sub->plan === 'premium' ? 'bg-purple-100 text-purple-800' : ($sub->plan === 'pro' ? 'bg-emerald-100 text-emerald-800' : 'bg-slate-100 text-slate-800') }}">
                                {{ $sub->plan }}
                            </span>
                        </td>
                        <td class="py-3.5 px-4">
                            <span class="capitalize text-xs font-medium {{ $sub->status === 'active' ? 'text-emerald-600' : 'text-slate-500' }}">
                                {{ $sub->status }}
                            </span>
                        </td>
                        <td class="py-3.5 px-4 text-xs text-slate-600">
                            {{ $sub->store ?? 'RevenueCat' }}
                        </td>
                        <td class="py-3.5 px-4 text-xs text-slate-600">
                            {{ $sub->expires_at ? $sub->expires_at->format('M d, Y H:i') : 'Never / Free' }}
                        </td>
                        <td class="py-3.5 px-4 text-right text-xs text-slate-400">
                            {{ $sub->updated_at->diffForHumans() }}
                        </td>
                    </tr>
                    @empty
                    <tr>
                        <td colspan="6" class="py-8 text-center text-slate-400">No active subscriptions on record.</td>
                    </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
        @if(method_exists($subscriptions, 'hasPages') && $subscriptions->hasPages())
        <div class="p-4 border-t border-slate-100">
            {{ $subscriptions->links() }}
        </div>
        @endif
    </div>

    <!-- Recent Webhook Events -->
    <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
        <div class="p-4 border-b border-slate-100 bg-slate-50">
            <h3 class="font-bold text-slate-900 text-sm">Recent RevenueCat Webhook Events (Idempotent Audit)</h3>
        </div>
        <div class="overflow-x-auto">
            <table class="w-full text-left border-collapse text-sm">
                <thead>
                    <tr class="text-xs uppercase font-semibold text-slate-500 border-b border-slate-200 bg-white">
                        <th class="py-3 px-4">Received At</th>
                        <th class="py-3 px-4">Event ID</th>
                        <th class="py-3 px-4">Event Type</th>
                        <th class="py-3 px-4">App User ID</th>
                        <th class="py-3 px-4">Product ID</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-100 font-mono text-xs">
                    @forelse($recentWebhooks as $event)
                    <tr>
                        <td class="py-3 px-4 text-slate-500">{{ $event->created_at->format('Y-m-d H:i:s') }}</td>
                        <td class="py-3 px-4 text-slate-700 truncate max-w-xs">{{ $event->event_id }}</td>
                        <td class="py-3 px-4 text-emerald-700 font-semibold uppercase">{{ $event->event_type ?? 'SUBSCRIPTION' }}</td>
                        <td class="py-3 px-4 text-slate-600">{{ $event->app_user_id }}</td>
                        <td class="py-3 px-4 text-slate-600">{{ $event->product_id }}</td>
                    </tr>
                    @empty
                    <tr>
                        <td colspan="5" class="py-6 text-center text-slate-400 font-sans">No webhook events logged yet.</td>
                    </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
    </div>
</div>
@endsection
