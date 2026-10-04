import '../entities/weight_history_entity.dart';
import '../entities/weight_log_entity.dart';

abstract class IWeightRepository {
  Future<WeightHistoryEntity> getWeightHistory({String? startDate, String? endDate, int? limit});
  Future<WeightLogEntity> logWeight({
    required double weightKg,
    String? date,
    DateTime? loggedAt,
    bool syncProfile = true,
  });
  Future<void> deleteWeight(int id);
}
