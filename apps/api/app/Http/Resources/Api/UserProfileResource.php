<?php

namespace App\Http\Resources\Api;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class UserProfileResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'user_id' => $this->user_id,
            'goal' => $this->goal?->value ?? $this->goal,
            'gender' => $this->gender?->value ?? $this->gender,
            'date_of_birth' => $this->date_of_birth?->format('Y-m-d'),
            'height_cm' => $this->height_cm !== null ? (int)$this->height_cm : null,
            'weight_kg' => $this->weight_kg !== null ? (float)$this->weight_kg : null,
            'target_weight_kg' => $this->target_weight_kg !== null ? (float)$this->target_weight_kg : null,
            'activity_level' => $this->activity_level?->value ?? $this->activity_level,
            'diet_type' => $this->diet_type?->value ?? $this->diet_type,
            'unit_system' => $this->unit_system,
            'is_completed' => (bool)$this->is_completed,
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
        ];
    }
}
