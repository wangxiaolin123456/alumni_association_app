import 'package:alumni_association_app/core/network/core/http_core.dart';
import 'package:alumni_association_app/core/network/model/api_exception.dart';
import 'package:alumni_association_app/core/network/model/api_response.dart';
import 'package:alumni_association_app/core/network/model/json_request.dart';

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../storage/storage.dart';

class HttpManager extends GetxService {
  late final Dio client;

  @override
  void onInit() {
    super.onInit();
    client = HttpCore.createClient();
  }

  /// 构建通用 Header
  Future<Map<String, dynamic>> _getAuthorizationHeader() async {
    final token = Storage.accessToken;

    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Future<ApiResponse<T>> get<T>(
    String path, {
    JsonRequest? query,
    T Function(Object? json)? parser,
    CancelToken? cancelToken,
  }) => request<T>(
    path,
    method: 'GET',
    queryParameters: query?.toJson(),
    parser: parser,
    cancelToken: cancelToken,
  );

  Future<ApiResponse<T>> post<T>(
    String path, {
    JsonRequest? body,
    T Function(Object? json)? parser,
    CancelToken? cancelToken,
  }) => request<T>(
    path,
    method: 'POST',
    data: body?.toJson(),
    parser: parser,
    cancelToken: cancelToken,
  );

  Future<ApiResponse<T>> put<T>(
    String path, {
    JsonRequest? body,
    T Function(Object? json)? parser,
    CancelToken? cancelToken,
  }) => request<T>(
    path,
    method: 'PUT',
    data: body?.toJson(),
    parser: parser,
    cancelToken: cancelToken,
  );

  Future<ApiResponse<T>> delete<T>(
    String path, {
    JsonRequest? body,
    T Function(Object? json)? parser,
    CancelToken? cancelToken,
  }) => request<T>(
    path,
    method: 'DELETE',
    data: body?.toJson(),
    parser: parser,
    cancelToken: cancelToken,
  );

  Future<ApiResponse<T>> request<T>(
    String path, {
    required String method,
    Object? data,
    Map<String, dynamic>? queryParameters,
    T Function(Object? json)? parser,
    CancelToken? cancelToken,
  }) async {
    try {
      final headers = await _getAuthorizationHeader();

      final response = await client.request<Object?>(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: Options(method: method, headers: headers),
      );

      final json = response.data;

      if (json is! Map<String, dynamic>) {
        throw const ApiException(message: '接口返回格式异常');
      }

      final result = ApiResponse<T>.fromJson(json, parser);

      if (!result.isSuccess) {
        throw ApiException(message: result.message, code: result.code);
      }

      return result;
    } on ApiException {
      rethrow;
    } on DioException catch (error) {
      throw ApiException.fromDioException(error);
    }
  }
}
