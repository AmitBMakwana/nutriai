<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Subscription;
use App\Models\WebhookEvent;
use Illuminate\Http\Request;

class SubscriptionController extends Controller
{
    public function index(Request $request)
    {
        $query = Subscription::query()->with('user');

        if ($request->filled('plan')) {
            $query->where('plan', $request->input('plan'));
        }

        if ($request->filled('status')) {
            $query->where('status', $request->input('status'));
        }

        $subscriptions = $query->latest('id')->paginate(15)->withQueryString();

        $activeProCount = Subscription::where('status', 'active')->where('plan', 'pro')->count();
        $activePremiumCount = Subscription::where('status', 'active')->where('plan', 'premium')->count();
        $freeCount = \App\Models\User::count() - ($activeProCount + $activePremiumCount);
        $tierCounts = [
            'free' => max(0, $freeCount),
            'pro' => $activeProCount,
            'premium' => $activePremiumCount,
        ];
        $estimatedMrr = ($activeProCount * 9.99) + ($activePremiumCount * 19.99);

        // Recent Webhook events
        $recentWebhooks = WebhookEvent::latest()->take(10)->get();

        return view('admin.subscriptions.index', compact(
            'subscriptions',
            'tierCounts',
            'activeProCount',
            'activePremiumCount',
            'estimatedMrr',
            'recentWebhooks'
        ));
    }
}
