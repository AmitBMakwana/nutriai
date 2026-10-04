/// Entity representing a single water logging instance.
class WaterLogEntity {
  final int id;
  final int amountMl;
  final DateTime loggedAt;

  const WaterLogEntity({
    required this.id,
    required this.amountMl,
    required this.loggedAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WaterLogEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          amountMl == other.amountMl &&
          loggedAt == other.loggedAt;

  @override
  int get hashCode => Object.hash(id, amountMl, loggedAt);
}
