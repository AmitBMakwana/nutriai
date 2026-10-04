import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/nutrition_goal_entity.dart';

part 'nutrition_goal_dto.freezed.dart';
part 'nutrition_goal_dto.g.dart';

@freezed
abstract class NutritionGoalDto with _$NutritionGoalDto {
  const NutritionGoalDto._();

  const factory NutritionGoalDto({
    int? id,
    @JsonKey(name: 'user_id') int? userId,
    @JsonKey(name: 'daily_calories') required int dailyCalories,
    @JsonKey(name: 'protein_grams') required int proteinGrams,
    @JsonKey(name: 'carbs_grams') required int carbsGrams,
    @JsonKey(name: 'fat_grams') required int fatGrams,
    @JsonKey(name: 'water_ml') required int waterMl,
    @JsonKey(name: 'effective_from') String? effectiveFrom,
  }) = _NutritionGoalDto;

  factory NutritionGoalDto.fromJson(Map<String, dynamic> json) =>
      _$NutritionGoalDtoFromJson(json);

  NutritionGoalEntity toDomain() {
    return NutritionGoalEntity(
      id: id,
      userId: userId,
      dailyCalories: dailyCalories,
      proteinGrams: proteinGrams,
      carbsGrams: carbsGrams,
      fatGrams: fatGrams,
      waterMl: waterMl,
      effectiveFrom: effectiveFrom != null ? DateTime.tryParse(effectiveFrom!) : null,
    );
  }

  factory NutritionGoalDto.fromDomain(NutritionGoalEntity entity) {
    return NutritionGoalDto(
      id: entity.id,
      userId: entity.userId,
      dailyCalories: entity.dailyCalories,
      proteinGrams: entity.proteinGrams,
      carbsGrams: entity.carbsGrams,
      fatGrams: entity.fatGrams,
      waterMl: entity.waterMl,
      effectiveFrom: entity.effectiveFrom?.toIso8601String().split('T').first,
    );
  }
}
