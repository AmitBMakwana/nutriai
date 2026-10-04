<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\Api\OnboardingRequest;
use App\Http\Requests\Api\UpdateProfileRequest;
use App\Http\Resources\Api\UserProfileResource;
use App\Http\Resources\Api\UserResource;
use App\Services\Profile\ProfileService;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;

class ProfileController extends Controller
{
    use ApiResponse;

    public function __construct(
        private readonly ProfileService $profileService
    ) {}

    public function onboarding(OnboardingRequest $request)
    {
        $profile = $this->profileService->saveOnboarding(
            $request->user(),
            $request->validated()
        );

        return $this->success([
            'profile' => new UserProfileResource($profile),
            'user' => new UserResource($request->user()->fresh(['profile'])),
        ], 'Onboarding completed successfully');
    }

    public function show(Request $request)
    {
        $profile = $this->profileService->getProfile($request->user());

        return $this->success(
            new UserProfileResource($profile),
            'Profile retrieved successfully'
        );
    }

    public function update(UpdateProfileRequest $request)
    {
        $profile = $this->profileService->updateProfile(
            $request->user(),
            $request->validated()
        );

        return $this->success([
            'profile' => new UserProfileResource($profile),
            'user' => new UserResource($request->user()->fresh(['profile'])),
        ], 'Profile updated successfully');
    }

    public function uploadAvatar(Request $request)
    {
        $request->validate([
            'avatar' => ['required', 'file', 'image', 'mimes:jpeg,png,jpg,webp', 'max:5120'],
        ]);

        $user = $request->user();
        $file = $request->file('avatar');
        $filename = 'avatar_' . $user->id . '_' . time() . '.' . $file->getClientOriginalExtension();
        $path = $file->storeAs('avatars', $filename, 'public');

        if ($user->avatar && str_contains($user->avatar, '/storage/avatars/')) {
            $oldPath = str_replace('/storage/', '', parse_url($user->avatar, PHP_URL_PATH));
            \Illuminate\Support\Facades\Storage::disk('public')->delete($oldPath);
        }

        $url = \Illuminate\Support\Facades\Storage::disk('public')->url($path);
        $user->update(['avatar' => $url]);

        return $this->success([
            'avatar' => $url,
            'user' => new UserResource($user->fresh(['profile'])),
        ], 'Avatar uploaded successfully');
    }

    public function changePassword(Request $request)
    {
        $request->validate([
            'current_password' => ['required', 'string', 'current_password'],
            'password' => ['required', 'string', 'min:8', 'confirmed'],
        ]);

        $user = $request->user();
        $user->update([
            'password' => \Illuminate\Support\Facades\Hash::make($request->password),
        ]);

        return $this->success(null, 'Password changed successfully');
    }

    public function deleteAccount(Request $request)
    {
        $request->validate([
            'confirmation' => ['required_without:password', 'boolean', 'accepted'],
            'password' => ['required_without:confirmation', 'string', 'current_password'],
        ]);

        $user = $request->user();
        $this->profileService->deleteAccount($user);

        return $this->success(null, 'Account and all associated data deleted successfully');
    }
}

