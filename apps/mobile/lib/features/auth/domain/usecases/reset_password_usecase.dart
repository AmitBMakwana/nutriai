import '../repositories/auth_repository_interface.dart';

class ResetPasswordUseCase {
  final IAuthRepository repository;

  const ResetPasswordUseCase(this.repository);

  Future<String> call({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
  }) {
    return repository.resetPassword(
      email: email,
      token: token,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
  }
}
