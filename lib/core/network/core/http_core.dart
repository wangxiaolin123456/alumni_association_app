import 'package:alumni_association_app/core/config/app_config.dart';
import 'package:alumni_association_app/core/network/interceptor/request_interceptor.dart';
import 'package:alumni_association_app/core/network/interceptor/response_interceptor.dart';
import 'package:alumni_association_app/core/network/interceptor/retry_interceptor.dart';
import 'package:dio/dio.dart';

/// Creates and configures the single Dio client shared by the application.
abstract final class HttpCore {
  static Dio createClient() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: const {'Accept': 'application/json'},
      ),
    );

    dio.interceptors.addAll([
      AppRequestInterceptor(),
      AppResponseInterceptor(),
      RetryInterceptor(dio),
      if (AppConfig.currentEnvironment != AppEnvironment.production)
        LogInterceptor(requestBody: true, responseBody: true),
    ]);
    return dio;
  }
}
