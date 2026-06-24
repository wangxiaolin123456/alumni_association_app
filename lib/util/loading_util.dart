import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

/// 全局 Loading 工具类
class LoadingUtil {
  /// 初始化 Loading 样式
  /// 在 main() 里面调用一次即可
  static void initStyle() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 1800)

    // 样式
      ..loadingStyle = EasyLoadingStyle.custom
      ..backgroundColor = Colors.white
      ..indicatorColor = AppColors.primary
      ..textColor = const Color(0xFF222222)
      ..maskColor = Colors.black.withOpacity(0.18)

    // 圆角与大小
      ..radius = 18
      ..contentPadding = const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 20,
      )
      ..indicatorSize = 36

    // 字体
      ..fontSize = 14
      ..toastPosition = EasyLoadingToastPosition.center

    // 交互
      ..userInteractions = false
      ..dismissOnTap = false

    // 动画
      ..animationStyle = EasyLoadingAnimationStyle.scale;
  }

  /// 显示 loading
  static void show({String? text}) {
    EasyLoading.show(
      status: text ?? '読み込み中...',
      maskType: EasyLoadingMaskType.custom,
      dismissOnTap: false,
    );
  }

  /// 显示 toast
  static void toast(String text) {
    EasyLoading.showToast(
      text,
      toastPosition: EasyLoadingToastPosition.center,
      maskType: EasyLoadingMaskType.none,
      dismissOnTap: true,
    );
  }

  /// 显示错误 toast
  static void showError(String text) {
    EasyLoading.showError(
      text,
      maskType: EasyLoadingMaskType.none,
      dismissOnTap: true,
      duration: const Duration(milliseconds: 1800),
    );
  }

  /// 显示成功 toast
  static void showSuccess(String text) {
    EasyLoading.showSuccess(
      text,
      maskType: EasyLoadingMaskType.none,
      dismissOnTap: true,
      duration: const Duration(milliseconds: 1600),
    );
  }

  /// 隐藏 loading
  static void dismiss() {
    try {
      if (isLoading) {
        EasyLoading.dismiss();
      }
    } catch (e) {
      debugPrint('[LoadingUtil] dismiss error: $e');
    }
  }

  /// 安全显示 loading，避免重复显示
  static void showSafe({String? text}) {
    try {
      if (!isLoading) {
        show(text: text);
      }
    } catch (e) {
      debugPrint('[LoadingUtil] showSafe error: $e');
    }
  }

  /// 安全隐藏 loading，避免重复隐藏
  static void dismissSafe() {
    try {
      if (isLoading) {
        EasyLoading.dismiss();
      }
    } catch (e) {
      debugPrint('[LoadingUtil] dismissSafe error: $e');
    }
  }

  /// 判断是否在 loading 中
  static bool get isLoading => EasyLoading.isShow;
}