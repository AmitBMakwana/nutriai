/// Domain entity representing a Food item.
class FoodEntity {
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

  const FoodEntity({
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

  FoodEntity copyWith({
    int? id,
    String? name,
    String? brand,
    double? servingSize,
    String? servingUnit,
    int? calories,
    double? protein,
    double? carbs,
    double? fat,
    double? fiber,
    double? sugar,
    double? sodium,
    bool? isVerified,
    bool? isFavorite,
    int? userId,
  }) {
    return FoodEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      servingSize: servingSize ?? this.servingSize,
      servingUnit: servingUnit ?? this.servingUnit,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      fiber: fiber ?? this.fiber,
      sugar: sugar ?? this.sugar,
      sodium: sodium ?? this.sodium,
      isVerified: isVerified ?? this.isVerified,
      isFavorite: isFavorite ?? this.isFavorite,
      userId: userId ?? this.userId,
    );
  }
}
