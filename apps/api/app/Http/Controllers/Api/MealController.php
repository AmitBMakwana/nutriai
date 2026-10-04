<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\AiAnalysis;
use App\Models\Meal;
use App\Models\MealItem;
use App\Services\Meal\MealCalculationService;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class MealController extends Controller
{
    use ApiResponse;

    public function __construct(
        protected MealCalculationService $mealCalculationService
    ) {}

    /**
     * GET /api/v1/meals?date=YYYY-MM-DD
     */
    public function index(Request $request)
    {
        $user = $request->user();
        $date = $request->query('date');

        $query = Meal::with('items')
            ->where('user_id', $user->id);

        if ($date) {
            $query->whereDate('meal_date', $date);
        }

        $meals = $query->orderBy('meal_date', 'desc')
            ->orderBy('meal_time', 'asc')
            ->get();

        return $this->success($meals, 'Meals retrieved successfully');
    }

    /**
     * POST /api/v1/meals
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'meal_type' => ['required', 'string', 'in:breakfast,lunch,dinner,snack'],
            'meal_date' => ['required', 'date_format:Y-m-d'],
            'meal_time' => ['nullable', 'string'],
            'source' => ['nullable', 'string', 'in:manual,ai,search'],
            'image_path' => ['nullable', 'string'],
            'analysis_id' => ['nullable', 'integer', 'exists:ai_analyses,id'],
            'items' => ['required', 'array', 'min:1'],
            'items.*.food_id' => ['nullable', 'exists:foods,id'],
            'items.*.food_name' => ['required', 'string', 'max:255'],
            'items.*.quantity' => ['required', 'numeric', 'min:0.01'],
            'items.*.unit' => ['required', 'string', 'max:50'],
            'items.*.calories' => ['nullable', 'numeric', 'min:0'],
            'items.*.protein' => ['nullable', 'numeric', 'min:0'],
            'items.*.carbs' => ['nullable', 'numeric', 'min:0'],
            'items.*.fat' => ['nullable', 'numeric', 'min:0'],
            'items.*.fiber' => ['nullable', 'numeric', 'min:0'],
        ]);

        if ($validator->fails()) {
            return $this->error('Validation failed', $validator->errors()->toArray(), 422);
        }

        $data = $validator->validated();

        // Calculate totals server-side (never trust client)
        $calculation = $this->mealCalculationService->calculate($data['items']);
        $totals = $calculation['totals'];
        $computedItems = $calculation['items'];

        $meal = DB::transaction(function () use ($request, $data, $totals, $computedItems) {
            $meal = Meal::create([
                'user_id' => $request->user()->id,
                'meal_type' => $data['meal_type'],
                'meal_date' => $data['meal_date'],
                'meal_time' => $data['meal_time'] ?? now()->format('H:i:s'),
                'source' => $data['source'] ?? 'manual',
                'image_path' => $data['image_path'] ?? null,
                'total_calories' => $totals['total_calories'],
                'total_protein' => $totals['total_protein'],
                'total_carbs' => $totals['total_carbs'],
                'total_fat' => $totals['total_fat'],
                'total_fiber' => $totals['total_fiber'],
            ]);

            foreach ($computedItems as $item) {
                $item['meal_id'] = $meal->id;
                MealItem::create($item);
            }

            if (!empty($data['analysis_id'])) {
                AiAnalysis::where('id', $data['analysis_id'])
                    ->where('user_id', $request->user()->id)
                    ->update(['meal_id' => $meal->id]);
            }

            return $meal->load('items');
        });

        return $this->success($meal, 'Meal created successfully', 201);
    }

    /**
     * GET /api/v1/meals/{id}
     */
    public function show(Request $request, int $id)
    {
        $meal = Meal::with('items')->find($id);

        if (!$meal) {
            return $this->error('Meal not found', [], 404);
        }

        if ($request->user()->cannot('view', $meal)) {
            return $this->error('You are not authorized to view this meal', [], 403);
        }

        return $this->success($meal, 'Meal retrieved successfully');
    }

    /**
     * PUT /api/v1/meals/{id}
     */
    public function update(Request $request, int $id)
    {
        $meal = Meal::find($id);

        if (!$meal) {
            return $this->error('Meal not found', [], 404);
        }

        if ($request->user()->cannot('update', $meal)) {
            return $this->error('You are not authorized to update this meal', [], 403);
        }

        $validator = Validator::make($request->all(), [
            'meal_type' => ['sometimes', 'string', 'in:breakfast,lunch,dinner,snack'],
            'meal_date' => ['sometimes', 'date_format:Y-m-d'],
            'meal_time' => ['nullable', 'string'],
            'items' => ['sometimes', 'array', 'min:1'],
            'items.*.food_id' => ['nullable', 'exists:foods,id'],
            'items.*.food_name' => ['required_with:items', 'string', 'max:255'],
            'items.*.quantity' => ['required_with:items', 'numeric', 'min:0.01'],
            'items.*.unit' => ['required_with:items', 'string', 'max:50'],
        ]);

        if ($validator->fails()) {
            return $this->error('Validation failed', $validator->errors()->toArray(), 422);
        }

        $data = $validator->validated();

        $meal = DB::transaction(function () use ($meal, $data) {
            if (isset($data['items'])) {
                $calculation = $this->mealCalculationService->calculate($data['items']);
                $totals = $calculation['totals'];
                $computedItems = $calculation['items'];

                $meal->update([
                    'total_calories' => $totals['total_calories'],
                    'total_protein' => $totals['total_protein'],
                    'total_carbs' => $totals['total_carbs'],
                    'total_fat' => $totals['total_fat'],
                    'total_fiber' => $totals['total_fiber'],
                ]);

                // Replace items
                $meal->items()->delete();
                foreach ($computedItems as $item) {
                    $item['meal_id'] = $meal->id;
                    MealItem::create($item);
                }
            }

            if (isset($data['meal_type'])) {
                $meal->meal_type = $data['meal_type'];
            }
            if (isset($data['meal_date'])) {
                $meal->meal_date = $data['meal_date'];
            }
            if (isset($data['meal_time'])) {
                $meal->meal_time = $data['meal_time'];
            }

            $meal->save();

            return $meal->load('items');
        });

        return $this->success($meal, 'Meal updated successfully');
    }

    /**
     * DELETE /api/v1/meals/{id}
     */
    public function destroy(Request $request, int $id)
    {
        $meal = Meal::find($id);

        if (!$meal) {
            return $this->error('Meal not found', [], 404);
        }

        if ($request->user()->cannot('delete', $meal)) {
            return $this->error('You are not authorized to delete this meal', [], 403);
        }

        $meal->delete();

        return $this->success([], 'Meal deleted successfully');
    }
}
