<?php

namespace App\Http\Requests\Api;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class CalculateGoalRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'weight_kg' => ['sometimes', 'numeric', 'min:20', 'max:500'],
            'height_cm' => ['sometimes', 'numeric', 'min:50', 'max:300'],
            'date_of_birth' => ['sometimes', 'date', 'before:today'],
            'gender' => ['sometimes', 'string', Rule::in(['male', 'female', 'other', 'prefer_not_to_say'])],
            'activity_level' => ['sometimes', 'string', Rule::in([
                'sedentary', 'lightly_active', 'moderately_active', 'very_active', 'extra_active', 'extremely_active'
            ])],
            'goal' => ['sometimes', 'string', Rule::in(['maintain', 'lose_weight', 'gain_weight', 'build_muscle'])],
            'diet_type' => ['sometimes', 'nullable', 'string'],
        ];
    }
}
