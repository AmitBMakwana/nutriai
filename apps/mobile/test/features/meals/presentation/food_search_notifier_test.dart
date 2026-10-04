import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutriai/features/meals/data/repositories/food_repository_impl.dart';
import 'package:nutriai/features/meals/domain/entities/food_entity.dart';
import 'package:nutriai/features/meals/domain/repositories/food_repository_interface.dart';
import 'package:nutriai/features/meals/presentation/providers/food_search_provider.dart';

class MockFoodRepository extends Mock implements IFoodRepository {}

void main() {
  late MockFoodRepository mockRepo;
  late ProviderContainer container;

  final sampleFoods = [
    const FoodEntity(
      id: 1,
      name: 'Chicken Breast',
      servingSize: 100,
      servingUnit: 'g',
      calories: 165,
      protein: 31,
      carbs: 0,
      fat: 3.6,
      isVerified: true,
      isFavorite: false,
    ),
    const FoodEntity(
      id: 2,
      name: 'Brown Rice',
      servingSize: 50,
      servingUnit: 'g',
      calories: 170,
      protein: 3.5,
      carbs: 36,
      fat: 1.5,
      isVerified: true,
      isFavorite: true,
    ),
  ];

  setUp(() {
    mockRepo = MockFoodRepository();
    when(() => mockRepo.searchFoods(query: any(named: 'query'), page: any(named: 'page')))
        .thenAnswer((_) async => sampleFoods);
    when(() => mockRepo.getFavorites())
        .thenAnswer((_) async => [sampleFoods[1]]);

    container = ProviderContainer(
      overrides: [
        foodRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('FoodSearchNotifier Tests', () {
    test('initial state has empty foods', () {
      final state = container.read(foodSearchProvider);

      expect(state.isLoading, isFalse);
      expect(state.foods, isEmpty);
      expect(state.query, isEmpty);
    });

    test('search loads foods matching query', () async {
      final notifier = container.read(foodSearchProvider.notifier);
      await notifier.search('');

      final state = container.read(foodSearchProvider);
      expect(state.isLoading, isFalse);
      expect(state.foods.length, equals(2));
      expect(state.foods.first.name, equals('Chicken Breast'));
    });

    test('search filters foods by query', () async {
      when(() => mockRepo.searchFoods(query: 'Rice', page: any(named: 'page')))
          .thenAnswer((_) async => [sampleFoods[1]]);

      final notifier = container.read(foodSearchProvider.notifier);
      await notifier.search('Rice');

      final state = container.read(foodSearchProvider);
      expect(state.foods.length, equals(1));
      expect(state.foods.first.name, equals('Brown Rice'));
    });

    test('toggleFavorite updates isFavorite state of the food', () async {
      when(() => mockRepo.toggleFavorite(1)).thenAnswer((_) async => true);

      final notifier = container.read(foodSearchProvider.notifier);
      await notifier.search('');
      await notifier.toggleFavorite(1);

      final state = container.read(foodSearchProvider);
      final updatedFood = state.foods.firstWhere((f) => f.id == 1);
      expect(updatedFood.isFavorite, isTrue);
    });

    test('setFavoritesOnly loads favorites list', () async {
      final notifier = container.read(foodSearchProvider.notifier);
      await notifier.setFavoritesOnly(true);

      final state = container.read(foodSearchProvider);
      expect(state.isFavoritesOnly, isTrue);
      expect(state.foods.length, equals(1));
      expect(state.foods.first.name, equals('Brown Rice'));
    });
  });
}
