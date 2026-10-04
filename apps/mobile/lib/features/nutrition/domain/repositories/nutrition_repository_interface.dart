import '../entities/nutrition_goal_entity.dart';

abstract class INutritionRepository {
  Future<NutritionGoalEntity> getActiveGoal();
  Future<NutritionGoalEntity> calculateGoal({
    double? weightKg,
    double? heightCm,
    DateTime? dateOfBirth,
    String? gender,
    String? activityLevel,
    String? goal,
    String? dietType,
  });
  Future<NutritionGoalEntity> overrideGoal(NutritionGoalEntity goal);
}
