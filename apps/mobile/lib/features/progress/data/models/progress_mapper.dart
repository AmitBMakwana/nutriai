import '../../domain/entities/progress_entities.dart';
import '../../data/models/progress_dto.dart';

/// Maps DTOs → domain entities
class ProgressMapper {
  static ProgressData fromDto(ProgressDto dto) {
    return ProgressData(
      range: dto.range,
      start: DateTime.parse(dto.start),
      end: DateTime.parse(dto.end),
      calorieDaily: dto.calories.daily
          .map(
            (p) => DailyCaloriePoint(
              date: DateTime.parse(p.date),
              consumed: p.consumed,
              target: p.target,
            ),
          )
          .toList(),
      calorieAverage: dto.calories.average,
      calorieTarget: dto.calories.target,
      macroAverages: MacroAverages(
        calories: dto.macros.average.calories,
        protein: dto.macros.average.protein,
        carbs: dto.macros.average.carbs,
        fat: dto.macros.average.fat,
      ),
      macroTargets: MacroTargets(
        protein: dto.macros.target.protein,
        carbs: dto.macros.target.carbs,
        fat: dto.macros.target.fat,
      ),
      weight: _mapWeight(dto.weight),
      mealsTracked: dto.mealsTracked,
      daysOnTarget: dto.daysOnTarget,
      activeDays: dto.activeDays,
      streak: dto.streak,
    );
  }

  static WeightProgress _mapWeight(WeightProgressDto w) {
    return WeightProgress(
      series: w.series
          .map((p) => WeightPoint(
                date: DateTime.parse(p.date),
                weightKg: p.weightKg,
              ))
          .toList(),
      startKg: w.startKg,
      currentKg: w.currentKg,
      targetKg: w.targetKg,
      changeKg: w.changeKg,
    );
  }

  static DailySummaryPoint _mapDay(DailySummaryPointDto d) {
    return DailySummaryPoint(
      date: DateTime.parse(d.date),
      calories: d.calories,
      protein: d.protein,
      carbs: d.carbs,
      fat: d.fat,
      fiber: d.fiber,
      waterMl: d.waterMl,
      mealsCount: d.mealsCount,
    );
  }

  static MacroAverages _mapAvg(MacroAveragesDto a) {
    return MacroAverages(
      calories: a.calories,
      protein: a.protein,
      carbs: a.carbs,
      fat: a.fat,
    );
  }

  static WeeklyProgress fromWeeklyDto(WeeklyProgressDto dto) {
    return WeeklyProgress(
      weekStart: DateTime.parse(dto.weekStart),
      weekEnd: DateTime.parse(dto.weekEnd),
      days: dto.days.map(_mapDay).toList(),
      totals: _mapAvg(dto.totals),
      averages: _mapAvg(dto.averages),
      calorieTarget: dto.calorieTarget,
    );
  }

  static MonthlyProgress fromMonthlyDto(MonthlyProgressDto dto) {
    return MonthlyProgress(
      year: dto.year,
      month: dto.month,
      days: dto.days.map(_mapDay).toList(),
      averages: _mapAvg(dto.averages),
      calorieTarget: dto.calorieTarget,
      daysOnTarget: dto.daysOnTarget,
      activeDays: dto.activeDays,
    );
  }
}
