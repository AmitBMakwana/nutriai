import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/weight_history_entity.dart';
import '../../domain/repositories/weight_repository.dart';
import '../../data/repositories/weight_repository_impl.dart';

class WeightState {
  final WeightHistoryEntity history;
  final bool isLoading;
  final bool isSaving;
  final bool isDeleting;
  final String? errorMessage;

  const WeightState({
    this.history = const WeightHistoryEntity(),
    this.isLoading = false,
    this.isSaving = false,
    this.isDeleting = false,
    this.errorMessage,
  });

  WeightState copyWith({
    WeightHistoryEntity? history,
    bool? isLoading,
    bool? isSaving,
    bool? isDeleting,
    String? errorMessage,
  }) {
    return WeightState(
      history: history ?? this.history,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      isDeleting: isDeleting ?? this.isDeleting,
      errorMessage: errorMessage,
    );
  }
}

final weightNotifierProvider =
    NotifierProvider<WeightNotifier, WeightState>(WeightNotifier.new);

class WeightNotifier extends Notifier<WeightState> {
  IWeightRepository get _repo => ref.read(weightRepositoryProvider);

  @override
  WeightState build() {
    Future.microtask(() => loadHistory());
    return const WeightState(isLoading: true);
  }

  Future<void> loadHistory() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final history = await _repo.getWeightHistory();
      state = state.copyWith(
        history: history,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Adds a new weight log.
  /// If [unitSystem] is 'imperial', converts [value] (in lbs) to kg before sending to backend.
  Future<bool> addWeight({
    required double value,
    required String unitSystem,
    required DateTime date,
    bool syncProfile = true,
  }) async {
    state = state.copyWith(isSaving: true, errorMessage: null);

    // Convert to metric kg if entered in imperial lbs
    final double metricKg = unitSystem.toLowerCase() == 'imperial'
        ? value / 2.20462
        : value;

    final dateString = DateFormat('yyyy-MM-dd').format(date);

    try {
      final newLog = await _repo.logWeight(
        weightKg: double.parse(metricKg.toStringAsFixed(2)),
        date: dateString,
        loggedAt: date,
        syncProfile: syncProfile,
      );

      // Re-sort logs chronologically
      final updatedLogs = [...state.history.logs, newLog]
        ..sort((a, b) => a.loggedAt.compareTo(b.loggedAt));

      final updatedHistory = state.history.copyWith(
        currentWeightKg: syncProfile ? newLog.weightKg : state.history.currentWeightKg,
        logs: updatedLogs,
      );

      state = state.copyWith(
        history: updatedHistory,
        isSaving: false,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Deletes a weight entry by [id].
  Future<bool> deleteWeight(int id) async {
    state = state.copyWith(isDeleting: true, errorMessage: null);
    try {
      await _repo.deleteWeight(id);

      final updatedLogs = state.history.logs.where((l) => l.id != id).toList();
      final newCurrent = updatedLogs.isNotEmpty ? updatedLogs.last.weightKg : null;

      final updatedHistory = state.history.copyWith(
        currentWeightKg: newCurrent,
        logs: updatedLogs,
      );

      state = state.copyWith(
        history: updatedHistory,
        isDeleting: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isDeleting: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }
}
