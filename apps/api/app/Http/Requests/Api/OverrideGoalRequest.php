<?php

namespace App\Http\Requests\Api;

use Illuminate\Foundation\Http\FormRequest;

class OverrideGoalRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'daily_calories' => ['required', 'integer', 'min:800', 'max:10000'],
            'protein_grams' => ['required', 'integer', 'min:10', 'max:1000'],
            'carbs_grams' => ['required', 'integer', 'min:0', 'max:1500'],
            'fat_grams' => ['required', 'integer', 'min:10', 'max:1000'],
            'water_ml' => ['required', 'integer', 'min:500', 'max:10000'],
            'effective_from' => ['sometimes', 'date'],
        ];
    }
}
