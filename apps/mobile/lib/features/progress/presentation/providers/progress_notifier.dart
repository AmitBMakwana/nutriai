import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/progress_entities.dart';
import '../../data/datasources/progress_api.dart';
import '../../data/repositories/progress_repository.dart';
import '../../../../core/network/dio_client.dart';

// ─── State ───────────────────────────────────────────────────────────────────

class ProgressState {
  final ProgressData? data;
  final WeeklyProgress? weekly;
  final MonthlyProgress? monthly;
  final String selectedRange;
  final bool isLoading;
  final String? errorMessage;

  const ProgressState({
    this.data,
    this.weekly,
    this.monthly,
    this.selectedRange = '7d',
    this.isLoading = false,
    this.errorMessage,
  });

  ProgressState copyWith({
    ProgressData? data,
    WeeklyProgress? weekly,
    MonthlyProgress? monthly,
    String? selectedRange,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ProgressState(
      data: data ?? this.data,
      weekly: weekly ?? this.weekly,
      monthly: monthly ?? this.monthly,
      selectedRange: selectedRange ?? this.selectedRange,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

// ─── Repository provider (overrideable in tests) ─────────────────────────────

final progressRepositoryProvider = Provider<IProgressRepository>((ref) {
  final dioClient = ref.read(dioClientProvider);
  return ProgressRepository(ProgressApi(dioClient));
});

// ─── Notifier provider ───────────────────────────────────────────────────────

final progressNotifierProvider =
    NotifierProvider<ProgressNotifier, ProgressState>(ProgressNotifier.new);

// ─── Notifier ────────────────────────────────────────────────────────────────

class ProgressNotifier extends Notifier<ProgressState> {
  late final IProgressRepository _repository;

  @override
  ProgressState build() {
    _repository = ref.read(progressRepositoryProvider);
    // Auto-load on first build
    Future.microtask(loadProgress);
    return const ProgressState();
  }

  /// Load main range progress (default 7d)
  Future<void> loadProgress({String? range}) async {
    final r = range ?? state.selectedRange;
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final data = await _repository.getProgress(range: r);
      state = state.copyWith(
        data: data,
        selectedRange: r,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _friendly(e),
      );
    }
  }

  /// Change the selected range and reload
  Future<void> selectRange(String range) => loadProgress(range: range);

  /// Load weekly summary
  Future<void> loadWeekly() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final weekly = await _repository.getWeekly();
      state = state.copyWith(weekly: weekly, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: _friendly(e));
    }
  }

  /// Load monthly summary
  Future<void> loadMonthly({int? year, int? month}) async {
    final now = DateTime.now();
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final monthly = await _repository.getMonthly(
        year: year ?? now.year,
        month: month ?? now.month,
      );
      state = state.copyWith(monthly: monthly, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: _friendly(e));
    }
  }

  String _friendly(Object e) {
    final msg = e.toString().toLowerCase();
    if (msg.contains('connection') || msg.contains('network') || msg.contains('socket')) {
      return 'No internet connection. Please try again.';
    }
    if (msg.contains('timeout')) {
      return 'Request timed out. Please try again.';
    }
    return 'Could not load progress data. Please try again.';
  }
}
