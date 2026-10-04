import '../entities/user_entity.dart';
import '../repositories/auth_repository_interface.dart';

class LoginUseCase {
  final IAuthRepository repository;

  const LoginUseCase(this.repository);

  Future<(UserEntity user, String token)> call({
    required String email,
    required String password,
  }) {
    return repository.login(email: email, password: password);
  }
}
