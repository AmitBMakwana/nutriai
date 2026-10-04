import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/weight_dto.dart';

abstract class IWeightApi {
  Future<WeightHistoryDto> getWeightHistory({String? startDate, String? endDate, int? limit});
  Future<WeightLogDto> logWeight({required double weightKg, String? date, DateTime? loggedAt, bool syncProfile = true});
  Future<void> deleteWeight(int id);
}

class WeightApi implements IWeightApi {
  final DioClient _dioClient;

  WeightApi(this._dioClient);

  @override
  Future<WeightHistoryDto> getWeightHistory({
    String? startDate,
    String? endDate,
    int? limit,
  }) async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      ApiEndpoints.weight,
      queryParameters: {
        'start_date': ?startDate,
        'end_date': ?endDate,
        'limit': ?limit,
      },
    );

    final data = response.data ?? <String, dynamic>{};
    return WeightHistoryDto.fromJson(data);
  }

  @override
  Future<WeightLogDto> logWeight({
    required double weightKg,
    String? date,
    DateTime? loggedAt,
    bool syncProfile = true,
  }) async {
    final response = await _dioClient.post<Map<String, dynamic>>(
      ApiEndpoints.weight,
      data: {
        'weight_kg': weightKg,
        'date': ?date,
        'logged_at': ?loggedAt?.toIso8601String(),
        'sync_profile': syncProfile,
      },
    );

    final data = response.data ?? <String, dynamic>{};
    return WeightLogDto.fromJson(data);
  }

  @override
  Future<void> deleteWeight(int id) async {
    await _dioClient.delete<dynamic>('${ApiEndpoints.weight}/$id');
  }
}
