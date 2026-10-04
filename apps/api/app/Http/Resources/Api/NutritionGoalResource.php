<?php

namespace App\Http\Resources\Api;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class NutritionGoalResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'user_id' => $this->user_id,
            'daily_calories' => (int) $this->daily_calories,
            'protein_grams' => (int) $this->protein_grams,
            'carbs_grams' => (int) $this->carbs_grams,
            'fat_grams' => (int) $this->fat_grams,
            'water_ml' => (int) $this->water_ml,
            'effective_from' => $this->effective_from?->format('Y-m-d'),
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
        ];
    }
}
