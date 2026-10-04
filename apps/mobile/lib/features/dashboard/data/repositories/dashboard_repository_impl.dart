import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../../domain/repositories/dashboard_repository_interface.dart';
import '../datasources/dashboard_api.dart';

final dashboardRepositoryProvider = Provider<IDashboardRepository>((ref) {
  final api = ref.watch(dashboardApiProvider);
  return DashboardRepositoryImpl(api);
});

class DashboardRepositoryImpl implements IDashboardRepository {
  final DashboardApi _api;

  const DashboardRepositoryImpl(this._api);

  @override
  Future<DashboardEntity> getDashboard({String? date}) async {
    final dto = await _api.getDashboard(date: date);
    return dto.toDomain();
  }
}
