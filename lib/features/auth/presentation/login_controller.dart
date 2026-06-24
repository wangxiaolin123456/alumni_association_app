import 'dart:async';

import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/auth/domain/session_controller.dart';
import 'package:alumni_association_app/features/auth/model/response/login_response.dart';
import 'package:alumni_association_app/l10n/generated/app_localizations.dart';
import 'package:alumni_association_app/util/loading_util.dart';
import 'package:alumni_association_app/util/password_util.dart';
import 'package:alumni_association_app/util/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/api/api_request.dart';
import '../../../app/router/app_router.dart';
import '../model/request/bind_mobile_source.dart';

/// 统一管理登录页表单状态。
///
/// 注册走「邮箱 + 验证码 + 密码」。
/// 登录走「邮箱 + 密码」。
/// 真实网络请求统一走 ApiRequest，页面不直接接触网络层。
class LoginController extends GetxController {
  LoginController(this._sessionController);

  /// 登录成功后写入全局会话。
  final SessionController _sessionController;

  /// 邮箱输入框。
  final emailController = TextEditingController();

  /// 注册验证码输入框。
  final codeController = TextEditingController();

  /// 密码输入框。
  final passwordController = TextEditingController();

  /// 密码是否隐藏显示。
  final obscurePassword = true.obs;

  /// false 为邮箱密码登录，true 为邮箱验证码注册。
  final isRegisterMode = false.obs;

  /// 用户协议勾选状态。
  final agreedToTerms = false.obs;

  /// 验证码倒计时。
  final secondsRemaining = 0.obs;

  /// 表单错误提示。
  final errorMessage = RxnString();

  /// 登录/注册提交中，防止重复点击。
  final isSubmitting = false.obs;

  /// 当前验证码倒计时任务。
  Timer? _timer;

  /// 当前邮箱是否可以请求验证码。
  bool get canSendCode =>
      emailController.text.trim().contains('@') && secondsRemaining.value == 0;

  /// 切换登录/注册模式，并清理上一种模式遗留的错误提示。
  void switchMode(bool register) {
    isRegisterMode.value = register;
    errorMessage.value = null;
  }

  /// 更新用户协议勾选状态。
  void toggleAgreement(bool? value) {
    agreedToTerms.value = value ?? false;
  }

  /// 切换密码明文/隐藏显示。
  void togglePasswordVisible() {
    obscurePassword.value = !obscurePassword.value;
  }

  /// 校验邮箱、调用发送验证码接口，并开启倒计时。
  Future<void> sendEmailCode() async {
    if (!canSendCode) {
      errorMessage.value = _message((l10n) => l10n.invalidEmailMessage);
      return;
    }

    errorMessage.value = null;

    LoadingUtil.showSafe();
    final success = await ApiRequest.sendRegisterCode(
      email: emailController.text.trim(),
    ).whenComplete(LoadingUtil.dismissSafe);

    if (!success) {
      errorMessage.value = _message((l10n) => l10n.sendCodeFailed);
      return;
    }

    ToastUtils.showToast(message: _message((l10n) => l10n.sendCodeSuccess));
    secondsRemaining.value = 60;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value <= 1) {
        secondsRemaining.value = 0;
        timer.cancel();
      } else {
        secondsRemaining.value--;
      }
    });
  }

  /// 按当前模式提交表单。
  Future<void> login(BuildContext context) async {
    if (isSubmitting.value) return;

    if (isRegisterMode.value) {
      await _registerWithEmailCode(context);
    } else {
      await _loginWithEmailPassword(context);
    }
  }

  /// 邮箱密码登录。
  Future<void> _loginWithEmailPassword(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (!_validateEmail(email)) return;

    if (password.length < 6) {
      errorMessage.value = _message((l10n) => l10n.passwordRequiredMessage);
      return;
    }

    if (!_validateAgreement()) return;

    isSubmitting.value = true;
    LoadingUtil.showSafe();

    try {
      final response = await ApiRequest.login(
        email: email,
        password: PasswordUtil.encryptForApi(password),
      );

      if (response == null || response.token.isEmpty) {
        return;
      }

      if (!context.mounted) return;
      await _finishAuth(context, response);
    } finally {
      isSubmitting.value = false;
      LoadingUtil.dismissSafe();
    }
  }

  /// 邮箱验证码注册。
  ///
  /// 注册成功后不直接登录。
  /// 注册成功后自动切换回登录模式，让用户使用邮箱密码登录。
  Future<void> _registerWithEmailCode(BuildContext context) async {
    final email = emailController.text.trim();
    final code = codeController.text.trim();
    final password = passwordController.text.trim();

    if (!_validateEmail(email)) return;

    if (code.length < 4) {
      errorMessage.value = _message((l10n) => l10n.codeRequiredMessage);
      return;
    }

    if (!PasswordUtil.isValid(password)) {
      errorMessage.value = _message((l10n) => l10n.passwordRuleMessage);
      return;
    }

    if (!_validateAgreement()) return;

    isSubmitting.value = true;
    LoadingUtil.showSafe();

    try {
      final success = await ApiRequest.register(
        email: email,
        code: code,
        // 注册接口统一提交加密后的密码，避免明文密码进入请求体。
        password: PasswordUtil.encryptForApi(password),
      );

      if (!success) {
        errorMessage.value = _message((l10n) => l10n.registerFailed);
        return;
      }

      if (!context.mounted) return;

      errorMessage.value = null;

      /// 清空验证码和密码，邮箱保留，方便直接登录。
      codeController.clear();
      passwordController.clear();

      /// 切换回登录模式。
      isRegisterMode.value = false;

      ToastUtils.showToast(message: _message((l10n) => l10n.registerSuccess));
    } finally {
      isSubmitting.value = false;
      LoadingUtil.dismissSafe();
    }
  }

  /// 邮箱基础校验。
  bool _validateEmail(String email) {
    if (!email.contains('@')) {
      errorMessage.value = _message((l10n) => l10n.invalidEmailMessage);
      return false;
    }

    return true;
  }

  /// 协议勾选校验。
  bool _validateAgreement() {
    if (!agreedToTerms.value) {
      errorMessage.value = _message((l10n) => l10n.agreementRequiredMessage);
      return false;
    }

    return true;
  }

  /// 读取当前语言的提示文案。
  ///
  /// 无页面上下文时保留中文兜底，避免空指针。
  String _message(String Function(AppLocalizations l10n) mapper) {
    final context = Get.context;

    if (context == null) {
      return '请检查输入内容';
    }

    return mapper(context.l10n);
  }

  /// 返回首页，给登录页左上角返回按钮使用。
  void backHome() {
    if (Get.key.currentState?.canPop() ?? false) {
      Get.back();
    } else {
      Get.offAllNamed(Pages.home);
    }
  }

  /// 根据接口返回结果完成登录并回到首页。
  Future<void> _finishAuth(BuildContext context, LoginResponse response) async {
    errorMessage.value = null;


    /// 未绑定手机号时，先带着登录结果进入绑定页。
    /// 绑定完成后再保存登录态，避免未完成绑定的账号直接进入 App。
    if (!response.hasBoundPhone) {
      final email =  emailController.text.trim();
      Get.offNamed(
        Pages.accountBind,
        arguments: {
          'email': email,
          'source': BindMobileSource.email(email),

        },
      );
      return;
    }

    /// 登录完成后补拉一次用户信息，保证我的页面展示后端最新资料。
    final res = await ApiRequest.userInfo(userId: response.userId);
    if(res!=null){
      await _sessionController.signIn(res);
      await _sessionController.signInAs(res);
    }
    Get.offAllNamed('/');
  }

  /// 释放倒计时和输入框资源。
  @override
  void onClose() {
    _timer?.cancel();

    emailController.dispose();
    codeController.dispose();
    passwordController.dispose();

    super.onClose();
  }
}
