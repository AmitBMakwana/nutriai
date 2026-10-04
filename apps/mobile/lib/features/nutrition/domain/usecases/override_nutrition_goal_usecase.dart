import '../entities/nutrition_goal_entity.dart';
import '../repositories/nutrition_repository_interface.dart';

class OverrideNutritionGoalUseCase {
  final INutritionRepository _repository;

  OverrideNutritionGoalUseCase(this._repository);

  Future<NutritionGoalEntity> call(NutritionGoalEntity goal) {
    return _repository.overrideGoal(goal);
  }
}
