import '../entities/user_entity.dart';

/// Contract defining authentication operations for the domain layer.
abstract class IAuthRepository {
  /// Registers a new user.
  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  });

  /// Authenticates with email and password, returning the user and bearer token.
  Future<(UserEntity user, String token)> login({
    required String email,
    required String password,
  });

  /// Logs out the user and clears stored credentials.
  Future<void> logout();

  /// Restores session using stored token via GET /me.
  /// Returns null if no token is stored or token is invalid.
  Future<UserEntity?> restoreSession();

  /// Requests a password reset link for the provided email.
  Future<String> forgotPassword({
    required String email,
  });

  /// Resets password using the received token.
  Future<String> resetPassword({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
  });
}
