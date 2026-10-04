import '../entities/user_entity.dart';
import '../repositories/auth_repository_interface.dart';

class RegisterUseCase {
  final IAuthRepository repository;

  const RegisterUseCase(this.repository);

  Future<UserEntity> call({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) {
    return repository.register(
      name: name,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
  }
}
