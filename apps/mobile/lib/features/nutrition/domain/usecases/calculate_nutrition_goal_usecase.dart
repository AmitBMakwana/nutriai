import '../entities/nutrition_goal_entity.dart';
import '../repositories/nutrition_repository_interface.dart';

class CalculateNutritionGoalUseCase {
  final INutritionRepository _repository;

  CalculateNutritionGoalUseCase(this._repository);

  Future<NutritionGoalEntity> call({
    double? weightKg,
    double? heightCm,
    DateTime? dateOfBirth,
    String? gender,
    String? activityLevel,
    String? goal,
    String? dietType,
  }) {
    return _repository.calculateGoal(
      weightKg: weightKg,
      heightCm: heightCm,
      dateOfBirth: dateOfBirth,
      gender: gender,
      activityLevel: activityLevel,
      goal: goal,
      dietType: dietType,
    );
  }
}
