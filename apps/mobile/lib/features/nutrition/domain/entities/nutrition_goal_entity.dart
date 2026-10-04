/// Domain entity representing a user's daily nutrition and hydration goals.
class NutritionGoalEntity {
  final int? id;
  final int? userId;
  final int dailyCalories;
  final int proteinGrams;
  final int carbsGrams;
  final int fatGrams;
  final int waterMl;
  final DateTime? effectiveFrom;

  const NutritionGoalEntity({
    this.id,
    this.userId,
    required this.dailyCalories,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatGrams,
    required this.waterMl,
    this.effectiveFrom,
  });

  int get proteinCalories => proteinGrams * 4;
  int get carbsCalories => carbsGrams * 4;
  int get fatCalories => fatGrams * 9;
  int get totalMacroCalories => proteinCalories + carbsCalories + fatCalories;

  double get proteinPercentage =>
      totalMacroCalories > 0 ? (proteinCalories / totalMacroCalories) * 100 : 30.0;
  double get carbsPercentage =>
      totalMacroCalories > 0 ? (carbsCalories / totalMacroCalories) * 100 : 40.0;
  double get fatPercentage =>
      totalMacroCalories > 0 ? (fatCalories / totalMacroCalories) * 100 : 30.0;

  int get waterGlasses => (waterMl / 250).round();
  double get waterLiters => waterMl / 1000.0;

  NutritionGoalEntity copyWith({
    int? id,
    int? userId,
    int? dailyCalories,
    int? proteinGrams,
    int? carbsGrams,
    int? fatGrams,
    int? waterMl,
    DateTime? effectiveFrom,
  }) {
    return NutritionGoalEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      dailyCalories: dailyCalories ?? this.dailyCalories,
      proteinGrams: proteinGrams ?? this.proteinGrams,
      carbsGrams: carbsGrams ?? this.carbsGrams,
      fatGrams: fatGrams ?? this.fatGrams,
      waterMl: waterMl ?? this.waterMl,
      effectiveFrom: effectiveFrom ?? this.effectiveFrom,
    );
  }
}
