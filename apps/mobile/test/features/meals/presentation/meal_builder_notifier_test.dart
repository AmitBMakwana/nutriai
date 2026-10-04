import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutriai/features/meals/data/repositories/meal_repository_impl.dart';
import 'package:nutriai/features/meals/domain/entities/meal_entity.dart';
import 'package:nutriai/features/meals/domain/repositories/meal_repository_interface.dart';
import 'package:nutriai/features/meals/presentation/providers/meal_builder_provider.dart';

class MockMealRepository extends Mock implements IMealRepository {}

void main() {
  late MockMealRepository mockRepo;
  late ProviderContainer container;

  final sampleItem = const MealItemEntity(
    foodId: 1,
    foodName: 'Oatmeal',
    quantity: 100,
    unit: 'g',
    calories: 380,
    protein: 13,
    carbs: 68,
    fat: 6.5,
  );

  final sampleMeal = MealEntity(
    id: 10,
    mealType: 'breakfast',
    mealDate: '2026-10-02',
    mealTime: '08:30:00',
    totalCalories: 380,
    totalProtein: 13,
    totalCarbs: 68,
    totalFat: 6.5,
    items: [sampleItem],
  );

  setUpAll(() {
    registerFallbackValue(sampleMeal);
  });

  setUp(() {
    mockRepo = MockMealRepository();
    container = ProviderContainer(
      overrides: [
        mealRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('MealBuilderNotifier Tests', () {
    test('initial state has empty items and default meal type', () {
      final state = container.read(mealBuilderProvider);
      expect(state.items, isEmpty);
      expect(state.mealType, equals('breakfast'));
      expect(state.totalCalories, equals(0));
      expect(state.totalProtein, equals(0.0));
      expect(state.isEditMode, isFalse);
    });

    test('addItem updates items list and computes live totals', () {
      final notifier = container.read(mealBuilderProvider.notifier);
      notifier.addItem(sampleItem);

      final state = container.read(mealBuilderProvider);
      expect(state.items.length, equals(1));
      expect(state.totalCalories, equals(380));
      expect(state.totalProtein, equals(13.0));
      expect(state.totalCarbs, equals(68.0));
      expect(state.totalFat, equals(6.5));
    });

    test('removeItem removes item and recalculates live totals', () {
      final notifier = container.read(mealBuilderProvider.notifier);
      notifier.addItem(sampleItem);
      notifier.addItem(const MealItemEntity(
        foodName: 'Apple',
        quantity: 1,
        unit: 'piece',
        calories: 95,
        protein: 0.5,
        carbs: 25,
        fat: 0.3,
      ));

      var state = container.read(mealBuilderProvider);
      expect(state.items.length, equals(2));
      expect(state.totalCalories, equals(475));

      notifier.removeItem(0);
      state = container.read(mealBuilderProvider);
      expect(state.items.length, equals(1));
      expect(state.totalCalories, equals(95));
    });

    test('saveMeal calls createMeal in new meal mode', () async {
      when(() => mockRepo.createMeal(any())).thenAnswer((_) async => sampleMeal);

      final notifier = container.read(mealBuilderProvider.notifier);
      notifier.addItem(sampleItem);
      notifier.setMealType('breakfast');

      final success = await notifier.saveMeal();

      expect(success, isTrue);
      final state = container.read(mealBuilderProvider);
      expect(state.isSaved, isTrue);
      expect(state.isSaving, isFalse);
      verify(() => mockRepo.createMeal(any())).called(1);
    });

    test('loadForEdit switches state to edit mode and sets items', () {
      final notifier = container.read(mealBuilderProvider.notifier);
      notifier.loadForEdit(sampleMeal);

      final state = container.read(mealBuilderProvider);
      expect(state.isEditMode, isTrue);
      expect(state.mealId, equals(10));
      expect(state.items.length, equals(1));
      expect(state.totalCalories, equals(380));
    });

    test('duplicate clones meal items with cleared id for today', () {
      final notifier = container.read(mealBuilderProvider.notifier);
      notifier.duplicate(sampleMeal);

      final state = container.read(mealBuilderProvider);
      expect(state.isEditMode, isFalse);
      expect(state.mealId, isNull);
      expect(state.items.length, equals(1));
      expect(state.items.first.foodName, equals('Oatmeal'));
    });
  });
}
