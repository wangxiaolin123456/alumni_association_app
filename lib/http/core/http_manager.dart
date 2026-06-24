import 'dart:typed_data';

import 'package:dio/dio.dart';
import '../../storage/storage.dart';
import '../base_response.dart';
import 'http_core.dart';

class HttpManager {
  /// 构建通用 Header
  static Future<Map<String, dynamic>> _getAuthorizationHeader() async {
    final token = await Storage.accessToken;
    print("token=$token");
    return {
      "Authorization": "$token",
      // "platform": Platform.isIOS ? "ios" : "android",
      // "brand": Platform.isIOS ? "apple" : DeviceInfo.brand,
      // "version": DeviceInfo.version,
    };
  }

  /// 构建带 header 和额外参数的 Options
  static Future<Options> _buildOptions(
      Options? options, {
        Map<String, dynamic>? extra,
      }) async {
    final headers = await _getAuthorizationHeader();

    final inputHeaders = options?.headers ?? {};

    return (options ?? Options()).copyWith(
      headers: {
        ...headers,
        ...inputHeaders,
      },
      contentType: options?.contentType ?? Headers.jsonContentType,
      extra: extra ?? {},
    );
  }

  /// 统一处理 Dio 异常
  static void _handleDioError(DioException e) {
    print("❌ DioError: ${e.type} - ${e.message}");
  }

  static void cancelRequests({required CancelToken token}) {
    HttpCore().cancelRequests(token: token);
  }

  static Future<ApiResponse<T>> get<T>(
      String path, {
        Map<String, dynamic>? params,
        Options? options,
        CancelToken? cancelToken,
        bool refresh = false,
        bool noCache = true,///!CACHE_ENABLE
        String? cacheKey,
        bool cacheDisk = false,
        T Function(Map<String, dynamic> json)? parse,
      }) async {
    try {
      final requestOptions = await _buildOptions(options, extra: {
        "refresh": refresh,
        "noCache": noCache,
        "cacheKey": cacheKey,
        "cacheDisk": cacheDisk,
      });

      final response = await HttpCore().get(
        path,
        params: params,
        options: requestOptions,
        cancelToken: cancelToken,
      );
      return ApiResponse<T>.fromJson(
        response
      );
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  static Future<ApiResponse<T>> post<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? params,
        Options? options,
        CancelToken? cancelToken,
        T Function(Map<String, dynamic> json)? parse,
      }) async {
    try {
      final requestOptions = await _buildOptions(options);
      final response = await HttpCore().post(
        path,
        body: data,
        queryParams: params,
        options: requestOptions,
        cancelToken: cancelToken,
      );
      return ApiResponse<T>.fromJson(response);
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  static Future<ApiResponse<T>> put<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? params,
        Options? options,
        CancelToken? cancelToken,
        T Function(Map<String, dynamic> json)? parse,
      }) async {
    try {
      final requestOptions = await _buildOptions(options);
      final response = await HttpCore().put(
        path,
        data: data,
        params: params,
        options: requestOptions,
        cancelToken: cancelToken,
      );
      return ApiResponse<T>.fromJson(
        response
      );
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  static Future<ApiResponse<T>> patch<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? params,
        Options? options,
        CancelToken? cancelToken,
        T Function(Map<String, dynamic> json)? parse,
      }) async {
    try {
      final requestOptions = await _buildOptions(options);
      final response = await HttpCore().patch(
        path,
        data: data,
        params: params,
        options: requestOptions,
        cancelToken: cancelToken,
      );
      return ApiResponse<T>.fromJson(
        response
      );
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  static Future<ApiResponse<T>> delete<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? params,
        Options? options,
        CancelToken? cancelToken,
        T Function(Map<String, dynamic> json)? parse,
      }) async {
    try {
      final requestOptions = await _buildOptions(options);
      final response = await HttpCore().delete(
        path,
        data: data,
        params: params,
        options: requestOptions,
        cancelToken: cancelToken,
      );
      return ApiResponse<T>.fromJson(
        response
      );
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }


  /// 下载二进制（用于 PDF/图片/文件）
  /// 返回 Uint8List
  static Future<Uint8List> downloadBytes(
      String path, {
        Map<String, dynamic>? params,
        Options? options,
        CancelToken? cancelToken,
        bool refresh = false,
        bool noCache = true,
        String? cacheKey,
        bool cacheDisk = false,
      }) async {
    try {
      final requestOptions = await _buildOptions(
        (options ?? Options()).copyWith(responseType: ResponseType.bytes),
        extra: {
          "refresh": refresh,
          "noCache": noCache,
          "cacheKey": cacheKey,
          "cacheDisk": cacheDisk,
        },
      );

      final resp = await HttpCore().get(
        path,
        params: params,
        options: requestOptions,
        cancelToken: cancelToken,
      );

      // 这里的 resp 取决于你 HttpCore().get 返回什么：
      // ✅ 常见情况1：直接返回 Dio 的 Response 对象
      // ✅ 常见情况2：返回 response.data
      //
      // 你现在 HttpManager.get 是把 resp 直接丢给 ApiResponse.fromJson，
      // 说明 HttpCore().get 很可能返回的是 Map/String，而不是 Response。
      //
      // 所以这里做“兼容解析”：
      if (resp is Response) {
        final data = resp.data;
        if (data is List<int>) return Uint8List.fromList(data);
        if (data is Uint8List) return data;
      }

      if (resp is List<int>) return Uint8List.fromList(resp);
      if (resp is Uint8List) return resp;

      throw Exception("downloadBytes: 未获取到二进制数据，respType=${resp.runtimeType}");
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

}
