import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/auth_response_dto.dart';
import '../models/forgot_password_request_dto.dart';
import '../models/login_request_dto.dart';
import '../models/register_request_dto.dart';
import '../models/reset_password_request_dto.dart';
import '../models/user_dto.dart';

/// Provider for [AuthApi].
final authApiProvider = Provider<AuthApi>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return AuthApi(dioClient);
});

/// API service communicating with the NutriAI Laravel backend authentication endpoints.
class AuthApi {
  final DioClient _dioClient;

  const AuthApi(this._dioClient);

  /// POST /api/v1/register
  Future<UserDto> register(RegisterRequestDto request) async {
    final response = await _dioClient.post<Map<String, dynamic>>(
      ApiEndpoints.register,
      data: request.toJson(),
    );

    final data = response.data!;
    return UserDto.fromJson(data);
  }

  /// POST /api/v1/login
  Future<AuthResponseDto> login(LoginRequestDto request) async {
    final response = await _dioClient.post<Map<String, dynamic>>(
      ApiEndpoints.login,
      data: request.toJson(),
    );

    final data = response.data!;
    return AuthResponseDto.fromJson(data);
  }

  /// POST /api/v1/logout
  Future<void> logout() async {
    await _dioClient.post(ApiEndpoints.logout);
  }

  /// GET /api/v1/me
  Future<UserDto> getMe() async {
    final response = await _dioClient.get<Map<String, dynamic>>(ApiEndpoints.me);
    final data = response.data!;
    return UserDto.fromJson(data);
  }

  /// POST /api/v1/password/forgot
  Future<String> forgotPassword(ForgotPasswordRequestDto request) async {
    final response = await _dioClient.post(
      ApiEndpoints.forgotPassword,
      data: request.toJson(),
    );
    return response.message ?? 'Password reset link sent to your email.';
  }

  /// POST /api/v1/password/reset
  Future<String> resetPassword(ResetPasswordRequestDto request) async {
    final response = await _dioClient.post(
      ApiEndpoints.resetPassword,
      data: request.toJson(),
    );
    return response.message ?? 'Password reset successfully.';
  }
}
