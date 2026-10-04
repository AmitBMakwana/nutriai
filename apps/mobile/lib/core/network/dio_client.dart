import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_config.dart';
import '../errors/exceptions.dart';
import '../storage/secure_storage.dart';
import 'api_response.dart';
import 'auth_interceptor.dart';

/// Provider for app configuration.
final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig.dev();
});

/// Notifier holding the 401 unauthenticated logout callback.
class UnauthorizedHandlerNotifier extends Notifier<VoidCallback?> {
  @override
  VoidCallback? build() => null;

  void setHandler(VoidCallback? handler) => state = handler;
}

/// Callback hook provider for 401 unauthenticated events.
final unauthorizedHandlerProvider = NotifierProvider<UnauthorizedHandlerNotifier, VoidCallback?>(
  UnauthorizedHandlerNotifier.new,
);

/// Provider for [DioClient].
final dioClientProvider = Provider<DioClient>((ref) {
  final config = ref.watch(appConfigProvider);
  final storage = ref.watch(secureStorageProvider);
  final onUnauthorized = ref.watch(unauthorizedHandlerProvider);

  return DioClient(
    config: config,
    secureStorage: storage,
    onUnauthorized: onUnauthorized,
  );
});

/// Configured Dio HTTP client with interceptors, timeouts, and error mappings.
class DioClient {
  late final Dio _dio;
  final AppConfig config;

  DioClient({
    required this.config,
    required SecureStorageService secureStorage,
    VoidCallback? onUnauthorized,
  }) {
    if (kReleaseMode && !config.baseUrl.startsWith('https://')) {
      throw StateError('Security violation: Insecure HTTP connection is prohibited in release mode. Base URL must start with https://');
    }

    final baseOptions = BaseOptions(
      baseUrl: config.baseUrl,
      connectTimeout: config.connectTimeout,
      receiveTimeout: config.receiveTimeout,
      sendTimeout: config.sendTimeout,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      responseType: ResponseType.json,
    );

    _dio = Dio(baseOptions);

    _dio.interceptors.add(
      AuthInterceptor(
        secureStorage: secureStorage,
        onUnauthorized: onUnauthorized,
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          error: true,
          requestHeader: false,
          responseHeader: false,
        ),
      );
    }
  }

  /// Underlying raw Dio instance.
  Dio get dio => _dio;

  /// Performs a GET request and wraps response in [ApiResponse<T>].
  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic data)? fromJsonT,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse<T>(response, fromJsonT);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  /// Performs a POST request and wraps response in [ApiResponse<T>].
  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic data)? fromJsonT,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse<T>(response, fromJsonT);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  /// Performs a PUT request and wraps response in [ApiResponse<T>].
  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic data)? fromJsonT,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse<T>(response, fromJsonT);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  /// Performs a DELETE request and wraps response in [ApiResponse<T>].
  Future<ApiResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic data)? fromJsonT,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse<T>(response, fromJsonT);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  ApiResponse<T> _handleResponse<T>(
    Response response,
    T Function(dynamic data)? fromJsonT,
  ) {
    final responseData = response.data;
    if (responseData is Map<String, dynamic>) {
      return ApiResponse<T>.fromJson(responseData, fromJsonT);
    }
    return ApiResponse<T>.success(responseData as T);
  }
}
