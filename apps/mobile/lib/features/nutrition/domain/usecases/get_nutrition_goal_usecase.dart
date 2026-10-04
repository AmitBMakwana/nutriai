import '../entities/nutrition_goal_entity.dart';
import '../repositories/nutrition_repository_interface.dart';

class GetNutritionGoalUseCase {
  final INutritionRepository _repository;

  GetNutritionGoalUseCase(this._repository);

  Future<NutritionGoalEntity> call() {
    return _repository.getActiveGoal();
  }
}
