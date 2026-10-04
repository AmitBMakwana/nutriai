import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/ai_meal_analysis_entity.dart';
import '../../domain/repositories/ai_analysis_repository_interface.dart';
import '../datasources/ai_analysis_api.dart';

final aiAnalysisApiProvider = Provider<AiAnalysisApi>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return AiAnalysisApi(dioClient);
});

final aiAnalysisRepositoryProvider = Provider<IAiAnalysisRepository>((ref) {
  final api = ref.watch(aiAnalysisApiProvider);
  return AiAnalysisRepositoryImpl(api);
});

class AiAnalysisRepositoryImpl implements IAiAnalysisRepository {
  final AiAnalysisApi _api;

  AiAnalysisRepositoryImpl(this._api);

  @override
  Future<AiMealAnalysisResultEntity> analyzeMealImage({
    required File image,
    required String mealType,
  }) async {
    final dto = await _api.analyzeMeal(image: image, mealType: mealType);
    return dto.toEntity();
  }

  @override
  Future<AiMealAnalysisResultEntity> getAnalysis(int analysisId) async {
    final dto = await _api.getAnalysis(analysisId);
    return dto.toEntity();
  }
}
