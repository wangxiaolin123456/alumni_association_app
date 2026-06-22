import 'package:dio/dio.dart';

/// Normalized exception exposed to controllers and repositories.
class ApiException implements Exception {
  const ApiException({required this.message, this.code = -1, this.statusCode});

  final String message;
  final int code;
  final int? statusCode;

  factory ApiException.fromDioException(DioException error) {
    final responseData = error.response?.data;
    final serverMessage = responseData is Map<String, dynamic>
        ? responseData['message'] ?? responseData['msg']
        : null;

    return ApiException(
      message: serverMessage?.toString() ?? _fallbackMessage(error.type),
      statusCode: error.response?.statusCode,
    );
  }

  static String _fallbackMessage(DioExceptionType type) => switch (type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout => '网络连接超时，请稍后重试',
    DioExceptionType.connectionError => '网络连接失败，请检查网络设置',
    DioExceptionType.cancel => '请求已取消',
    _ => '服务暂时不可用，请稍后重试',
  };

  @override
  String toString() => message;
}
