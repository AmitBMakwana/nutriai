import '../../domain/entities/progress_entities.dart';
import '../datasources/progress_api.dart';
import '../models/progress_mapper.dart';

abstract class IProgressRepository {
  Future<ProgressData> getProgress({String range = '7d'});
  Future<WeeklyProgress> getWeekly();
  Future<MonthlyProgress> getMonthly({required int year, required int month});
}

class ProgressRepository implements IProgressRepository {
  final IProgressApi _api;

  ProgressRepository(this._api);

  @override
  Future<ProgressData> getProgress({String range = '7d'}) async {
    final dto = await _api.getProgress(range: range);
    return ProgressMapper.fromDto(dto);
  }

  @override
  Future<WeeklyProgress> getWeekly() async {
    final dto = await _api.getWeekly();
    return ProgressMapper.fromWeeklyDto(dto);
  }

  @override
  Future<MonthlyProgress> getMonthly({
    required int year,
    required int month,
  }) async {
    final dto = await _api.getMonthly(year: year, month: month);
    return ProgressMapper.fromMonthlyDto(dto);
  }
}
