<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Enums\AiAnalysisStatus;

class AiAnalysis extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id', 'meal_id', 'provider', 'model', 'image_path', 
        'status', 'raw_response', 'parsed_response', 'confidence', 
        'processing_time_ms', 'error_message'
    ];

    protected function casts(): array
    {
        return [
            'status' => AiAnalysisStatus::class,
            'raw_response' => 'array',
            'parsed_response' => 'array',
        ];
    }

    public function user() { return $this->belongsTo(User::class); }
    public function meal() { return $this->belongsTo(Meal::class); }
}
