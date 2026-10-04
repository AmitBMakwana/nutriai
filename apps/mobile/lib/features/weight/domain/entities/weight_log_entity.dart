/// Entity representing a single logged weight measurement.
class WeightLogEntity {
  final int id;
  final double weightKg;
  final DateTime loggedAt;

  const WeightLogEntity({
    required this.id,
    required this.weightKg,
    required this.loggedAt,
  });

  /// Returns the weight converted to the specified unit system ('metric' or 'imperial').
  double weightIn(String unitSystem) {
    if (unitSystem.toLowerCase() == 'imperial') {
      return weightKg * 2.20462;
    }
    return weightKg;
  }

  /// Returns the formatted weight string with 1 decimal place.
  String formatWeight(String unitSystem) {
    return weightIn(unitSystem).toStringAsFixed(1);
  }

  /// Returns the unit symbol ('kg' or 'lb').
  static String unitSymbol(String unitSystem) {
    return unitSystem.toLowerCase() == 'imperial' ? 'lb' : 'kg';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeightLogEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          weightKg == other.weightKg &&
          loggedAt == other.loggedAt;

  @override
  int get hashCode => Object.hash(id, weightKg, loggedAt);
}
