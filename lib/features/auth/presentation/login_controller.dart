import 'dart:async';

import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/auth/data/auth_api.dart';
import 'package:alumni_association_app/features/auth/domain/session_controller.dart';
import 'package:alumni_association_app/features/auth/domain/user_role.dart';
import 'package:alumni_association_app/features/auth/model/response/login_response.dart';
import 'package:alumni_association_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

/// 统一管理登录页表单状态。
///
/// 当前先用本地模拟登录：注册走「邮箱 + 验证码」，登录走「邮箱 + 密码」。
/// 后续接入真实接口时，只需要在 [_finishAuth] 前替换为接口校验即可。
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

  /// 校验邮箱并开启本地验证码倒计时。
  void sendEmailCode() {
    if (!canSendCode) {
      errorMessage.value = _message((l10n) => l10n.invalidEmailMessage);
      return;
    }

    errorMessage.value = null;
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
    try {
      final response = await AuthApi.loginWithEmailPassword(
        email: email,
        password: password,
      );
      if (response == null) {
        errorMessage.value = _message((l10n) => l10n.invalidLoginMessage);
        return;
      }
      if (!context.mounted) return;
      _finishAuth(context, response);
    } finally {
      isSubmitting.value = false;
    }
  }

  /// 邮箱验证码注册。
  Future<void> _registerWithEmailCode(BuildContext context) async {
    final email = emailController.text.trim();
    final code = codeController.text.trim();
    final password = passwordController.text.trim();
    if (!_validateEmail(email)) return;
    if (code.length < 4) {
      errorMessage.value = _message((l10n) => l10n.codeRequiredMessage);
      return;
    }
    if (password.length < 6) {
      errorMessage.value = _message((l10n) => l10n.passwordRequiredMessage);
      return;
    }
    if (!_validateAgreement()) return;

    isSubmitting.value = true;
    try {
      final response = await AuthApi.registerWithEmailCode(
        email: email,
        code: code,
        password: password,
      );
      if (!context.mounted) return;
      _finishAuth(context, response);
    } finally {
      isSubmitting.value = false;
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

  /// 读取当前语言的提示文案；无页面上下文时保留中文兜底，避免空指针。
  String _message(String Function(AppLocalizations l10n) mapper) {
    final context = Get.context;
    if (context == null) return '请检查输入内容';
    return mapper(context.l10n);
  }

  /// 返回首页，给登录页左上角返回按钮使用。
  void backHome(BuildContext context) {
    final router = GoRouter.of(context);

    if (router.canPop()) {
      context.pop();
    } else {
      context.go('/');
    }
  }

  /// 根据接口返回结果完成登录并回到首页。
  void _finishAuth(BuildContext context, LoginResponse response) {
    errorMessage.value = null;
    _sessionController.signInAs(_roleFromResponse(response));
    backHome(context);
  }

  /// 将接口返回的角色字段转换为应用内角色枚举。
  UserRole _roleFromResponse(LoginResponse response) {
    if (response.role == 'merchant') {
      return UserRole.merchant;
    }
    return UserRole.member;
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
