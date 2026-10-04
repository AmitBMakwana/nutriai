import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../../domain/usecases/get_dashboard_usecase.dart';

final getDashboardUseCaseProvider = Provider<GetDashboardUseCase>((ref) {
  final repo = ref.watch(dashboardRepositoryProvider);
  return GetDashboardUseCase(repo);
});

final selectedDateProvider =
    NotifierProvider<SelectedDateNotifier, DateTime>(SelectedDateNotifier.new);

class SelectedDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  void setDate(DateTime date) {
    state = DateTime(date.year, date.month, date.day);
  }

  void previousDay() {
    state = state.subtract(const Duration(days: 1));
  }

  void nextDay() {
    state = state.add(const Duration(days: 1));
  }

  void today() {
    final now = DateTime.now();
    state = DateTime(now.year, now.month, now.day);
  }
}

final dashboardProvider =
    AsyncNotifierProvider<DashboardNotifier, DashboardEntity>(
  DashboardNotifier.new,
);

class DashboardNotifier extends AsyncNotifier<DashboardEntity> {
  @override
  Future<DashboardEntity> build() async {
    final date = ref.watch(selectedDateProvider);
    final dateString = DateFormat('yyyy-MM-dd').format(date);
    final useCase = ref.watch(getDashboardUseCaseProvider);
    return useCase(date: dateString);
  }

  void selectDate(DateTime newDate) {
    ref.read(selectedDateProvider.notifier).setDate(newDate);
  }

  void previousDay() {
    ref.read(selectedDateProvider.notifier).previousDay();
  }

  void nextDay() {
    ref.read(selectedDateProvider.notifier).nextDay();
  }

  void goToToday() {
    ref.read(selectedDateProvider.notifier).today();
  }

  Future<void> refreshDashboard() async {
    ref.invalidateSelf();
    await future;
  }
}
