import 'package:dio/dio.dart';

/// Keeps response normalization in one place before data reaches repositories.
class AppResponseInterceptor extends Interceptor {
  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (response.data is Map) {
      response.data = Map<String, dynamic>.from(response.data as Map);
    }
    handler.next(response);
  }
}
