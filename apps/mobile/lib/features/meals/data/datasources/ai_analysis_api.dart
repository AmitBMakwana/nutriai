import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/ai_analysis_dto.dart';

class AiAnalysisApi {
  final DioClient _dioClient;

  AiAnalysisApi(this._dioClient);

  Future<AiAnalysisResponseDto> analyzeMeal({
    required File image,
    required String mealType,
  }) async {
    try {
      final fileName = image.path.split(RegExp(r'[\\/]')).last;
      final MultipartFile multipartFile;

      if (kIsWeb) {
        final bytes = await XFile(image.path).readAsBytes();
        multipartFile = MultipartFile.fromBytes(
          bytes,
          filename: fileName.isNotEmpty ? fileName : 'meal_photo.jpg',
        );
      } else {
        multipartFile = await MultipartFile.fromFile(
          image.path,
          filename: fileName,
        );
      }

      final formData = FormData.fromMap({
        'image': multipartFile,
        'meal_type': mealType,
      });

      final response = await _dioClient.post(
        ApiEndpoints.analyzeMeal,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          sendTimeout: const Duration(seconds: 40),
          receiveTimeout: const Duration(seconds: 40),
        ),
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return AiAnalysisResponseDto.fromJson(data);
      }

      throw const UnknownException('Invalid response structure received from meal analysis.');
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<AiAnalysisResponseDto> getAnalysis(int analysisId) async {
    try {
      final response = await _dioClient.get('${ApiEndpoints.aiAnalysis}/$analysisId');
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return AiAnalysisResponseDto.fromJson(data);
      }
      throw const UnknownException('Invalid analysis response structure.');
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
