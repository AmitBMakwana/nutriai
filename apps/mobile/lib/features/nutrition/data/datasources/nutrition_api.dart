import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/nutrition_goal_dto.dart';

/// Provider for [NutritionApi].
final nutritionApiProvider = Provider<NutritionApi>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return NutritionApi(dioClient);
});

class NutritionApi {
  final DioClient _dioClient;

  const NutritionApi(this._dioClient);

  /// GET /api/v1/goals
  Future<NutritionGoalDto> getActiveGoal() async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      ApiEndpoints.goals,
    );

    final data = response.data!;
    return NutritionGoalDto.fromJson(data);
  }

  /// POST /api/v1/goals/calculate
  Future<NutritionGoalDto> calculateGoal(Map<String, dynamic> params) async {
    final response = await _dioClient.post<Map<String, dynamic>>(
      ApiEndpoints.calculateGoals,
      data: params,
    );

    final data = response.data!;
    return NutritionGoalDto.fromJson(data);
  }

  /// PUT /api/v1/goals
  Future<NutritionGoalDto> overrideGoal(Map<String, dynamic> data) async {
    final response = await _dioClient.put<Map<String, dynamic>>(
      ApiEndpoints.goals,
      data: data,
    );

    final responseData = response.data!;
    return NutritionGoalDto.fromJson(responseData);
  }
}
