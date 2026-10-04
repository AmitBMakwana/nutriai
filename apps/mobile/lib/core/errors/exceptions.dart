import 'package:dio/dio.dart';

/// Base class for all API exceptions in NutriAI.
abstract class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(
    this.message, {
    this.statusCode,
  });

  @override
  String toString() => message;

  /// Maps a [DioException] into a domain-specific [ApiException].
  factory ApiException.fromDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException('Connection timed out. Please try again.');

      case DioExceptionType.connectionError:
        return const NetworkException('No internet connection. Please verify your network.');

      case DioExceptionType.badResponse:
        final response = error.response;
        final statusCode = response?.statusCode;
        final data = response?.data;

        String message = 'An unexpected error occurred.';
        Map<String, dynamic>? errors;

        if (data is Map<String, dynamic>) {
          if (data['message'] is String && (data['message'] as String).isNotEmpty) {
            message = data['message'];
          }
          if (data['errors'] is Map<String, dynamic>) {
            errors = data['errors'] as Map<String, dynamic>;
          }
        }

        switch (statusCode) {
          case 400:
            return BadRequestException(message, statusCode: statusCode);
          case 401:
            return UnauthorizedException(message: message, statusCode: statusCode);
          case 403:
            return ForbiddenException(message: message, statusCode: statusCode);
          case 404:
            return NotFoundException(message: message, statusCode: statusCode);
          case 422:
            return ValidationException(
              message: message,
              errors: errors,
              statusCode: statusCode,
            );
          case 429:
            int used = 5;
            int quota = 5;
            String plan = 'free';
            if (data is Map<String, dynamic> && data['data'] is Map<String, dynamic>) {
              final sub = data['data'] as Map<String, dynamic>;
              used = (sub['used'] as num?)?.toInt() ?? 5;
              quota = (sub['quota'] as num?)?.toInt() ?? 5;
              plan = sub['plan']?.toString() ?? 'free';
            }
            return QuotaExceededApiException(
              message: message,
              used: used,
              quota: quota,
              plan: plan,
              statusCode: statusCode,
            );
          case 500:
          case 502:
          case 503:
            return ServerException(
              message: message.isNotEmpty ? message : 'Server error ($statusCode). Please try again later.',
              statusCode: statusCode,
            );
          default:
            return UnknownException(message, statusCode);
        }

      case DioExceptionType.cancel:
        return const RequestCancelledException('Request was cancelled.');

      case DioExceptionType.badCertificate:
        return const NetworkException('SSL Certificate validation failed.');

      case DioExceptionType.unknown:
      default:
        return UnknownException(
          error.message ?? 'An unknown network error occurred.',
        );
    }
  }
}

/// Thrown when there is no internet connection or network failure.
class NetworkException extends ApiException {
  const NetworkException([super.message = 'Network connection error.']);
}

/// Thrown when an HTTP request times out.
class TimeoutException extends ApiException {
  const TimeoutException([super.message = 'The request timed out.']);
}

/// Thrown for HTTP 400 Bad Request.
class BadRequestException extends ApiException {
  const BadRequestException(super.message, {super.statusCode = 400});
}

/// Thrown for HTTP 401 Unauthorized (session expired or invalid token).
class UnauthorizedException extends ApiException {
  const UnauthorizedException({
    String message = 'Session expired. Please log in again.',
    int? statusCode = 401,
  }) : super(message, statusCode: statusCode);
}

/// Thrown for HTTP 403 Forbidden.
class ForbiddenException extends ApiException {
  const ForbiddenException({
    String message = 'You do not have permission to perform this action.',
    int? statusCode = 403,
  }) : super(message, statusCode: statusCode);
}

/// Thrown for HTTP 404 Not Found.
class NotFoundException extends ApiException {
  const NotFoundException({
    String message = 'The requested resource was not found.',
    int? statusCode = 404,
  }) : super(message, statusCode: statusCode);
}

/// Thrown for HTTP 422 Validation Error.
class ValidationException extends ApiException {
  final Map<String, dynamic>? errors;

  const ValidationException({
    required String message,
    this.errors,
    int? statusCode = 422,
  }) : super(message, statusCode: statusCode);

  /// Returns the first validation error message if available.
  String get firstErrorMessage {
    if (errors != null && errors!.isNotEmpty) {
      final firstVal = errors!.values.first;
      if (firstVal is List && firstVal.isNotEmpty) {
        return firstVal.first.toString();
      } else if (firstVal is String) {
        return firstVal;
      }
    }
    return message;
  }
}

/// Thrown for HTTP 500+ Server Errors.
class ServerException extends ApiException {
  const ServerException({
    String message = 'Internal server error.',
    int? statusCode = 500,
  }) : super(message, statusCode: statusCode);
}

/// Thrown when request is cancelled.
class RequestCancelledException extends ApiException {
  const RequestCancelledException([super.message = 'Request was cancelled.']);
}

/// Thrown for unmapped or unexpected exceptions.
class UnknownException extends ApiException {
  const UnknownException([
    super.message = 'An unexpected error occurred.',
    int? statusCode,
  ]) : super(statusCode: statusCode);
}

/// Thrown when monthly scan quota is exceeded (HTTP 429).
class QuotaExceededApiException extends ApiException {
  final int used;
  final int quota;
  final String plan;

  const QuotaExceededApiException({
    String message = 'Monthly scan quota exceeded.',
    this.used = 5,
    this.quota = 5,
    this.plan = 'free',
    int? statusCode = 429,
  }) : super(message, statusCode: statusCode);
}
