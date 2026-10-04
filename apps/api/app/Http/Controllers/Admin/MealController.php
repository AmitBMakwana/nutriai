<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Meal;
use Illuminate\Http\Request;

class MealController extends Controller
{
    /**
     * Read-only meals list.
     */
    public function index(Request $request)
    {
        $query = Meal::query()->with(['user', 'items.food']);

        if ($request->filled('search')) {
            $search = $request->input('search');
            $query->whereHas('user', function ($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                  ->orWhere('email', 'like', "%{$search}%");
            });
        }

        if ($request->filled('meal_type')) {
            $query->where('meal_type', $request->input('meal_type'));
        }

        if ($request->filled('date')) {
            $query->whereDate('meal_date', $request->input('date'));
        }

        $meals = $query->latest('meal_date')->latest('id')->paginate(15)->withQueryString();

        return view('admin.meals.index', compact('meals'));
    }

    /**
     * Read-only meal detail view.
     */
    public function show(int $id)
    {
        $meal = Meal::with(['user', 'items.food', 'aiAnalysis'])->findOrFail($id);

        return view('admin.meals.show', compact('meal'));
    }
}
