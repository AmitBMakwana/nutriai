import '../../domain/entities/food_entity.dart';

class FoodDto {
  final int id;
  final String name;
  final String? brand;
  final double servingSize;
  final String servingUnit;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final double fiber;
  final double? sugar;
  final double? sodium;
  final bool isVerified;
  final bool isFavorite;
  final int? userId;

  const FoodDto({
    required this.id,
    required this.name,
    this.brand,
    required this.servingSize,
    required this.servingUnit,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.fiber = 0.0,
    this.sugar,
    this.sodium,
    this.isVerified = true,
    this.isFavorite = false,
    this.userId,
  });

  factory FoodDto.fromJson(Map<String, dynamic> json) {
    return FoodDto(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      brand: json['brand'] as String?,
      servingSize: (json['serving_size'] as num?)?.toDouble() ?? 100.0,
      servingUnit: json['serving_unit'] as String? ?? 'g',
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      protein: (json['protein'] as num?)?.toDouble() ?? 0.0,
      carbs: (json['carbs'] as num?)?.toDouble() ?? 0.0,
      fat: (json['fat'] as num?)?.toDouble() ?? 0.0,
      fiber: (json['fiber'] as num?)?.toDouble() ?? 0.0,
      sugar: (json['sugar'] as num?)?.toDouble(),
      sodium: (json['sodium'] as num?)?.toDouble(),
      isVerified: json['is_verified'] as bool? ?? true,
      isFavorite: json['is_favorite'] as bool? ?? false,
      userId: json['user_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (brand != null) 'brand': brand,
      'serving_size': servingSize,
      'serving_unit': servingUnit,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'fiber': fiber,
      if (sugar != null) 'sugar': sugar,
      if (sodium != null) 'sodium': sodium,
    };
  }

  FoodEntity toDomain() {
    return FoodEntity(
      id: id,
      name: name,
      brand: brand,
      servingSize: servingSize,
      servingUnit: servingUnit,
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
      fiber: fiber,
      sugar: sugar,
      sodium: sodium,
      isVerified: isVerified,
      isFavorite: isFavorite,
      userId: userId,
    );
  }

  factory FoodDto.fromDomain(FoodEntity entity) {
    return FoodDto(
      id: entity.id,
      name: entity.name,
      brand: entity.brand,
      servingSize: entity.servingSize,
      servingUnit: entity.servingUnit,
      calories: entity.calories,
      protein: entity.protein,
      carbs: entity.carbs,
      fat: entity.fat,
      fiber: entity.fiber,
      sugar: entity.sugar,
      sodium: entity.sodium,
      isVerified: entity.isVerified,
      isFavorite: entity.isFavorite,
      userId: entity.userId,
    );
  }
}
