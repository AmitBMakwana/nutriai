<?php
namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use App\Models\UserProfile;
use App\Enums\Gender;
use App\Enums\ActivityLevel;
use App\Enums\GoalType;
use App\Enums\DietType;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        $this->call(FoodSeeder::class);
        $this->call(AdminRoleSeeder::class);

        $user = User::factory()->create([
            'name' => 'Amit',
            'email' => 'amit@example.com',
            'password' => bcrypt('password123'),
        ]);

        UserProfile::create([
            'user_id' => $user->id,
            'gender' => Gender::MALE->value,
            'date_of_birth' => '1990-01-01',
            'height_cm' => 175,
            'weight_kg' => 75.0,
            'target_weight_kg' => 70.0,
            'activity_level' => ActivityLevel::MODERATELY_ACTIVE->value,
            'goal' => GoalType::LOSE_WEIGHT->value,
            'diet_type' => DietType::STANDARD->value,
        ]);
    }
}
