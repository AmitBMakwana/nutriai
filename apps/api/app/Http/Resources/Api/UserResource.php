<?php

namespace App\Http\Resources\Api;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class UserResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'email' => $this->email,
            'avatar' => $this->avatar,
            'timezone' => $this->timezone,
            'is_onboarding_completed' => $this->isOnboardingCompleted(),
            'profile' => $this->profile ? new UserProfileResource($this->profile) : null,
            'created_at' => $this->created_at,
        ];
    }
}
