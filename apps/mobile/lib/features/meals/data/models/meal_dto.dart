import '../../domain/entities/meal_entity.dart';

class MealItemDto {
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

  const MealItemDto({
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

  factory MealItemDto.fromJson(Map<String, dynamic> json) {
    return MealItemDto(
      id: json['id'] as int?,
      foodId: json['food_id'] as int?,
      foodName: json['food_name'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toDouble() ?? 1.0,
      unit: json['unit'] as String? ?? 'serving',
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      protein: (json['protein'] as num?)?.toDouble() ?? 0.0,
      carbs: (json['carbs'] as num?)?.toDouble() ?? 0.0,
      fat: (json['fat'] as num?)?.toDouble() ?? 0.0,
      fiber: (json['fiber'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (foodId != null) 'food_id': foodId,
      'food_name': foodName,
      'quantity': quantity,
      'unit': unit,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'fiber': fiber,
    };
  }

  MealItemEntity toDomain() {
    return MealItemEntity(
      id: id,
      foodId: foodId,
      foodName: foodName,
      quantity: quantity,
      unit: unit,
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
      fiber: fiber,
    );
  }

  factory MealItemDto.fromDomain(MealItemEntity entity) {
    return MealItemDto(
      id: entity.id,
      foodId: entity.foodId,
      foodName: entity.foodName,
      quantity: entity.quantity,
      unit: entity.unit,
      calories: entity.calories,
      protein: entity.protein,
      carbs: entity.carbs,
      fat: entity.fat,
      fiber: entity.fiber,
    );
  }
}

class MealDto {
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
  final List<MealItemDto> items;

  const MealDto({
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

  factory MealDto.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? [];
    return MealDto(
      id: json['id'] as int?,
      userId: json['user_id'] as int?,
      mealType: json['meal_type'] as String? ?? 'breakfast',
      mealDate: json['meal_date'] as String? ?? '',
      mealTime: json['meal_time'] as String? ?? '',
      totalCalories: (json['total_calories'] as num?)?.toInt() ?? 0,
      totalProtein: (json['total_protein'] as num?)?.toDouble() ?? 0.0,
      totalCarbs: (json['total_carbs'] as num?)?.toDouble() ?? 0.0,
      totalFat: (json['total_fat'] as num?)?.toDouble() ?? 0.0,
      totalFiber: (json['total_fiber'] as num?)?.toDouble() ?? 0.0,
      source: json['source'] as String? ?? 'manual',
      imagePath: json['image_path'] as String?,
      analysisId: (json['analysis_id'] as num?)?.toInt(),
      items: rawItems
          .map((i) => MealItemDto.fromJson(i as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meal_type': mealType,
      'meal_date': mealDate,
      'meal_time': mealTime,
      'source': source,
      if (imagePath != null) 'image_path': imagePath,
      if (analysisId != null) 'analysis_id': analysisId,
      'items': items.map((i) => i.toJson()).toList(),
    };
  }

  MealEntity toDomain() {
    return MealEntity(
      id: id,
      userId: userId,
      mealType: mealType,
      mealDate: mealDate,
      mealTime: mealTime,
      totalCalories: totalCalories,
      totalProtein: totalProtein,
      totalCarbs: totalCarbs,
      totalFat: totalFat,
      totalFiber: totalFiber,
      source: source,
      imagePath: imagePath,
      analysisId: analysisId,
      items: items.map((i) => i.toDomain()).toList(),
    );
  }

  factory MealDto.fromDomain(MealEntity entity) {
    return MealDto(
      id: entity.id,
      userId: entity.userId,
      mealType: entity.mealType,
      mealDate: entity.mealDate,
      mealTime: entity.mealTime,
      totalCalories: entity.totalCalories,
      totalProtein: entity.totalProtein,
      totalCarbs: entity.totalCarbs,
      totalFat: entity.totalFat,
      totalFiber: entity.totalFiber,
      source: entity.source,
      imagePath: entity.imagePath,
      analysisId: entity.analysisId,
      items: entity.items.map((i) => MealItemDto.fromDomain(i)).toList(),
    );
  }
}
