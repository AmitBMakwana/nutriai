import 'dart:io';
import '../entities/ai_meal_analysis_entity.dart';

abstract class IAiAnalysisRepository {
  /// Uploads and analyzes a meal photo via backend AI vision.
  Future<AiMealAnalysisResultEntity> analyzeMealImage({
    required File image,
    required String mealType,
  });

  /// Retrieves an existing analysis by ID.
  Future<AiMealAnalysisResultEntity> getAnalysis(int analysisId);
}
