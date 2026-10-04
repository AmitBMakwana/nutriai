<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Symfony\Component\HttpFoundation\Response;

class AdminAuthenticate
{
    /**
     * Handle an incoming request.
     */
    public function handle(Request $request, Closure $next): Response
    {
        $user = Auth::user();

        if (!$user) {
            if ($request->expectsJson() || $request->is('api/*')) {
                return response()->json(['message' => 'Unauthenticated.'], 401);
            }
            return redirect()->guest(route('admin.login'));
        }

        // Verify user is not disabled
        if ($user->is_disabled) {
            Auth::logout();
            $request->session()->invalidate();
            $request->session()->regenerateToken();

            if ($request->expectsJson()) {
                return response()->json(['message' => 'Account is disabled.'], 403);
            }
            return redirect()->route('admin.login')->withErrors(['email' => 'Your administrator account has been disabled.']);
        }

        // Verify user has 'admin' role via Spatie Permission
        if (!$user->hasRole('admin')) {
            if ($request->expectsJson()) {
                return response()->json(['message' => 'Forbidden: Administrator access required.'], 403);
            }
            abort(403, 'Forbidden: Administrator access required.');
        }

        return $next($request);
    }
}
