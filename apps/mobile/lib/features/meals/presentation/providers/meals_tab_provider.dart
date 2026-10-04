import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';
import '../../data/repositories/meal_repository_impl.dart';
import '../../domain/entities/meal_entity.dart';
import '../../domain/repositories/meal_repository_interface.dart';

final mealsTabProvider =
    AsyncNotifierProvider<MealsTabNotifier, List<MealEntity>>(
  MealsTabNotifier.new,
);

class MealsTabNotifier extends AsyncNotifier<List<MealEntity>> {
  @override
  Future<List<MealEntity>> build() async {
    final date = ref.watch(selectedDateProvider);
    final dateString = DateFormat('yyyy-MM-dd').format(date);
    final repo = ref.watch(mealRepositoryProvider);
    return repo.getMeals(date: dateString);
  }

  IMealRepository get _repo => ref.read(mealRepositoryProvider);

  Future<void> refreshMeals() async {
    ref.invalidateSelf();
    await future;
  }

  Future<bool> deleteMeal(int id) async {
    try {
      await _repo.deleteMeal(id);
      // Invalidate both meals tab and dashboard cache
      ref.invalidateSelf();
      ref.invalidate(dashboardProvider);
      return true;
    } catch (_) {
      return false;
    }
  }
}
