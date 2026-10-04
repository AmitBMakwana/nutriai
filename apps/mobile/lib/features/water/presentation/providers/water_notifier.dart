import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';
import '../../domain/entities/water_log_entity.dart';
import '../../domain/repositories/water_repository.dart';
import '../../data/repositories/water_repository_impl.dart';

class WaterState {
  final int consumedMl;
  final int targetMl;
  final List<WaterLogEntity> logs;
  final bool isLoading;
  final bool isLogging;
  final String? errorMessage;

  const WaterState({
    this.consumedMl = 0,
    this.targetMl = 2500,
    this.logs = const [],
    this.isLoading = false,
    this.isLogging = false,
    this.errorMessage,
  });

  double get progressFraction => targetMl > 0 ? (consumedMl / targetMl).clamp(0.0, 1.0) : 0.0;
  bool get canUndo => logs.isNotEmpty || consumedMl > 0;

  WaterState copyWith({
    int? consumedMl,
    int? targetMl,
    List<WaterLogEntity>? logs,
    bool? isLoading,
    bool? isLogging,
    String? errorMessage,
  }) {
    return WaterState(
      consumedMl: consumedMl ?? this.consumedMl,
      targetMl: targetMl ?? this.targetMl,
      logs: logs ?? this.logs,
      isLoading: isLoading ?? this.isLoading,
      isLogging: isLogging ?? this.isLogging,
      errorMessage: errorMessage,
    );
  }
}

final waterNotifierProvider =
    NotifierProvider<WaterNotifier, WaterState>(WaterNotifier.new);

class WaterNotifier extends Notifier<WaterState> {
  IWaterRepository get _repo => ref.read(waterRepositoryProvider);

  @override
  WaterState build() {
    // Sync initial target and consumption from dashboard if available
    final dashState = ref.read(dashboardProvider).asData?.value;
    final initialConsumed = dashState?.water.consumed ?? 0;
    final initialTarget = dashState?.water.target ?? 2500;

    return WaterState(
      consumedMl: initialConsumed,
      targetMl: initialTarget,
      isLoading: false,
    );
  }

  Future<void> loadWater(String dateString) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final result = await _repo.getWaterLogs(date: dateString);
      if (!ref.mounted) return;
      state = state.copyWith(
        consumedMl: result.totalMl,
        logs: result.logs,
        isLoading: false,
      );
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Quick-add water amount (250, 500, 750, 1000 ml).
  Future<bool> quickAdd(int amountMl) async {
    final date = ref.read(selectedDateProvider);
    final dateString = DateFormat('yyyy-MM-dd').format(date);

    // Optimistic UI update
    final prevConsumed = state.consumedMl;
    state = state.copyWith(
      consumedMl: prevConsumed + amountMl,
      isLogging: true,
      errorMessage: null,
    );

    try {
      final result = await _repo.logWater(
        amountMl: amountMl,
        date: dateString,
      );

      if (!ref.mounted) return true;
      final updatedLogs = [result.log, ...state.logs];
      state = state.copyWith(
        consumedMl: result.totalMl,
        logs: updatedLogs,
        isLogging: false,
      );

      // Refresh Dashboard summary
      ref.invalidate(dashboardProvider);
      return true;
    } catch (e) {
      if (!ref.mounted) return false;
      // Revert on error
      state = state.copyWith(
        consumedMl: prevConsumed,
        isLogging: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Undo the last logged water entry.
  Future<bool> undoLast() async {
    if (!state.canUndo) return false;

    final date = ref.read(selectedDateProvider);
    final dateString = DateFormat('yyyy-MM-dd').format(date);
    final targetId = state.logs.isNotEmpty ? state.logs.first.id : null;

    final prevConsumed = state.consumedMl;
    final prevLogs = List<WaterLogEntity>.from(state.logs);

    state = state.copyWith(isLogging: true, errorMessage: null);

    try {
      final result = await _repo.deleteWater(
        id: targetId,
        date: dateString,
      );

      if (!ref.mounted) return true;
      final remainingLogs = state.logs.where((l) => l.id != result.deletedLog?.id).toList();
      state = state.copyWith(
        consumedMl: result.totalMl,
        logs: remainingLogs,
        isLogging: false,
      );

      // Refresh Dashboard summary
      ref.invalidate(dashboardProvider);
      return true;
    } catch (e) {
      if (!ref.mounted) return false;
      state = state.copyWith(
        consumedMl: prevConsumed,
        logs: prevLogs,
        isLogging: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }
}
