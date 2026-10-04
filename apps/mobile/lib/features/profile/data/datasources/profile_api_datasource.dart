import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../auth/data/models/user_dto.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../onboarding/data/models/user_profile_dto.dart';
import '../../../onboarding/domain/entities/user_profile_entity.dart';

abstract class IProfileApiDataSource {
  Future<UserProfileEntity> getProfile();
  Future<UserProfileEntity> updateProfile(Map<String, dynamic> data);
  Future<UserEntity> uploadAvatar(File imageFile);
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String passwordConfirmation,
  });
  Future<void> deleteAccount({String? password, bool confirmation = true});
}

class ProfileApiDataSource implements IProfileApiDataSource {
  final DioClient _dioClient;

  ProfileApiDataSource(this._dioClient);

  @override
  Future<UserProfileEntity> getProfile() async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      ApiEndpoints.profile,
    );
    final data = response.data ?? <String, dynamic>{};
    return UserProfileDto.fromJson(data).toDomain();
  }

  @override
  Future<UserProfileEntity> updateProfile(Map<String, dynamic> data) async {
    final response = await _dioClient.put<Map<String, dynamic>>(
      ApiEndpoints.profile,
      data: data,
    );
    final responseData = response.data ?? <String, dynamic>{};
    final profileData = responseData['profile'] as Map<String, dynamic>? ?? responseData;
    return UserProfileDto.fromJson(profileData).toDomain();
  }

  @override
  Future<UserEntity> uploadAvatar(File imageFile) async {
    final filename = imageFile.path.split(Platform.pathSeparator).last;
    final formData = FormData.fromMap({
      'avatar': await MultipartFile.fromFile(
        imageFile.path,
        filename: filename,
      ),
    });

    final response = await _dioClient.post<Map<String, dynamic>>(
      ApiEndpoints.avatar,
      data: formData,
    );

    final responseData = response.data ?? <String, dynamic>{};
    final userData = responseData['user'] as Map<String, dynamic>? ?? responseData;
    return UserDto.fromJson(userData).toDomain();
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String passwordConfirmation,
  }) async {
    await _dioClient.post<void>(
      ApiEndpoints.changePassword,
      data: {
        'current_password': currentPassword,
        'password': newPassword,
        'password_confirmation': passwordConfirmation,
      },
    );
  }

  @override
  Future<void> deleteAccount({String? password, bool confirmation = true}) async {
    await _dioClient.delete<void>(
      ApiEndpoints.account,
      data: {
        if (password != null && password.isNotEmpty) 'password': password,
        'confirmation': confirmation,
      },
    );
  }
}
