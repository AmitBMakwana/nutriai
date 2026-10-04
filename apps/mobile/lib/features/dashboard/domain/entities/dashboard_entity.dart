/// Domain entities representing the daily dashboard overview.
class CalorieSummaryEntity {
  final int target;
  final int consumed;
  final int remaining;
  final double percentage;

  const CalorieSummaryEntity({
    required this.target,
    required this.consumed,
    required this.remaining,
    required this.percentage,
  });

  bool get isOverTarget => consumed > target;
  int get overTargetAmount => isOverTarget ? (consumed - target) : 0;
  double get progressFraction => target > 0 ? (consumed / target).clamp(0.0, 1.0) : 0.0;
}

class MacroNutrientEntity {
  final double target;
  final double consumed;
  final double remaining;
  final double percentage;

  const MacroNutrientEntity({
    required this.target,
    required this.consumed,
    required this.remaining,
    required this.percentage,
  });

  double get progressFraction => target > 0 ? (consumed / target).clamp(0.0, 1.0) : 0.0;
  bool get isCompleted => consumed >= target;
}

class MacrosSummaryEntity {
  final MacroNutrientEntity protein;
  final MacroNutrientEntity carbs;
  final MacroNutrientEntity fat;

  const MacrosSummaryEntity({
    required this.protein,
    required this.carbs,
    required this.fat,
  });
}

class WaterSummaryEntity {
  final int target;
  final int consumed;
  final int remaining;
  final double percentage;

  const WaterSummaryEntity({
    required this.target,
    required this.consumed,
    required this.remaining,
    required this.percentage,
  });

  int get glassesConsumed => (consumed / 250).floor();
  int get glassesTarget => (target / 250).round();
  double get progressFraction => target > 0 ? (consumed / target).clamp(0.0, 1.0) : 0.0;
}

class MealItemSummaryEntity {
  final int? id;
  final String foodName;
  final double quantity;
  final String unit;
  final int calories;

  const MealItemSummaryEntity({
    this.id,
    required this.foodName,
    required this.quantity,
    required this.unit,
    required this.calories,
  });
}

class MealEntryEntity {
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
  final List<MealItemSummaryEntity> items;

  const MealEntryEntity({
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
}

class MealGroupEntity {
  final String type;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final List<MealEntryEntity> meals;

  const MealGroupEntity({
    required this.type,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.meals = const [],
  });

  bool get isEmpty => meals.isEmpty;
  String get displayName {
    switch (type.toLowerCase()) {
      case 'breakfast':
        return 'Breakfast';
      case 'lunch':
        return 'Lunch';
      case 'dinner':
        return 'Dinner';
      case 'snack':
        return 'Snack';
      default:
        return type.substring(0, 1).toUpperCase() + type.substring(1);
    }
  }
}

class DashboardEntity {
  final String date;
  final CalorieSummaryEntity calories;
  final MacrosSummaryEntity macros;
  final WaterSummaryEntity water;
  final Map<String, MealGroupEntity> meals;

  const DashboardEntity({
    required this.date,
    required this.calories,
    required this.macros,
    required this.water,
    required this.meals,
  });

  MealGroupEntity? get breakfast => meals['breakfast'];
  MealGroupEntity? get lunch => meals['lunch'];
  MealGroupEntity? get dinner => meals['dinner'];
  MealGroupEntity? get snack => meals['snack'];
}
