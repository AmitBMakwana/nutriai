// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DailyCaloriePointDto _$DailyCaloriePointDtoFromJson(
  Map<String, dynamic> json,
) => _DailyCaloriePointDto(
  date: json['date'] as String,
  consumed: (json['consumed'] as num).toInt(),
  target: (json['target'] as num).toInt(),
);

Map<String, dynamic> _$DailyCaloriePointDtoToJson(
  _DailyCaloriePointDto instance,
) => <String, dynamic>{
  'date': instance.date,
  'consumed': instance.consumed,
  'target': instance.target,
};

_MacroAveragesDto _$MacroAveragesDtoFromJson(Map<String, dynamic> json) =>
    _MacroAveragesDto(
      calories: (json['calories'] as num).toInt(),
      protein: (json['protein'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
    );

Map<String, dynamic> _$MacroAveragesDtoToJson(_MacroAveragesDto instance) =>
    <String, dynamic>{
      'calories': instance.calories,
      'protein': instance.protein,
      'carbs': instance.carbs,
      'fat': instance.fat,
    };

_MacroTargetsDto _$MacroTargetsDtoFromJson(Map<String, dynamic> json) =>
    _MacroTargetsDto(
      protein: (json['protein'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
    );

Map<String, dynamic> _$MacroTargetsDtoToJson(_MacroTargetsDto instance) =>
    <String, dynamic>{
      'protein': instance.protein,
      'carbs': instance.carbs,
      'fat': instance.fat,
    };

_MacroProgressDto _$MacroProgressDtoFromJson(Map<String, dynamic> json) =>
    _MacroProgressDto(
      average: MacroAveragesDto.fromJson(
        json['average'] as Map<String, dynamic>,
      ),
      target: MacroTargetsDto.fromJson(json['target'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MacroProgressDtoToJson(_MacroProgressDto instance) =>
    <String, dynamic>{'average': instance.average, 'target': instance.target};

_WeightPointDto _$WeightPointDtoFromJson(Map<String, dynamic> json) =>
    _WeightPointDto(
      date: json['date'] as String,
      weightKg: (json['weight_kg'] as num).toDouble(),
    );

Map<String, dynamic> _$WeightPointDtoToJson(_WeightPointDto instance) =>
    <String, dynamic>{'date': instance.date, 'weight_kg': instance.weightKg};

_WeightProgressDto _$WeightProgressDtoFromJson(Map<String, dynamic> json) =>
    _WeightProgressDto(
      series: (json['series'] as List<dynamic>)
          .map((e) => WeightPointDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      startKg: (json['start_kg'] as num?)?.toDouble(),
      currentKg: (json['current_kg'] as num?)?.toDouble(),
      targetKg: (json['target_kg'] as num?)?.toDouble(),
      changeKg: (json['change_kg'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$WeightProgressDtoToJson(_WeightProgressDto instance) =>
    <String, dynamic>{
      'series': instance.series,
      'start_kg': instance.startKg,
      'current_kg': instance.currentKg,
      'target_kg': instance.targetKg,
      'change_kg': instance.changeKg,
    };

_CaloriesProgressDto _$CaloriesProgressDtoFromJson(Map<String, dynamic> json) =>
    _CaloriesProgressDto(
      daily: (json['daily'] as List<dynamic>)
          .map((e) => DailyCaloriePointDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      average: (json['average'] as num).toInt(),
      target: (json['target'] as num).toInt(),
    );

Map<String, dynamic> _$CaloriesProgressDtoToJson(
  _CaloriesProgressDto instance,
) => <String, dynamic>{
  'daily': instance.daily,
  'average': instance.average,
  'target': instance.target,
};

_ProgressDto _$ProgressDtoFromJson(Map<String, dynamic> json) => _ProgressDto(
  range: json['range'] as String,
  start: json['start'] as String,
  end: json['end'] as String,
  calories: CaloriesProgressDto.fromJson(
    json['calories'] as Map<String, dynamic>,
  ),
  macros: MacroProgressDto.fromJson(json['macros'] as Map<String, dynamic>),
  weight: WeightProgressDto.fromJson(json['weight'] as Map<String, dynamic>),
  mealsTracked: (json['meals_tracked'] as num).toInt(),
  daysOnTarget: (json['days_on_target'] as num).toInt(),
  activeDays: (json['active_days'] as num).toInt(),
  streak: (json['streak'] as num).toInt(),
);

Map<String, dynamic> _$ProgressDtoToJson(_ProgressDto instance) =>
    <String, dynamic>{
      'range': instance.range,
      'start': instance.start,
      'end': instance.end,
      'calories': instance.calories,
      'macros': instance.macros,
      'weight': instance.weight,
      'meals_tracked': instance.mealsTracked,
      'days_on_target': instance.daysOnTarget,
      'active_days': instance.activeDays,
      'streak': instance.streak,
    };

_DailySummaryPointDto _$DailySummaryPointDtoFromJson(
  Map<String, dynamic> json,
) => _DailySummaryPointDto(
  date: json['date'] as String,
  calories: (json['calories'] as num).toInt(),
  protein: (json['protein'] as num).toDouble(),
  carbs: (json['carbs'] as num).toDouble(),
  fat: (json['fat'] as num).toDouble(),
  fiber: (json['fiber'] as num).toDouble(),
  waterMl: (json['water_ml'] as num).toInt(),
  mealsCount: (json['meals_count'] as num).toInt(),
);

Map<String, dynamic> _$DailySummaryPointDtoToJson(
  _DailySummaryPointDto instance,
) => <String, dynamic>{
  'date': instance.date,
  'calories': instance.calories,
  'protein': instance.protein,
  'carbs': instance.carbs,
  'fat': instance.fat,
  'fiber': instance.fiber,
  'water_ml': instance.waterMl,
  'meals_count': instance.mealsCount,
};

_WeeklyProgressDto _$WeeklyProgressDtoFromJson(Map<String, dynamic> json) =>
    _WeeklyProgressDto(
      weekStart: json['week_start'] as String,
      weekEnd: json['week_end'] as String,
      days: (json['days'] as List<dynamic>)
          .map((e) => DailySummaryPointDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      totals: MacroAveragesDto.fromJson(json['totals'] as Map<String, dynamic>),
      averages: MacroAveragesDto.fromJson(
        json['averages'] as Map<String, dynamic>,
      ),
      calorieTarget: (json['calorie_target'] as num).toInt(),
    );

Map<String, dynamic> _$WeeklyProgressDtoToJson(_WeeklyProgressDto instance) =>
    <String, dynamic>{
      'week_start': instance.weekStart,
      'week_end': instance.weekEnd,
      'days': instance.days,
      'totals': instance.totals,
      'averages': instance.averages,
      'calorie_target': instance.calorieTarget,
    };

_MonthlyProgressDto _$MonthlyProgressDtoFromJson(Map<String, dynamic> json) =>
    _MonthlyProgressDto(
      year: (json['year'] as num).toInt(),
      month: (json['month'] as num).toInt(),
      days: (json['days'] as List<dynamic>)
          .map((e) => DailySummaryPointDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      averages: MacroAveragesDto.fromJson(
        json['averages'] as Map<String, dynamic>,
      ),
      calorieTarget: (json['calorie_target'] as num).toInt(),
      daysOnTarget: (json['days_on_target'] as num).toInt(),
      activeDays: (json['active_days'] as num).toInt(),
    );

Map<String, dynamic> _$MonthlyProgressDtoToJson(_MonthlyProgressDto instance) =>
    <String, dynamic>{
      'year': instance.year,
      'month': instance.month,
      'days': instance.days,
      'averages': instance.averages,
      'calorie_target': instance.calorieTarget,
      'days_on_target': instance.daysOnTarget,
      'active_days': instance.activeDays,
    };
