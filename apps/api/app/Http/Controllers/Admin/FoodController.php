<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\AuditLog;
use App\Models\Food;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class FoodController extends Controller
{
    public function index(Request $request)
    {
        $query = Food::query()->with('user');

        if ($request->filled('search')) {
            $search = $request->input('search');
            $query->where('name', 'like', "%{$search}%")
                  ->orWhere('brand', 'like', "%{$search}%");
        }

        if ($request->filled('filter')) {
            if ($request->input('filter') === 'unverified') {
                $query->where('is_verified', false)->whereNotNull('user_id');
            } elseif ($request->input('filter') === 'verified') {
                $query->where('is_verified', true);
            }
        }

        $foods = $query->latest('id')->paginate(15)->withQueryString();

        return view('admin.foods.index', compact('foods'));
    }

    public function create()
    {
        return view('admin.foods.create');
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'brand' => ['nullable', 'string', 'max:255'],
            'serving_size' => ['required', 'numeric', 'min:0'],
            'serving_unit' => ['required', 'string', 'max:50'],
            'calories' => ['required', 'integer', 'min:0'],
            'protein' => ['required', 'numeric', 'min:0'],
            'carbs' => ['required', 'numeric', 'min:0'],
            'fat' => ['required', 'numeric', 'min:0'],
            'fiber' => ['nullable', 'numeric', 'min:0'],
            'sugar' => ['nullable', 'numeric', 'min:0'],
            'sodium' => ['nullable', 'numeric', 'min:0'],
            'is_verified' => ['nullable', 'boolean'],
        ]);

        $validated['is_verified'] = $request->boolean('is_verified', true);
        $validated['user_id'] = null; // Admin created is standard database food

        $food = Food::create($validated);

        AuditLog::record(
            Auth::id(),
            'create_food',
            'Food',
            $food->id,
            ['name' => $food->name, 'calories' => $food->calories]
        );

        return redirect()->route('admin.foods.index')->with('success', "Food item '{$food->name}' created successfully.");
    }

    public function edit(int $id)
    {
        $food = Food::findOrFail($id);
        return view('admin.foods.edit', compact('food'));
    }

    public function update(Request $request, int $id)
    {
        $food = Food::findOrFail($id);

        $validated = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'brand' => ['nullable', 'string', 'max:255'],
            'serving_size' => ['required', 'numeric', 'min:0'],
            'serving_unit' => ['required', 'string', 'max:50'],
            'calories' => ['required', 'integer', 'min:0'],
            'protein' => ['required', 'numeric', 'min:0'],
            'carbs' => ['required', 'numeric', 'min:0'],
            'fat' => ['required', 'numeric', 'min:0'],
            'fiber' => ['nullable', 'numeric', 'min:0'],
            'sugar' => ['nullable', 'numeric', 'min:0'],
            'sodium' => ['nullable', 'numeric', 'min:0'],
            'is_verified' => ['nullable', 'boolean'],
        ]);

        $validated['is_verified'] = $request->boolean('is_verified', $food->is_verified);
        $oldName = $food->name;
        $food->update($validated);

        AuditLog::record(
            Auth::id(),
            'update_food',
            'Food',
            $food->id,
            ['name' => $food->name, 'calories' => $food->calories]
        );

        return redirect()->route('admin.foods.index')->with('success', "Food item '{$food->name}' updated successfully.");
    }

    public function destroy(int $id)
    {
        $food = Food::findOrFail($id);
        $name = $food->name;
        $food->delete();

        AuditLog::record(
            Auth::id(),
            'delete_food',
            'Food',
            $id,
            ['deleted_name' => $name]
        );

        return redirect()->route('admin.foods.index')->with('success', "Food item '{$name}' deleted.");
    }

    public function verify(int $id)
    {
        $food = Food::findOrFail($id);
        $food->is_verified = true;
        $food->save();

        AuditLog::record(
            Auth::id(),
            'verify_food',
            'Food',
            $food->id,
            ['name' => $food->name]
        );

        return back()->with('success', "Food item '{$food->name}' has been verified and added to public database.");
    }

    public function importCsv(Request $request)
    {
        $request->validate([
            'csv_file' => ['required_without:file', 'nullable', 'file', 'mimes:csv,txt', 'max:10240'],
            'file' => ['required_without:csv_file', 'nullable', 'file', 'mimes:csv,txt', 'max:10240'],
        ]);

        $file = $request->file('csv_file') ?? $request->file('file');
        $handle = fopen($file->getRealPath(), 'r');

        if (!$handle) {
            return back()->withErrors(['csv_file' => 'Could not read uploaded CSV file.']);
        }

        $header = fgetcsv($handle);
        if (!$header) {
            fclose($handle);
            return back()->withErrors(['csv_file' => 'CSV file is empty.']);
        }

        // Normalize header row to lowercase trimmed strings
        $normalizedHeader = array_map(fn($col) => strtolower(trim((string) $col)), $header);

        $nameIdx = array_search('name', $normalizedHeader);
        $caloriesIdx = array_search('calories', $normalizedHeader);
        $proteinIdx = array_search('protein', $normalizedHeader);
        $carbsIdx = array_search('carbs', $normalizedHeader);
        $fatIdx = array_search('fat', $normalizedHeader);
        $servingSizeIdx = array_search('serving_size', $normalizedHeader);
        $servingUnitIdx = array_search('serving_unit', $normalizedHeader);

        if ($nameIdx === false || $caloriesIdx === false) {
            fclose($handle);
            return back()->withErrors(['csv_file' => 'CSV must contain at least "name" and "calories" columns.']);
        }

        $importedCount = 0;

        while (($row = fgetcsv($handle)) !== false) {
            if (empty($row[$nameIdx])) {
                continue;
            }

            Food::create([
                'name' => trim((string) $row[$nameIdx]),
                'brand' => isset($row[array_search('brand', $normalizedHeader)]) ? trim((string) $row[array_search('brand', $normalizedHeader)]) : null,
                'serving_size' => $servingSizeIdx !== false && isset($row[$servingSizeIdx]) ? (float) $row[$servingSizeIdx] : 100.0,
                'serving_unit' => $servingUnitIdx !== false && isset($row[$servingUnitIdx]) ? trim((string) $row[$servingUnitIdx]) : 'g',
                'calories' => (int) ($row[$caloriesIdx] ?? 0),
                'protein' => $proteinIdx !== false && isset($row[$proteinIdx]) ? (float) $row[$proteinIdx] : 0.0,
                'carbs' => $carbsIdx !== false && isset($row[$carbsIdx]) ? (float) $row[$carbsIdx] : 0.0,
                'fat' => $fatIdx !== false && isset($row[$fatIdx]) ? (float) $row[$fatIdx] : 0.0,
                'fiber' => 0.0,
                'is_verified' => true,
                'user_id' => null,
            ]);

            $importedCount++;
        }

        fclose($handle);

        AuditLog::record(
            Auth::id(),
            'import_foods',
            'Food',
            null,
            ['count' => $importedCount, 'filename' => $file->getClientOriginalName()]
        );

        return redirect()->route('admin.foods.index')->with('success', "Successfully imported {$importedCount} food items from CSV.");
    }
}
