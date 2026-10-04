import '../entities/meal_entity.dart';

abstract class IMealRepository {
  Future<List<MealEntity>> getMeals({String? date});
  Future<MealEntity> getMeal(int id);
  Future<MealEntity> createMeal(MealEntity meal);
  Future<MealEntity> updateMeal(MealEntity meal);
  Future<void> deleteMeal(int id);
}
