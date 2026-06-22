import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 商户入驻表单逻辑。
class MerchantOnboardingController extends GetxController {
  final storeNameController = TextEditingController();
  final industryController = TextEditingController();
  final provinceController = TextEditingController(text: '上海市');
  final cityController = TextEditingController(text: '上海市');
  final districtController = TextEditingController(text: '浦东新区');
  final addressController = TextEditingController();
  final contactController = TextEditingController();
  final phoneController = TextEditingController();

  final agreed = false.obs;
  final isSubmitting = false.obs;
  final uploadedPhotos = <String>[].obs;
  final uploadedLicenses = <String>[].obs;
  final errorMessage = RxnString();

  void toggleAgreement(bool? value) {
    agreed.value = value ?? false;
  }

  /// 模拟上传图片。
  void uploadPhoto(String label) {
    if (!uploadedPhotos.contains(label)) {
      uploadedPhotos.add(label);
    }
  }

  /// 模拟上传资质文件。
  void uploadLicense(String label) {
    if (!uploadedLicenses.contains(label)) {
      uploadedLicenses.add(label);
    }
  }

  Future<void> submit(BuildContext context) async {
    final l10n = context.l10n;
    if (storeNameController.text.trim().isEmpty ||
        industryController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty ||
        contactController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty) {
      errorMessage.value = l10n.completeMerchantOnboardingForm;
      return;
    }
    if (uploadedPhotos.isEmpty) {
      errorMessage.value = l10n.uploadMerchantPhotoRequired;
      return;
    }
    if (!agreed.value) {
      errorMessage.value = l10n.agreementRequiredMessage;
      return;
    }

    isSubmitting.value = true;
    try {
      await Future<void>.delayed(const Duration(milliseconds: 400));
      errorMessage.value = null;
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.merchantOnboardingSubmitted)));
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    storeNameController.dispose();
    industryController.dispose();
    provinceController.dispose();
    cityController.dispose();
    districtController.dispose();
    addressController.dispose();
    contactController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
