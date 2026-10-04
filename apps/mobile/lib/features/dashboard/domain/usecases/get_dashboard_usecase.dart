import '../entities/dashboard_entity.dart';
import '../repositories/dashboard_repository_interface.dart';

class GetDashboardUseCase {
  final IDashboardRepository _repository;

  GetDashboardUseCase(this._repository);

  Future<DashboardEntity> call({String? date}) {
    return _repository.getDashboard(date: date);
  }
}
