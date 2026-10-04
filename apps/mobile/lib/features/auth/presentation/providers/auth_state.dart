import '../../domain/entities/user_entity.dart';

/// Sealed class hierarchy representing authentication states:
/// initial, unauthenticated, loading, authenticated, and error.
sealed class AuthState {
  const AuthState();

  const factory AuthState.initial() = AuthInitial;
  const factory AuthState.unauthenticated({String? message}) = AuthUnauthenticated;
  const factory AuthState.loading() = AuthLoading;
  const factory AuthState.authenticated({
    required UserEntity user,
    String? token,
  }) = AuthAuthenticated;
  const factory AuthState.error({
    required String message,
    Map<String, dynamic>? fieldErrors,
  }) = AuthError;

  bool get isInitial => this is AuthInitial;
  bool get isUnauthenticated => this is AuthUnauthenticated;
  bool get isLoading => this is AuthLoading;
  bool get isAuthenticated => this is AuthAuthenticated;
  bool get isError => this is AuthError;

  UserEntity? get user => switch (this) {
        AuthAuthenticated(:final user) => user,
        _ => null,
      };

  String? get errorMessage => switch (this) {
        AuthError(:final message) => message,
        _ => null,
      };

  Map<String, dynamic>? get fieldErrors => switch (this) {
        AuthError(:final fieldErrors) => fieldErrors,
        _ => null,
      };

  /// Returns the specific error string for [field] if present in fieldErrors.
  String? fieldError(String field) {
    final errors = fieldErrors;
    if (errors == null || !errors.containsKey(field)) return null;
    final val = errors[field];
    if (val is List && val.isNotEmpty) {
      return val.first.toString();
    } else if (val is String) {
      return val;
    }
    return null;
  }
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthUnauthenticated extends AuthState {
  final String? message;
  const AuthUnauthenticated({this.message});
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  @override
  final UserEntity user;
  final String? token;
  const AuthAuthenticated({required this.user, this.token});
}

class AuthError extends AuthState {
  final String message;
  @override
  final Map<String, dynamic>? fieldErrors;

  const AuthError({required this.message, this.fieldErrors});

  @override
  String get errorMessage => message;
}
