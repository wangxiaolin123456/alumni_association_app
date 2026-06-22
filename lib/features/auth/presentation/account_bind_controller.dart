import 'dart:async';

import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

/// 第三方登录后绑定邮箱的页面逻辑。
class AccountBindController extends GetxController {
  final emailController = TextEditingController();
  final codeController = TextEditingController();
  final passwordController = TextEditingController();

  final currentStep = 0.obs;
  final secondsRemaining = 0.obs;
  final obscurePassword = true.obs;
  final errorMessage = RxnString();
  final isSubmitting = false.obs;

  Timer? _timer;

  bool get canSendCode =>
      emailController.text.trim().contains('@') && secondsRemaining.value == 0;

  void togglePasswordVisible() {
    obscurePassword.value = !obscurePassword.value;
  }

  void sendCode() {
    if (!canSendCode) {
      errorMessage.value =
          Get.context?.l10n.invalidEmailMessage ?? '请输入有效的邮件地址';
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

  Future<void> next(BuildContext context) async {
    final l10n = context.l10n;
    if (currentStep.value == 0) {
      if (!emailController.text.trim().contains('@')) {
        errorMessage.value = l10n.invalidEmailMessage;
        return;
      }
      if (codeController.text.trim().length < 4) {
        errorMessage.value = l10n.codeRequiredMessage;
        return;
      }
      errorMessage.value = null;
      currentStep.value = 1;
      return;
    }

    if (currentStep.value == 1) {
      if (passwordController.text.trim().length < 6) {
        errorMessage.value = l10n.passwordRequiredMessage;
        return;
      }
      isSubmitting.value = true;
      try {
        await Future<void>.delayed(const Duration(milliseconds: 300));
        currentStep.value = 2;
        if (!context.mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.accountBindSuccess)));
      } finally {
        isSubmitting.value = false;
      }
      return;
    }

    context.go('/');
  }

  @override
  void onClose() {
    _timer?.cancel();
    emailController.dispose();
    codeController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
