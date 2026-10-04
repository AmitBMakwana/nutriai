import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/food_entity.dart';
import '../../domain/repositories/food_repository_interface.dart';
import '../datasources/food_api.dart';
import '../models/food_dto.dart';

final foodRepositoryProvider = Provider<IFoodRepository>((ref) {
  final api = ref.watch(foodApiProvider);
  return FoodRepositoryImpl(api);
});

class FoodRepositoryImpl implements IFoodRepository {
  final FoodApi _api;

  FoodRepositoryImpl(this._api);

  @override
  Future<List<FoodEntity>> searchFoods({String? query, int page = 1}) async {
    final dtos = await _api.searchFoods(query: query, page: page);
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<FoodEntity> createCustomFood(FoodEntity food) async {
    final dto = FoodDto.fromDomain(food);
    final result = await _api.createCustomFood(dto.toJson());
    return result.toDomain();
  }

  @override
  Future<bool> toggleFavorite(int foodId) {
    return _api.toggleFavorite(foodId);
  }

  @override
  Future<List<FoodEntity>> getFavorites() async {
    final dtos = await _api.getFavorites();
    return dtos.map((dto) => dto.toDomain()).toList();
  }
}
