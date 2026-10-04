<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class MealItem extends Model
{
    use HasFactory;

    protected $fillable = [
        'meal_id', 'food_id', 'food_name', 'quantity', 'unit', 
        'calories', 'protein', 'carbs', 'fat', 'fiber', 'confidence'
    ];

    public function meal() { return $this->belongsTo(Meal::class); }
    public function food() { return $this->belongsTo(Food::class); }
}
