import '../../domain/entities/nutrition_goal_entity.dart';

class NutritionGoalState {
  final bool isLoading;
  final NutritionGoalEntity? goal;
  final String? errorMessage;
  final bool isSuccess;

  const NutritionGoalState({
    this.isLoading = false,
    this.goal,
    this.errorMessage,
    this.isSuccess = false,
  });

  factory NutritionGoalState.initial() => const NutritionGoalState();

  NutritionGoalState copyWith({
    bool? isLoading,
    NutritionGoalEntity? goal,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return NutritionGoalState(
      isLoading: isLoading ?? this.isLoading,
      goal: goal ?? this.goal,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
