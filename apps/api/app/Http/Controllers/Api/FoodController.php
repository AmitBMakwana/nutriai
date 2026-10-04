<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\FavoriteFood;
use App\Models\Food;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class FoodController extends Controller
{
    use ApiResponse;

    /**
     * GET /api/v1/foods/search?q=
     * Returns verified foods and user's custom foods matching query.
     */
    public function search(Request $request)
    {
        $user = $request->user();
        $query = $request->query('q');

        $foodsQuery = Food::query()
            ->where(function ($q) use ($user) {
                $q->where('is_verified', true)
                  ->orWhere('user_id', $user->id);
            });

        if ($query) {
            $escapedQuery = addcslashes((string) $query, '%_');
            $foodsQuery->where(function ($q) use ($escapedQuery) {
                $q->where('name', 'like', "%{$escapedQuery}%")
                  ->orWhere('brand', 'like', "%{$escapedQuery}%");
            });
        }

        // Attach favorite flag for authenticated user
        $foodsQuery->withExists(['favoriteUsers as is_favorite' => function ($q) use ($user) {
            $q->where('user_id', $user->id);
        }]);

        $foods = $foodsQuery
            ->orderBy('is_verified', 'desc')
            ->orderBy('name', 'asc')
            ->paginate($request->query('per_page', 25));

        return $this->success($foods, 'Foods retrieved successfully');
    }

    /**
     * POST /api/v1/foods/custom
     * Create a user-specific custom food.
     */
    public function storeCustom(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => ['required', 'string', 'max:255'],
            'brand' => ['nullable', 'string', 'max:255'],
            'serving_size' => ['required', 'numeric', 'min:0.1'],
            'serving_unit' => ['required', 'string', 'max:50'],
            'calories' => ['required', 'integer', 'min:0', 'max:10000'],
            'protein' => ['required', 'numeric', 'min:0', 'max:1000'],
            'carbs' => ['required', 'numeric', 'min:0', 'max:1000'],
            'fat' => ['required', 'numeric', 'min:0', 'max:1000'],
            'fiber' => ['nullable', 'numeric', 'min:0', 'max:500'],
            'sugar' => ['nullable', 'numeric', 'min:0', 'max:500'],
            'sodium' => ['nullable', 'numeric', 'min:0', 'max:50000'],
        ]);

        if ($validator->fails()) {
            return $this->error('Validation failed', $validator->errors()->toArray(), 422);
        }

        $data = $validator->validated();
        $data['user_id'] = $request->user()->id;
        $data['is_verified'] = false;

        $food = Food::create($data);
        $food->is_favorite = false;

        return $this->success($food, 'Custom food created successfully', 201);
    }

    /**
     * POST /api/v1/foods/{id}/favorite
     * Toggle favorite status of a food for the authenticated user.
     */
    public function toggleFavorite(Request $request, int $id)
    {
        $user = $request->user();

        // User can only favorite verified foods or their own custom foods
        $food = Food::where(function ($q) use ($user) {
            $q->where('is_verified', true)
              ->orWhere('user_id', $user->id);
        })->find($id);

        if (!$food) {
            return $this->error('Food not found', [], 404);
        }

        $existing = FavoriteFood::where('user_id', $user->id)
            ->where('food_id', $food->id)
            ->first();

        if ($existing) {
            $existing->delete();
            $isFavorite = false;
            $message = 'Food removed from favorites';
        } else {
            FavoriteFood::create([
                'user_id' => $user->id,
                'food_id' => $food->id,
            ]);
            $isFavorite = true;
            $message = 'Food added to favorites';
        }

        return $this->success([
            'food_id' => $food->id,
            'is_favorite' => $isFavorite,
        ], $message);
    }

    /**
     * GET /api/v1/foods/favorites
     * Returns list of user's favorite foods.
     */
    public function favorites(Request $request)
    {
        $user = $request->user();

        $foods = Food::whereHas('favorites', function ($q) use ($user) {
            $q->where('user_id', $user->id);
        })->get()->map(function ($food) {
            $food->is_favorite = true;
            return $food;
        });

        return $this->success($foods, 'Favorite foods retrieved successfully');
    }
}
