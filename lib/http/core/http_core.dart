import 'package:alumni_association_app/core/config/app_config.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../interceptor/reponse.dart';
import '../interceptor/request.dart';
import '../interceptor/retry.dart';
import '../model/retrier.dart';

/// 网络核心封装类：单例模式 + 支持泛型解析
class HttpCore {
  // 单例实例
  static final HttpCore _instance = HttpCore._internal();
  // 工厂构造，返回单例
  factory HttpCore() => _instance;
  // Dio 实例（全局）
  static late final Dio _dio;

  // 私有构造方法
  HttpCore._internal() {
    // 初始化基础配置
    BaseOptions options = BaseOptions(
      baseUrl: AppConfig.apiBaseUrl, // 接口根地址，可根据环境修改
      connectTimeout: const Duration(seconds: 60), // 连接超时
      receiveTimeout: const Duration(seconds: 60), // 接收超时
      headers: {
        'Content-Type': 'application/json', // 默认请求头为 JSON
        // 可以在拦截器中统一注入 token
      },
    );
    // 初始化 Dio 实例
    _dio = Dio(options);
    // 添加日志拦截器，打印请求和响应体
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
    // 可以在此添加拦截器，如请求拦截器、错误处理等
    _dio.interceptors.add(MyRequestInterceptor());
    _dio.interceptors.add(MyResponseInterceptor());
    _dio.interceptors.add(
      MyRetryOnConnectionChangeInterceptor(
        requestRetrier: DioConnectivityRequestRetrier(
          dio: _dio,
          connectivity: Connectivity(),
        ),
      ),
    );
    // _dio.interceptors.add(MyResponseInterceptor());
  }
  /// 创建新的取消令牌，用于控制取消请求
  CancelToken generateCancelToken() => CancelToken();

  void cancelRequests({required CancelToken token}) {
    token.cancel("cancelled");
  }

  /// 统一封装 POST 请求，支持泛型解析和可选的解析函数
  ///
  /// [T] 为返回的数据模型类型
  /// [path] 为接口路径，如 /api/login
  /// [queryParams] 可选的 URL 查询参数
  /// [body] 请求体参数
  /// [options] 可选的 Dio Options（比如 header、contentType 等）
  /// [cancelToken] 可取消请求的令牌
  /// [parse] 传入自定义的解析函数，默认使用 FactoryModel.generateModel<T>
  Future<dynamic> post<T>(
      String path, {
        Map<String, dynamic>? queryParams,
        dynamic body,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    try {
      // 发起 POST 请求
      final response = await _dio.post(
        path,
        data: body,
        queryParameters: queryParams,
        options: options,
        cancelToken: cancelToken ?? generateCancelToken(),
      );
      return response.data;// 保持返回原始 JSON 数据
    } catch (e, stack) {
      // 捕获异常，打印日志并向上抛出
      print('❌ POST 请求异常: $e\n$stack');
      rethrow;
    }
  }

  Future get(String path,
      {Map<String, dynamic>? params,
        Options? options,
        CancelToken? cancelToken}) async {
    try {
      var response = await _dio.get(
        path,
        queryParameters: params,
        options: options,
        cancelToken: cancelToken ?? generateCancelToken(),
      );
      return response.data;
    } catch (e, stack) {
      print('❌ GET 请求异常: $e\n$stack');
      rethrow;
    }
  }

  Future put(String path,
      {data,
        Map<String, dynamic>? params,
        Options? options,
        CancelToken? cancelToken}) async {
    var response = await _dio.put(
      path,
      data: data,
      queryParameters: params,
      options: options,
      cancelToken: cancelToken ?? generateCancelToken(),
    );
    return response.data;
  }

  Future patch(String path,
      {data,
        Map<String, dynamic>? params,
        Options? options,
        CancelToken? cancelToken}) async {
    var response = await _dio.patch(
      path,
      data: data,
      queryParameters: params,
      options: options,
      cancelToken: cancelToken ?? generateCancelToken(),
    );
    return response.data;
  }

  Future delete(String path,
      {data,
        Map<String, dynamic>? params,
        Options? options,
        CancelToken? cancelToken}) async {
    var response = await _dio.delete(
      path,
      data: data,
      queryParameters: params,
      options: options,
      cancelToken: cancelToken ?? generateCancelToken(),
    );
    return response.data;
  }
}
