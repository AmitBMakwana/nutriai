import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/weight_history_entity.dart';
import '../../domain/entities/weight_log_entity.dart';
import '../../domain/repositories/weight_repository.dart';
import '../datasources/weight_api.dart';

final weightApiProvider = Provider<IWeightApi>((ref) {
  final client = ref.watch(dioClientProvider);
  return WeightApi(client);
});

final weightRepositoryProvider = Provider<IWeightRepository>((ref) {
  final api = ref.watch(weightApiProvider);
  return WeightRepositoryImpl(api);
});

class WeightRepositoryImpl implements IWeightRepository {
  final IWeightApi _api;

  WeightRepositoryImpl(this._api);

  @override
  Future<WeightHistoryEntity> getWeightHistory({
    String? startDate,
    String? endDate,
    int? limit,
  }) async {
    final dto = await _api.getWeightHistory(
      startDate: startDate,
      endDate: endDate,
      limit: limit,
    );
    return dto.toDomain();
  }

  @override
  Future<WeightLogEntity> logWeight({
    required double weightKg,
    String? date,
    DateTime? loggedAt,
    bool syncProfile = true,
  }) async {
    final dto = await _api.logWeight(
      weightKg: weightKg,
      date: date,
      loggedAt: loggedAt,
      syncProfile: syncProfile,
    );
    return dto.toDomain();
  }

  @override
  Future<void> deleteWeight(int id) async {
    await _api.deleteWeight(id);
  }
}
