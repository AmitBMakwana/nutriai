<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class EnsureUserNotDisabled
{
    /**
     * Handle an incoming request.
     * Ensure the authenticated user account has not been disabled by an administrator.
     */
    public function handle(Request $request, Closure $next): Response
    {
        $user = $request->user();

        if ($user && $user->is_disabled) {
            // Revoke current access token if calling via API token
            if ($user->currentAccessToken()) {
                $user->currentAccessToken()->delete();
            }

            return response()->json([
                'success' => false,
                'message' => 'Your account has been suspended by an administrator. Please contact support.',
                'errors' => (object) [],
            ], 403);
        }

        return $next($request);
    }
}
