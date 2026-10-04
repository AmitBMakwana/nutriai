<?php
namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Food;

class FoodSeeder extends Seeder
{
    public function run(): void
    {
        $foods = [
            // Indian Foods
            ['name' => 'Roti', 'serving_size' => 1, 'serving_unit' => 'piece', 'calories' => 104, 'protein' => 3, 'carbs' => 22, 'fat' => 0.5, 'fiber' => 3.3],
            ['name' => 'Dal Tadka', 'serving_size' => 1, 'serving_unit' => 'cup', 'calories' => 200, 'protein' => 10, 'carbs' => 30, 'fat' => 5, 'fiber' => 8],
            ['name' => 'White Rice', 'serving_size' => 1, 'serving_unit' => 'cup', 'calories' => 205, 'protein' => 4, 'carbs' => 45, 'fat' => 0.4, 'fiber' => 0.6],
            ['name' => 'Paneer Tikka', 'serving_size' => 100, 'serving_unit' => 'g', 'calories' => 260, 'protein' => 14, 'carbs' => 6, 'fat' => 20, 'fiber' => 1],
            ['name' => 'Mixed Sabzi', 'serving_size' => 1, 'serving_unit' => 'cup', 'calories' => 150, 'protein' => 4, 'carbs' => 20, 'fat' => 7, 'fiber' => 5],
            ['name' => 'Chicken Biryani', 'serving_size' => 1, 'serving_unit' => 'plate', 'calories' => 450, 'protein' => 22, 'carbs' => 55, 'fat' => 15, 'fiber' => 3],
            ['name' => 'Idli', 'serving_size' => 1, 'serving_unit' => 'piece', 'calories' => 39, 'protein' => 1.5, 'carbs' => 8, 'fat' => 0.1, 'fiber' => 0.5],
            ['name' => 'Masala Dosa', 'serving_size' => 1, 'serving_unit' => 'piece', 'calories' => 415, 'protein' => 8, 'carbs' => 65, 'fat' => 15, 'fiber' => 4],
            ['name' => 'Poha', 'serving_size' => 1, 'serving_unit' => 'cup', 'calories' => 250, 'protein' => 4, 'carbs' => 45, 'fat' => 6, 'fiber' => 2],
            ['name' => 'Chole Bhature', 'serving_size' => 1, 'serving_unit' => 'plate', 'calories' => 550, 'protein' => 12, 'carbs' => 70, 'fat' => 25, 'fiber' => 8],
            ['name' => 'Aloo Paratha', 'serving_size' => 1, 'serving_unit' => 'piece', 'calories' => 280, 'protein' => 5, 'carbs' => 40, 'fat' => 10, 'fiber' => 3],
            ['name' => 'Palak Paneer', 'serving_size' => 1, 'serving_unit' => 'cup', 'calories' => 280, 'protein' => 12, 'carbs' => 10, 'fat' => 22, 'fiber' => 4],
            ['name' => 'Butter Chicken', 'serving_size' => 1, 'serving_unit' => 'cup', 'calories' => 400, 'protein' => 20, 'carbs' => 12, 'fat' => 30, 'fiber' => 2],
            ['name' => 'Rajma Chawal', 'serving_size' => 1, 'serving_unit' => 'plate', 'calories' => 350, 'protein' => 12, 'carbs' => 60, 'fat' => 8, 'fiber' => 10],
            ['name' => 'Samosa', 'serving_size' => 1, 'serving_unit' => 'piece', 'calories' => 260, 'protein' => 3, 'carbs' => 28, 'fat' => 15, 'fiber' => 2],
            // Generic/Western Foods
            ['name' => 'Apple', 'serving_size' => 1, 'serving_unit' => 'medium', 'calories' => 95, 'protein' => 0.5, 'carbs' => 25, 'fat' => 0.3, 'fiber' => 4.4],
            ['name' => 'Banana', 'serving_size' => 1, 'serving_unit' => 'medium', 'calories' => 105, 'protein' => 1.3, 'carbs' => 27, 'fat' => 0.3, 'fiber' => 3.1],
            ['name' => 'Chicken Breast', 'serving_size' => 100, 'serving_unit' => 'g', 'calories' => 165, 'protein' => 31, 'carbs' => 0, 'fat' => 3.6, 'fiber' => 0],
            ['name' => 'Boiled Egg', 'serving_size' => 1, 'serving_unit' => 'large', 'calories' => 78, 'protein' => 6.3, 'carbs' => 0.6, 'fat' => 5.3, 'fiber' => 0],
            ['name' => 'Oatmeal', 'serving_size' => 1, 'serving_unit' => 'cup', 'calories' => 158, 'protein' => 6, 'carbs' => 27, 'fat' => 3.2, 'fiber' => 4],
            ['name' => 'Greek Yogurt', 'serving_size' => 150, 'serving_unit' => 'g', 'calories' => 90, 'protein' => 15, 'carbs' => 6, 'fat' => 0, 'fiber' => 0],
            ['name' => 'Broccoli', 'serving_size' => 1, 'serving_unit' => 'cup', 'calories' => 55, 'protein' => 3.7, 'carbs' => 11.2, 'fat' => 0.6, 'fiber' => 5.1],
            ['name' => 'Almonds', 'serving_size' => 30, 'serving_unit' => 'g', 'calories' => 164, 'protein' => 6, 'carbs' => 6, 'fat' => 14, 'fiber' => 3.5],
            ['name' => 'Salmon', 'serving_size' => 100, 'serving_unit' => 'g', 'calories' => 208, 'protein' => 20, 'carbs' => 0, 'fat' => 13, 'fiber' => 0],
            ['name' => 'Avocado', 'serving_size' => 1, 'serving_unit' => 'medium', 'calories' => 234, 'protein' => 2.9, 'carbs' => 12, 'fat' => 21, 'fiber' => 9.2],
        ];

        foreach ($foods as $f) {
            Food::create(array_merge($f, ['is_verified' => true]));
        }
    }
}
