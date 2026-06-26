import 'dart:async';

import 'package:alumni_association_app/app/api/api_request.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/auth/domain/session_controller.dart';
import 'package:alumni_association_app/features/auth/model/request/bind_mobile_source.dart';
import 'package:alumni_association_app/features/auth/model/response/login_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 绑定手机号页面逻辑。
///
/// 注册成功或第三方登录后进入这里，只做手机号绑定，不再分步骤。
/// 绑定成功后会保存登录接口返回的 token，并正式进入 App。
class AccountBindController extends GetxController {
  AccountBindController(
    this._sessionController, {
    LoginResponse? initialLoginResponse,
    BindMobileSource? initialSource,
  }) : _loginResponse = initialLoginResponse,
       _source = initialSource;

  final SessionController _sessionController;

  /// 注册接口返回的登录信息。第三方登录进来时可能为空。
  LoginResponse? _loginResponse;

  /// 当前绑定手机号的来源信息。
  BindMobileSource? _source;

  /// 手机号输入框。
  final phoneController = TextEditingController();

  /// 表单错误提示。
  final errorMessage = RxnString();

  /// 提交中状态，防止重复点击。
  final isSubmitting = false.obs;



  /// 页面复用时同步第三方登录来源。
  void syncInitialSource(BindMobileSource? source) {
    if (source != null) _source = source;
  }

  /// 绑定手机号并进入 App。
  Future<void> bindPhone(BuildContext context,String email) async {
    final l10n = context.l10n;
    final phone = phoneController.text.trim();
    print("email=$email");


    if (!_isValidPhone(phone)) {
      errorMessage.value = l10n.invalidPhoneMessage;
      return;
    }

    isSubmitting.value = true;

    try {
      final source =
          _source ?? BindMobileSource.email(email);
      final success = await ApiRequest.bindMobile(
        phone: phone,
        email: source.email,
        lineId: source.lineId,
        wechatId: source.wechatId,
      );
      if (!success) return;
      if (!context.mounted) return;

      /// 绑定成功后把 phoneStatus 更新为已绑定，再保存完整登录态。
      final boundResponse =
          _loginResponse?.copyWith(phoneStatus: 0) ??
          const LoginResponse(
            token: 'phone_bind_mock_token',
            userId: 0,
            phoneStatus: 0,
            role: 0,
          );
      final latest =
          await ApiRequest.userInfo(userId: boundResponse.userId);
      if(latest!=null){
        await _sessionController.signIn(latest);
        await _sessionController.signInAs(latest);
      }

      Get.offAllNamed('/');
    } finally {
      isSubmitting.value = false;
    }
  }

  bool _isValidPhone(String phone) {
    return RegExp(r'^1\d{10}$').hasMatch(phone);
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}
