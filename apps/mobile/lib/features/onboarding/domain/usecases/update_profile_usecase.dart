import '../entities/user_profile_entity.dart';
import '../repositories/onboarding_repository_interface.dart';

class UpdateProfileUseCase {
  final IOnboardingRepository _repository;

  UpdateProfileUseCase(this._repository);

  Future<UserProfileEntity> call(UserProfileEntity profile) {
    return _repository.updateProfile(profile);
  }
}
