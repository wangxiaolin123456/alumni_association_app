import 'package:alumni_association_app/app/router/app_router.dart';
import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/member/certification/presentation/certification_controller.dart';
import 'package:alumni_association_app/features/member/widgets/member_feature_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


class CertificationStatusPage extends StatelessWidget {
  const CertificationStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CertificationController>();
    final data = controller.submitted.value;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.certificationStatus,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 24.h),
        children: [
          Container(
            padding: EdgeInsets.all(26.r),
            decoration: memberFeatureCardDecoration,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 48.r,
                  backgroundColor: const Color(0xFFFFF5E9),
                  child: Icon(
                    Icons.hourglass_top_rounded,
                    color: AppColors.warning,
                    size: 48.sp,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  context.l10n.certificationPending,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  context.l10n.certificationPendingHint,
                  textAlign: TextAlign.center,
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
                  context.l10n.submittedInformation,
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                _InfoRow(label: context.l10n.name, value: data?.name ?? '--'),
                _InfoRow(
                  label: context.l10n.school,
                  value: data?.school ?? '--',
                ),
                _InfoRow(
                  label: context.l10n.college,
                  value: data?.college ?? '--',
                ),
                _InfoRow(
                  label: context.l10n.cohort,
                  value: data?.cohort ?? '--',
                ),
                _InfoRow(
                  label: context.l10n.phoneNumber,
                  value: _maskPhone(data?.phone),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF5FF),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Text(
              context.l10n.certificationReviewTips,
              style: const TextStyle(height: 1.8),
            ),
          ),
          SizedBox(height: 28.h),
          OutlinedButton(
            onPressed: () {
              controller.withdraw();
              Get.toNamed(Pages.memberCertification);
            },
            child: Text(context.l10n.withdrawAndEdit),
          ),
          SizedBox(height: 10.h),
          FilledButton(
            onPressed: () {
              controller.approve();
              Get.toNamed(Pages.memberCertificationSuccess);
            },
            child: Text(context.l10n.viewReviewResult),
          ),
        ],
      ),
    );
  }

  String _maskPhone(String? phone) {
    if (phone == null || phone.length < 7) return '--';
    return '${phone.substring(0, 3)} **** ${phone.substring(phone.length - 4)}';
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 14.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
