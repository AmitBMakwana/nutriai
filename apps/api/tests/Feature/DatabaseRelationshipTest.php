<?php
namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;
use App\Models\User;
use App\Models\UserProfile;
use App\Models\NutritionGoal;
use App\Models\Food;
use App\Models\Meal;
use App\Models\MealItem;
use App\Models\AiAnalysis;
use App\Models\WaterLog;
use App\Models\WeightLog;
use App\Models\DailySummary;
use App\Models\FavoriteFood;
use App\Models\FavoriteMeal;
use App\Models\Subscription;
use App\Enums\Gender;
use App\Enums\ActivityLevel;
use App\Enums\GoalType;
use App\Enums\DietType;
use App\Enums\MealType;
use App\Enums\AiAnalysisStatus;

class DatabaseRelationshipTest extends TestCase
{
    use RefreshDatabase;

    public function test_user_relationships()
    {
        $user = User::create([
            'name' => 'Test User',
            'email' => 'test@example.com',
            'password' => bcrypt('password'),
        ]);

        $profile = UserProfile::create([
            'user_id' => $user->id,
            'gender' => Gender::MALE,
            'activity_level' => ActivityLevel::SEDENTARY,
            'goal' => GoalType::MAINTAIN,
            'diet_type' => DietType::STANDARD,
        ]);

        $this->assertEquals($user->id, $profile->user->id);
        $this->assertNotNull($user->profile);

        $meal = Meal::create([
            'user_id' => $user->id,
            'meal_type' => MealType::LUNCH,
            'meal_date' => now()->toDateString(),
            'meal_time' => now()->toTimeString(),
        ]);

        $this->assertTrue($user->meals->contains($meal));

        $food = Food::create([
            'name' => 'Test Food',
            'is_verified' => true
        ]);

        $mealItem = MealItem::create([
            'meal_id' => $meal->id,
            'food_id' => $food->id,
            'food_name' => 'Test Food',
            'quantity' => 1,
            'unit' => 'piece'
        ]);

        $this->assertTrue($meal->items->contains($mealItem));
        $this->assertEquals($food->id, $mealItem->food->id);

        $aiAnalysis = AiAnalysis::create([
            'user_id' => $user->id,
            'meal_id' => $meal->id,
            'provider' => 'gemini',
            'model' => 'gemini-1.5-pro',
            'image_path' => 'test.jpg',
            'status' => AiAnalysisStatus::COMPLETED,
        ]);

        $this->assertEquals($aiAnalysis->id, $meal->aiAnalysis->id);

        $waterLog = WaterLog::create(['user_id' => $user->id, 'amount_ml' => 250, 'logged_at' => now()]);
        $weightLog = WeightLog::create(['user_id' => $user->id, 'weight_kg' => 70, 'logged_at' => now()]);
        $summary = DailySummary::where('user_id', $user->id)->whereDate('summary_date', now()->toDateString())->first()
            ?? DailySummary::create(['user_id' => $user->id, 'summary_date' => now()->toDateString()]);
        
        $this->assertTrue($user->waterLogs->contains($waterLog));
        $this->assertTrue($user->weightLogs->contains($weightLog));
        $this->assertTrue($user->dailySummaries->contains($summary));
    }
}
