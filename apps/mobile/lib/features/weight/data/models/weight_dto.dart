import '../../domain/entities/weight_history_entity.dart';
import '../../domain/entities/weight_log_entity.dart';

class WeightLogDto {
  final int id;
  final double weightKg;
  final String loggedAt;

  const WeightLogDto({
    required this.id,
    required this.weightKg,
    required this.loggedAt,
  });

  factory WeightLogDto.fromJson(Map<String, dynamic> json) {
    return WeightLogDto(
      id: (json['id'] as num).toInt(),
      weightKg: (json['weight_kg'] as num).toDouble(),
      loggedAt: json['logged_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'weight_kg': weightKg,
      'logged_at': loggedAt,
    };
  }

  WeightLogEntity toDomain() {
    return WeightLogEntity(
      id: id,
      weightKg: weightKg,
      loggedAt: DateTime.tryParse(loggedAt) ?? DateTime.now(),
    );
  }
}

class WeightHistoryDto {
  final double? currentWeightKg;
  final double? targetWeightKg;
  final String unitSystem;
  final List<WeightLogDto> logs;

  const WeightHistoryDto({
    this.currentWeightKg,
    this.targetWeightKg,
    this.unitSystem = 'metric',
    this.logs = const [],
  });

  factory WeightHistoryDto.fromJson(Map<String, dynamic> json) {
    final rawLogs = json['logs'] as List<dynamic>? ?? [];
    return WeightHistoryDto(
      currentWeightKg: (json['current_weight_kg'] as num?)?.toDouble(),
      targetWeightKg: (json['target_weight_kg'] as num?)?.toDouble(),
      unitSystem: json['unit_system'] as String? ?? 'metric',
      logs: rawLogs
          .map((item) => WeightLogDto.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  WeightHistoryEntity toDomain() {
    return WeightHistoryEntity(
      currentWeightKg: currentWeightKg,
      targetWeightKg: targetWeightKg,
      unitSystem: unitSystem,
      logs: logs.map((dto) => dto.toDomain()).toList(),
    );
  }
}
