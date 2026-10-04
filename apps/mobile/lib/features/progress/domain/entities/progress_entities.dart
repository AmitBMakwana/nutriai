import 'package:freezed_annotation/freezed_annotation.dart';

part 'progress_entities.freezed.dart';

// ─── Daily calorie point ─────────────────────────────────────────────────────

@freezed
abstract class DailyCaloriePoint with _$DailyCaloriePoint {
  const factory DailyCaloriePoint({
    required DateTime date,
    required int consumed,
    required int target,
  }) = _DailyCaloriePoint;
}

// ─── Macro averages ──────────────────────────────────────────────────────────

@freezed
abstract class MacroAverages with _$MacroAverages {
  const factory MacroAverages({
    @Default(0) int calories,
    @Default(0.0) double protein,
    @Default(0.0) double carbs,
    @Default(0.0) double fat,
  }) = _MacroAverages;
}

// ─── Macro targets ───────────────────────────────────────────────────────────

@freezed
abstract class MacroTargets with _$MacroTargets {
  const factory MacroTargets({
    @Default(150.0) double protein,
    @Default(200.0) double carbs,
    @Default(67.0) double fat,
  }) = _MacroTargets;
}

// ─── Weight series point ─────────────────────────────────────────────────────

@freezed
abstract class WeightPoint with _$WeightPoint {
  const factory WeightPoint({
    required DateTime date,
    required double weightKg,
  }) = _WeightPoint;
}

// ─── Weight progress summary (plain Dart for direct field access) ─────────────

class WeightProgress {
  final List<WeightPoint> series;
  final double? startKg;
  final double? currentKg;
  final double? targetKg;
  final double? changeKg;

  const WeightProgress({
    this.series = const [],
    this.startKg,
    this.currentKg,
    this.targetKg,
    this.changeKg,
  });

  static const empty = WeightProgress();
}

// ─── Main progress data ──────────────────────────────────────────────────────

@freezed
abstract class ProgressData with _$ProgressData {
  const factory ProgressData({
    required String range,
    required DateTime start,
    required DateTime end,
    required List<DailyCaloriePoint> calorieDaily,
    required int calorieAverage,
    required int calorieTarget,
    required MacroAverages macroAverages,
    required MacroTargets macroTargets,
    required WeightProgress weight,
    required int mealsTracked,
    required int daysOnTarget,
    required int activeDays,
    required int streak,
  }) = _ProgressData;
}

// ─── Daily summary point (weekly/monthly) ────────────────────────────────────

@freezed
abstract class DailySummaryPoint with _$DailySummaryPoint {
  const factory DailySummaryPoint({
    required DateTime date,
    required int calories,
    required double protein,
    required double carbs,
    required double fat,
    required double fiber,
    required int waterMl,
    required int mealsCount,
  }) = _DailySummaryPoint;
}

// ─── Weekly progress ─────────────────────────────────────────────────────────

@freezed
abstract class WeeklyProgress with _$WeeklyProgress {
  const factory WeeklyProgress({
    required DateTime weekStart,
    required DateTime weekEnd,
    required List<DailySummaryPoint> days,
    required MacroAverages totals,
    required MacroAverages averages,
    required int calorieTarget,
  }) = _WeeklyProgress;
}

// ─── Monthly progress ────────────────────────────────────────────────────────

@freezed
abstract class MonthlyProgress with _$MonthlyProgress {
  const factory MonthlyProgress({
    required int year,
    required int month,
    required List<DailySummaryPoint> days,
    required MacroAverages averages,
    required int calorieTarget,
    required int daysOnTarget,
    required int activeDays,
  }) = _MonthlyProgress;
}
