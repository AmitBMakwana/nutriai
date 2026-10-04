<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\AuditLog;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class AdminAuthController extends Controller
{
    /**
     * Show admin login form.
     */
    public function showLoginForm()
    {
        if (Auth::check() && Auth::user()->hasRole('admin')) {
            return redirect()->route('admin.dashboard');
        }

        return view('admin.auth.login');
    }

    /**
     * Handle admin login attempt.
     */
    public function login(Request $request)
    {
        $credentials = $request->validate([
            'email' => ['required', 'email'],
            'password' => ['required', 'string'],
        ]);

        $remember = $request->boolean('remember');

        if (Auth::attempt($credentials, $remember)) {
            $user = Auth::user();

            // Enforce account active status
            if ($user->is_disabled) {
                Auth::logout();
                return back()->withErrors(['email' => 'This account has been disabled.']);
            }

            // Enforce admin role
            if (!$user->hasRole('admin')) {
                Auth::logout();
                return back()->withErrors(['email' => 'Access denied: Administrator privileges required.']);
            }

            $request->session()->regenerate();

            AuditLog::record(
                $user->id,
                'admin_login',
                'User',
                $user->id,
                ['email' => $user->email],
                $request->ip()
            );

            return redirect()->intended(route('admin.dashboard'));
        }

        return back()->withErrors(['email' => 'Invalid credentials provided.'])->onlyInput('email');
    }

    /**
     * Handle admin logout.
     */
    public function logout(Request $request)
    {
        $user = Auth::user();

        if ($user) {
            AuditLog::record(
                $user->id,
                'admin_logout',
                'User',
                $user->id,
                ['email' => $user->email],
                $request->ip()
            );
        }

        Auth::logout();
        $request->session()->invalidate();
        $request->session()->regenerateToken();

        return redirect()->route('admin.login');
    }
}
