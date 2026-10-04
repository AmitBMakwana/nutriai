class AiDetectedItemEntity {
  final String name;
  final double quantity;
  final String unit;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final double confidence; // 0.0 to 1.0

  const AiDetectedItemEntity({
    required this.name,
    required this.quantity,
    required this.unit,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.confidence = 0.9,
  });

  bool get isLowConfidence => confidence < 0.60;

  /// Rescales calories and macronutrients proportionally to a new quantity.
  AiDetectedItemEntity rescaleQuantity(double newQuantity) {
    if (newQuantity <= 0) return this;
    final ratio = newQuantity / (quantity <= 0 ? 1.0 : quantity);

    return AiDetectedItemEntity(
      name: name,
      quantity: double.parse(newQuantity.toStringAsFixed(1)),
      unit: unit,
      calories: (calories * ratio).round(),
      protein: double.parse((protein * ratio).toStringAsFixed(1)),
      carbs: double.parse((carbs * ratio).toStringAsFixed(1)),
      fat: double.parse((fat * ratio).toStringAsFixed(1)),
      confidence: confidence,
    );
  }

  AiDetectedItemEntity copyWith({
    String? name,
    double? quantity,
    String? unit,
    int? calories,
    double? protein,
    double? carbs,
    double? fat,
    double? confidence,
  }) {
    return AiDetectedItemEntity(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      confidence: confidence ?? this.confidence,
    );
  }
}

class AiMealAnalysisResultEntity {
  final int analysisId;
  final String status;
  final bool isFood;
  final String mealName;
  final String mealType;
  final double confidence;
  final List<AiDetectedItemEntity> items;
  final int totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFat;
  final String? notes;
  final String? imageUrl;
  final int? processingTimeMs;

  const AiMealAnalysisResultEntity({
    required this.analysisId,
    required this.status,
    required this.isFood,
    required this.mealName,
    required this.mealType,
    required this.confidence,
    required this.items,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
    this.notes,
    this.imageUrl,
    this.processingTimeMs,
  });
}
