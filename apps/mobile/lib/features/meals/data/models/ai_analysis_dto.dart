import '../../domain/entities/ai_meal_analysis_entity.dart';

class AiDetectedItemDto {
  final String name;
  final double quantity;
  final String unit;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final double confidence;

  const AiDetectedItemDto({
    required this.name,
    required this.quantity,
    required this.unit,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.confidence = 0.9,
  });

  factory AiDetectedItemDto.fromJson(Map<String, dynamic> json) {
    return AiDetectedItemDto(
      name: json['name'] as String? ?? 'Food Item',
      quantity: (json['quantity'] as num?)?.toDouble() ?? 100.0,
      unit: json['unit'] as String? ?? 'g',
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      protein: (json['protein'] as num?)?.toDouble() ?? 0.0,
      carbs: (json['carbs'] as num?)?.toDouble() ?? 0.0,
      fat: (json['fat'] as num?)?.toDouble() ?? 0.0,
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.9,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'unit': unit,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'confidence': confidence,
    };
  }

  AiDetectedItemEntity toEntity() {
    return AiDetectedItemEntity(
      name: name,
      quantity: quantity,
      unit: unit,
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
      confidence: confidence,
    );
  }
}

class AiAnalysisResponseDto {
  final int analysisId;
  final String status;
  final bool isFood;
  final String mealName;
  final String mealType;
  final double confidence;
  final List<AiDetectedItemDto> items;
  final int totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFat;
  final String? notes;
  final String? imageUrl;
  final int? processingTimeMs;

  const AiAnalysisResponseDto({
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

  factory AiAnalysisResponseDto.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic> ? json['data'] as Map<String, dynamic> : json;

    final rawItems = data['items'] as List<dynamic>? ?? [];
    final itemsList = rawItems
        .map((e) => AiDetectedItemDto.fromJson(e as Map<String, dynamic>))
        .toList();

    final total = data['total'] as Map<String, dynamic>? ?? {};

    return AiAnalysisResponseDto(
      analysisId: (data['analysis_id'] as num?)?.toInt() ?? 0,
      status: data['status'] as String? ?? 'completed',
      isFood: (data['is_food'] as bool?) ?? true,
      mealName: data['meal_name'] as String? ?? 'Recognized Meal',
      mealType: data['meal_type'] as String? ?? 'lunch',
      confidence: (data['confidence'] as num?)?.toDouble() ?? 0.9,
      items: itemsList,
      totalCalories: (total['calories'] as num?)?.toInt() ?? 0,
      totalProtein: (total['protein'] as num?)?.toDouble() ?? 0.0,
      totalCarbs: (total['carbs'] as num?)?.toDouble() ?? 0.0,
      totalFat: (total['fat'] as num?)?.toDouble() ?? 0.0,
      notes: data['notes'] as String?,
      imageUrl: data['image_url'] as String?,
      processingTimeMs: (data['processing_time_ms'] as num?)?.toInt(),
    );
  }

  AiMealAnalysisResultEntity toEntity() {
    return AiMealAnalysisResultEntity(
      analysisId: analysisId,
      status: status,
      isFood: isFood,
      mealName: mealName,
      mealType: mealType,
      confidence: confidence,
      items: items.map((e) => e.toEntity()).toList(),
      totalCalories: totalCalories,
      totalProtein: totalProtein,
      totalCarbs: totalCarbs,
      totalFat: totalFat,
      notes: notes,
      imageUrl: imageUrl,
      processingTimeMs: processingTimeMs,
    );
  }
}
