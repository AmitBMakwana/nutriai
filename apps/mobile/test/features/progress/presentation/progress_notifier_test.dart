import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nutriai/features/progress/data/repositories/progress_repository.dart';
import 'package:nutriai/features/progress/domain/entities/progress_entities.dart';
import 'package:nutriai/features/progress/presentation/providers/progress_notifier.dart';

// ─── Mocks ───────────────────────────────────────────────────────────────────

class MockProgressRepository extends Mock implements IProgressRepository {}

// ─── Fake data helpers ────────────────────────────────────────────────────────

final _today = DateTime(2026, 10, 2);

MacroAverages _avg() => const MacroAverages(
      calories: 1900,
      protein: 140.0,
      carbs: 190.0,
      fat: 60.0,
    );

MacroTargets _targets() => const MacroTargets(
      protein: 150.0,
      carbs: 200.0,
      fat: 67.0,
    );

ProgressData _makeProgressData(String range, {int days = 7}) {
  final start = _today.subtract(Duration(days: days - 1));
  return ProgressData(
    range: range,
    start: start,
    end: _today,
    calorieDaily: List.generate(
      days,
      (i) => DailyCaloriePoint(
        date: start.add(Duration(days: i)),
        consumed: 1800 + i * 10,
        target: 2000,
      ),
    ),
    calorieAverage: 1850,
    calorieTarget: 2000,
    macroAverages: _avg(),
    macroTargets: _targets(),
    weight: const WeightProgress(
      series: [],
      startKg: null,
      currentKg: null,
      targetKg: null,
      changeKg: null,
    ),
    mealsTracked: 21,
    daysOnTarget: 5,
    activeDays: 7,
    streak: 3,
  );
}

WeeklyProgress _makeWeekly() => WeeklyProgress(
      weekStart: _today.subtract(const Duration(days: 6)),
      weekEnd: _today,
      days: [],
      totals: _avg(),
      averages: _avg(),
      calorieTarget: 2000,
    );

MonthlyProgress _makeMonthly() => MonthlyProgress(
      year: 2026,
      month: 10,
      days: [],
      averages: _avg(),
      calorieTarget: 2000,
      daysOnTarget: 20,
      activeDays: 25,
    );

// ─── Container factory ────────────────────────────────────────────────────────

ProviderContainer _makeContainer(MockProgressRepository repo) {
  return ProviderContainer(
    overrides: [
      progressRepositoryProvider.overrideWithValue(repo),
    ],
  );
}

// ─── Tests ───────────────────────────────────────────────────────────────────

void main() {
  late MockProgressRepository mockRepo;
  late ProviderContainer container;

  setUp(() {
    mockRepo = MockProgressRepository();
    container = _makeContainer(mockRepo);
  });

  tearDown(() => container.dispose());

  group('ProgressNotifier.loadProgress', () {
    test('initial state has no data and no error', () {
      final state = container.read(progressNotifierProvider);
      expect(state.data, isNull);
      expect(state.errorMessage, isNull);
      expect(state.selectedRange, '7d');
    });

    test('loadProgress populates data on success', () async {
      when(() => mockRepo.getProgress(range: '7d'))
          .thenAnswer((_) async => _makeProgressData('7d'));

      final notifier = container.read(progressNotifierProvider.notifier);
      await notifier.loadProgress();

      final state = container.read(progressNotifierProvider);
      expect(state.data, isNotNull);
      expect(state.data!.range, '7d');
      expect(state.data!.calorieDaily.length, 7);
      expect(state.data!.streak, 3);
      expect(state.errorMessage, isNull);
    });

    test('loadProgress sets error on failure', () async {
      when(() => mockRepo.getProgress(range: '7d'))
          .thenThrow(Exception('network error'));

      final notifier = container.read(progressNotifierProvider.notifier);
      await notifier.loadProgress();

      final state = container.read(progressNotifierProvider);
      expect(state.data, isNull);
      expect(state.errorMessage, isNotNull);
    });

    test('selectRange changes range and reloads', () async {
      when(() => mockRepo.getProgress(range: '30d'))
          .thenAnswer((_) async => _makeProgressData('30d', days: 30));

      final notifier = container.read(progressNotifierProvider.notifier);
      await notifier.selectRange('30d');

      final state = container.read(progressNotifierProvider);
      expect(state.selectedRange, '30d');
      expect(state.data!.range, '30d');
      expect(state.data!.calorieDaily.length, 30);
    });

    test('isLoading is false after completion', () async {
      when(() => mockRepo.getProgress(range: '7d'))
          .thenAnswer((_) async => _makeProgressData('7d'));

      await container.read(progressNotifierProvider.notifier).loadProgress();
      expect(container.read(progressNotifierProvider).isLoading, isFalse);
    });
  });

  group('ProgressNotifier.loadWeekly', () {
    test('loads weekly data successfully', () async {
      when(() => mockRepo.getWeekly()).thenAnswer((_) async => _makeWeekly());

      await container.read(progressNotifierProvider.notifier).loadWeekly();

      final state = container.read(progressNotifierProvider);
      expect(state.weekly, isNotNull);
      expect(state.weekly!.calorieTarget, 2000);
    });

    test('sets error when weekly load fails', () async {
      when(() => mockRepo.getWeekly()).thenThrow(Exception('timeout'));

      await container.read(progressNotifierProvider.notifier).loadWeekly();
      expect(container.read(progressNotifierProvider).errorMessage, isNotNull);
    });
  });

  group('ProgressNotifier.loadMonthly', () {
    test('loads monthly data successfully', () async {
      when(() => mockRepo.getMonthly(year: 2026, month: 10))
          .thenAnswer((_) async => _makeMonthly());

      await container
          .read(progressNotifierProvider.notifier)
          .loadMonthly(year: 2026, month: 10);

      final state = container.read(progressNotifierProvider);
      expect(state.monthly, isNotNull);
      expect(state.monthly!.daysOnTarget, 20);
    });
  });

  group('ProgressData value assertions', () {
    setUp(() {
      when(() => mockRepo.getProgress(range: '7d'))
          .thenAnswer((_) async => _makeProgressData('7d'));
    });

    test('calorieAverage matches expected', () async {
      await container.read(progressNotifierProvider.notifier).loadProgress();
      expect(container.read(progressNotifierProvider).data!.calorieAverage, 1850);
    });

    test('macroAverages are correct', () async {
      await container.read(progressNotifierProvider.notifier).loadProgress();
      final avg = container.read(progressNotifierProvider).data!.macroAverages;
      expect(avg.protein, 140.0);
      expect(avg.carbs, 190.0);
      expect(avg.fat, 60.0);
    });

    test('daysOnTarget and activeDays are populated', () async {
      await container.read(progressNotifierProvider.notifier).loadProgress();
      final data = container.read(progressNotifierProvider).data!;
      expect(data.daysOnTarget, 5);
      expect(data.activeDays, 7);
    });
  });
}
