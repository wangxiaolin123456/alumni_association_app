import 'package:alumni_association_app/app/router/app_router.dart';
import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/member/widgets/member_feature_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CertificationSuccessPage extends StatelessWidget {
  const CertificationSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final rights = [
      (Icons.badge_outlined, context.l10n.identityMark, AppColors.primary),
      (
        Icons.currency_yen_rounded,
        context.l10n.merchantBenefits,
        AppColors.success,
      ),
      (
        Icons.star_rounded,
        context.l10n.activityPriority,
        const Color(0xFF8954F6),
      ),
      (
        Icons.redeem_rounded,
        context.l10n.memberBenefits,
        const Color(0xFFFF6A1A),
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.certificationSuccess,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 24.h),
        children: [
          Container(
            padding: EdgeInsets.all(28.r),
            decoration: memberFeatureCardDecoration,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 48.r,
                  backgroundColor: const Color(0xFFE6F9EF),
                  child: Icon(
                    Icons.check_rounded,
                    color: AppColors.success,
                    size: 58.sp,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  context.l10n.certificationPassed,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  context.l10n.certifiedAlumniMember,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: memberFeatureCardDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.certificationRights,
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  children: rights
                      .map(
                        (item) => Expanded(
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: item.$3,
                                child: Icon(item.$1, color: Colors.white),
                              ),
                              SizedBox(height: 7.h),
                              Text(
                                item.$2,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 10.sp),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: memberFeatureCardDecoration,
            child: Column(
              children: [
                _SuccessInfo(
                  label: context.l10n.memberIdLabel,
                  value: 'XYH20240001',
                ),
                _SuccessInfo(
                  label: context.l10n.memberIdentity,
                  value: context.l10n.alumniMember,
                ),
                _SuccessInfo(
                  label: context.l10n.certificationTime,
                  value: '2026-06-12',
                ),
              ],
            ),
          ),
          SizedBox(height: 30.h),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () => context.pushReplacement(Pages.memberCard),
                  child: Text(context.l10n.viewMemberCard),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.go('/'),
                  child: Text(context.l10n.returnHome),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SuccessInfo extends StatelessWidget {
  const _SuccessInfo({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
