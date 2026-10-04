import 'weight_log_entity.dart';

/// Entity representing full weight tracking history, current status, and goals.
class WeightHistoryEntity {
  final double? currentWeightKg;
  final double? targetWeightKg;
  final String unitSystem;
  final List<WeightLogEntity> logs;

  const WeightHistoryEntity({
    this.currentWeightKg,
    this.targetWeightKg,
    this.unitSystem = 'metric',
    this.logs = const [],
  });

  bool get isImperial => unitSystem.toLowerCase() == 'imperial';
  String get unitLabel => isImperial ? 'lb' : 'kg';

  double? get displayCurrentWeight => currentWeightKg != null
      ? (isImperial ? currentWeightKg! * 2.20462 : currentWeightKg)
      : null;

  double? get displayTargetWeight => targetWeightKg != null
      ? (isImperial ? targetWeightKg! * 2.20462 : targetWeightKg)
      : null;

  String get formattedCurrentWeight => displayCurrentWeight != null
      ? displayCurrentWeight!.toStringAsFixed(1)
      : '--';

  String get formattedTargetWeight => displayTargetWeight != null
      ? displayTargetWeight!.toStringAsFixed(1)
      : '--';

  /// Weight difference to target (positive if above target, negative if below).
  double? get differenceToTarget {
    if (displayCurrentWeight == null || displayTargetWeight == null) return null;
    return displayCurrentWeight! - displayTargetWeight!;
  }

  static const _sentinel = Object();

  WeightHistoryEntity copyWith({
    Object? currentWeightKg = _sentinel,
    Object? targetWeightKg = _sentinel,
    String? unitSystem,
    List<WeightLogEntity>? logs,
  }) {
    return WeightHistoryEntity(
      currentWeightKg: identical(currentWeightKg, _sentinel)
          ? this.currentWeightKg
          : currentWeightKg as double?,
      targetWeightKg: identical(targetWeightKg, _sentinel)
          ? this.targetWeightKg
          : targetWeightKg as double?,
      unitSystem: unitSystem ?? this.unitSystem,
      logs: logs ?? this.logs,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeightHistoryEntity &&
          runtimeType == other.runtimeType &&
          currentWeightKg == other.currentWeightKg &&
          targetWeightKg == other.targetWeightKg &&
          unitSystem == other.unitSystem;

  @override
  int get hashCode => Object.hash(currentWeightKg, targetWeightKg, unitSystem);
}
