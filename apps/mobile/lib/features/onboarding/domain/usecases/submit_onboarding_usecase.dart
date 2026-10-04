import '../entities/user_profile_entity.dart';
import '../repositories/onboarding_repository_interface.dart';

class SubmitOnboardingUseCase {
  final IOnboardingRepository _repository;

  SubmitOnboardingUseCase(this._repository);

  Future<UserProfileEntity> call(UserProfileEntity profile) {
    return _repository.submitOnboarding(profile);
  }
}
