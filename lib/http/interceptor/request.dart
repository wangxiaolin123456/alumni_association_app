import 'package:dio/dio.dart';

/// 请求拦截器
class MyRequestInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print(
        "========REQUEST BEGIBN=======\n[METHOD]: ${options.method}\n[PATH]: ${options.baseUrl}${options.path}\n[HEADER]: ${options.headers}}\n[PARAMS]: ${options.data}\n========REQUEST END=======");
    return super.onRequest(options, handler);
  }
}
