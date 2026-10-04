<?php

namespace App\Http\Requests\Api;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class OnboardingRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'goal' => ['required', 'string', Rule::in(['maintain', 'lose_weight', 'gain_weight', 'build_muscle'])],
            'gender' => ['required', 'string', Rule::in(['male', 'female', 'other', 'prefer_not_to_say'])],
            'date_of_birth' => ['required', 'date', 'before:today', 'after:1900-01-01'],
            'height_cm' => ['required', 'numeric', 'min:50', 'max:300'],
            'weight_kg' => ['required', 'numeric', 'min:20', 'max:500'],
            'target_weight_kg' => ['required', 'numeric', 'min:20', 'max:500'],
            'activity_level' => ['required', 'string', Rule::in([
                'sedentary', 'lightly_active', 'moderately_active', 'very_active', 'extra_active', 'extremely_active'
            ])],
            'diet_type' => ['required', 'string', Rule::in([
                'everything', 'standard', 'vegetarian', 'vegan', 'pescatarian', 'keto', 'paleo', 'other'
            ])],
            'unit_system' => ['required', 'string', Rule::in(['metric', 'imperial'])],
        ];
    }
}
