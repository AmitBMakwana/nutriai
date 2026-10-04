import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nutriai/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:nutriai/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:nutriai/features/water/data/repositories/water_repository_impl.dart';
import 'package:nutriai/features/water/domain/entities/water_log_entity.dart';
import 'package:nutriai/features/water/domain/repositories/water_repository.dart';
import 'package:nutriai/features/water/presentation/providers/water_notifier.dart';

class MockWaterRepository extends Mock implements IWaterRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockWaterRepository mockRepo;
  late ProviderContainer container;

  final testDate = DateTime(2026, 10, 2);
  final initialLog = WaterLogEntity(
    id: 1,
    amountMl: 250,
    loggedAt: testDate,
  );

  setUp(() {
    mockRepo = MockWaterRepository();

    when(() => mockRepo.getWaterLogs(date: any(named: 'date'))).thenAnswer(
      (_) async => (totalMl: 250, logs: [initialLog]),
    );

    container = ProviderContainer(
      overrides: [
        waterRepositoryProvider.overrideWithValue(mockRepo),
        selectedDateProvider.overrideWith(() => _MockSelectedDateNotifier(testDate)),
        dashboardProvider.overrideWith(() => _MockDashboardNotifier()),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('WaterNotifier Tests', () {
    test('initial state loads water logs and total ml', () async {
      final notifier = container.read(waterNotifierProvider.notifier);
      await notifier.loadWater('2026-10-02');

      final state = container.read(waterNotifierProvider);
      expect(state.consumedMl, 250);
      expect(state.logs.length, 1);
      expect(state.logs.first.amountMl, 250);
      expect(state.canUndo, isTrue);
    });

    test('quickAdd updates total and prepends new log', () async {
      final newLog = WaterLogEntity(
        id: 2,
        amountMl: 500,
        loggedAt: testDate,
      );

      when(() => mockRepo.logWater(
            amountMl: 500,
            date: any(named: 'date'),
            loggedAt: any(named: 'loggedAt'),
          )).thenAnswer((_) async => (totalMl: 750, log: newLog));

      final notifier = container.read(waterNotifierProvider.notifier);
      await notifier.loadWater('2026-10-02');

      final success = await notifier.quickAdd(500);

      expect(success, isTrue);
      final state = container.read(waterNotifierProvider);
      expect(state.consumedMl, 750);
      expect(state.logs.length, 2);
      expect(state.logs.first.id, 2);
      verify(() => mockRepo.logWater(
            amountMl: 500,
            date: '2026-10-02',
          )).called(1);
    });

    test('undoLast deletes the last water log and decrements total', () async {
      when(() => mockRepo.deleteWater(
            id: any(named: 'id'),
            date: any(named: 'date'),
          )).thenAnswer((_) async => (totalMl: 0, deletedLog: initialLog));

      final notifier = container.read(waterNotifierProvider.notifier);
      await notifier.loadWater('2026-10-02');

      final success = await notifier.undoLast();

      expect(success, isTrue);
      final state = container.read(waterNotifierProvider);
      expect(state.consumedMl, 0);
      expect(state.logs, isEmpty);
      verify(() => mockRepo.deleteWater(
            id: 1,
            date: '2026-10-02',
          )).called(1);
    });

    test('quickAdd reverts optimistic update when api throws error', () async {
      when(() => mockRepo.logWater(
            amountMl: 250,
            date: any(named: 'date'),
          )).thenThrow(Exception('Network timeout'));

      final notifier = container.read(waterNotifierProvider.notifier);
      await notifier.loadWater('2026-10-02');

      final success = await notifier.quickAdd(250);

      expect(success, isFalse);
      final state = container.read(waterNotifierProvider);
      expect(state.consumedMl, 250); // Reverted back to initial 250
      expect(state.errorMessage, contains('Network timeout'));
    });
  });
}

class _MockSelectedDateNotifier extends SelectedDateNotifier {
  final DateTime initial;
  _MockSelectedDateNotifier(this.initial);

  @override
  DateTime build() => initial;
}

class _MockDashboardNotifier extends DashboardNotifier {
  @override
  Future<DashboardEntity> build() async {
    return const DashboardEntity(
      date: '2026-10-02',
      calories: CalorieSummaryEntity(target: 2000, consumed: 0, remaining: 2000, percentage: 0),
      macros: MacrosSummaryEntity(
        protein: MacroNutrientEntity(target: 150, consumed: 0, remaining: 150, percentage: 0),
        carbs: MacroNutrientEntity(target: 200, consumed: 0, remaining: 200, percentage: 0),
        fat: MacroNutrientEntity(target: 60, consumed: 0, remaining: 60, percentage: 0),
      ),
      water: WaterSummaryEntity(target: 2000, consumed: 250, remaining: 1750, percentage: 12.5),
      meals: {},
    );
  }
}

