<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class NutritionGoal extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id', 'daily_calories', 'protein_grams', 'carbs_grams', 
        'fat_grams', 'water_ml', 'effective_from'
    ];

    protected function casts(): array
    {
        return [
            'effective_from' => 'date',
        ];
    }

    public function user() { return $this->belongsTo(User::class); }
}
