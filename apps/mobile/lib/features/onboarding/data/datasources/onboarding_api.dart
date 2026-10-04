import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/onboarding_request_dto.dart';
import '../models/user_profile_dto.dart';

/// Provider for [OnboardingApi].
final onboardingApiProvider = Provider<OnboardingApi>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return OnboardingApi(dioClient);
});

/// Remote data source communicating with onboarding and profile API endpoints.
class OnboardingApi {
  final DioClient _dioClient;

  const OnboardingApi(this._dioClient);

  /// POST /api/v1/onboarding
  Future<UserProfileDto> submitOnboarding(OnboardingRequestDto request) async {
    final response = await _dioClient.post<Map<String, dynamic>>(
      ApiEndpoints.onboarding,
      data: request.toJson(),
    );

    final data = response.data!;
    final profileData = data['profile'] as Map<String, dynamic>? ?? data;
    return UserProfileDto.fromJson(profileData);
  }

  /// GET /api/v1/profile
  Future<UserProfileDto> getProfile() async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      ApiEndpoints.profile,
    );

    final data = response.data!;
    return UserProfileDto.fromJson(data);
  }

  /// PUT /api/v1/profile
  Future<UserProfileDto> updateProfile(UserProfileDto profile) async {
    final response = await _dioClient.put<Map<String, dynamic>>(
      ApiEndpoints.profile,
      data: profile.toJson(),
    );

    final data = response.data!;
    final profileData = data['profile'] as Map<String, dynamic>? ?? data;
    return UserProfileDto.fromJson(profileData);
  }
}
