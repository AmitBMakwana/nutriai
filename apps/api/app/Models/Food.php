<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Food extends Model
{
    use HasFactory;
    
    protected $table = 'foods';

    protected $fillable = [
        'name', 'brand', 'serving_size', 'serving_unit', 'calories', 
        'protein', 'carbs', 'fat', 'fiber', 'sugar', 'sodium', 
        'is_verified', 'user_id'
    ];

    protected function casts(): array
    {
        return [
            'is_verified' => 'boolean',
        ];
    }

    public function user() { return $this->belongsTo(User::class); }
    public function favorites() { return $this->hasMany(FavoriteFood::class); }
    public function favoriteUsers() { return $this->belongsToMany(User::class, 'favorite_foods'); }
}
