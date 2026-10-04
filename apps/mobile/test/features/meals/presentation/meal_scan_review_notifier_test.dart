import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nutriai/core/errors/exceptions.dart';
import 'package:nutriai/features/meals/data/repositories/ai_analysis_repository_impl.dart';
import 'package:nutriai/features/meals/data/repositories/meal_repository_impl.dart';
import 'package:nutriai/features/meals/domain/entities/ai_meal_analysis_entity.dart';
import 'package:nutriai/features/meals/domain/entities/meal_entity.dart';
import 'package:nutriai/features/meals/domain/repositories/ai_analysis_repository_interface.dart';
import 'package:nutriai/features/meals/domain/repositories/meal_repository_interface.dart';
import 'package:nutriai/features/meals/presentation/providers/meal_scan_review_provider.dart';

class MockAiAnalysisRepository extends Mock implements IAiAnalysisRepository {}
class MockMealRepository extends Mock implements IMealRepository {}
class FakeFile extends Fake implements File {}
class FakeMealEntity extends Fake implements MealEntity {}

void main() {
  late MockAiAnalysisRepository mockAiRepo;
  late MockMealRepository mockMealRepo;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(FakeFile());
    registerFallbackValue(FakeMealEntity());
  });

  final sampleItems = [
    const AiDetectedItemEntity(
      name: 'Paneer Tikka',
      quantity: 150.0,
      unit: 'g',
      calories: 300,
      protein: 20.0,
      carbs: 10.0,
      fat: 18.0,
      confidence: 0.95,
    ),
    const AiDetectedItemEntity(
      name: 'Mint Chutney',
      quantity: 30.0,
      unit: 'g',
      calories: 25,
      protein: 1.0,
      carbs: 2.0,
      fat: 0.5,
      confidence: 0.55, // Low confidence (<0.60)
    ),
  ];

  final sampleAnalysisResult = AiMealAnalysisResultEntity(
    analysisId: 101,
    status: 'completed',
    isFood: true,
    mealName: 'Paneer Tikka Platter',
    mealType: 'dinner',
    confidence: 0.92,
    items: sampleItems,
    totalCalories: 325,
    totalProtein: 21.0,
    totalCarbs: 12.0,
    totalFat: 18.5,
  );

  setUp(() {
    mockAiRepo = MockAiAnalysisRepository();
    mockMealRepo = MockMealRepository();

    container = ProviderContainer(
      overrides: [
        aiAnalysisRepositoryProvider.overrideWithValue(mockAiRepo),
        mealRepositoryProvider.overrideWithValue(mockMealRepo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('MealScanReviewNotifier Tests', () {
    test('initial state has initial status and empty items', () {
      final state = container.read(mealScanReviewProvider);
      expect(state.status, equals(ScanStatus.initial));
      expect(state.items, isEmpty);
      expect(state.totalCalories, equals(0));
    });

    test('analyzeImage succeeds and populates items with computed totals', () async {
      when(() => mockAiRepo.analyzeMealImage(
            image: any(named: 'image'),
            mealType: any(named: 'mealType'),
          )).thenAnswer((_) async => sampleAnalysisResult);

      final notifier = container.read(mealScanReviewProvider.notifier);
      final dummyFile = File('dummy.jpg');

      await notifier.analyzeImage(dummyFile, 'dinner');

      final state = container.read(mealScanReviewProvider);
      expect(state.status, equals(ScanStatus.success));
      expect(state.items.length, equals(2));
      expect(state.totalCalories, equals(325));
      expect(state.totalProtein, equals(21.0));
      expect(state.hasLowConfidenceItems, isTrue); // Mint Chutney is 0.55
    });

    test('updateItemQuantity proportionally rescales calories and macros', () async {
      when(() => mockAiRepo.analyzeMealImage(
            image: any(named: 'image'),
            mealType: any(named: 'mealType'),
          )).thenAnswer((_) async => sampleAnalysisResult);

      final notifier = container.read(mealScanReviewProvider.notifier);
      await notifier.analyzeImage(File('dummy.jpg'), 'dinner');

      // Double the portion of Paneer Tikka from 150g to 300g (2x ratio)
      notifier.updateItemQuantity(0, 300.0);

      final state = container.read(mealScanReviewProvider);
      final updatedItem = state.items[0];

      expect(updatedItem.quantity, equals(300.0));
      expect(updatedItem.calories, equals(600)); // 300 * 2
      expect(updatedItem.protein, equals(40.0)); // 20 * 2
      expect(updatedItem.carbs, equals(20.0)); // 10 * 2
      expect(updatedItem.fat, equals(36.0)); // 18 * 2

      // Live total recalculated
      expect(state.totalCalories, equals(625)); // 600 + 25
      expect(state.totalProtein, equals(41.0)); // 40 + 1
    });

    test('removeItem removes item and recalculates live totals', () async {
      when(() => mockAiRepo.analyzeMealImage(
            image: any(named: 'image'),
            mealType: any(named: 'mealType'),
          )).thenAnswer((_) async => sampleAnalysisResult);

      final notifier = container.read(mealScanReviewProvider.notifier);
      await notifier.analyzeImage(File('dummy.jpg'), 'dinner');

      // Remove Mint Chutney (index 1)
      notifier.removeItem(1);

      final state = container.read(mealScanReviewProvider);
      expect(state.items.length, equals(1));
      expect(state.items.first.name, equals('Paneer Tikka'));
      expect(state.totalCalories, equals(300));
      expect(state.hasLowConfidenceItems, isFalse);
    });

    test('addItem adds new food item and recalculates totals', () async {
      when(() => mockAiRepo.analyzeMealImage(
            image: any(named: 'image'),
            mealType: any(named: 'mealType'),
          )).thenAnswer((_) async => sampleAnalysisResult);

      final notifier = container.read(mealScanReviewProvider.notifier);
      await notifier.analyzeImage(File('dummy.jpg'), 'dinner');

      const extraItem = AiDetectedItemEntity(
        name: 'Naan',
        quantity: 1,
        unit: 'piece',
        calories: 200,
        protein: 5.0,
        carbs: 35.0,
        fat: 4.0,
      );

      notifier.addItem(extraItem);

      final state = container.read(mealScanReviewProvider);
      expect(state.items.length, equals(3));
      expect(state.totalCalories, equals(525)); // 325 + 200
      expect(state.totalCarbs, equals(47.0)); // 12 + 35
    });

    test('analyzeImage flags non-food error when isFood is false', () async {
      final nonFoodResult = AiMealAnalysisResultEntity(
        analysisId: 102,
        status: 'completed',
        isFood: false,
        mealName: 'Non-food item',
        mealType: 'lunch',
        confidence: 0.98,
        items: const [],
        totalCalories: 0,
        totalProtein: 0.0,
        totalCarbs: 0.0,
        totalFat: 0.0,
        notes: 'A picture of a laptop keyboard.',
      );

      when(() => mockAiRepo.analyzeMealImage(
            image: any(named: 'image'),
            mealType: any(named: 'mealType'),
          )).thenAnswer((_) async => nonFoodResult);

      final notifier = container.read(mealScanReviewProvider.notifier);
      await notifier.analyzeImage(File('dummy.jpg'), 'lunch');

      final state = container.read(mealScanReviewProvider);
      expect(state.status, equals(ScanStatus.error));
      expect(state.errorType, equals(ScanErrorType.nonFood));
      expect(state.errorMessage, contains('laptop keyboard'));
    });

    test('analyzeImage handles quota exceeded error (429)', () async {
      when(() => mockAiRepo.analyzeMealImage(
            image: any(named: 'image'),
            mealType: any(named: 'mealType'),
          )).thenThrow(const QuotaExceededApiException(
        message: 'Monthly scan quota exceeded (5/5).',
        used: 5,
        quota: 5,
      ));

      final notifier = container.read(mealScanReviewProvider.notifier);
      await notifier.analyzeImage(File('dummy.jpg'), 'lunch');

      final state = container.read(mealScanReviewProvider);
      expect(state.status, equals(ScanStatus.error));
      expect(state.errorType, equals(ScanErrorType.quotaExceeded));
      expect(state.errorMessage, contains('quota exceeded'));
    });

    test('saveMeal dispatches createMeal with source ai and refreshes state', () async {
      when(() => mockAiRepo.analyzeMealImage(
            image: any(named: 'image'),
            mealType: any(named: 'mealType'),
          )).thenAnswer((_) async => sampleAnalysisResult);

      when(() => mockMealRepo.createMeal(any())).thenAnswer((_) async => const MealEntity(
            id: 55,
            mealType: 'dinner',
            mealDate: '2026-10-02',
            mealTime: '12:00:00',
            totalCalories: 325,
            totalProtein: 21.0,
            totalCarbs: 12.0,
            totalFat: 18.5,
            source: 'ai',
          ));

      final notifier = container.read(mealScanReviewProvider.notifier);
      await notifier.analyzeImage(File('dummy.jpg'), 'dinner');

      final success = await notifier.saveMeal();

      expect(success, isTrue);
      verify(() => mockMealRepo.createMeal(any())).called(1);
    });
  });
}
