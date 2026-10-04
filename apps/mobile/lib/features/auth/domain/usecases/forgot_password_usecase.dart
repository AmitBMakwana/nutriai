import '../repositories/auth_repository_interface.dart';

class ForgotPasswordUseCase {
  final IAuthRepository repository;

  const ForgotPasswordUseCase(this.repository);

  Future<String> call({
    required String email,
  }) {
    return repository.forgotPassword(email: email);
  }
}
