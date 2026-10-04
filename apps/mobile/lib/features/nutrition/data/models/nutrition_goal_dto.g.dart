// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrition_goal_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NutritionGoalDto _$NutritionGoalDtoFromJson(Map<String, dynamic> json) =>
    _NutritionGoalDto(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      dailyCalories: (json['daily_calories'] as num).toInt(),
      proteinGrams: (json['protein_grams'] as num).toInt(),
      carbsGrams: (json['carbs_grams'] as num).toInt(),
      fatGrams: (json['fat_grams'] as num).toInt(),
      waterMl: (json['water_ml'] as num).toInt(),
      effectiveFrom: json['effective_from'] as String?,
    );

Map<String, dynamic> _$NutritionGoalDtoToJson(_NutritionGoalDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'daily_calories': instance.dailyCalories,
      'protein_grams': instance.proteinGrams,
      'carbs_grams': instance.carbsGrams,
      'fat_grams': instance.fatGrams,
      'water_ml': instance.waterMl,
      'effective_from': instance.effectiveFrom,
    };
