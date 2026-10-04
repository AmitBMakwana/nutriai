<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class DailySummary extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id', 'summary_date', 'calories', 'protein', 
        'carbs', 'fat', 'fiber', 'water_ml'
    ];

    protected function casts(): array
    {
        return [
            'summary_date' => 'date',
        ];
    }

    public function user() { return $this->belongsTo(User::class); }
}
