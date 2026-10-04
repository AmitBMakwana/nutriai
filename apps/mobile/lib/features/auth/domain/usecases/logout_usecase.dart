import '../repositories/auth_repository_interface.dart';

class LogoutUseCase {
  final IAuthRepository repository;

  const LogoutUseCase(this.repository);

  Future<void> call() {
    return repository.logout();
  }
}
