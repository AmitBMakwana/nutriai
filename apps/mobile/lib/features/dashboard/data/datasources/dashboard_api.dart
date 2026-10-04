import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/dashboard_dto.dart';

final dashboardApiProvider = Provider<DashboardApi>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return DashboardApi(dioClient);
});

class DashboardApi {
  final DioClient _dioClient;

  const DashboardApi(this._dioClient);

  /// GET /api/v1/dashboard?date=YYYY-MM-DD
  Future<DashboardDto> getDashboard({String? date}) async {
    final queryParams = <String, dynamic>{};
    if (date != null && date.isNotEmpty) {
      queryParams['date'] = date;
    }

    final response = await _dioClient.get<Map<String, dynamic>>(
      ApiEndpoints.dashboard,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    final data = response.data!;
    return DashboardDto.fromJson(data);
  }
}
