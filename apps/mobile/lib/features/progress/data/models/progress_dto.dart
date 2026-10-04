import 'package:freezed_annotation/freezed_annotation.dart';

part 'progress_dto.g.dart';
part 'progress_dto.freezed.dart';

// ─── Daily calorie point ─────────────────────────────────────────────────────

@freezed
abstract class DailyCaloriePointDto with _$DailyCaloriePointDto {
  const factory DailyCaloriePointDto({
    required String date,
    required int consumed,
    required int target,
  }) = _DailyCaloriePointDto;

  factory DailyCaloriePointDto.fromJson(Map<String, dynamic> json) =>
      _$DailyCaloriePointDtoFromJson(json);
}

// ─── Macro averages ──────────────────────────────────────────────────────────

@freezed
abstract class MacroAveragesDto with _$MacroAveragesDto {
  const factory MacroAveragesDto({
    required int calories,
    required double protein,
    required double carbs,
    required double fat,
  }) = _MacroAveragesDto;

  factory MacroAveragesDto.fromJson(Map<String, dynamic> json) =>
      _$MacroAveragesDtoFromJson(json);
}

@freezed
abstract class MacroTargetsDto with _$MacroTargetsDto {
  const factory MacroTargetsDto({
    required double protein,
    required double carbs,
    required double fat,
  }) = _MacroTargetsDto;

  factory MacroTargetsDto.fromJson(Map<String, dynamic> json) =>
      _$MacroTargetsDtoFromJson(json);
}

@freezed
abstract class MacroProgressDto with _$MacroProgressDto {
  const factory MacroProgressDto({
    required MacroAveragesDto average,
    required MacroTargetsDto target,
  }) = _MacroProgressDto;

  factory MacroProgressDto.fromJson(Map<String, dynamic> json) =>
      _$MacroProgressDtoFromJson(json);
}

// ─── Weight point ────────────────────────────────────────────────────────────

@freezed
abstract class WeightPointDto with _$WeightPointDto {
  const factory WeightPointDto({
    required String date,
    @JsonKey(name: 'weight_kg') required double weightKg,
  }) = _WeightPointDto;

  factory WeightPointDto.fromJson(Map<String, dynamic> json) =>
      _$WeightPointDtoFromJson(json);
}

@freezed
abstract class WeightProgressDto with _$WeightProgressDto {
  const factory WeightProgressDto({
    required List<WeightPointDto> series,
    @JsonKey(name: 'start_kg') double? startKg,
    @JsonKey(name: 'current_kg') double? currentKg,
    @JsonKey(name: 'target_kg') double? targetKg,
    @JsonKey(name: 'change_kg') double? changeKg,
  }) = _WeightProgressDto;

  factory WeightProgressDto.fromJson(Map<String, dynamic> json) =>
      _$WeightProgressDtoFromJson(json);
}

// ─── Calories progress ───────────────────────────────────────────────────────

@freezed
abstract class CaloriesProgressDto with _$CaloriesProgressDto {
  const factory CaloriesProgressDto({
    required List<DailyCaloriePointDto> daily,
    required int average,
    required int target,
  }) = _CaloriesProgressDto;

  factory CaloriesProgressDto.fromJson(Map<String, dynamic> json) =>
      _$CaloriesProgressDtoFromJson(json);
}

// ─── Top-level progress response ─────────────────────────────────────────────

@freezed
abstract class ProgressDto with _$ProgressDto {
  const factory ProgressDto({
    required String range,
    required String start,
    required String end,
    required CaloriesProgressDto calories,
    required MacroProgressDto macros,
    required WeightProgressDto weight,
    @JsonKey(name: 'meals_tracked') required int mealsTracked,
    @JsonKey(name: 'days_on_target') required int daysOnTarget,
    @JsonKey(name: 'active_days') required int activeDays,
    required int streak,
  }) = _ProgressDto;

  factory ProgressDto.fromJson(Map<String, dynamic> json) =>
      _$ProgressDtoFromJson(json);
}

// ─── Daily summary point (weekly/monthly) ────────────────────────────────────

@freezed
abstract class DailySummaryPointDto with _$DailySummaryPointDto {
  const factory DailySummaryPointDto({
    required String date,
    required int calories,
    required double protein,
    required double carbs,
    required double fat,
    required double fiber,
    @JsonKey(name: 'water_ml') required int waterMl,
    @JsonKey(name: 'meals_count') required int mealsCount,
  }) = _DailySummaryPointDto;

  factory DailySummaryPointDto.fromJson(Map<String, dynamic> json) =>
      _$DailySummaryPointDtoFromJson(json);
}

@freezed
abstract class WeeklyProgressDto with _$WeeklyProgressDto {
  const factory WeeklyProgressDto({
    @JsonKey(name: 'week_start') required String weekStart,
    @JsonKey(name: 'week_end') required String weekEnd,
    required List<DailySummaryPointDto> days,
    required MacroAveragesDto totals,
    required MacroAveragesDto averages,
    @JsonKey(name: 'calorie_target') required int calorieTarget,
  }) = _WeeklyProgressDto;

  factory WeeklyProgressDto.fromJson(Map<String, dynamic> json) =>
      _$WeeklyProgressDtoFromJson(json);
}

@freezed
abstract class MonthlyProgressDto with _$MonthlyProgressDto {
  const factory MonthlyProgressDto({
    required int year,
    required int month,
    required List<DailySummaryPointDto> days,
    required MacroAveragesDto averages,
    @JsonKey(name: 'calorie_target') required int calorieTarget,
    @JsonKey(name: 'days_on_target') required int daysOnTarget,
    @JsonKey(name: 'active_days') required int activeDays,
  }) = _MonthlyProgressDto;

  factory MonthlyProgressDto.fromJson(Map<String, dynamic> json) =>
      _$MonthlyProgressDtoFromJson(json);
}
