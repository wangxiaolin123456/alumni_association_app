import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// App 全局颜色配置
abstract final class AppColors {
  /// 主色：按钮、选中状态、重点文字等
  static const primary = Color(0xFF0967F2);
  /// 页面整体背景色
  static const background = Color(0xFFFFFFFF);

  /// 成功状态颜色：成功、通过、完成等
  static const success = Color(0xFF19B96B);
  /// 警告状态颜色：待处理、提醒等
  static const warning = Color(0xFFFFA51F);
  /// 危险状态颜色：失败、删除、错误等
  static const danger = Color(0xFFFF4057);
  /// 主要文字颜色：标题、正文重点内容
  static const textPrimary = Color(0xFF111827);
  /// 次要文字颜色：说明文字、提示文字、未选中状态
  static const textSecondary = Color(0xFF667085);
  ///搜索框的背景颜色
  static const searchBox = Color(0xFFF2F5FA);
}
/// App 全局主题配置
abstract final class AppTheme {
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      surface: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      fontFamilyFallback: const [
        'PingFang SC',
        'Microsoft YaHei',
        'sans-serif',
      ],
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark, // Android 状态栏图标深色
          statusBarBrightness: Brightness.light, // iOS 状态栏文字深色

        ),
      ),
      cardTheme: const CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: AppColors.primary.withValues(alpha: 0.12),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? AppColors.primary
                : AppColors.textSecondary,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            color: states.contains(WidgetState.selected)
                ? AppColors.primary
                : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
