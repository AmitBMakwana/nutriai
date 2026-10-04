import '../entities/user_profile_entity.dart';

abstract class IOnboardingRepository {
  Future<UserProfileEntity> submitOnboarding(UserProfileEntity profile);
  Future<UserProfileEntity> getProfile();
  Future<UserProfileEntity> updateProfile(UserProfileEntity profile);
}
