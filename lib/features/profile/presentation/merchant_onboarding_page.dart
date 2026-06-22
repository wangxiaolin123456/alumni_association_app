import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/profile/presentation/merchant_onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
/// 商户入驻
class MerchantOnboardingPage extends StatelessWidget {
  const MerchantOnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MerchantOnboardingController());
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: context.pop,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Text(l10n.merchantOnboarding),
        centerTitle: true,
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.menu_book_outlined),
            label: Text(l10n.onboardingGuide),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(18.w, 14.h, 18.w, 28.h),
        children: [
          _TipBanner(),
          SizedBox(height: 14.h),
          _Section(
            title: l10n.storeInformation,
            children: [
              _Field(
                l10n.storeNameRequired,
                l10n.storeNameHint,
                controller.storeNameController,
                maxLength: 30,
              ),
              _Field(
                l10n.industryRequired,
                l10n.chooseIndustry,
                controller.industryController,
                trailing: Icons.chevron_right_rounded,
              ),
              Row(
                children: [
                  Expanded(
                    child: _CompactField(
                      l10n.chooseProvince,
                      controller.provinceController,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: _CompactField(
                      l10n.chooseCity,
                      controller.cityController,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: _CompactField(
                      l10n.chooseDistrict,
                      controller.districtController,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.h),
              _Field(
                l10n.detailAddressRequired,
                l10n.detailAddressHint,
                controller.addressController,
                maxLength: 100,
              ),
            ],
          ),
          SizedBox(height: 14.h),
          _PhotoSection(controller: controller),
          SizedBox(height: 14.h),
          _Section(
            title: l10n.contactInfo,
            children: [
              _Field(
                l10n.contactRequired,
                l10n.contactNameHint,
                controller.contactController,
                maxLength: 20,
              ),
              _Field(
                l10n.phoneRequired,
                l10n.phoneHint,
                controller.phoneController,
                maxLength: 11,
              ),
            ],
          ),
          SizedBox(height: 14.h),
          _LicenseSection(controller: controller),
          SizedBox(height: 16.h),
          Obx(
            () => CheckboxListTile(
              value: controller.agreed.value,
              onChanged: controller.toggleAgreement,
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              title: Text.rich(
                TextSpan(
                  text: l10n.agreementPrefix,
                  children: [
                    TextSpan(
                      text: l10n.merchantOnboardingAgreement,
                      style: const TextStyle(color: AppColors.primary),
                    ),
                    TextSpan(text: l10n.and),
                    TextSpan(
                      text: l10n.privacyPolicy,
                      style: const TextStyle(color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Obx(
            () => controller.errorMessage.value == null
                ? const SizedBox.shrink()
                : Text(
                    controller.errorMessage.value!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.danger, fontSize: 12.sp),
                  ),
          ),
          SizedBox(height: 12.h),
          Obx(
            () => SizedBox(
              height: 54.h,
              child: FilledButton(
                onPressed: controller.isSubmitting.value
                    ? null
                    : () => controller.submit(context),
                child: Text(l10n.nextStep),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TipBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF2FF),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Icon(Icons.assignment_turned_in_rounded, color: AppColors.primary),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.fillStoreInfo, style: _titleStyle),
                Text(context.l10n.fillStoreInfoDesc, style: _hintStyle),
              ],
            ),
          ),
          _SecurityPill(),
        ],
      ),
    );
  }
}

class _SecurityPill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        context.l10n.informationSecurity,
        style: TextStyle(color: AppColors.primary, fontSize: 11.sp),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 16.h),
          ...children,
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field(
    this.label,
    this.hint,
    this.controller, {
    this.maxLength,
    this.trailing,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final int? maxLength;
  final IconData? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Row(
        children: [
          SizedBox(
            width: 82.w,
            child: Text(label, style: TextStyle(fontSize: 14.sp)),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              maxLength: maxLength,
              decoration: InputDecoration(
                hintText: hint,
                counterText: '',
                suffixIcon: trailing == null
                    ? null
                    : Icon(trailing, color: AppColors.textSecondary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactField extends StatelessWidget {
  const _CompactField(this.hint, this.controller);

  final String hint;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, size: 18.sp),
      ),
    );
  }
}

class _PhotoSection extends StatelessWidget {
  const _PhotoSection({required this.controller});

  final MerchantOnboardingController controller;

  @override
  Widget build(BuildContext context) {
    final labels = [
      context.l10n.storefrontPhoto,
      context.l10n.storeInteriorPhoto,
      context.l10n.businessScenePhoto,
      context.l10n.otherSupplementPhoto,
    ];
    return _Section(
      title: context.l10n.merchantPhotosRequired,
      children: [
        Obx(
          () => Row(
            children: labels
                .map(
                  (label) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 8.w),
                      child: _UploadBox(
                        label: label,
                        uploaded: controller.uploadedPhotos.contains(label),
                        onTap: () => controller.uploadPhoto(label),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        SizedBox(height: 12.h),
        Text(context.l10n.photoUploadHint, style: _hintStyle),
      ],
    );
  }
}

class _LicenseSection extends StatelessWidget {
  const _LicenseSection({required this.controller});

  final MerchantOnboardingController controller;

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: context.l10n.businessQualifications,
      children: [
        Obx(
          () => _WideUploadBox(
            title: context.l10n.businessLicense,
            uploaded: controller.uploadedLicenses.contains(
              context.l10n.businessLicense,
            ),
            onTap: () => controller.uploadLicense(context.l10n.businessLicense),
          ),
        ),
        SizedBox(height: 12.h),
        Obx(
          () => _WideUploadBox(
            title: context.l10n.otherQualification,
            uploaded: controller.uploadedLicenses.contains(
              context.l10n.otherQualification,
            ),
            onTap: () =>
                controller.uploadLicense(context.l10n.otherQualification),
          ),
        ),
      ],
    );
  }
}

class _UploadBox extends StatelessWidget {
  const _UploadBox({
    required this.label,
    required this.uploaded,
    required this.onTap,
  });

  final String label;
  final bool uploaded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Column(
        children: [
          Container(
            height: 70.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: const Color(0xFFDDE6F6)),
            ),
            child: Center(
              child: Icon(
                uploaded ? Icons.check_circle_rounded : Icons.add_rounded,
                color: AppColors.primary,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11.sp),
          ),
          Text(
            context.l10n.example,
            style: TextStyle(color: AppColors.primary, fontSize: 11.sp),
          ),
        ],
      ),
    );
  }
}

class _WideUploadBox extends StatelessWidget {
  const _WideUploadBox({
    required this.title,
    required this.uploaded,
    required this.onTap,
  });

  final String title;
  final bool uploaded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        height: 72.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: const Color(0xFFDDE6F6)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              uploaded ? Icons.check_circle_rounded : Icons.add_rounded,
              color: AppColors.primary,
            ),
            SizedBox(width: 8.w),
            Text(title),
          ],
        ),
      ),
    );
  }
}

BoxDecoration get _cardDecoration => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(16.r),
  boxShadow: [
    BoxShadow(
      color: const Color(0xFF1E5AA8).withValues(alpha: 0.05),
      blurRadius: 18,
      offset: const Offset(0, 6),
    ),
  ],
);

TextStyle get _titleStyle =>
    TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700);

TextStyle get _hintStyle =>
    TextStyle(color: AppColors.textSecondary, fontSize: 12.sp);
