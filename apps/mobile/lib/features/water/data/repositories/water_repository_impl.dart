import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/water_log_entity.dart';
import '../../domain/repositories/water_repository.dart';
import '../datasources/water_api.dart';
import '../models/water_log_dto.dart';

final waterApiProvider = Provider<IWaterApi>((ref) {
  final client = ref.watch(dioClientProvider);
  return WaterApi(client);
});

final waterRepositoryProvider = Provider<IWaterRepository>((ref) {
  final api = ref.watch(waterApiProvider);
  return WaterRepositoryImpl(api);
});

class WaterRepositoryImpl implements IWaterRepository {
  final IWaterApi _api;

  WaterRepositoryImpl(this._api);

  @override
  Future<({int totalMl, List<WaterLogEntity> logs})> getWaterLogs({String? date}) async {
    final result = await _api.getWaterLogs(date: date);
    return (
      totalMl: result.totalMl,
      logs: result.logs.map((dto) => dto.toDomain()).toList(),
    );
  }

  @override
  Future<({int totalMl, WaterLogEntity log})> logWater({
    required int amountMl,
    String? date,
    DateTime? loggedAt,
  }) async {
    final result = await _api.logWater(
      amountMl: amountMl,
      date: date,
      loggedAt: loggedAt,
    );
    final logDto = WaterLogDto.fromJson(result['log'] as Map<String, dynamic>);
    final totalMl = (result['total_ml'] as num?)?.toInt() ?? 0;
    return (
      totalMl: totalMl,
      log: logDto.toDomain(),
    );
  }

  @override
  Future<({int totalMl, WaterLogEntity? deletedLog})> deleteWater({
    int? id,
    String? date,
  }) async {
    final result = await _api.deleteWater(id: id, date: date);
    final rawDeleted = result['deleted_log'] as Map<String, dynamic>?;
    final deletedLog = rawDeleted != null ? WaterLogDto.fromJson(rawDeleted).toDomain() : null;
    final totalMl = (result['total_ml'] as num?)?.toInt() ?? 0;
    return (
      totalMl: totalMl,
      deletedLog: deletedLog,
    );
  }
}
