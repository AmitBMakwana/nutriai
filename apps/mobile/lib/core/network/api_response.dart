/// Standard API response envelope wrapper matching the NutriAI Laravel backend.
class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final Map<String, dynamic>? errors;

  const ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.errors,
  });

  /// Factory to construct [ApiResponse] from raw JSON decoded map.
  factory ApiResponse.fromJson(
    Map<String, dynamic> json, [
    T Function(dynamic data)? fromJsonT,
  ]) {
    final rawData = json['data'];
    T? parsedData;

    if (rawData != null && fromJsonT != null) {
      parsedData = fromJsonT(rawData);
    } else if (rawData is T) {
      parsedData = rawData;
    }

    return ApiResponse<T>(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      data: parsedData,
      errors: json['errors'] as Map<String, dynamic>?,
    );
  }

  factory ApiResponse.success(T data, {String? message}) {
    return ApiResponse<T>(
      success: true,
      data: data,
      message: message,
    );
  }

  factory ApiResponse.failure(String message, {Map<String, dynamic>? errors}) {
    return ApiResponse<T>(
      success: false,
      message: message,
      errors: errors,
    );
  }

  bool get isSuccess => success;
  bool get hasErrors => errors != null && errors!.isNotEmpty;

  @override
  String toString() => 'ApiResponse(success: $success, message: $message, data: $data, errors: $errors)';
}
