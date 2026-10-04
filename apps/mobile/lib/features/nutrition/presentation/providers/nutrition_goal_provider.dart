import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/nutrition_repository_impl.dart';
import '../../domain/entities/nutrition_goal_entity.dart';
import '../../domain/usecases/calculate_nutrition_goal_usecase.dart';
import '../../domain/usecases/get_nutrition_goal_usecase.dart';
import '../../domain/usecases/override_nutrition_goal_usecase.dart';
import 'nutrition_goal_state.dart';

final getNutritionGoalUseCaseProvider = Provider<GetNutritionGoalUseCase>((ref) {
  final repo = ref.watch(nutritionRepositoryProvider);
  return GetNutritionGoalUseCase(repo);
});

final calculateNutritionGoalUseCaseProvider =
    Provider<CalculateNutritionGoalUseCase>((ref) {
  final repo = ref.watch(nutritionRepositoryProvider);
  return CalculateNutritionGoalUseCase(repo);
});

final overrideNutritionGoalUseCaseProvider =
    Provider<OverrideNutritionGoalUseCase>((ref) {
  final repo = ref.watch(nutritionRepositoryProvider);
  return OverrideNutritionGoalUseCase(repo);
});

final nutritionGoalNotifierProvider =
    NotifierProvider<NutritionGoalNotifier, NutritionGoalState>(
        NutritionGoalNotifier.new);

class NutritionGoalNotifier extends Notifier<NutritionGoalState> {
  @override
  NutritionGoalState build() {
    return NutritionGoalState.initial();
  }

  GetNutritionGoalUseCase get _getGoalUseCase =>
      ref.read(getNutritionGoalUseCaseProvider);
  CalculateNutritionGoalUseCase get _calculateGoalUseCase =>
      ref.read(calculateNutritionGoalUseCaseProvider);
  OverrideNutritionGoalUseCase get _overrideGoalUseCase =>
      ref.read(overrideNutritionGoalUseCaseProvider);

  Future<void> loadActiveGoal() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final goal = await _getGoalUseCase();
      state = state.copyWith(isLoading: false, goal: goal, isSuccess: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> calculatePreview({
    double? weightKg,
    double? heightCm,
    DateTime? dateOfBirth,
    String? gender,
    String? activityLevel,
    String? goal,
    String? dietType,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final calculated = await _calculateGoalUseCase(
        weightKg: weightKg,
        heightCm: heightCm,
        dateOfBirth: dateOfBirth,
        gender: gender,
        activityLevel: activityLevel,
        goal: goal,
        dietType: dietType,
      );
      state = state.copyWith(isLoading: false, goal: calculated, isSuccess: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<bool> overrideGoal(NutritionGoalEntity newGoal) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final updated = await _overrideGoalUseCase(newGoal);
      state = state.copyWith(isLoading: false, goal: updated, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  void setGoalDirectly(NutritionGoalEntity goal) {
    state = state.copyWith(goal: goal, isSuccess: true);
  }
}
