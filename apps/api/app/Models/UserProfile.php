<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Enums\Gender;
use App\Enums\ActivityLevel;
use App\Enums\GoalType;
use App\Enums\DietType;

class UserProfile extends Model
{
    use HasFactory;
    
    protected $fillable = [
        'user_id', 'gender', 'date_of_birth', 'height_cm', 'weight_kg', 
        'target_weight_kg', 'activity_level', 'goal', 'diet_type', 'unit_system',
        'is_completed'
    ];
    
    protected function casts(): array
    {
        return [
            'date_of_birth' => 'date',
            'gender' => Gender::class,
            'activity_level' => ActivityLevel::class,
            'goal' => GoalType::class,
            'diet_type' => DietType::class,
            'is_completed' => 'boolean',
        ];
    }

    public function user() { return $this->belongsTo(User::class); }
}
