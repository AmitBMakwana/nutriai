<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\AuditLog;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class UserController extends Controller
{
    public function index(Request $request)
    {
        $query = User::query()->with(['profile', 'subscriptions']);

        if ($request->filled('search')) {
            $search = $request->input('search');
            $query->where(function ($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                  ->orWhere('email', 'like', "%{$search}%");
            });
        }

        if ($request->filled('status')) {
            if ($request->input('status') === 'disabled') {
                $query->where('is_disabled', true);
            } elseif ($request->input('status') === 'active') {
                $query->where('is_disabled', false);
            }
        }

        $users = $query->latest()->paginate(15)->withQueryString();

        return view('admin.users.index', compact('users'));
    }

    public function show(int $id)
    {
        $user = User::with(['profile', 'subscriptions', 'nutritionGoals', 'meals' => fn($q) => $q->latest()->take(10), 'aiAnalyses' => fn($q) => $q->latest()->take(10)])
            ->findOrFail($id);

        return view('admin.users.show', compact('user'));
    }

    public function toggleStatus(Request $request, int $id)
    {
        $user = User::findOrFail($id);

        // Prevent disabling yourself
        if ($user->id === Auth::id()) {
            return back()->with('error', 'You cannot disable your own administrator account.');
        }

        $user->is_disabled = !$user->is_disabled;
        $user->save();

        $action = $user->is_disabled ? 'disable_user' : 'enable_user';

        AuditLog::record(
            Auth::id(),
            $action,
            'User',
            $user->id,
            ['is_disabled' => $user->is_disabled, 'email' => $user->email]
        );

        $statusStr = $user->is_disabled ? 'disabled' : 'enabled';
        return back()->with('success', "User account {$user->name} has been {$statusStr}.");
    }
}
