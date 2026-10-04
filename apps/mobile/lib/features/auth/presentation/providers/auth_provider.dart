import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/restore_session_usecase.dart';
import 'auth_state.dart';

/// Provider for [AuthNotifier] holding [AuthState].
final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

/// Alias provider for convenience
final authProvider = authNotifierProvider;

/// Notifier managing authentication state and actions.
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    // Register 401 unauthenticated logout callback
    Future.microtask(() {
      ref.read(unauthorizedHandlerProvider.notifier).setHandler(() {
        logout();
      });
    });

    return const AuthState.initial();
  }

  LoginUseCase get _loginUseCase => ref.read(loginUseCaseProvider);
  RegisterUseCase get _registerUseCase => ref.read(registerUseCaseProvider);
  LogoutUseCase get _logoutUseCase => ref.read(logoutUseCaseProvider);
  RestoreSessionUseCase get _restoreSessionUseCase => ref.read(restoreSessionUseCaseProvider);
  ForgotPasswordUseCase get _forgotPasswordUseCase => ref.read(forgotPasswordUseCaseProvider);
  ResetPasswordUseCase get _resetPasswordUseCase => ref.read(resetPasswordUseCaseProvider);

  /// Restores session on launch via GET /me.
  Future<void> restoreSession() async {
    state = const AuthState.loading();
    try {
      final user = await _restoreSessionUseCase();
      if (user != null) {
        state = AuthState.authenticated(user: user);
      } else {
        state = const AuthState.unauthenticated();
      }
    } catch (_) {
      state = const AuthState.unauthenticated();
    }
  }

  /// Attempts to authenticate with email and password.
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();
    try {
      final (user, token) = await _loginUseCase(
        email: email,
        password: password,
      );
      state = AuthState.authenticated(user: user, token: token);
      return true;
    } on ValidationException catch (e) {
      state = AuthState.error(
        message: e.message,
        fieldErrors: e.errors,
      );
      return false;
    } on ApiException catch (e) {
      state = AuthState.error(message: e.message);
      return false;
    } catch (e) {
      state = AuthState.error(message: e.toString());
      return false;
    }
  }

  /// Registers a new user account and logs them in.
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    state = const AuthState.loading();
    try {
      await _registerUseCase(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );

      // Automatically log in after registration
      return await login(email: email, password: password);
    } on ValidationException catch (e) {
      state = AuthState.error(
        message: e.message,
        fieldErrors: e.errors,
      );
      return false;
    } on ApiException catch (e) {
      state = AuthState.error(message: e.message);
      return false;
    } catch (e) {
      state = AuthState.error(message: e.toString());
      return false;
    }
  }

  /// Logs the user out and clears stored credentials.
  Future<void> logout() async {
    state = const AuthState.loading();
    try {
      await _logoutUseCase();
    } finally {
      state = const AuthState.unauthenticated();
    }
  }

  /// Requests a password reset link.
  Future<String> forgotPassword({required String email}) async {
    try {
      return await _forgotPasswordUseCase(email: email);
    } on ValidationException catch (e) {
      state = AuthState.error(message: e.message, fieldErrors: e.errors);
      rethrow;
    } on ApiException catch (e) {
      state = AuthState.error(message: e.message);
      rethrow;
    }
  }

  /// Resets the user's password using the token received.
  Future<String> resetPassword({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      return await _resetPasswordUseCase(
        email: email,
        token: token,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
    } on ValidationException catch (e) {
      state = AuthState.error(message: e.message, fieldErrors: e.errors);
      rethrow;
    } on ApiException catch (e) {
      state = AuthState.error(message: e.message);
      rethrow;
    }
  }

  /// Updates authenticated user state to mark onboarding as completed.
  void markOnboardingCompleted() {
    final current = state;
    if (current is AuthAuthenticated) {
      state = AuthAuthenticated(
        user: current.user.copyWith(isOnboardingCompleted: true),
        token: current.token,
      );
    }
  }
}
