import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/meal_dto.dart';

final mealApiProvider = Provider<MealApi>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return MealApi(dioClient);
});

class MealApi {
  final DioClient _dioClient;

  const MealApi(this._dioClient);

  /// GET /api/v1/meals?date=...
  Future<List<MealDto>> getMeals({String? date}) async {
    final queryParams = <String, dynamic>{};
    if (date != null && date.isNotEmpty) {
      queryParams['date'] = date;
    }

    final response = await _dioClient.get<List<dynamic>>(
      ApiEndpoints.meals,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    final rawList = response.data ?? [];
    return rawList
        .map((item) => MealDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// GET /api/v1/meals/{id}
  Future<MealDto> getMeal(int id) async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      '${ApiEndpoints.meals}/$id',
    );

    return MealDto.fromJson(response.data!);
  }

  /// POST /api/v1/meals
  Future<MealDto> createMeal(Map<String, dynamic> data) async {
    final response = await _dioClient.post<Map<String, dynamic>>(
      ApiEndpoints.meals,
      data: data,
    );

    return MealDto.fromJson(response.data!);
  }

  /// PUT /api/v1/meals/{id}
  Future<MealDto> updateMeal(int id, Map<String, dynamic> data) async {
    final response = await _dioClient.put<Map<String, dynamic>>(
      '${ApiEndpoints.meals}/$id',
      data: data,
    );

    return MealDto.fromJson(response.data!);
  }

  /// DELETE /api/v1/meals/{id}
  Future<void> deleteMeal(int id) async {
    await _dioClient.delete<dynamic>(
      '${ApiEndpoints.meals}/$id',
    );
  }
}
