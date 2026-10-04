import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/food_dto.dart';

final foodApiProvider = Provider<FoodApi>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return FoodApi(dioClient);
});

class FoodApi {
  final DioClient _dioClient;

  const FoodApi(this._dioClient);

  /// GET /api/v1/foods/search?q=...&page=...
  Future<List<FoodDto>> searchFoods({String? query, int page = 1}) async {
    final queryParams = <String, dynamic>{
      'page': page,
    };
    if (query != null && query.isNotEmpty) {
      queryParams['q'] = query;
    }

    final response = await _dioClient.get<Map<String, dynamic>>(
      '${ApiEndpoints.foods}/search',
      queryParameters: queryParams,
    );

    final rawData = response.data!['data'] as List<dynamic>? ?? [];
    return rawData
        .map((item) => FoodDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// POST /api/v1/foods/custom
  Future<FoodDto> createCustomFood(Map<String, dynamic> data) async {
    final response = await _dioClient.post<Map<String, dynamic>>(
      '${ApiEndpoints.foods}/custom',
      data: data,
    );

    return FoodDto.fromJson(response.data!);
  }

  /// POST /api/v1/foods/{id}/favorite
  Future<bool> toggleFavorite(int foodId) async {
    final response = await _dioClient.post<Map<String, dynamic>>(
      '${ApiEndpoints.foods}/$foodId/favorite',
    );

    final data = response.data!;
    return data['is_favorite'] as bool? ?? false;
  }

  /// GET /api/v1/foods/favorites
  Future<List<FoodDto>> getFavorites() async {
    final response = await _dioClient.get<List<dynamic>>(
      '${ApiEndpoints.foods}/favorites',
    );

    final rawList = response.data ?? [];
    return rawList
        .map((item) => FoodDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
