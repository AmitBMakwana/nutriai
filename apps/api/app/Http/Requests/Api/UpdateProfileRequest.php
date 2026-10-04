<?php

namespace App\Http\Requests\Api;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class UpdateProfileRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'name' => ['sometimes', 'string', 'max:255'],
            'timezone' => ['sometimes', 'nullable', 'string', 'max:100'],
            'avatar' => ['sometimes', 'nullable', 'string', 'max:255'],
            'goal' => ['sometimes', 'string', Rule::in(['maintain', 'lose_weight', 'gain_weight', 'build_muscle'])],
            'gender' => ['sometimes', 'string', Rule::in(['male', 'female', 'other', 'prefer_not_to_say'])],
            'date_of_birth' => ['sometimes', 'date', 'before:today', 'after:1900-01-01'],
            'height_cm' => ['sometimes', 'numeric', 'min:50', 'max:300'],
            'weight_kg' => ['sometimes', 'numeric', 'min:20', 'max:500'],
            'target_weight_kg' => ['sometimes', 'numeric', 'min:20', 'max:500'],
            'activity_level' => ['sometimes', 'string', Rule::in([
                'sedentary', 'lightly_active', 'moderately_active', 'very_active', 'extra_active', 'extremely_active'
            ])],
            'diet_type' => ['sometimes', 'string', Rule::in([
                'everything', 'standard', 'vegetarian', 'vegan', 'pescatarian', 'keto', 'paleo', 'other'
            ])],
            'unit_system' => ['sometimes', 'string', Rule::in(['metric', 'imperial'])],
            'recalculate_goals' => ['sometimes', 'boolean'],
        ];
    }
}
