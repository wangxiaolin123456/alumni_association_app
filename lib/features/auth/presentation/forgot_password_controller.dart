import 'dart:async';

import 'package:alumni_association_app/app/api/api_request.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/util/loading_util.dart';
import 'package:alumni_association_app/util/password_util.dart';
import 'package:alumni_association_app/util/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 忘记密码页面逻辑。
class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();
  final codeController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  /// 两个密码框分别控制显隐。
  final obscureNewPassword = true.obs;
  final obscureConfirmPassword = true.obs;
  final secondsRemaining = 0.obs;
  final isSubmitting = false.obs;
  final errorMessage = RxnString();

  Timer? _timer;

  bool get canSendCode =>
      emailController.text.trim().contains('@') && secondsRemaining.value == 0;

  void toggleNewPasswordVisible() {
    obscureNewPassword.value = !obscureNewPassword.value;
  }

  void toggleConfirmPasswordVisible() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  /// 发送邮箱验证码。
  Future<void> sendCode() async {
    if (!canSendCode) {
      errorMessage.value =
          Get.context?.l10n.invalidEmailMessage ?? '请输入有效的邮件地址';
      return;
    }
    errorMessage.value = null;

    LoadingUtil.showSafe();
    final success = await ApiRequest.sendResetCode(
      email: emailController.text.trim(),
    ).whenComplete(LoadingUtil.dismissSafe);

    if (!success) return;
    ToastUtils.showToast(
      message: Get.context?.l10n.sendCodeSuccess ?? '验证码已发送，请查收邮件',
    );

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

  /// 重置密码，模拟接口成功后返回登录页。
  Future<void> resetPassword(BuildContext context) async {
    final l10n = context.l10n;
    final email = emailController.text.trim();
    final code = codeController.text.trim();
    final password = newPasswordController.text.trim();
    final confirm = confirmPasswordController.text.trim();

    if (!email.contains('@')) {
      errorMessage.value = l10n.invalidEmailMessage;
      return;
    }
    if (code.length < 4) {
      errorMessage.value = l10n.codeRequiredMessage;
      return;
    }
    if (!PasswordUtil.isValid(password)) {
      errorMessage.value = l10n.passwordRuleMessage;
      return;
    }
    if (password != confirm) {
      errorMessage.value = l10n.passwordNotMatch;
      return;
    }

    isSubmitting.value = true;
    LoadingUtil.showSafe();
    try {
      final success = await ApiRequest.passwordReset(
        email: email,
        code: code,
        password: PasswordUtil.encryptForApi(password),
      );
      if (!success) return;
      errorMessage.value = null;
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.passwordResetSuccess)));
      Get.back();
    } finally {
      isSubmitting.value = false;
      LoadingUtil.dismissSafe();
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    emailController.dispose();
    codeController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
