import '../../domain/entities/dashboard_entity.dart';

class CalorieSummaryDto {
  final int target;
  final int consumed;
  final int remaining;
  final double percentage;

  const CalorieSummaryDto({
    required this.target,
    required this.consumed,
    required this.remaining,
    required this.percentage,
  });

  factory CalorieSummaryDto.fromJson(Map<String, dynamic> json) {
    return CalorieSummaryDto(
      target: (json['target'] as num?)?.toInt() ?? 2000,
      consumed: (json['consumed'] as num?)?.toInt() ?? 0,
      remaining: (json['remaining'] as num?)?.toInt() ?? 2000,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
    );
  }

  CalorieSummaryEntity toDomain() {
    return CalorieSummaryEntity(
      target: target,
      consumed: consumed,
      remaining: remaining,
      percentage: percentage,
    );
  }
}

class MacroNutrientDto {
  final double target;
  final double consumed;
  final double remaining;
  final double percentage;

  const MacroNutrientDto({
    required this.target,
    required this.consumed,
    required this.remaining,
    required this.percentage,
  });

  factory MacroNutrientDto.fromJson(Map<String, dynamic> json) {
    return MacroNutrientDto(
      target: (json['target'] as num?)?.toDouble() ?? 0.0,
      consumed: (json['consumed'] as num?)?.toDouble() ?? 0.0,
      remaining: (json['remaining'] as num?)?.toDouble() ?? 0.0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
    );
  }

  MacroNutrientEntity toDomain() {
    return MacroNutrientEntity(
      target: target,
      consumed: consumed,
      remaining: remaining,
      percentage: percentage,
    );
  }
}

class MacrosSummaryDto {
  final MacroNutrientDto protein;
  final MacroNutrientDto carbs;
  final MacroNutrientDto fat;

  const MacrosSummaryDto({
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  factory MacrosSummaryDto.fromJson(Map<String, dynamic> json) {
    return MacrosSummaryDto(
      protein: MacroNutrientDto.fromJson(json['protein'] as Map<String, dynamic>? ?? {}),
      carbs: MacroNutrientDto.fromJson(json['carbs'] as Map<String, dynamic>? ?? {}),
      fat: MacroNutrientDto.fromJson(json['fat'] as Map<String, dynamic>? ?? {}),
    );
  }

  MacrosSummaryEntity toDomain() {
    return MacrosSummaryEntity(
      protein: protein.toDomain(),
      carbs: carbs.toDomain(),
      fat: fat.toDomain(),
    );
  }
}

class WaterSummaryDto {
  final int target;
  final int consumed;
  final int remaining;
  final double percentage;

  const WaterSummaryDto({
    required this.target,
    required this.consumed,
    required this.remaining,
    required this.percentage,
  });

  factory WaterSummaryDto.fromJson(Map<String, dynamic> json) {
    return WaterSummaryDto(
      target: (json['target'] as num?)?.toInt() ?? 2500,
      consumed: (json['consumed'] as num?)?.toInt() ?? 0,
      remaining: (json['remaining'] as num?)?.toInt() ?? 2500,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
    );
  }

  WaterSummaryEntity toDomain() {
    return WaterSummaryEntity(
      target: target,
      consumed: consumed,
      remaining: remaining,
      percentage: percentage,
    );
  }
}

class MealItemSummaryDto {
  final int? id;
  final String foodName;
  final double quantity;
  final String unit;
  final int calories;

  const MealItemSummaryDto({
    this.id,
    required this.foodName,
    required this.quantity,
    required this.unit,
    required this.calories,
  });

  factory MealItemSummaryDto.fromJson(Map<String, dynamic> json) {
    return MealItemSummaryDto(
      id: json['id'] as int?,
      foodName: json['food_name'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toDouble() ?? 1.0,
      unit: json['unit'] as String? ?? 'serving',
      calories: (json['calories'] as num?)?.toInt() ?? 0,
    );
  }

  MealItemSummaryEntity toDomain() {
    return MealItemSummaryEntity(
      id: id,
      foodName: foodName,
      quantity: quantity,
      unit: unit,
      calories: calories,
    );
  }
}

class MealEntryDto {
  final int id;
  final String mealType;
  final String mealDate;
  final String mealTime;
  final int totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFat;
  final String? source;
  final String? imagePath;
  final List<MealItemSummaryDto> items;

  const MealEntryDto({
    required this.id,
    required this.mealType,
    required this.mealDate,
    required this.mealTime,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
    this.source,
    this.imagePath,
    this.items = const [],
  });

  factory MealEntryDto.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? [];
    return MealEntryDto(
      id: (json['id'] as num?)?.toInt() ?? 0,
      mealType: json['meal_type'] as String? ?? 'breakfast',
      mealDate: json['meal_date'] as String? ?? '',
      mealTime: json['meal_time'] as String? ?? '',
      totalCalories: (json['total_calories'] as num?)?.toInt() ?? 0,
      totalProtein: (json['total_protein'] as num?)?.toDouble() ?? 0.0,
      totalCarbs: (json['total_carbs'] as num?)?.toDouble() ?? 0.0,
      totalFat: (json['total_fat'] as num?)?.toDouble() ?? 0.0,
      source: json['source'] as String?,
      imagePath: json['image_path'] as String?,
      items: rawItems
          .map((i) => MealItemSummaryDto.fromJson(i as Map<String, dynamic>))
          .toList(),
    );
  }

  MealEntryEntity toDomain() {
    return MealEntryEntity(
      id: id,
      mealType: mealType,
      mealDate: mealDate,
      mealTime: mealTime,
      totalCalories: totalCalories,
      totalProtein: totalProtein,
      totalCarbs: totalCarbs,
      totalFat: totalFat,
      source: source,
      imagePath: imagePath,
      items: items.map((i) => i.toDomain()).toList(),
    );
  }
}

class MealGroupDto {
  final String type;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final List<MealEntryDto> meals;

  const MealGroupDto({
    required this.type,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.meals = const [],
  });

  factory MealGroupDto.fromJson(Map<String, dynamic> json) {
    final rawMeals = json['meals'] as List<dynamic>? ?? [];
    return MealGroupDto(
      type: json['type'] as String? ?? '',
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      protein: (json['protein'] as num?)?.toDouble() ?? 0.0,
      carbs: (json['carbs'] as num?)?.toDouble() ?? 0.0,
      fat: (json['fat'] as num?)?.toDouble() ?? 0.0,
      meals: rawMeals
          .map((m) => MealEntryDto.fromJson(m as Map<String, dynamic>))
          .toList(),
    );
  }

  MealGroupEntity toDomain() {
    return MealGroupEntity(
      type: type,
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
      meals: meals.map((m) => m.toDomain()).toList(),
    );
  }
}

class DashboardDto {
  final String date;
  final CalorieSummaryDto calories;
  final MacrosSummaryDto macros;
  final WaterSummaryDto water;
  final Map<String, MealGroupDto> meals;

  const DashboardDto({
    required this.date,
    required this.calories,
    required this.macros,
    required this.water,
    required this.meals,
  });

  factory DashboardDto.fromJson(Map<String, dynamic> json) {
    final rawMeals = json['meals'] as Map<String, dynamic>? ?? {};
    final mappedMeals = <String, MealGroupDto>{};
    rawMeals.forEach((key, val) {
      if (val is Map<String, dynamic>) {
        mappedMeals[key] = MealGroupDto.fromJson(val);
      }
    });

    return DashboardDto(
      date: json['date'] as String? ?? '',
      calories: CalorieSummaryDto.fromJson(json['calories'] as Map<String, dynamic>? ?? {}),
      macros: MacrosSummaryDto.fromJson(json['macros'] as Map<String, dynamic>? ?? {}),
      water: WaterSummaryDto.fromJson(json['water'] as Map<String, dynamic>? ?? {}),
      meals: mappedMeals,
    );
  }

  DashboardEntity toDomain() {
    return DashboardEntity(
      date: date,
      calories: calories.toDomain(),
      macros: macros.toDomain(),
      water: water.toDomain(),
      meals: meals.map((k, v) => MapEntry(k, v.toDomain())),
    );
  }
}
