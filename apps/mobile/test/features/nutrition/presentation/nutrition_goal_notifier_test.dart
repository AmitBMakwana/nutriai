import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutriai/features/nutrition/data/repositories/nutrition_repository_impl.dart';
import 'package:nutriai/features/nutrition/domain/entities/nutrition_goal_entity.dart';
import 'package:nutriai/features/nutrition/domain/repositories/nutrition_repository_interface.dart';
import 'package:nutriai/features/nutrition/presentation/providers/nutrition_goal_provider.dart';

class MockNutritionRepository extends Mock implements INutritionRepository {}

void main() {
  late MockNutritionRepository mockRepo;
  late ProviderContainer container;

  final sampleGoal = NutritionGoalEntity(
    id: 1,
    userId: 1,
    dailyCalories: 2125,
    proteinGrams: 159,
    carbsGrams: 213,
    fatGrams: 71,
    waterMl: 2750,
  );

  setUpAll(() {
    registerFallbackValue(sampleGoal);
  });

  setUp(() {
    mockRepo = MockNutritionRepository();
    container = ProviderContainer(
      overrides: [
        nutritionRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('NutritionGoalNotifier Tests', () {
    test('initial state is uninitialized', () {
      final state = container.read(nutritionGoalNotifierProvider);
      expect(state.isLoading, isFalse);
      expect(state.goal, isNull);
      expect(state.errorMessage, isNull);
      expect(state.isSuccess, isFalse);
    });

    test('loadActiveGoal updates state with goal on success', () async {
      when(() => mockRepo.getActiveGoal()).thenAnswer((_) async => sampleGoal);

      final notifier = container.read(nutritionGoalNotifierProvider.notifier);
      await notifier.loadActiveGoal();

      final state = container.read(nutritionGoalNotifierProvider);
      expect(state.isLoading, isFalse);
      expect(state.goal, equals(sampleGoal));
      expect(state.errorMessage, isNull);
      expect(state.isSuccess, isTrue);
      verify(() => mockRepo.getActiveGoal()).called(1);
    });

    test('calculatePreview computes goal from profile without persisting', () async {
      when(() => mockRepo.calculateGoal(
            weightKg: any(named: 'weightKg'),
            heightCm: any(named: 'heightCm'),
            dateOfBirth: any(named: 'dateOfBirth'),
            gender: any(named: 'gender'),
            activityLevel: any(named: 'activityLevel'),
            goal: any(named: 'goal'),
            dietType: any(named: 'dietType'),
          )).thenAnswer((_) async => sampleGoal);

      final notifier = container.read(nutritionGoalNotifierProvider.notifier);
      await notifier.calculatePreview(
        weightKg: 75.0,
        heightCm: 175.0,
        dateOfBirth: DateTime(1995, 6, 15),
        gender: 'male',
        activityLevel: 'moderately_active',
        goal: 'lose_weight',
        dietType: 'everything',
      );

      final state = container.read(nutritionGoalNotifierProvider);
      expect(state.goal, equals(sampleGoal));
      expect(state.isLoading, isFalse);
      expect(state.isSuccess, isTrue);
    });

    test('overrideGoal persists overridden targets and updates state', () async {
      final updatedGoal = sampleGoal.copyWith(
        dailyCalories: 2200,
        proteinGrams: 165,
      );

      when(() => mockRepo.overrideGoal(any())).thenAnswer((_) async => updatedGoal);

      final notifier = container.read(nutritionGoalNotifierProvider.notifier);
      final success = await notifier.overrideGoal(updatedGoal);

      expect(success, isTrue);
      final state = container.read(nutritionGoalNotifierProvider);
      expect(state.goal?.dailyCalories, equals(2200));
      expect(state.goal?.proteinGrams, equals(165));
      expect(state.isLoading, isFalse);
      expect(state.isSuccess, isTrue);
      verify(() => mockRepo.overrideGoal(any())).called(1);
    });

    test('handles failure gracefully with error message', () async {
      when(() => mockRepo.getActiveGoal()).thenThrow(Exception('Server error'));

      final notifier = container.read(nutritionGoalNotifierProvider.notifier);
      await notifier.loadActiveGoal();

      final state = container.read(nutritionGoalNotifierProvider);
      expect(state.isLoading, isFalse);
      expect(state.goal, isNull);
      expect(state.errorMessage, contains('Server error'));
    });
  });
}
