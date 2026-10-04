import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/progress_dto.dart';

abstract class IProgressApi {
  Future<ProgressDto> getProgress({String range = '7d'});
  Future<WeeklyProgressDto> getWeekly();
  Future<MonthlyProgressDto> getMonthly({required int year, required int month});
}

class ProgressApi implements IProgressApi {
  final DioClient _dioClient;

  ProgressApi(this._dioClient);

  @override
  Future<ProgressDto> getProgress({String range = '7d'}) async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      ApiEndpoints.progress,
      queryParameters: {'range': range},
    );
    final data = response.data ?? <String, dynamic>{};
    return ProgressDto.fromJson(data);
  }

  @override
  Future<WeeklyProgressDto> getWeekly() async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      ApiEndpoints.progressWeekly,
    );
    final data = response.data ?? <String, dynamic>{};
    return WeeklyProgressDto.fromJson(data);
  }

  @override
  Future<MonthlyProgressDto> getMonthly({
    required int year,
    required int month,
  }) async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      ApiEndpoints.progressMonthly,
      queryParameters: {'year': year, 'month': month},
    );
    final data = response.data ?? <String, dynamic>{};
    return MonthlyProgressDto.fromJson(data);
  }
}
