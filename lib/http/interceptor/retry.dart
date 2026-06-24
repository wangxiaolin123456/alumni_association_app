import 'dart:io';
import 'package:dio/dio.dart';
import '../../core/widgets/dialog/confirm_dialog_util.dart';
import '../../util/loading_util.dart';
import '../model/retrier.dart';

/// 重试拦截器
///自定义 Dio 拦截器类
class MyRetryOnConnectionChangeInterceptor extends Interceptor {
  final DioConnectivityRequestRetrier requestRetrier;

  MyRetryOnConnectionChangeInterceptor({required this.requestRetrier});

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    LoadingUtil.dismiss();
    if (err.error is SocketException) {
      final retry = await ConfirmDialogUtil.show(
        title: 'ネットワークエラー',
        message: 'ネットワークに接続されていません。再試行してください。',
        cancelText: 'キャンセル',
        confirmText: '再試行',
      );
      if (retry == true) {
        try {
          final response = await requestRetrier.scheduleRequestRetry(err.requestOptions);
          return handler.resolve(response); // ✅ 成功后传递回响应
        } catch (e) {
          return handler.reject(err); // 重试失败再报错
        }
      } else {
        return handler.reject(err); // 用户取消不重试
      }
    } else {
      return handler.next(err); // 非网络错误继续传下去
    }
  }

}
