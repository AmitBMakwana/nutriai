import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/water_log_dto.dart';

abstract class IWaterApi {
  Future<WaterDailyDataDto> getWaterLogs({String? date});
  Future<Map<String, dynamic>> logWater({required int amountMl, String? date, DateTime? loggedAt});
  Future<Map<String, dynamic>> deleteWater({int? id, String? date});
}

class WaterApi implements IWaterApi {
  final DioClient _dioClient;

  WaterApi(this._dioClient);

  @override
  Future<WaterDailyDataDto> getWaterLogs({String? date}) async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      ApiEndpoints.water,
      queryParameters: {
        'date': ?date,
      },
    );

    final data = response.data ?? <String, dynamic>{};
    return WaterDailyDataDto.fromJson(data);
  }

  @override
  Future<Map<String, dynamic>> logWater({
    required int amountMl,
    String? date,
    DateTime? loggedAt,
  }) async {
    final response = await _dioClient.post<Map<String, dynamic>>(
      ApiEndpoints.water,
      data: {
        'amount_ml': amountMl,
        'date': ?date,
        'logged_at': ?loggedAt?.toIso8601String(),
      },
    );

    return response.data ?? <String, dynamic>{};
  }

  @override
  Future<Map<String, dynamic>> deleteWater({int? id, String? date}) async {
    final endpoint = id != null ? '${ApiEndpoints.water}/$id' : ApiEndpoints.water;
    final response = await _dioClient.delete<Map<String, dynamic>>(
      endpoint,
      queryParameters: {
        'date': ?date,
      },
    );

    return response.data ?? <String, dynamic>{};
  }
}
