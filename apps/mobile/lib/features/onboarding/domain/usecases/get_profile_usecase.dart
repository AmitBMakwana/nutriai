import '../entities/user_profile_entity.dart';
import '../repositories/onboarding_repository_interface.dart';

class GetProfileUseCase {
  final IOnboardingRepository _repository;

  GetProfileUseCase(this._repository);

  Future<UserProfileEntity> call() {
    return _repository.getProfile();
  }
}
