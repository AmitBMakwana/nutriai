import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/nutrition_goal_entity.dart';
import '../../domain/repositories/nutrition_repository_interface.dart';
import '../datasources/nutrition_api.dart';
import '../models/nutrition_goal_dto.dart';

/// Provider for [INutritionRepository].
final nutritionRepositoryProvider = Provider<INutritionRepository>((ref) {
  final api = ref.watch(nutritionApiProvider);
  return NutritionRepositoryImpl(api);
});

class NutritionRepositoryImpl implements INutritionRepository {
  final NutritionApi _api;

  const NutritionRepositoryImpl(this._api);

  @override
  Future<NutritionGoalEntity> getActiveGoal() async {
    final dto = await _api.getActiveGoal();
    return dto.toDomain();
  }

  @override
  Future<NutritionGoalEntity> calculateGoal({
    double? weightKg,
    double? heightCm,
    DateTime? dateOfBirth,
    String? gender,
    String? activityLevel,
    String? goal,
    String? dietType,
  }) async {
    final params = <String, dynamic>{};
    if (weightKg != null) params['weight_kg'] = weightKg;
    if (heightCm != null) params['height_cm'] = heightCm.round();
    if (dateOfBirth != null) {
      params['date_of_birth'] = dateOfBirth.toIso8601String().split('T').first;
    }
    if (gender != null) params['gender'] = gender;
    if (activityLevel != null) params['activity_level'] = activityLevel;
    if (goal != null) params['goal'] = goal;
    if (dietType != null) params['diet_type'] = dietType;

    final dto = await _api.calculateGoal(params);
    return dto.toDomain();
  }

  @override
  Future<NutritionGoalEntity> overrideGoal(NutritionGoalEntity goal) async {
    final dto = NutritionGoalDto.fromDomain(goal);
    final responseDto = await _api.overrideGoal(dto.toJson());
    return responseDto.toDomain();
  }
}
