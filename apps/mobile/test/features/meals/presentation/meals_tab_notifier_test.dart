import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutriai/features/meals/data/repositories/meal_repository_impl.dart';
import 'package:nutriai/features/meals/domain/entities/meal_entity.dart';
import 'package:nutriai/features/meals/domain/repositories/meal_repository_interface.dart';
import 'package:nutriai/features/meals/presentation/providers/meals_tab_provider.dart';

class MockMealRepository extends Mock implements IMealRepository {}

void main() {
  late MockMealRepository mockRepo;
  late ProviderContainer container;

  final sampleMeals = [
    const MealEntity(
      id: 1,
      mealType: 'breakfast',
      mealDate: '2026-10-02',
      mealTime: '08:30:00',
      totalCalories: 450,
      totalProtein: 30,
      totalCarbs: 50,
      totalFat: 15,
      items: [],
    ),
    const MealEntity(
      id: 2,
      mealType: 'lunch',
      mealDate: '2026-10-02',
      mealTime: '13:00:00',
      totalCalories: 650,
      totalProtein: 45,
      totalCarbs: 60,
      totalFat: 22,
      items: [],
    ),
  ];

  setUp(() {
    mockRepo = MockMealRepository();
    when(() => mockRepo.getMeals(date: any(named: 'date')))
        .thenAnswer((_) async => sampleMeals);

    container = ProviderContainer(
      overrides: [
        mealRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('MealsTabNotifier Tests', () {
    test('loads meals for selected date', () async {
      final meals = await container.read(mealsTabProvider.future);

      expect(meals.length, equals(2));
      expect(meals.first.mealType, equals('breakfast'));
      expect(meals.last.mealType, equals('lunch'));
      verify(() => mockRepo.getMeals(date: any(named: 'date'))).called(1);
    });

    test('deleteMeal calls repository and refreshes', () async {
      when(() => mockRepo.deleteMeal(1)).thenAnswer((_) async {});

      final notifier = container.read(mealsTabProvider.notifier);
      final success = await notifier.deleteMeal(1);

      expect(success, isTrue);
      verify(() => mockRepo.deleteMeal(1)).called(1);
    });
  });
}
