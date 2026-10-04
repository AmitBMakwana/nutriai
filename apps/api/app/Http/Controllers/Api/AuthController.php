<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Traits\ApiResponse;
use App\Services\Auth\AuthService;
use App\Http\Requests\Api\RegisterRequest;
use App\Http\Requests\Api\LoginRequest;
use App\Http\Requests\Api\ForgotPasswordRequest;
use App\Http\Requests\Api\ResetPasswordRequest;
use App\Http\Resources\Api\UserResource;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Password;

class AuthController extends Controller
{
    use ApiResponse;

    public function __construct(private AuthService $authService) {}

    public function register(RegisterRequest $request)
    {
        $user = $this->authService->register($request->validated());
        return $this->success(new UserResource($user), 'Registration successful', 201);
    }

    public function login(LoginRequest $request)
    {
        $data = $this->authService->login($request->validated());
        
        return $this->success([
            'user' => new UserResource($data['user']),
            'token' => $data['token']
        ], 'Login successful');
    }

    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();
        return $this->success([], 'Logout successful');
    }

    public function me(Request $request)
    {
        return $this->success(new UserResource($request->user()));
    }

    public function forgotPassword(ForgotPasswordRequest $request)
    {
        $status = $this->authService->sendResetLink($request->validated());

        if ($status === Password::RESET_THROTTLED) {
            return $this->error(__($status), [], 429);
        }

        // Generic safe response prevents account enumeration
        return $this->success([], 'If an account matches that email address, a password reset link has been dispatched.');
    }

    public function resetPassword(ResetPasswordRequest $request)
    {
        $status = $this->authService->resetPassword($request->validated());

        return $status === Password::PASSWORD_RESET
            ? $this->success([], __($status))
            : $this->error(__($status));
    }
}
