import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../storage/secure_storage.dart';

/// Interceptor that attaches the Bearer token to outgoing requests and handles
/// 401 Unauthorized responses by clearing credentials and triggering a logout callback.
class AuthInterceptor extends Interceptor {
  final SecureStorageService secureStorage;
  final VoidCallback? onUnauthorized;

  AuthInterceptor({
    required this.secureStorage,
    this.onUnauthorized,
  });

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers['Accept'] = 'application/json';

    // Only attach bearer token if not already explicitly provided
    if (!options.headers.containsKey('Authorization')) {
      final token = await secureStorage.getToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      // Clear token upon 401 Unauthorized
      await secureStorage.deleteToken();
      onUnauthorized?.call();
    }

    return handler.next(err);
  }
}
