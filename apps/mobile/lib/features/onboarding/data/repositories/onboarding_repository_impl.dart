import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repositories/onboarding_repository_interface.dart';
import '../datasources/onboarding_api.dart';
import '../models/onboarding_request_dto.dart';
import '../models/user_profile_dto.dart';

/// Provider for [IOnboardingRepository].
final onboardingRepositoryProvider = Provider<IOnboardingRepository>((ref) {
  final api = ref.watch(onboardingApiProvider);
  return OnboardingRepositoryImpl(api);
});

class OnboardingRepositoryImpl implements IOnboardingRepository {
  final OnboardingApi _api;

  const OnboardingRepositoryImpl(this._api);

  @override
  Future<UserProfileEntity> submitOnboarding(UserProfileEntity profile) async {
    final requestDto = OnboardingRequestDto(
      goal: profile.goal,
      gender: profile.gender,
      dateOfBirth: profile.dateOfBirth.toIso8601String().split('T').first,
      heightCm: profile.heightCm,
      weightKg: profile.weightKg,
      targetWeightKg: profile.targetWeightKg,
      activityLevel: profile.activityLevel,
      dietType: profile.dietType,
      unitSystem: profile.unitSystem,
    );

    final responseDto = await _api.submitOnboarding(requestDto);
    return responseDto.toDomain();
  }

  @override
  Future<UserProfileEntity> getProfile() async {
    final dto = await _api.getProfile();
    return dto.toDomain();
  }

  @override
  Future<UserProfileEntity> updateProfile(UserProfileEntity profile) async {
    final dto = UserProfileDto.fromDomain(profile);
    final responseDto = await _api.updateProfile(dto);
    return responseDto.toDomain();
  }
}
