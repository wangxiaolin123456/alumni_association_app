import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/auth/domain/session_controller.dart';
import 'package:alumni_association_app/features/store/model/response/store_response.dart';
import 'package:alumni_association_app/util/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../app/api/api_request.dart';
import '../../model/request/coupon_request.dart';
import '../view/widget/second_time.dart';

/// 发布优惠券 Controller
class PublishCouponController extends GetxController {
  /// 当前编辑的优惠券，空表示新增。
  final editingCoupon = Rxn<StoreCouponResponse>();

  /// 优惠券名称
  final nameController = TextEditingController();

  /// 优惠券描述
  final descriptionController = TextEditingController();

  /// 固定金额引：门槛金额
  final fixedMinAmountController = TextEditingController();

  /// 固定金额引：减免金额
  final fixedDiscountAmountController = TextEditingController();

  /// 百分比折扣引：折扣率
  final discountRateController = TextEditingController();

  /// 条件付割引：门槛金额
  final conditionMinAmountController = TextEditingController();

  /// 条件付割引：减免金额
  final conditionDiscountAmountController = TextEditingController();

  /// 适用门店显示文本
  final shopTextController = TextEditingController();

  /// 禁用原因
  final disableReasonController = TextEditingController();

  /// 优惠券类型
  ///
  /// 0 = 固定金额引
  /// 1 = 百分比折扣引
  /// 2 = 条件付割引
  final selectedType = 0.obs;

  /// 优惠券状态
  ///
  /// 0 = 进行中
  /// 1 = 禁用
  final disableStatus = 0.obs;

  /// 有效期开始时间
  final startDate = Rxn<DateTime>();

  /// 有效期结束时间
  final endDate = Rxn<DateTime>();

  /// 页面显示用开始时间
  final startDateText = ''.obs;

  /// 页面显示用结束时间
  final endDateText = ''.obs;

  /// 已确认选择的门店 ID
  final selectedShopIds = <int>[].obs;

  /// 我的商户列表
  final myStores = <StoreResponse>[].obs;

  /// 弹窗中临时选择的门店 ID
  final tempSelectedShopIds = <int>[].obs;

  /// 是否正在加载门店
  final isLoadingStores = false.obs;

  /// 是否正在提交
  final isSubmitting = false.obs;

  /// 错误信息
  final errorMessage = RxnString();

  /// 是否是固定金额引
  bool get isFixedAmount => selectedType.value == 0;

  /// 是否是百分比折扣引
  bool get isPercentageDiscount => selectedType.value == 1;

  /// 是否是条件付割引
  bool get isConditionDiscount => selectedType.value == 2;

  /// 是否禁用
  bool get isDisabled => disableStatus.value == 1;

  /// 是否编辑模式
  bool get isEditMode => editingCoupon.value != null;

  @override
  void onInit() {
    super.onInit();

    /// 从管理列表点击编辑时，会把当前优惠券传进来。
    final args = Get.arguments;
    if (args is StoreCouponResponse) {
      editingCoupon.value = args;
      _fillFormByCoupon(args);
    }
  }

  /// 编辑优惠券时，把接口返回字段回填到表单。
  void _fillFormByCoupon(StoreCouponResponse coupon) {
    nameController.text = coupon.name;
    descriptionController.text = coupon.description;
    selectedType.value = coupon.type;
    disableStatus.value = coupon.disableStatus;
    disableReasonController.text = coupon.disableMsg;

    if (coupon.type == 0) {
      fixedMinAmountController.text = _formatNumber(coupon.minOrderAmount);
      fixedDiscountAmountController.text = _formatNumber(coupon.value);
    } else if (coupon.type == 1) {
      discountRateController.text = _formatNumber(coupon.value);
    } else if (coupon.type == 2) {
      conditionMinAmountController.text = _formatNumber(coupon.maxDiscountAmount);
      conditionDiscountAmountController.text = _formatNumber(coupon.minOrderAmount);
    }

    startDate.value = _parseDate(coupon.startTime);
    endDate.value = _parseDate(coupon.endTime);
    startDateText.value = _formatDateTime(startDate.value);
    endDateText.value = _formatDateTime(endDate.value);

    final ids = coupon.shopIds
        .split(',')
        .map((item) => int.tryParse(item.trim()) ?? 0)
        .where((id) => id > 0)
        .toList();
    selectedShopIds.assignAll(ids);

    if (ids.isNotEmpty) {
      shopTextController.text = Get.context?.l10n.selectedStoresCount(ids.length) ?? '';
    }
  }

  String selectedStoresText(BuildContext context, int count) {
    return context.l10n.selectedStoresCount(count);
  }

  /// 选择优惠券类型
  void selectCouponType(int type) {
    selectedType.value = type;
    errorMessage.value = null;
  }

  /// 切换优惠券状态
  void changeStatus(int status) {
    disableStatus.value = status;
    errorMessage.value = null;

    if (status == 0) {
      disableReasonController.clear();
    }
  }

  /// 加载我的商户列表
  Future<void> loadMyStores() async {
    if (myStores.isNotEmpty) return;

    isLoadingStores.value = true;

    try {
      final result = await ApiRequest.myMerchantList();
      myStores.assignAll(result);
    } finally {
      isLoadingStores.value = false;
    }
  }

  /// 打开门店选择弹窗前准备数据
  Future<void> prepareStorePicker() async {
    tempSelectedShopIds.assignAll(selectedShopIds);
    await loadMyStores();
  }

  /// 切换临时门店选择
  void toggleTempStore(StoreResponse store) {
    final id = store.shopId;

    if (id <= 0) return;

    if (tempSelectedShopIds.contains(id)) {
      tempSelectedShopIds.remove(id);
    } else {
      tempSelectedShopIds.add(id);
    }
  }

  /// 全选 / 取消全选门店
  void toggleSelectAllStores() {
    final validIds = myStores
        .map((item) => item.shopId)
        .where((id) => id > 0)
        .toList();

    if (validIds.isEmpty) return;

    if (tempSelectedShopIds.length == validIds.length) {
      tempSelectedShopIds.clear();
    } else {
      tempSelectedShopIds.assignAll(validIds);
    }
  }

  /// 确认选择门店
  void confirmSelectedStores() {
    selectedShopIds.assignAll(tempSelectedShopIds);
    print("selectedShopIds${selectedShopIds.toJson()}");

    if (selectedShopIds.isEmpty) {
      shopTextController.clear();
    } else {
      shopTextController.text =
          Get.context?.l10n.selectedStoresCount(selectedShopIds.length) ?? '';
    }

    errorMessage.value = null;
  }

  /// 选择开始日期时间：年月日 + 时分秒
  Future<void> pickStartDate(BuildContext context) async {
    final now = DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: startDate.value ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );

    if (date == null) return;
    if (!context.mounted) return;

    final time = await _showSecondTimePicker(
      context,
      initialTime:
          startDate.value ?? DateTime(date.year, date.month, date.day, 0, 0, 0),
    );

    if (time == null) return;

    final selected = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
      time.second,
    );

    startDate.value = selected;
    startDateText.value = _formatDateTime(selected);

    errorMessage.value = null;
  }

  /// 选择结束日期时间：年月日 + 时分秒
  Future<void> pickEndDate(BuildContext context) async {
    final now = DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: endDate.value ?? startDate.value ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );

    if (date == null) return;
    if (!context.mounted) return;

    final time = await _showSecondTimePicker(
      context,
      initialTime:
          endDate.value ??
          DateTime(date.year, date.month, date.day, 23, 59, 59),
    );

    if (time == null) return;

    final selected = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
      time.second,
    );

    endDate.value = selected;
    endDateText.value = _formatDateTime(selected);

    errorMessage.value = null;
  }

  Future<SecondTime?> _showSecondTimePicker(
    BuildContext context, {
    required DateTime initialTime,
  }) async {
    int selectedHour = initialTime.hour;
    int selectedMinute = initialTime.minute;
    int selectedSecond = initialTime.second;

    return showModalBottomSheet<SecondTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: 320,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD5DFEF),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                   Text(
                    context.l10n.selectTime,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF102342),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(
                        SecondTime(
                          hour: selectedHour,
                          minute: selectedMinute,
                          second: selectedSecond,
                        ),
                      );
                    },
                    child: const Text(
                      '确定',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: TimePickerColumn(
                        title: context.l10n.hour,
                        itemCount: 24,
                        initialItem: selectedHour,
                        onSelectedItemChanged: (value) {
                          selectedHour = value;
                        },
                      ),
                    ),
                    Expanded(
                      child: TimePickerColumn(
                        title: context.l10n.minute,
                        itemCount: 60,
                        initialItem: selectedMinute,
                        onSelectedItemChanged: (value) {
                          selectedMinute = value;
                        },
                      ),
                    ),
                    Expanded(
                      child: TimePickerColumn(
                        title: context.l10n.second,
                        itemCount: 60,
                        initialItem: selectedSecond,
                        onSelectedItemChanged: (value) {
                          selectedSecond = value;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }



  /// 立即发布
  Future<void> publish(BuildContext context) async {
    await submit(context, isDraft: false);
  }

  /// 提交
  Future<void> submit(BuildContext context, {required bool isDraft}) async {
    if (!_validate(context,isDraft: isDraft)) return;

    if (isSubmitting.value) return;

    isSubmitting.value = true;

    try {
      final request = _buildRequest(isDraft: isDraft);

      final success = isEditMode
          ? await ApiRequest.updateCoupons(request: request)
          : await ApiRequest.addCoupons(request: request);

      if (!success) return;

      errorMessage.value = null;

      Get.back(result: true);
      ToastUtils.showToast(
        message: isEditMode
            ? context.l10n.couponUpdateSuccess
            : context.l10n.couponPublishSuccess,
        type: ToastType.success,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  /// 表单校验
  bool _validate(BuildContext context, {required bool isDraft}) {
    final name = nameController.text.trim();
    final desc = descriptionController.text.trim();

    if (name.isEmpty) {
      errorMessage.value = context.l10n.pleaseInputCouponName;
      return false;
    }

    if (desc.isEmpty) {

      errorMessage.value = context.l10n.pleaseInputCouponDescription;

      return false;

    }

    if (isFixedAmount) {
      final discountAmount = _doubleValue(fixedDiscountAmountController.text);

      if (discountAmount <= 0) {
        errorMessage.value = context.l10n.pleaseInputDiscountAmount;
        return false;
      }


    }

    if (isPercentageDiscount) {
      final rate = _doubleValue(discountRateController.text);

      if (rate <= 0 || rate > 100) {
        errorMessage.value = context.l10n.pleaseInputCorrectDiscountRate;
        return false;
      }
    }

    if (isConditionDiscount) {
      final minAmount = _doubleValue(conditionMinAmountController.text);
      final discountAmount = _doubleValue(
        conditionDiscountAmountController.text,
      );

      if (minAmount <= 0) {
        errorMessage.value = context.l10n.pleaseInputThresholdAmount;
        return false;
      }

      if (discountAmount <= 0) {
        errorMessage.value = context.l10n.pleaseInputDiscountAmount;
        return false;
      }

      if (discountAmount > minAmount) {
        errorMessage.value = context.l10n.discountAmountCannotExceedThreshold;
        return false;
      }
    }

    if (selectedShopIds.isEmpty) {
      errorMessage.value = context.l10n.pleaseSelectApplicableStores;
      return false;
    }

    if (startDate.value == null) {
      errorMessage.value = context.l10n.pleaseSelectStartDate;
      return false;
    }

    if (endDate.value == null) {
      errorMessage.value = context.l10n.pleaseSelectEndDate;
      return false;
    }

    if (endDate.value!.isBefore(startDate.value!)) {
      errorMessage.value = context.l10n.endTimeCannotBeforeStartTime;
      return false;
    }

    if (isDisabled && disableReasonController.text.trim().isEmpty) {
      errorMessage.value = context.l10n.pleaseInputDisableReason;
      return false;
    }

    errorMessage.value = null;
    return true;
  }

  /// 构建接口入参
  CouponRequest _buildRequest({required bool isDraft}) {
    final type = selectedType.value;
    double value = 0;
    double minOrderAmount = 0;
    double maxDiscountAmount = 0;

    if (type == 0) {
      /// 固定金额引
      value = _doubleValue(fixedDiscountAmountController.text);
      minOrderAmount = 0;
      maxDiscountAmount = 0;
    } else if (type == 1) {
      /// 百分比折扣引
      value = _doubleValue(discountRateController.text);
      minOrderAmount = 0;
      maxDiscountAmount = 0;
    } else if (type == 2) {
      /// 条件付割引
      minOrderAmount = _doubleValue(conditionDiscountAmountController.text);
      maxDiscountAmount = _doubleValue(conditionMinAmountController.text);
      value = 0;
    }

    final userId = SessionController.current.userInfo.value?.userId ?? 0;

    return CouponRequest(
      couponId: editingCoupon.value?.couponId ?? 0,
      userId: userId,
      name: nameController.text.trim(),
      description: descriptionController.text.trim(),
      type: type,
      value: value,
      minOrderAmount: minOrderAmount,
      maxDiscountAmount: maxDiscountAmount,
      startTime: _formatDateTime(startDate.value),
      endTime: _formatDateTime(endDate.value),

      disableStatus: isDraft ? 1 : disableStatus.value,
      disableMsg: isDisabled || isDraft
          ? disableReasonController.text.trim()
          : '',
      createTime: '',
      updateTime: '',
      isDeleted: 0,
      shopIds: selectedShopIds.join(','),
    );
  }

  /// 转 double
  double _doubleValue(String value) {
    return double.tryParse(value.trim()) ?? 0;
  }

  /// 格式化日期时间，用于页面显示和接口提交
  String _formatDateTime(DateTime? date) {
    if (date == null) return '';
    final y = date.year.toString();
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    final h = date.hour.toString().padLeft(2, '0');
    final min = date.minute.toString().padLeft(2, '0');
    final s = date.second.toString().padLeft(2, '0');

    return '$y-$m-$d $h:$min:$s';
  }

  /// 后端时间字符串转 DateTime。
  DateTime? _parseDate(String value) {
    final text = value.trim();
    if (text.isEmpty) return null;
    return DateTime.tryParse(text);
  }

  /// 数字回填输入框时去掉多余的 .0。
  String _formatNumber(double value) {
    if (value == 0) return '';
    if (value % 1 == 0) return value.toInt().toString();
    return value.toString();
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();

    fixedMinAmountController.dispose();
    fixedDiscountAmountController.dispose();

    discountRateController.dispose();

    conditionMinAmountController.dispose();
    conditionDiscountAmountController.dispose();

    shopTextController.dispose();
    disableReasonController.dispose();

    super.onClose();
  }
}
