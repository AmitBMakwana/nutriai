import '../entities/food_entity.dart';

abstract class IFoodRepository {
  Future<List<FoodEntity>> searchFoods({String? query, int page = 1});
  Future<FoodEntity> createCustomFood(FoodEntity food);
  Future<bool> toggleFavorite(int foodId);
  Future<List<FoodEntity>> getFavorites();
}
