import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/meal_entity.dart';
import '../../domain/repositories/meal_repository_interface.dart';
import '../datasources/meal_api.dart';
import '../models/meal_dto.dart';

final mealRepositoryProvider = Provider<IMealRepository>((ref) {
  final api = ref.watch(mealApiProvider);
  return MealRepositoryImpl(api);
});

class MealRepositoryImpl implements IMealRepository {
  final MealApi _api;

  MealRepositoryImpl(this._api);

  @override
  Future<List<MealEntity>> getMeals({String? date}) async {
    final dtos = await _api.getMeals(date: date);
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<MealEntity> getMeal(int id) async {
    final dto = await _api.getMeal(id);
    return dto.toDomain();
  }

  @override
  Future<MealEntity> createMeal(MealEntity meal) async {
    final dto = MealDto.fromDomain(meal);
    final result = await _api.createMeal(dto.toJson());
    return result.toDomain();
  }

  @override
  Future<MealEntity> updateMeal(MealEntity meal) async {
    final dto = MealDto.fromDomain(meal);
    final result = await _api.updateMeal(meal.id!, dto.toJson());
    return result.toDomain();
  }

  @override
  Future<void> deleteMeal(int id) {
    return _api.deleteMeal(id);
  }
}
