import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nutriai/features/weight/data/repositories/weight_repository_impl.dart';
import 'package:nutriai/features/weight/domain/entities/weight_history_entity.dart';
import 'package:nutriai/features/weight/domain/entities/weight_log_entity.dart';
import 'package:nutriai/features/weight/domain/repositories/weight_repository.dart';
import 'package:nutriai/features/weight/presentation/providers/weight_notifier.dart';

class MockWeightRepository extends Mock implements IWeightRepository {}

void main() {
  late MockWeightRepository mockRepo;
  late ProviderContainer container;

  final testDate = DateTime(2026, 10, 2);
  final initialLog = WeightLogEntity(
    id: 1,
    weightKg: 75.0,
    loggedAt: testDate,
  );
  final initialHistory = WeightHistoryEntity(
    currentWeightKg: 75.0,
    targetWeightKg: 70.0,
    unitSystem: 'metric',
    logs: [initialLog],
  );

  setUp(() {
    mockRepo = MockWeightRepository();

    when(() => mockRepo.getWeightHistory()).thenAnswer(
      (_) async => initialHistory,
    );

    container = ProviderContainer(
      overrides: [
        weightRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('WeightNotifier Tests', () {
    test('initial state loads weight history from repository', () async {
      final notifier = container.read(weightNotifierProvider.notifier);
      await notifier.loadHistory();

      final state = container.read(weightNotifierProvider);
      expect(state.isLoading, isFalse);
      expect(state.history.currentWeightKg, 75.0);
      expect(state.history.targetWeightKg, 70.0);
      expect(state.history.logs.length, 1);
      expect(state.history.unitSystem, 'metric');
    });

    test('addWeight in metric kg saves exact weight and updates history', () async {
      final newLog = WeightLogEntity(
        id: 2,
        weightKg: 74.5,
        loggedAt: testDate,
      );

      when(() => mockRepo.logWeight(
            weightKg: 74.5,
            date: any(named: 'date'),
            loggedAt: any(named: 'loggedAt'),
            syncProfile: any(named: 'syncProfile'),
          )).thenAnswer((_) async => newLog);

      final notifier = container.read(weightNotifierProvider.notifier);
      await notifier.loadHistory();

      final success = await notifier.addWeight(
        value: 74.5,
        unitSystem: 'metric',
        date: testDate,
      );

      expect(success, isTrue);
      final state = container.read(weightNotifierProvider);
      expect(state.history.currentWeightKg, 74.5);
      expect(state.history.logs.length, 2);
      expect(state.history.logs.last.weightKg, 74.5);
      verify(() => mockRepo.logWeight(
            weightKg: 74.5,
            date: '2026-10-02',
            loggedAt: testDate,
            syncProfile: true,
          )).called(1);
    });

    test('addWeight in imperial lb accurately converts to metric kg', () async {
      // 160 lbs = 160 / 2.20462 = 72.57 kg
      const inputLbs = 160.0;
      final expectedKg = double.parse((inputLbs / 2.20462).toStringAsFixed(2));

      final convertedLog = WeightLogEntity(
        id: 3,
        weightKg: expectedKg,
        loggedAt: testDate,
      );

      when(() => mockRepo.logWeight(
            weightKg: expectedKg,
            date: any(named: 'date'),
            loggedAt: any(named: 'loggedAt'),
            syncProfile: any(named: 'syncProfile'),
          )).thenAnswer((_) async => convertedLog);

      final notifier = container.read(weightNotifierProvider.notifier);
      await notifier.loadHistory();

      final success = await notifier.addWeight(
        value: inputLbs,
        unitSystem: 'imperial',
        date: testDate,
      );

      expect(success, isTrue);
      final state = container.read(weightNotifierProvider);
      expect(state.history.currentWeightKg, expectedKg);
      verify(() => mockRepo.logWeight(
            weightKg: expectedKg,
            date: '2026-10-02',
            loggedAt: testDate,
            syncProfile: true,
          )).called(1);
    });

    test('deleteWeight removes entry and updates current weight', () async {
      when(() => mockRepo.deleteWeight(1)).thenAnswer((_) async {});

      final notifier = container.read(weightNotifierProvider.notifier);
      await notifier.loadHistory();

      final success = await notifier.deleteWeight(1);

      expect(success, isTrue);
      final state = container.read(weightNotifierProvider);
      expect(state.history.logs, isEmpty);
      expect(state.history.currentWeightKg, isNull);
      verify(() => mockRepo.deleteWeight(1)).called(1);
    });
  });
}
