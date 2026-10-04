import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/food_repository_impl.dart';
import '../../domain/entities/food_entity.dart';
import '../../domain/repositories/food_repository_interface.dart';

class FoodSearchState {
  final String query;
  final bool isFavoritesOnly;
  final bool isLoading;
  final List<FoodEntity> foods;
  final String? errorMessage;

  const FoodSearchState({
    this.query = '',
    this.isFavoritesOnly = false,
    this.isLoading = false,
    this.foods = const [],
    this.errorMessage,
  });

  FoodSearchState copyWith({
    String? query,
    bool? isFavoritesOnly,
    bool? isLoading,
    List<FoodEntity>? foods,
    String? errorMessage,
  }) {
    return FoodSearchState(
      query: query ?? this.query,
      isFavoritesOnly: isFavoritesOnly ?? this.isFavoritesOnly,
      isLoading: isLoading ?? this.isLoading,
      foods: foods ?? this.foods,
      errorMessage: errorMessage,
    );
  }
}

final foodSearchProvider =
    NotifierProvider<FoodSearchNotifier, FoodSearchState>(FoodSearchNotifier.new);

class FoodSearchNotifier extends Notifier<FoodSearchState> {
  Timer? _debounceTimer;

  @override
  FoodSearchState build() {
    ref.onDispose(() {
      _debounceTimer?.cancel();
    });
    return const FoodSearchState();
  }

  IFoodRepository get _repo => ref.read(foodRepositoryProvider);

  void onQueryChanged(String query) {
    state = state.copyWith(query: query);
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      search(query);
    });
  }

  Future<void> setFavoritesOnly(bool favoritesOnly) async {
    state = state.copyWith(isFavoritesOnly: favoritesOnly);
    if (favoritesOnly) {
      await loadFavorites();
    } else {
      await search(state.query);
    }
  }

  Future<void> search(String query) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final results = await _repo.searchFoods(query: query);
      state = state.copyWith(isLoading: false, foods: results);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> loadFavorites() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final favorites = await _repo.getFavorites();
      state = state.copyWith(isLoading: false, foods: favorites);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> toggleFavorite(int foodId) async {
    try {
      final isFav = await _repo.toggleFavorite(foodId);
      final updated = state.foods.map((food) {
        if (food.id == foodId) {
          return food.copyWith(isFavorite: isFav);
        }
        return food;
      }).toList();

      state = state.copyWith(foods: updated);
    } catch (_) {}
  }

  void addCustomFoodLocally(FoodEntity food) {
    state = state.copyWith(foods: [food, ...state.foods]);
  }
}
