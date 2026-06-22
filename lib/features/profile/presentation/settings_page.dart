import 'package:alumni_association_app/app/router/app_router.dart';
import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/auth/domain/session_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
///设置
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: context.pop,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Text(
          l10n.settings,
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 30.h),
        children: [
          _SettingsCard(
            icon: Icons.lock_outline_rounded,
            color: const Color(0xFF5B5EF7),
            title: l10n.changePassword,
            subtitle: l10n.changePasswordDesc,
            onTap: () => context.push(Pages.forgotPassword),
          ),
          _SettingsCard(
            icon: Icons.language_rounded,
            color: AppColors.primary,
            title: l10n.languageSwitch,
            subtitle: l10n.chinese,
            onTap: () => context.push(Pages.settingsLanguage),
          ),
          _SettingsCard(
            icon: Icons.work_outline_rounded,
            color: AppColors.success,
            title: l10n.clearCache,
            subtitle: l10n.currentCache,
          ),
          _SettingsCard(
            icon: Icons.info_outline_rounded,
            color: AppColors.primary,
            title: l10n.aboutUs,
            subtitle: l10n.aboutUsDesc,
          ),
          _SettingsCard(
            icon: Icons.upgrade_rounded,
            color: const Color(0xFF9B5CF6),
            title: l10n.checkUpdates,
            subtitle: l10n.currentVersion,
          ),
          _SettingsCard(
            icon: Icons.description_outlined,
            color: const Color(0xFFFF8A3D),
            title: l10n.relatedAgreements,
            subtitle: l10n.relatedAgreementsDesc,
          ),
          SizedBox(height: 24.h),
          SizedBox(
            height: 58.h,
            child: FilledButton(
              onPressed: () {
                Get.find<SessionController>().signOut();
                context.go('/');
              },
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.danger,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              child: Text(
                l10n.signOut,
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E5AA8).withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        minTileHeight: 78.h,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
        leading: Container(
          width: 46.r,
          height: 46.r,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(13.r),
          ),
          child: Icon(icon, color: color, size: 25.sp),
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13.sp),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
