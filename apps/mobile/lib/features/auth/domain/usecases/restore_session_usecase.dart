import '../entities/user_entity.dart';
import '../repositories/auth_repository_interface.dart';

class RestoreSessionUseCase {
  final IAuthRepository repository;

  const RestoreSessionUseCase(this.repository);

  Future<UserEntity?> call() {
    return repository.restoreSession();
  }
}
