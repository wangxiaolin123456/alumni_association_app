import 'package:alumni_association_app/app/api/api_request.dart';
import 'package:alumni_association_app/app/services/address_service.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/auth/domain/session_controller.dart';
import 'package:alumni_association_app/features/profile/presentation/merchant_onboarding_request.dart';
import 'package:alumni_association_app/features/profile/presentation/merchant_region_item.dart';
import 'package:alumni_association_app/features/profile/presentation/merchant_type_item.dart';
import 'package:alumni_association_app/util/loading_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

/// 商户入驻表单逻辑。
class MerchantOnboardingController extends GetxController {
  final storeNameController = TextEditingController();
  final industryController = TextEditingController();
  final provinceController = TextEditingController();
  final cityController = TextEditingController();
  final districtController = TextEditingController();
  final addressController = TextEditingController();
  final postalCodeController = TextEditingController();
  final businessStartTimeController = TextEditingController();
  final businessEndTimeController = TextEditingController();
  final contactController = TextEditingController();
  final phoneController = TextEditingController();

  final agreed = false.obs;
  final isSubmitting = false.obs;
  final isRegionLoading = false.obs;
  final isIndustryLoading = false.obs;
  final errorMessage = RxnString();
  final merchantTypes = <MerchantTypeItem>[].obs;
  final selectedMerchantType = Rxn<MerchantTypeItem>();
  final shopLogoPath = ''.obs;
  final shopLogoFileName = ''.obs;
  final interiorImagePaths = <String>[].obs;
  final interiorImageFileNames = <String>[].obs;
  final businessLicensePath = ''.obs;
  final businessLicenseFileName = ''.obs;
  final provinces = <MerchantRegionItem>[].obs;
  final cities = <MerchantRegionItem>[].obs;
  final districts = <MerchantRegionItem>[].obs;
  final selectedProvince = Rxn<MerchantRegionItem>();
  final selectedCity = Rxn<MerchantRegionItem>();
  final selectedDistrict = Rxn<MerchantRegionItem>();
  final AddressService _addressService = Get.find<AddressService>();
  final ImagePicker _imagePicker = ImagePicker();
  final int? shopId = _parseShopId(Get.arguments);

  /// 从路由参数中安全解析商户 id，兼容 int 和字符串两种传参。
  static int? _parseShopId(dynamic arguments) {
    if (arguments is! Map) return null;
    final raw = arguments['shopId'];
    if (raw is int) return raw;
    return int.tryParse(raw?.toString() ?? '');
  }

  void toggleAgreement(bool? value) {
    agreed.value = value ?? false;
  }

  /// 加载商户行业列表。
  Future<void> loadMerchantTypes() async {
    if (merchantTypes.isNotEmpty || isIndustryLoading.value) return;
    isIndustryLoading.value = true;
    try {
      LoadingUtil.showSafe();
      merchantTypes.assignAll(await ApiRequest.merchantTypes());
    } finally {
      isIndustryLoading.value = false;
      LoadingUtil.dismissSafe();
    }
  }

  /// 选择所属行业，并保存接口返回的 typeId/typeName。
  void selectIndustry(MerchantTypeItem industry) {
    selectedMerchantType.value = industry;
    industryController.text = industry.typeName;
  }

  /// 选择并上传门店门头照，接口返回 fileName 后保存到 shopLogo。
  Future<void> pickShopLogo() async {
    if (shopLogoPath.value.isNotEmpty) return;
    final image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1800,
    );
    if (image == null) return;

    LoadingUtil.showSafe();
    try {
      final fileName = await ApiRequest.uploadFile(filePath: image.path);
      if (fileName == null || fileName.isEmpty) return;
      shopLogoPath.value = image.path;
      shopLogoFileName.value = fileName;
    } finally {
      LoadingUtil.dismissSafe();
    }
  }

  /// 删除门店门头照，删除后再次点击上传框才会重新选择图片。
  void removeShopLogo() {
    shopLogoPath.value = '';
    shopLogoFileName.value = '';
  }

  /// 选择并上传店内环境照，最多 9 张。
  Future<void> pickInteriorImages() async {
    final remain = 9 - interiorImagePaths.length;
    if (remain <= 0) return;

    final images = await _imagePicker.pickMultiImage(
      imageQuality: 85,
      maxWidth: 1800,
    );
    if (images.isEmpty) return;

    final selected = images.take(remain).map((item) => item.path).toList();
    LoadingUtil.showSafe();
    try {
      final fileNames = await ApiRequest.uploadFiles(filePaths: selected);
      if (fileNames == null || fileNames.trim().isEmpty) return;
      interiorImagePaths.addAll(selected);
      interiorImageFileNames.addAll(
        fileNames
            .split(',')
            .map((item) => item.trim())
            .where((item) => item.isNotEmpty),
      );
    } finally {
      LoadingUtil.dismissSafe();
    }
  }

  /// 删除一张店内环境图。
  void removeInteriorImageAt(int index) {
    if (index < 0 || index >= interiorImagePaths.length) return;
    interiorImagePaths.removeAt(index);
    if (index < interiorImageFileNames.length) {
      interiorImageFileNames.removeAt(index);
    }
  }

  /// 选择并上传营业执照，接口返回 fileName 后保存到 licenseImages。
  Future<void> pickBusinessLicense() async {
    if (businessLicensePath.value.isNotEmpty) return;
    final image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1800,
    );
    if (image == null) return;

    LoadingUtil.showSafe();
    try {
      final fileName = await ApiRequest.uploadFile(filePath: image.path);
      if (fileName == null || fileName.isEmpty) return;
      businessLicensePath.value = image.path;
      businessLicenseFileName.value = fileName;
    } finally {
      LoadingUtil.dismissSafe();
    }
  }

  /// 删除营业执照图片，删除后再次点击上传框才会重新选择图片。
  void removeBusinessLicense() {
    businessLicensePath.value = '';
    businessLicenseFileName.value = '';
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
    final postalCode =
        district?.postalCode ?? city?.postalCode ?? province?.postalCode ?? '';
    if (postalCode.isNotEmpty) {
      postalCodeController.text = postalCode;
    }
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

  Future<void> submit(BuildContext context) async {
    final l10n = context.l10n;
    if (storeNameController.text.trim().isEmpty ||
        industryController.text.trim().isEmpty ||
        provinceController.text.trim().isEmpty ||
        cityController.text.trim().isEmpty ||
        districtController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty ||
        postalCodeController.text.trim().isEmpty ||
        businessStartTimeController.text.trim().isEmpty ||
        businessEndTimeController.text.trim().isEmpty ||
        contactController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty) {
      errorMessage.value = l10n.completeMerchantOnboardingForm;
      return;
    }
    if (shopLogoFileName.value.isEmpty) {
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

        ///不用传
        shopId: shopId,
        shopName: storeNameController.text.trim(),
        typeId: selectedMerchantType.value?.id ?? 0,
        typeName:
            selectedMerchantType.value?.typeName ??
            industryController.text.trim(),
        types:
            selectedMerchantType.value?.typeName ??
            industryController.text.trim(),
        names: contactController.text.trim(),
        phone: phoneController.text.trim(),
        postalCode: postalCodeController.text.trim(),
        province: provinceController.text.trim(),
        city: cityController.text.trim(),
        area: districtController.text.trim(),
        address: addressController.text.trim(),
        businessStartTime: businessStartTimeController.text.trim(),
        businessEndTime: businessEndTimeController.text.trim(),
        shopLogo: shopLogoFileName.value,
        shopImgs: interiorImageFileNames.join(','),
        licenseImages: businessLicenseFileName.value,
      );
      final success = shopId == null
          ? await ApiRequest.addMerchant(request: request)
          : await ApiRequest.updateMerchant(request: request);
      if (!success) return;

      /// 入驻/修改成功后刷新用户信息，后端若已把 isMerchant 更新为 1，
      /// 我的页面会立即从“商户入驻”切换为“我的商户”。
      if (userInfo != null) {
        final latest = await ApiRequest.userInfo(userId: userInfo.id);
        if (latest != null) {
          await SessionController.current.updateLoginInfo(latest);
        }
      }
      errorMessage.value = null;

      await Future.delayed(const Duration(milliseconds: 150));
      Get.back();
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
    postalCodeController.dispose();
    businessStartTimeController.dispose();
    businessEndTimeController.dispose();
    contactController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
