import 'package:alumni_association_app/app/api/api_request.dart';
import 'package:alumni_association_app/app/services/address_service.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/auth/domain/session_controller.dart';
import 'package:alumni_association_app/features/profile/presentation/merchant_onboarding_request.dart';
import 'package:alumni_association_app/features/profile/presentation/merchant_region_item.dart';
import 'package:alumni_association_app/util/loading_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 商户入驻表单逻辑。
class MerchantOnboardingController extends GetxController {
  final storeNameController = TextEditingController();
  final industryController = TextEditingController();
  final provinceController = TextEditingController();
  final cityController = TextEditingController();
  final districtController = TextEditingController();
  final addressController = TextEditingController();
  final businessStartTimeController = TextEditingController();
  final businessEndTimeController = TextEditingController();
  final contactController = TextEditingController();
  final phoneController = TextEditingController();

  final agreed = false.obs;
  final isSubmitting = false.obs;
  final isRegionLoading = false.obs;
  final uploadedPhotos = <String>[].obs;
  final uploadedLicenses = <String>[].obs;
  final errorMessage = RxnString();
  final provinces = <MerchantRegionItem>[].obs;
  final cities = <MerchantRegionItem>[].obs;
  final districts = <MerchantRegionItem>[].obs;
  final selectedProvince = Rxn<MerchantRegionItem>();
  final selectedCity = Rxn<MerchantRegionItem>();
  final selectedDistrict = Rxn<MerchantRegionItem>();
  final AddressService _addressService = Get.find<AddressService>();

  void toggleAgreement(bool? value) {
    agreed.value = value ?? false;
  }

  /// 准备地址选择器数据。
  ///
  /// 第一次打开时拉取省列表并默认选中第一项，随后自动加载该省下的市列表、
  /// 再默认选中第一个市并加载区列表。所有接口数据都由 AddressService 缓存，
  /// 后续重复打开不会重复请求同一个 pid。
  Future<void> prepareRegionPicker() async {
    if (provinces.isNotEmpty &&
        cities.isNotEmpty &&
        districts.isNotEmpty &&
        !isRegionLoading.value) {
      return;
    }
    isRegionLoading.value = true;
    try {
      LoadingUtil.showSafe();
      final provinceList = await _addressService.provinces();
      provinces.assignAll(provinceList);
      if (provinceList.isEmpty) return;

      final province = selectedProvince.value ?? provinceList.first;
      selectedProvince.value = province;

      final cityList = await _addressService.childrenOf(province);
      cities.assignAll(cityList);
      if (cityList.isEmpty) return;

      final city = selectedCity.value ?? cityList.first;
      selectedCity.value = city;

      final districtList = await _addressService.childrenOf(city);
      districts.assignAll(districtList);
      if (districtList.isNotEmpty) {
        selectedDistrict.value = selectedDistrict.value ?? districtList.first;
      }
    } finally {
      isRegionLoading.value = false;
      LoadingUtil.dismissSafe();
    }
  }

  /// 选择省份后清空下级选项，并根据省节点 requestPid 拉取城市。
  Future<void> selectProvince(MerchantRegionItem item) async {
    selectedProvince.value = item;
    selectedCity.value = null;
    selectedDistrict.value = null;
    cities.clear();
    districts.clear();
    isRegionLoading.value = true;
    try {
      final cityList = await _addressService.childrenOf(item);
      cities.assignAll(cityList);
      if (cityList.isEmpty) return;

      selectedCity.value = cityList.first;
      final districtList = await _addressService.childrenOf(cityList.first);
      districts.assignAll(districtList);
      if (districtList.isNotEmpty) {
        selectedDistrict.value = districtList.first;
      }
    } finally {
      isRegionLoading.value = false;
    }
  }

  /// 选择城市后清空区县，并根据市节点 requestPid 拉取区县。
  Future<void> selectCity(MerchantRegionItem item) async {
    selectedCity.value = item;
    selectedDistrict.value = null;
    districts.clear();
    isRegionLoading.value = true;
    try {
      final districtList = await _addressService.childrenOf(item);
      districts.assignAll(districtList);
      if (districtList.isNotEmpty) {
        selectedDistrict.value = districtList.first;
      }
    } finally {
      isRegionLoading.value = false;
    }
  }

  /// 选择区县，仅保存当前选中值。
  void selectDistrict(MerchantRegionItem item) {
    selectedDistrict.value = item;
  }

  /// 确认地区选择，把底部弹窗里的选中项同步到表单输入框。
  void confirmRegionSelection() {
    final province = selectedProvince.value;
    final city = selectedCity.value;
    final district = selectedDistrict.value;
    if (province != null) provinceController.text = province.name;
    if (city != null) cityController.text = city.name;
    if (district != null) districtController.text = district.name;
  }

  /// 选择营业时间后写回表单。
  void updateBusinessTime({required bool isStart, required TimeOfDay time}) {
    final value =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    if (isStart) {
      businessStartTimeController.text = value;
    } else {
      businessEndTimeController.text = value;
    }
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
        provinceController.text.trim().isEmpty ||
        cityController.text.trim().isEmpty ||
        districtController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty ||
        businessStartTimeController.text.trim().isEmpty ||
        businessEndTimeController.text.trim().isEmpty ||
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
      final userInfo = SessionController.current.userInfo.value;
      final request = MerchantOnboardingRequest(
        userId: userInfo?.id ?? 0,
        shopName: storeNameController.text.trim(),
        types: industryController.text.trim(),
        names: contactController.text.trim(),
        phone: phoneController.text.trim(),
        province: provinceController.text.trim(),
        city: cityController.text.trim(),
        area: districtController.text.trim(),
        address: addressController.text.trim(),
        businessStartTime: businessStartTimeController.text.trim(),
        businessEndTime: businessEndTimeController.text.trim(),
        shopImgs: uploadedPhotos.join(','),
        licenseImages: uploadedLicenses.join(','),
      );
      final success = await ApiRequest.addMerchant(request: request);
      if (!success) return;
      errorMessage.value = null;
      if (context.mounted) Get.back();
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
    businessStartTimeController.dispose();
    businessEndTimeController.dispose();
    contactController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
