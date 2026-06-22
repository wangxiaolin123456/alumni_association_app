import 'package:alumni_association_app/app/router/app_router.dart';
import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/member/certification/presentation/certification_controller.dart';
import 'package:alumni_association_app/features/member/widgets/member_feature_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
///校友认证
class CertificationFormPage extends StatelessWidget {
  const CertificationFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CertificationController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.alumniCertification,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => _showInstructions(context),
            child: Text(context.l10n.certificationInstructions),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 30.h),
        children: [
          _CertificationBanner(),
          SizedBox(height: 14.h),
          Container(
            padding: EdgeInsets.all(14.r),
            decoration: memberFeatureCardDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.certificationInformation,
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  context.l10n.certificationFormHint,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                SizedBox(height: 14.h),
                _FormField(
                  label: context.l10n.name,
                  controller: controller.nameController,
                  icon: Icons.person_outline_rounded,
                ),
                _FormField(
                  label: context.l10n.school,
                  controller: controller.schoolController,
                  icon: Icons.account_balance_outlined,
                ),
                _FormField(
                  label: context.l10n.college,
                  controller: controller.collegeController,
                  icon: Icons.school_outlined,
                ),
                _FormField(
                  label: context.l10n.cohort,
                  controller: controller.cohortController,
                  icon: Icons.workspace_premium_outlined,
                ),
                _FormField(
                  label: context.l10n.major,
                  controller: controller.majorController,
                  icon: Icons.menu_book_outlined,
                ),
                _FormField(
                  label: context.l10n.phoneNumber,
                  controller: controller.phoneController,
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
                Text(
                  context.l10n.uploadImages,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 10.h),
                Obx(() {
                  final uploaded = controller.uploadedTypes.toSet();
                  return Row(
                    children: [
                      _UploadCard(
                        label: context.l10n.studentCard,
                        selected: uploaded.contains('student'),
                        onTap: () => controller.toggleUpload('student'),
                      ),
                      SizedBox(width: 8.w),
                      _UploadCard(
                        label: context.l10n.diploma,
                        selected: uploaded.contains('diploma'),
                        onTap: () => controller.toggleUpload('diploma'),
                      ),
                      SizedBox(width: 8.w),
                      _UploadCard(
                        label: context.l10n.alumniProof,
                        selected: uploaded.contains('alumni'),
                        onTap: () => controller.toggleUpload('alumni'),
                      ),
                    ],
                  );
                }),
                SizedBox(height: 16.h),
                Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF5FF),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.verified_user_rounded,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(child: Text(context.l10n.certificationWarmTip)),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      if (controller.submit()) {
                        context.pushReplacement(
                          Pages.memberCertificationStatus,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              context.l10n.completeCertificationForm,
                            ),
                          ),
                        );
                      }
                    },
                    child: Text(context.l10n.submitCertification),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showInstructions(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.certificationInstructions),
        content: Text(context.l10n.certificationWarmTip),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(context.l10n.confirm),
          ),
        ],
      ),
    );
  }
}

class _CertificationBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 132.h,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF0752D8), Color(0xFF2498EF)],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  context.l10n.alumniCertification,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  context.l10n.certificationBenefitsHint,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          Icon(Icons.verified_user_rounded, color: Colors.white70, size: 78.sp),
        ],
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  const _FormField({
    required this.label,
    required this.controller,
    required this.icon,
    this.keyboardType,
  });
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label *', style: const TextStyle(fontWeight: FontWeight.w600)),
          SizedBox(height: 6.h),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(prefixIcon: Icon(icon)),
          ),
        ],
      ),
    );
  }
}

class _UploadCard extends StatelessWidget {
  const _UploadCard({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          height: 92.h,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFEAF2FF) : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: selected ? AppColors.primary : const Color(0xFFDDE5F0),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                selected
                    ? Icons.check_circle_rounded
                    : Icons.add_photo_alternate_outlined,
                color: AppColors.primary,
              ),
              SizedBox(height: 6.h),
              Text(label, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
