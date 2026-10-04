<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Enums\MealType;

class Meal extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id', 'meal_type', 'meal_date', 'meal_time', 'image_path', 
        'total_calories', 'total_protein', 'total_carbs', 'total_fat', 
        'total_fiber', 'source'
    ];

    protected function casts(): array
    {
        return [
            'meal_date' => 'date',
            'meal_type' => MealType::class,
        ];
    }

    public function user() { return $this->belongsTo(User::class); }
    public function items() { return $this->hasMany(MealItem::class); }
    public function aiAnalysis() { return $this->hasOne(AiAnalysis::class); }
}
