import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/locale_controller.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LocaleController>();

    return Obx(() {
      final l10n = context.l10n;
      return Scaffold(
        appBar: AppBar(title: Text(l10n.languageSwitch,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),), centerTitle: true),
        body: SafeArea(
          top: false,
          child: ListView(
            padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 30.h),
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                decoration: _languageCardDecoration,
                child: SwitchListTile(
                  secondary: _LanguageIcon(size: 38.r),
                  title: Text(l10n.followSystemLanguage, style: _titleStyle),
                  subtitle: Text(
                    l10n.followSystemLanguageDesc,
                    style: _subtitleStyle,
                  ),
                  value: controller.followsSystem.value,
                  onChanged: (value) {
                    value
                        ? controller.followSystem()
                        : controller.stopFollowingSystem();
                  },
                ),
              ),
              SizedBox(height: 26.h),
              Text(
                l10n.chooseLanguage,
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 10.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: _languageCardDecoration,
                child: Column(
                  children: [
                    _LanguageTile(
                      title: l10n.chinese,
                      subtitle: l10n.simplifiedChinese,
                      selected:
                          !controller.followsSystem.value &&
                          controller.activeLocale.value.languageCode == 'zh',
                      onTap: () => controller.select(const Locale('zh')),
                    ),
                    const Divider(height: 1),
                    _LanguageTile(
                      title: l10n.english,
                      subtitle: l10n.english,
                      selected:
                          !controller.followsSystem.value &&
                          controller.activeLocale.value.languageCode == 'en',
                      onTap: () => controller.select(const Locale('en')),
                    ),
                    const Divider(height: 1),
                    _LanguageTile(
                      title: l10n.japanese,
                      subtitle: l10n.japanese,
                      selected:
                          !controller.followsSystem.value &&
                          controller.activeLocale.value.languageCode == 'ja',
                      onTap: () => controller.select(const Locale('ja')),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18.h),
              Text(l10n.languageUpdateHint, style: _subtitleStyle),
            ],
          ),
        ),
      );
    });
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minTileHeight: 68.h,
      contentPadding: EdgeInsets.symmetric(horizontal: 5.w),
      onTap: onTap,
      leading: _LanguageIcon(size: 34.r),
      title: Text(title, style: _titleStyle),
      subtitle: Text(subtitle, style: _subtitleStyle),
      trailing: selected
          ? Icon(Icons.check_rounded, color: AppColors.primary, size: 25.sp)
          : null,
    );
  }
}

class _LanguageIcon extends StatelessWidget {
  const _LanguageIcon({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFEAF2FF),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Icon(
        Icons.language_rounded,
        color: AppColors.primary,
        size: 23.sp,
      ),
    );
  }
}

BoxDecoration get _languageCardDecoration => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(18.r),
  boxShadow: [
    BoxShadow(
      color: const Color(0xFF1E5AA8).withValues(alpha: 0.05),
      blurRadius: 20,
      offset: const Offset(0, 6),
    ),
  ],
);

TextStyle get _titleStyle =>
    TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600);
TextStyle get _subtitleStyle =>
    TextStyle(color: AppColors.textSecondary, fontSize: 13.sp);
