import '../entities/water_log_entity.dart';

abstract class IWaterRepository {
  Future<({int totalMl, List<WaterLogEntity> logs})> getWaterLogs({String? date});
  Future<({int totalMl, WaterLogEntity log})> logWater({
    required int amountMl,
    String? date,
    DateTime? loggedAt,
  });
  Future<({int totalMl, WaterLogEntity? deletedLog})> deleteWater({
    int? id,
    String? date,
  });
}
