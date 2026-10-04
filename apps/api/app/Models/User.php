<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use Spatie\Permission\Traits\HasRoles;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable, HasRoles;

    protected $fillable = [
        'name', 'email', 'password', 'avatar', 'timezone', 'is_disabled'
    ];

    protected $hidden = [
        'password', 'remember_token',
    ];

    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
            'is_disabled' => 'boolean',
        ];
    }

    public function profile() { return $this->hasOne(UserProfile::class); }
    public function isOnboardingCompleted(): bool { return (bool) ($this->profile?->is_completed ?? false); }
    public function nutritionGoals() { return $this->hasMany(NutritionGoal::class); }
    public function meals() { return $this->hasMany(Meal::class); }
    public function aiAnalyses() { return $this->hasMany(AiAnalysis::class); }
    public function waterLogs() { return $this->hasMany(WaterLog::class); }
    public function weightLogs() { return $this->hasMany(WeightLog::class); }
    public function dailySummaries() { return $this->hasMany(DailySummary::class); }
    public function favoriteFoods() { return $this->hasMany(FavoriteFood::class); }
    public function favoriteMeals() { return $this->hasMany(FavoriteMeal::class); }
    public function subscriptions() { return $this->hasMany(Subscription::class); }

    public function isPro(): bool
    {
        return app(\App\Services\Subscription\EntitlementService::class)->isPro($this);
    }

    public function getMonthlyScanCount(): int
    {
        return app(\App\Services\Subscription\EntitlementService::class)->getUsedScansThisMonth($this);
    }

    public function getMonthlyScanQuota(): int
    {
        return app(\App\Services\Subscription\EntitlementService::class)->getMonthlyScanQuota($this);
    }
}
