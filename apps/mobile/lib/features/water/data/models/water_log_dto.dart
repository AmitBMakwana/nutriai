import '../../domain/entities/water_log_entity.dart';

class WaterLogDto {
  final int id;
  final int amountMl;
  final String loggedAt;

  const WaterLogDto({
    required this.id,
    required this.amountMl,
    required this.loggedAt,
  });

  factory WaterLogDto.fromJson(Map<String, dynamic> json) {
    return WaterLogDto(
      id: (json['id'] as num).toInt(),
      amountMl: (json['amount_ml'] as num).toInt(),
      loggedAt: json['logged_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount_ml': amountMl,
      'logged_at': loggedAt,
    };
  }

  WaterLogEntity toDomain() {
    return WaterLogEntity(
      id: id,
      amountMl: amountMl,
      loggedAt: DateTime.tryParse(loggedAt) ?? DateTime.now(),
    );
  }
}

class WaterDailyDataDto {
  final String date;
  final int totalMl;
  final List<WaterLogDto> logs;

  const WaterDailyDataDto({
    required this.date,
    required this.totalMl,
    required this.logs,
  });

  factory WaterDailyDataDto.fromJson(Map<String, dynamic> json) {
    final rawLogs = json['logs'] as List<dynamic>? ?? [];
    return WaterDailyDataDto(
      date: json['date'] as String? ?? '',
      totalMl: (json['total_ml'] as num?)?.toInt() ?? 0,
      logs: rawLogs
          .map((item) => WaterLogDto.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
