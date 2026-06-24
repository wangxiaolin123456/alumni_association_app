import 'dart:io';

import 'package:alumni_association_app/app/router/app_router.dart';
import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/member/certification/presentation/certification_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';

/// 校友认证表单页。
///
/// 按设计图拆成：顶部说明、权益 Banner、认证表单、证明材料上传、温馨提示、提交按钮。
/// 具体表单状态和上传逻辑放在 [CertificationController] 中，方便后续替换真实接口。
class CertificationFormPage extends StatelessWidget {
  const CertificationFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CertificationController>();
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => Get.back()),
        title: Text(context.l10n.alumniCertification, style: _pageTitleStyle),
        centerTitle: true,
        actions: [
          TextButton.icon(
            onPressed: () => _showInstructions(context),
            icon: Icon(Icons.info_outline_rounded, size: 16.sp),
            label: Text(context.l10n.certificationInstructions),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(14.w, 4.h, 14.w, 30.h),
        children: [
          _CertificationBanner(),
          SizedBox(height: 14.h),
          _CertificationFormCard(controller: controller),
        ],
      ),
    );
  }

  /// 认证说明弹窗。
  void _showInstructions(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.certificationInstructions),
        content: Text(context.l10n.certificationInstructionDetail),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
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
      height: 128.h,
      padding: EdgeInsets.fromLTRB(18.w, 12.h, 12.w, 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF075EF2), Color(0xFF1F8BFF)],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.alumniCertification,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  context.l10n.certificationBenefitsHint,
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                ),
                const Spacer(),
                Row(
                  children: [
                    _BannerBenefit(
                      icon: Icons.person_pin_circle_rounded,
                      label: context.l10n.exclusiveIdentity,
                    ),
                    SizedBox(width: 8.w),
                    _BannerBenefit(
                      icon: Icons.verified_user_rounded,
                      label: context.l10n.exclusiveRights,
                    ),
                    SizedBox(width: 8.w),
                    _BannerBenefit(
                      icon: Icons.workspace_premium_rounded,
                      label: context.l10n.exclusiveService,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // SizedBox(width: 8.w),
          Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.shield_rounded,
                color: Colors.white.withValues(alpha: 0.34),
                size: 90.sp,
              ),
              Icon(Icons.person_rounded, color: Colors.white, size: 38.sp),
              Positioned(
                right: 2.w,
                bottom: 21.h,
                child: CircleAvatar(
                  radius: 18.r,
                  backgroundColor: const Color(0xFFB8DCFF),
                  child: Icon(
                    Icons.check_rounded,
                    color: AppColors.primary,
                    size: 22.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BannerBenefit extends StatelessWidget {
  const _BannerBenefit({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white70, size: 15.sp),
        SizedBox(width: 4.w),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.white, fontSize: 12.sp),
        ),
      ],
    );
  }
}

class _CertificationFormCard extends StatelessWidget {
  const _CertificationFormCard({required this.controller});
  final CertificationController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            title: context.l10n.certificationInformation,
            subtitle: context.l10n.certificationFormHint,
          ),
          SizedBox(height: 16.h),
          _TextInputRow(
            label: context.l10n.name,
            hint: context.l10n.realNameHint,
            icon: Icons.person_outline_rounded,
            controller: controller.nameController,
          ),
          _SelectorRow(
            label: context.l10n.school,
            hint: context.l10n.chooseGraduatedSchool,
            icon: Icons.corporate_fare_outlined,
            controller: controller.schoolController,
            options: controller.schoolOptions,
            onSelected: controller.selectSchool,
          ),
          _SelectorRow(
            label: context.l10n.college,
            hint: context.l10n.chooseCollege,
            icon: Icons.account_balance_outlined,
            controller: controller.collegeController,
            options: controller.collegeOptions,
            onSelected: controller.selectCollege,
          ),
          _SelectorRow(
            label: context.l10n.cohort,
            hint: context.l10n.chooseCohort,
            icon: Icons.school_outlined,
            controller: controller.cohortController,
            options: controller.cohortOptions,
            onSelected: controller.selectCohort,
          ),
          _TextInputRow(
            label: context.l10n.major,
            hint: context.l10n.majorHint,
            icon: Icons.menu_book_outlined,
            controller: controller.majorController,
          ),
          _TextInputRow(
            label: context.l10n.phoneNumber,
            hint: context.l10n.phoneHint,
            icon: Icons.phone_outlined,
            controller: controller.phoneController,
            keyboardType: TextInputType.phone,
          ),
          Obx(
            () => _ProofMaterialRow(
              fileName: controller.proofMaterialName.value,
              onTap: controller.selectProofMaterial,
            ),
          ),
          SizedBox(height: 12.h),
          _UploadTitle(),
          SizedBox(height: 10.h),
          Obx(
            () => Row(
              children: [
                _UploadCard(
                  type: 'student',
                  title: context.l10n.studentCard,
                  imagePath: controller.uploadedImagePaths['student'],
                  onTap: () => _showUploadSheet(context, controller, 'student'),
                  onRemove: () => controller.removeProofImage('student'),
                ),
                SizedBox(width: 10.w),
                _UploadCard(
                  type: 'diploma',
                  title: context.l10n.diploma,
                  imagePath: controller.uploadedImagePaths['diploma'],
                  onTap: () => _showUploadSheet(context, controller, 'diploma'),
                  onRemove: () => controller.removeProofImage('diploma'),
                ),
                SizedBox(width: 10.w),
                _UploadCard(
                  type: 'alumni',
                  title: context.l10n.alumniProof,
                  imagePath: controller.uploadedImagePaths['alumni'],
                  onTap: () => _showUploadSheet(context, controller, 'alumni'),
                  onRemove: () => controller.removeProofImage('alumni'),
                ),
              ],
            ),
          ),
          SizedBox(height: 18.h),
          _WarmTipCard(),
          SizedBox(height: 18.h),
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: FilledButton(
              onPressed: () => _submit(context, controller),
              child: Text(
                context.l10n.submitCertification,
                style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w800),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Center(
            child: Text.rich(
              TextSpan(
                text: context.l10n.submitCertificationAgreementPrefix,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12.sp,
                ),
                children: [
                  TextSpan(
                    text: context.l10n.alumniCertificationAgreement,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 提交表单，校验失败时给出提示，成功后进入审核中页面。
  void _submit(BuildContext context, CertificationController controller) {
    if (controller.submit()) {
      Get.toNamed(Pages.memberCertificationStatus);
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.completeCertificationForm)),
    );
  }

  /// 上传图片底部弹窗：拍照、相册选择、删除已选图片。
  void _showUploadSheet(
    BuildContext context,
    CertificationController controller,
    String type,
  ) {
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 18.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 38.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFD6DFEA),
                  borderRadius: BorderRadius.circular(99.r),
                ),
              ),
              SizedBox(height: 10.h),
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: Text(context.l10n.takePhoto),
                onTap: () async {
                  Navigator.of(sheetContext).pop();
                  await controller.pickProofImage(
                    type: type,
                    source: ImageSource.camera,
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text(context.l10n.chooseFromAlbum),
                onTap: () async {
                  Navigator.of(sheetContext).pop();
                  await controller.pickProofImage(
                    type: type,
                    source: ImageSource.gallery,
                  );
                },
              ),
              if (controller.uploadedImagePaths[type] != null)
                ListTile(
                  leading: const Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.danger,
                  ),
                  title: Text(
                    context.l10n.removeUploadedImage,
                    style: const TextStyle(color: AppColors.danger),
                  ),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    controller.removeProofImage(type);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 4.w,
          height: 22.h,
          margin: EdgeInsets.only(top: 2.h),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(99.r),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: _sectionTitleStyle),
              SizedBox(height: 8.h),
              Text(subtitle, style: _hintStyle),
            ],
          ),
        ),
      ],
    );
  }
}

class _TextInputRow extends StatelessWidget {
  const _TextInputRow({
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    this.keyboardType,
  });

  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return _FieldBlock(
      label: label,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: _inputDecoration(hint: hint, icon: icon),
      ),
    );
  }
}

class _SelectorRow extends StatelessWidget {
  const _SelectorRow({
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    required this.options,
    required this.onSelected,
  });

  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final List<String> options;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return _FieldBlock(
      label: label,
      child: TextField(
        controller: controller,
        readOnly: true,
        onTap: () => _showSelector(context),
        decoration: _inputDecoration(
          hint: hint,
          icon: icon,
          suffixIcon: Icons.keyboard_arrow_down_rounded,
        ),
      ),
    );
  }

  /// 显示底部选择弹窗。
  void _showSelector(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(vertical: 10.h),
          itemCount: options.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (_, index) {
            final value = options[index];
            return ListTile(
              title: Text(value),
              trailing: controller.text == value
                  ? const Icon(Icons.check_rounded, color: AppColors.primary)
                  : null,
              onTap: () {
                onSelected(value);
                Navigator.of(sheetContext).pop();
              },
            );
          },
        ),
      ),
    );
  }
}

class _ProofMaterialRow extends StatelessWidget {
  const _ProofMaterialRow({required this.fileName, required this.onTap});
  final String fileName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _FieldBlock(
      label: context.l10n.proofMaterial,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: InputDecorator(
          decoration: _inputDecoration(
            hint: context.l10n.proofMaterialHint,
            icon: Icons.description_outlined,
            suffixIcon: Icons.chevron_right_rounded,
          ),
          child: Text(
            fileName.isEmpty ? context.l10n.proofMaterialHint : fileName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: fileName.isEmpty
                  ? const Color(0xFF9AA6B8)
                  : AppColors.textPrimary,
              fontSize: 14.sp,
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldBlock extends StatelessWidget {
  const _FieldBlock({required this.label, required this.child});
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              text: label,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800),
              children: const [
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: AppColors.danger),
                ),
              ],
            ),
          ),
          SizedBox(height: 7.h),
          child,
        ],
      ),
    );
  }
}

class _UploadTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: context.l10n.uploadImagesTitle,
        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w900),
        children: [
          TextSpan(
            text: '（${context.l10n.uploadAtLeastOne}）',
            style: const TextStyle(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class _UploadCard extends StatelessWidget {
  const _UploadCard({
    required this.type,
    required this.title,
    required this.imagePath,
    required this.onTap,
    required this.onRemove,
  });

  final String type;
  final String title;
  final String? imagePath;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final selected = imagePath != null && imagePath!.isNotEmpty;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          height: 104.h,
          decoration: BoxDecoration(
            color: const Color(0xFFF8FBFF),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: selected ? AppColors.primary : const Color(0xFFD8E5F7),
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: selected
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: Image.file(File(imagePath!), fit: BoxFit.cover),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate_outlined,
                            color: AppColors.primary,
                            size: 30.sp,
                          ),
                          SizedBox(height: 7.h),
                          Text(title, style: _uploadTitleStyle),
                          SizedBox(height: 4.h),
                          Text(context.l10n.exampleImage, style: _hintStyle),
                        ],
                      ),
              ),
              if (selected)
                Positioned(
                  right: 5.w,
                  top: 5.h,
                  child: InkWell(
                    onTap: onRemove,
                    child: CircleAvatar(
                      radius: 11.r,
                      backgroundColor: Colors.black.withValues(alpha: 0.55),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 14.sp,
                      ),
                    ),
                  ),
                ),
              if (selected)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 12.sp),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WarmTipCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.verified_user_rounded,
            color: AppColors.primary,
            size: 23.sp,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.warmTip,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w900,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  context.l10n.certificationWarmTip,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    height: 1.55,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

InputDecoration _inputDecoration({
  required String hint,
  required IconData icon,
  IconData? suffixIcon,
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Color(0xFF9AA6B8)),
    filled: true,
    fillColor: Colors.white,
    isDense: true,
    contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 13.h),
    prefixIcon: Container(
      width: 42.w,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        border: Border(right: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Icon(icon, color: AppColors.textSecondary, size: 21.sp),
    ),
    suffixIcon: suffixIcon == null
        ? null
        : Icon(suffixIcon, color: AppColors.textSecondary),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: const BorderSide(color: Color(0xFFDCE4EF)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: const BorderSide(color: AppColors.primary),
    ),
  );
}

final _pageTitleStyle = TextStyle(fontSize:18.sp, fontWeight: FontWeight.w900);
final _sectionTitleStyle = TextStyle(
  fontSize: 18.sp,
  fontWeight: FontWeight.w900,
);
final _uploadTitleStyle = TextStyle(
  fontSize: 13.sp,
  fontWeight: FontWeight.w800,
);
final _hintStyle = TextStyle(color: AppColors.textSecondary, fontSize: 12.sp);
final _cardDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(16.r),
  boxShadow: [
    BoxShadow(
      color: const Color(0xFF1E5AA8).withValues(alpha: 0.06),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ],
);
