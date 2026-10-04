class MealItemEntity {
  final int? id;
  final int? foodId;
  final String foodName;
  final double quantity;
  final String unit;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final double fiber;

  const MealItemEntity({
    this.id,
    this.foodId,
    required this.foodName,
    required this.quantity,
    required this.unit,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.fiber = 0.0,
  });

  MealItemEntity copyWith({
    int? id,
    int? foodId,
    String? foodName,
    double? quantity,
    String? unit,
    int? calories,
    double? protein,
    double? carbs,
    double? fat,
    double? fiber,
  }) {
    return MealItemEntity(
      id: id ?? this.id,
      foodId: foodId ?? this.foodId,
      foodName: foodName ?? this.foodName,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      fiber: fiber ?? this.fiber,
    );
  }
}

class MealEntity {
  final int? id;
  final int? userId;
  final String mealType;
  final String mealDate;
  final String mealTime;
  final int totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFat;
  final double totalFiber;
  final String source;
  final String? imagePath;
  final int? analysisId;
  final List<MealItemEntity> items;

  const MealEntity({
    this.id,
    this.userId,
    required this.mealType,
    required this.mealDate,
    required this.mealTime,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
    this.totalFiber = 0.0,
    this.source = 'manual',
    this.imagePath,
    this.analysisId,
    this.items = const [],
  });

  String get displayName {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return 'Breakfast';
      case 'lunch':
        return 'Lunch';
      case 'dinner':
        return 'Dinner';
      case 'snack':
        return 'Snack';
      default:
        return mealType.substring(0, 1).toUpperCase() + mealType.substring(1);
    }
  }

  MealEntity copyWith({
    int? id,
    int? userId,
    String? mealType,
    String? mealDate,
    String? mealTime,
    int? totalCalories,
    double? totalProtein,
    double? totalCarbs,
    double? totalFat,
    double? totalFiber,
    String? source,
    String? imagePath,
    int? analysisId,
    List<MealItemEntity>? items,
  }) {
    return MealEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      mealType: mealType ?? this.mealType,
      mealDate: mealDate ?? this.mealDate,
      mealTime: mealTime ?? this.mealTime,
      totalCalories: totalCalories ?? this.totalCalories,
      totalProtein: totalProtein ?? this.totalProtein,
      totalCarbs: totalCarbs ?? this.totalCarbs,
      totalFat: totalFat ?? this.totalFat,
      totalFiber: totalFiber ?? this.totalFiber,
      source: source ?? this.source,
      imagePath: imagePath ?? this.imagePath,
      analysisId: analysisId ?? this.analysisId,
      items: items ?? this.items,
    );
  }
}
