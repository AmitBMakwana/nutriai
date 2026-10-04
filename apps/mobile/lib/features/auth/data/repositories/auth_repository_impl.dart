import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository_interface.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/restore_session_usecase.dart';
import '../datasources/auth_api.dart';
import '../models/forgot_password_request_dto.dart';
import '../models/login_request_dto.dart';
import '../models/register_request_dto.dart';
import '../models/reset_password_request_dto.dart';

/// Provider for [IAuthRepository] implementation.
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final authApi = ref.watch(authApiProvider);
  final storage = ref.watch(secureStorageProvider);
  return AuthRepositoryImpl(authApi: authApi, storage: storage);
});

// Usecase providers
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
});

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  return RegisterUseCase(ref.watch(authRepositoryProvider));
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(ref.watch(authRepositoryProvider));
});

final restoreSessionUseCaseProvider = Provider<RestoreSessionUseCase>((ref) {
  return RestoreSessionUseCase(ref.watch(authRepositoryProvider));
});

final forgotPasswordUseCaseProvider = Provider<ForgotPasswordUseCase>((ref) {
  return ForgotPasswordUseCase(ref.watch(authRepositoryProvider));
});

final resetPasswordUseCaseProvider = Provider<ResetPasswordUseCase>((ref) {
  return ResetPasswordUseCase(ref.watch(authRepositoryProvider));
});

/// Implementation of [IAuthRepository] connecting [AuthApi] and [SecureStorageService].
class AuthRepositoryImpl implements IAuthRepository {
  final AuthApi authApi;
  final SecureStorageService storage;

  const AuthRepositoryImpl({
    required this.authApi,
    required this.storage,
  });

  @override
  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    final request = RegisterRequestDto(
      name: name,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );

    final userDto = await authApi.register(request);
    return userDto.toDomain();
  }

  @override
  Future<(UserEntity user, String token)> login({
    required String email,
    required String password,
  }) async {
    final request = LoginRequestDto(
      email: email,
      password: password,
    );

    final response = await authApi.login(request);
    final user = response.user.toDomain();
    final token = response.token;

    // Persist token & basic details securely
    await storage.saveToken(token);
    await storage.saveUserDetails(
      id: user.id.toString(),
      name: user.name,
      email: user.email,
    );

    return (user, token);
  }

  @override
  Future<void> logout() async {
    try {
      await authApi.logout();
    } catch (_) {
      // Allow local logout to succeed even if offline or network drops
    } finally {
      await storage.deleteToken();
    }
  }

  @override
  Future<UserEntity?> restoreSession() async {
    try {
      final token = await storage.getToken();
      if (token == null || token.isEmpty) {
        return null;
      }

      // Verify token with backend via GET /me
      final userDto = await authApi.getMe();
      final user = userDto.toDomain();

      await storage.saveUserDetails(
        id: user.id.toString(),
        name: user.name,
        email: user.email,
      );

      return user;
    } catch (_) {
      // Invalid/expired token or error: clean up token
      await storage.deleteToken();
      return null;
    }
  }

  @override
  Future<String> forgotPassword({
    required String email,
  }) async {
    final request = ForgotPasswordRequestDto(email: email);
    return authApi.forgotPassword(request);
  }

  @override
  Future<String> resetPassword({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
  }) async {
    final request = ResetPasswordRequestDto(
      email: email,
      token: token,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
    return authApi.resetPassword(request);
  }
}
