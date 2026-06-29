import 'package:alumni_association_app/features/auth/domain/session_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../app/router/app_router.dart';
import '../../core/widgets/dialog/confirm_dialog_util.dart';
import '../../storage/storage.dart';
import 'package:get/get.dart' hide Response;

import '../../util/loading_util.dart';
import '../../util/pretty_print_json.dart';


/// 响应拦截器
class MyResponseInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    // print("========RESPONSE BEGIBN=======\n[RESPONSE]: ${response.toString()}");
    debugPrint("======== RESPONSE BEGIN ========");
    debugPrint("url: ${response.requestOptions.uri}");
    debugPrint("status: ${response.statusCode}");


    // ✅ 1) 文件/二进制：直接放行，别走下面的 JSON code 解析
    final rt = response.requestOptions.responseType;
    if (rt == ResponseType.bytes || rt == ResponseType.stream) {
      // 这里不要 printJsonLine，会打印一堆数字
      handler.next(response);
      return;
    }


    // ✅ 2) 再兜底：根据 Content-Type 判断（防止忘记设置 responseType）
    final ct = response.headers.value(Headers.contentTypeHeader) ?? '';
    if (ct.contains('application/pdf') || ct.contains('application/octet-stream')) {
      handler.next(response);
      return;
    }

    printJsonLine(response.data);
    // print('response.data=${response.data}');
    int? responseBodyCode = response.data['code'];
    print('response.statusCode=${response.statusCode}');
    if (responseBodyCode == 401) {
      LoadingUtil.dismiss();
      print('清token');
      ///登录已过期，请重新登录
      SessionController.current.signOut();
      Storage.setAccessToken(token: null);
      Storage.clearUserInfo();
      final result = await ConfirmDialogUtil.show(
        title: 'アカウント通知',
        message: '他のデバイスでログイン中です。このデバイスで続ける場合は、再度ログインしてください。',
        confirmText: '確定',
        showCancelButton: false
      );
      if (result == true) {
        // 清空页面栈并跳转到登录页
        Get.offAllNamed(Pages.login);
      }
    }
    super.onResponse(response, handler);
  }
}
