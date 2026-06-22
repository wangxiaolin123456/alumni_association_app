import 'package:dio/dio.dart';

/// Retries idempotent GET requests once after transient network failures.
class RetryInterceptor extends Interceptor {
  RetryInterceptor(this._dio);

  final Dio _dio;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;
    final retryCount = request.extra['retryCount'] as int? ?? 0;
    final canRetry =
        request.method == 'GET' &&
        retryCount < 1 &&
        {
          DioExceptionType.connectionError,
          DioExceptionType.connectionTimeout,
          DioExceptionType.receiveTimeout,
        }.contains(err.type);

    if (!canRetry) {
      handler.next(err);
      return;
    }

    request.extra['retryCount'] = retryCount + 1;
    try {
      handler.resolve(await _dio.fetch<dynamic>(request));
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }
}
