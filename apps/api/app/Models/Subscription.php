<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Enums\SubscriptionStatus;

class Subscription extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id', 'provider', 'provider_customer_id', 
        'provider_subscription_id', 'plan', 'status', 
        'starts_at', 'ends_at'
    ];

    protected function casts(): array
    {
        return [
            'status' => SubscriptionStatus::class,
            'starts_at' => 'datetime',
            'ends_at' => 'datetime',
        ];
    }

    public function user() { return $this->belongsTo(User::class); }
}
