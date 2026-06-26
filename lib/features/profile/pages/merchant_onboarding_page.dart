import 'dart:io';

import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/profile/pages/merchant_onboarding_controller.dart';
import 'package:alumni_association_app/features/profile/pages/merchant_region_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// 商户入驻
class MerchantOnboardingPage extends StatelessWidget {
  const MerchantOnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MerchantOnboardingController());
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7FAFF),
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: Get.back,
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20.sp,
            color: Colors.black,
          ),
        ),
        title: Text(
          l10n.merchantOnboarding,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(18.w, 8.h, 18.w, 28.h),
        children: [
          _TipBanner(),
          SizedBox(height: 14.h),

          _Section(
            title: l10n.storeInformation,
            children: [
              _Field(
                label: l10n.storeNameRequired,
                hint: l10n.storeNameHint,
                controller: controller.storeNameController,
                maxLength: 30,
              ),
              _Field(
                label: l10n.industryRequired,
                hint: l10n.chooseIndustry,
                controller: controller.industryController,
                trailing: Icons.chevron_right_rounded,
                readOnly: true,
                onTap: () => _showIndustryPicker(context, controller),
              ),
              _AddressRow(controller: controller),
              _Field(
                label: l10n.detailAddressRequired,
                hint: l10n.detailAddressHint,
                controller: controller.addressController,
                maxLength: 100,
              ),
              _Field(
                label: l10n.postalCodeRequired,
                hint: l10n.postalCodeHint,
                controller: controller.postalCodeController,
                maxLength: 12,
                keyboardType: TextInputType.number,
              ),
              //营业时间
              _BusinessTimeRow(controller: controller),
            ],
          ),

          SizedBox(height: 14.h),
          _PhotoSection(controller: controller),

          SizedBox(height: 14.h),
          _Section(
            title: l10n.contactInfo,
            children: [
              _Field(
                label: l10n.contactRequired,
                hint: l10n.contactNameHint,
                controller: controller.contactController,
                maxLength: 20,
              ),
              _Field(
                label: l10n.phoneRequired,
                hint: l10n.phoneHint,
                controller: controller.phoneController,
                maxLength: 11,
                bottomPadding: 0,
                keyboardType: TextInputType.phone,
              ),
            ],
          ),

          SizedBox(height: 14.h),
          _LicenseSection(controller: controller),

          SizedBox(height: 16.h),
          _AgreementRow(controller: controller),

          Obx(
            () => controller.errorMessage.value == null
                ? const SizedBox.shrink()
                : Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Text(
                      controller.errorMessage.value!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.danger,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
          ),

          SizedBox(height: 14.h),
          _SubmitButton(controller: controller),
        ],
      ),
    );
  }

  Future<void> _showIndustryPicker(
    BuildContext context,
    MerchantOnboardingController controller,
  ) async {
    await controller.loadMerchantTypes();
    if (!context.mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 24.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(26.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFD5DFEF),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              SizedBox(height: 18.h),
              Row(
                children: [
                  Text(
                    context.l10n.chooseIndustry,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: Get.back,
                    icon: Icon(Icons.close_rounded, size: 20.sp),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Obx(
                () => controller.isIndustryLoading.value
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 34.h),
                        child: const CircularProgressIndicator(),
                      )
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.merchantTypes.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 48.h,
                          crossAxisSpacing: 12.w,
                          mainAxisSpacing: 12.h,
                        ),
                        itemBuilder: (context, index) {
                          final industry = controller.merchantTypes[index];
                          return InkWell(
                            onTap: () {
                              controller.selectIndustry(industry);
                              Get.back();
                            },
                            borderRadius: BorderRadius.circular(14.r),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4F7FC),
                                borderRadius: BorderRadius.circular(14.r),
                                border: Border.all(
                                  color: const Color(0xFFE3EAF5),
                                ),
                              ),
                              child: Text(
                                industry.typeName,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showRegionPicker(
    BuildContext context,
    MerchantOnboardingController controller,
  ) async {
    await controller.prepareRegionPicker();
    if (!context.mounted) return;

    if (controller.provinces.isEmpty) {
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: 520.h,
          padding: EdgeInsets.fromLTRB(18.w, 14.h, 18.w, 18.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF7FAFF),
            borderRadius: BorderRadius.vertical(top: Radius.circular(26.r)),
          ),
          child: Column(
            children: [
              Container(
                width: 42.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFD5DFEF),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Text(
                    context.l10n.selectRegion,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      controller.confirmRegionSelection();
                      Get.back();
                    },
                    child: Text(context.l10n.confirm),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: Obx(
                  () =>
                      controller.isRegionLoading.value &&
                          controller.provinces.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : Row(
                          children: [
                            _RegionColumn(
                              title: context.l10n.chooseProvince,
                              items: controller.provinces,
                              selectedId: controller.selectedProvince.value?.id,
                              onTap: controller.selectProvince,
                            ),
                            SizedBox(width: 8.w),
                            _RegionColumn(
                              title: context.l10n.chooseCity,
                              items: controller.cities,
                              selectedId: controller.selectedCity.value?.id,
                              onTap: controller.selectCity,
                            ),
                            SizedBox(width: 8.w),
                            _RegionColumn(
                              title: context.l10n.chooseDistrict,
                              items: controller.districts,
                              selectedId: controller.selectedDistrict.value?.id,
                              onTap: controller.selectDistrict,
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BusinessTimeRow extends StatelessWidget {
  const _BusinessTimeRow({required this.controller});

  final MerchantOnboardingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _RequiredLabel(context.l10n.businessHoursRequired),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _BusinessTimeField(
                    hint: context.l10n.startTime,
                    controller: controller.businessStartTimeController,
                    onTap: () => _pickTime(context, controller, isStart: true),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Text(
                    context.l10n.to,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: _BusinessTimeField(
                    hint: context.l10n.endTime,
                    controller: controller.businessEndTimeController,
                    onTap: () => _pickTime(context, controller, isStart: false),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickTime(
    BuildContext context,
    MerchantOnboardingController controller, {
    required bool isStart,
  }) async {
    final time = await showTimePicker(
      context: context,
      initialTime: isStart
          ? const TimeOfDay(hour: 9, minute: 0)
          : const TimeOfDay(hour: 18, minute: 0),
    );

    if (time == null) return;

    controller.updateBusinessTime(isStart: isStart, time: time);
  }
}

class _BusinessTimeField extends StatelessWidget {
  const _BusinessTimeField({
    required this.hint,
    required this.controller,
    required this.onTap,
  });

  final String hint;
  final TextEditingController controller;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42.h,
      child: TextField(
        controller: controller,
        readOnly: true,
        onTap: onTap,
        style: TextStyle(
          fontSize: 13.sp,
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hint,
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.only(left: 12.w, right: 4.w),
          hintStyle: TextStyle(fontSize: 12.sp, color: const Color(0xFF9AA8BD)),
          suffixIconConstraints: BoxConstraints(
            minWidth: 34.w,
            minHeight: 42.h,
          ),
          suffixIcon: Icon(
            Icons.access_time_rounded,
            size: 17.sp,
            color: const Color(0xFF8B98AA),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7.r),
            borderSide: const BorderSide(color: Color(0xFFDDE6F6), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7.r),
            borderSide: const BorderSide(color: AppColors.primary, width: 1),
          ),
        ),
      ),
    );
  }
}

/// 顶部提示信息
class _TipBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF2FF),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFDDEAFF), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E5AA8).withValues(alpha: 0.035),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4C8DFF), Color(0xFF0B5CFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0B5CFF).withValues(alpha: 0.18),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Icon(
              Icons.assignment_turned_in_rounded,
              color: Colors.white,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.fillStoreInfo,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  context.l10n.fillStoreInfoDesc,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _hintStyle,
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
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
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(13.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28.w,
            height: 28.w,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF2FF),
              borderRadius: BorderRadius.circular(9.r),
            ),
            child: Icon(
              Icons.verified_user_rounded,
              color: AppColors.primary,
              size: 18.sp,
            ),
          ),
          SizedBox(width: 7.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.informationSecurity,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                context.l10n.merchantSecurityGuarantee,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 9.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 通用卡片区域
class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(14.w, 16.h, 14.w, 16.h),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RequiredLabel(title),
          SizedBox(height: 18.h),
          ...children,
        ],
      ),
    );
  }
}

/// 左标题 + 输入框
class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.hint,
    required this.controller,
    this.maxLength,
    this.trailing,
    this.readOnly = false,
    this.onTap,
    this.bottomPadding = 14,
    this.keyboardType,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final int? maxLength;
  final IconData? trailing;
  final bool readOnly;
  final VoidCallback? onTap;
  final double bottomPadding;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _RequiredLabel(label),
          Expanded(
            child: SizedBox(
              height: 45.h,
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: controller,
                builder: (context, value, child) {
                  return TextField(
                    controller: controller,
                    readOnly: readOnly,
                    onTap: onTap,
                    maxLength: maxLength,
                    keyboardType: keyboardType,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textPrimary,
                    ),
                    decoration: _inputDecoration(
                      hint: hint,
                      trailing: trailing,
                      maxLength: maxLength,
                      currentLength: value.text.length,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RequiredLabel extends StatelessWidget {
  const _RequiredLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final hasRequiredMark = text.contains('*');
    final cleanText = text.replaceAll('*', '').trimRight();

    return SizedBox(
      width: 82.w,
      child: Text.rich(
        TextSpan(
          text: cleanText,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          children: [
            if (hasRequiredMark)
              TextSpan(
                text: ' *',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.danger,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// 经营地址行
class _AddressRow extends StatelessWidget {
  const _AddressRow({required this.controller});

  final MerchantOnboardingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _RequiredLabel(context.l10n.operationAddressRequired),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _CompactField(
                    hint: context.l10n.chooseProvince,
                    controller: controller.provinceController,
                    onTap: () {
                      final page = context
                          .findAncestorWidgetOfExactType<
                            MerchantOnboardingPage
                          >();
                      page?._showRegionPicker(context, controller);
                    },
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _CompactField(
                    hint: context.l10n.chooseCity,
                    controller: controller.cityController,
                    onTap: () {
                      final page = context
                          .findAncestorWidgetOfExactType<
                            MerchantOnboardingPage
                          >();
                      page?._showRegionPicker(context, controller);
                    },
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _CompactField(
                    hint: context.l10n.chooseDistrict,
                    controller: controller.districtController,
                    onTap: () {
                      final page = context
                          .findAncestorWidgetOfExactType<
                            MerchantOnboardingPage
                          >();
                      page?._showRegionPicker(context, controller);
                    },
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

/// 小输入框：省 / 市 / 区
class _CompactField extends StatelessWidget {
  const _CompactField({
    required this.hint,
    required this.controller,
    this.onTap,
  });

  final String hint;
  final TextEditingController controller;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45.h,
      child: TextField(
        controller: controller,
        readOnly: onTap != null,
        onTap: onTap,
        style: TextStyle(fontSize: 12.sp, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.only(left: 4.w, right: 4.w),
          hintStyle: TextStyle(fontSize: 13.sp, color: const Color(0xFF9AA8BD)),
          suffixIconConstraints: BoxConstraints(
            minWidth: 18.w,
            // minHeight: 25.h,
          ),
          suffixIcon: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 18.sp,
            color: const Color(0xFF617089),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9.r),
            borderSide: const BorderSide(color: Color(0xFFDDE6F6)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9.r),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
        ),
      ),
    );
  }
}

/// 商户照片
class _PhotoSection extends StatelessWidget {
  const _PhotoSection({required this.controller});

  final MerchantOnboardingController controller;

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: context.l10n.merchantPhotosRequired,
      children: [
        _UploadLine(
          label: context.l10n.storefrontPhoto,
          child: Obx(
            () => _SingleImagePickerTile(
              addText: context.l10n.uploadStorefrontPhoto,
              imagePath: controller.shopLogoPath.value,
              onTap: controller.pickShopLogo,
              onRemove: controller.removeShopLogo,
            ),
          ),
        ),
        SizedBox(height: 14.h),
        _UploadLine(
          label: context.l10n.storeInteriorPhotos,
          child: _InteriorImagesGrid(controller: controller),
        ),
        SizedBox(height: 12.h),
        Text(context.l10n.interiorPhotoUploadHint, style: _hintStyle),
      ],
    );
  }
}

class _InteriorImagesGrid extends StatelessWidget {
  const _InteriorImagesGrid({required this.controller});

  final MerchantOnboardingController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final paths = controller.interiorImagePaths;
      final itemCount = paths.length + (paths.length < 9 ? 1 : 0);

      return SizedBox(
        height: 76.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          clipBehavior: Clip.hardEdge,
          padding: EdgeInsets.only(
            top: 2.h,
            right: 2.w,
            bottom: 2.h,
          ),
          itemCount: itemCount,
          separatorBuilder: (_, _) => SizedBox(width: 8.w),
          itemBuilder: (context, index) {
            if (index < paths.length) {
              return _ImageThumb(
                path: paths[index],
                onRemove: () => controller.removeInteriorImageAt(index),
              );
            }

            return _AddImageTile(
              text: context.l10n.addInteriorPhoto,
              onTap: controller.pickInteriorImages,
            );
          },
        ),
      );
    });
  }
}

class _SingleImagePickerTile extends StatelessWidget {
  const _SingleImagePickerTile({
    required this.addText,
    required this.imagePath,
    required this.onTap,
    required this.onRemove,
  });

  final String addText;
  final String imagePath;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    if (imagePath.isNotEmpty) {
      return _ImageThumb(path: imagePath, onRemove: onRemove);
    }
    return _AddImageTile(text: addText, onTap: onTap);
  }
}

class _ImageThumb extends StatelessWidget {
  const _ImageThumb({
    required this.path,
    required this.onRemove,
  });

  final String path;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64.w,
      height: 64.w,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => _showImagePreview(context, path),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.file(
                File(path),
                width: 64.w,
                height: 64.w,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            right: 3.w,
            top: 3.h,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                width: 18.w,
                height: 18.w,
                decoration: BoxDecoration(
                  color: AppColors.danger,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 1.2,
                  ),
                ),
                child: Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 12.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showImagePreview(BuildContext context, String path) {
    Get.dialog<void>(
      Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            InteractiveViewer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.file(File(path), fit: BoxFit.contain),
              ),
            ),
            Positioned(
              right: 8.w,
              top: 8.h,
              child: IconButton(
                onPressed: Get.back,
                icon: const Icon(Icons.close_rounded, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddImageTile extends StatelessWidget {
  const _AddImageTile({required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        width: 64.w,
        height: 64.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: const Color(0xFFDDE6F6)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_rounded, color: AppColors.primary, size: 24.sp),
            SizedBox(height: 2.h),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.primary, fontSize: 9.sp),
            ),
          ],
        ),
      ),
    );
  }
}

/// 营业资质
class _LicenseSection extends StatelessWidget {
  const _LicenseSection({required this.controller});

  final MerchantOnboardingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(14.w, 16.h, 14.w, 16.h),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              text: context.l10n.businessQualifications,
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
              children: [
                TextSpan(
                  text: '（${context.l10n.optional}）',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                TextSpan(
                  text: context.l10n.qualificationSupplementTip,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 18.h),
          _UploadLine(
            label: context.l10n.businessLicenseLabel,
            child: Obx(
              () => _SingleImagePickerTile(
                addText: context.l10n.businessLicense,
                imagePath: controller.businessLicensePath.value,
                onTap: controller.pickBusinessLicense,
                onRemove: controller.removeBusinessLicense,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UploadLine extends StatelessWidget {
  const _UploadLine({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 82.w,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              height: 1.45,
            ),
          ),
        ),
        Expanded(
          child: Align(alignment: Alignment.centerLeft, child: child),
        ),
      ],
    );
  }
}

/// 协议
class _AgreementRow extends StatelessWidget {
  const _AgreementRow({required this.controller});

  final MerchantOnboardingController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => controller.toggleAgreement(!controller.agreed.value),
              child: Icon(
                controller.agreed.value
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: controller.agreed.value
                    ? AppColors.primary
                    : const Color(0xFF9AA8BD),
                size: 20.sp,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    l10n.agreementPrefix,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showAgreementDialog(
                      context,
                      l10n.merchantOnboardingAgreement,
                    ),
                    child: Text(
                      l10n.merchantOnboardingAgreement,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    l10n.and,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () =>
                        _showAgreementDialog(context, l10n.privacyPolicy),
                    child: Text(
                      l10n.privacyPolicy,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAgreementDialog(BuildContext context, String title) {
    Get.dialog<void>(
      AlertDialog(
        title: Text(title),
        content: Text(context.l10n.agreementPreviewContent),
        actions: [
          TextButton(onPressed: Get.back, child: Text(context.l10n.confirm)),
        ],
      ),
    );
  }
}

/// 下一步按钮
class _SubmitButton extends StatelessWidget {
  const _SubmitButton({required this.controller});

  final MerchantOnboardingController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InkWell(
        onTap: controller.isSubmitting.value
            ? null
            : () => controller.submit(context),
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          height: 54.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: controller.isSubmitting.value
                ? null
                : const LinearGradient(
                    colors: [Color(0xFF0B5CFF), Color(0xFF0052F5)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
            color: controller.isSubmitting.value
                ? const Color(0xFFB8C5D8)
                : null,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              if (!controller.isSubmitting.value)
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.20),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
            ],
          ),
          child: Text(
            context.l10n.nextStep,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

/// 地区弹窗列
class _RegionColumn extends StatelessWidget {
  const _RegionColumn({
    required this.title,
    required this.items,
    required this.selectedId,
    required this.onTap,
  });

  final String title;
  final List<MerchantRegionItem> items;
  final int? selectedId;
  final void Function(MerchantRegionItem item) onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFEAF0F7)),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Text(
                title,
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: Text(
                        context.l10n.noMoreData,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12.sp,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final selected = item.id == selectedId;

                        return InkWell(
                          onTap: () => onTap(item),
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 3.h,
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 9.h,
                            ),
                            decoration: BoxDecoration(
                              color: selected
                                  ? const Color(0xFFEAF2FF)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Text(
                              item.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: selected
                                    ? AppColors.primary
                                    : AppColors.textPrimary,
                                fontSize: 13.sp,
                                fontWeight: selected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 输入框统一样式
InputDecoration _inputDecoration({
  required String hint,
  IconData? trailing,
  int? maxLength,
  int currentLength = 0,
}) {
  return InputDecoration(
    hintText: hint,
    counterText: '',
    filled: true,
    fillColor: Colors.white,
    contentPadding: EdgeInsets.symmetric(horizontal: 14.w),
    hintStyle: TextStyle(fontSize: 13.sp, color: const Color(0xFF9AA8BD)),
    suffixIconConstraints: BoxConstraints(minWidth: 48.w, minHeight: 48.h),
    suffixIcon: trailing != null
        ? Icon(trailing, color: AppColors.textSecondary, size: 22.sp)
        : maxLength == null
        ? null
        : Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: Center(
              widthFactor: 1,
              child: Text(
                '$currentLength/$maxLength',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF8B98AA),
                ),
              ),
            ),
          ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(9.r),
      borderSide: const BorderSide(color: Color(0xFFDDE6F6), width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(9.r),
      borderSide: const BorderSide(color: AppColors.primary, width: 1),
    ),
  );
}

/// 卡片样式
BoxDecoration get _cardDecoration => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(16.r),
  border: Border.all(color: const Color(0xFFEAF0F7), width: 1),
  boxShadow: [
    BoxShadow(
      color: const Color(0xFF1E5AA8).withValues(alpha: 0.045),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ],
);

TextStyle get _hintStyle =>
    TextStyle(color: const Color(0xFF7E8DA3), fontSize: 12.sp, height: 1.5);
