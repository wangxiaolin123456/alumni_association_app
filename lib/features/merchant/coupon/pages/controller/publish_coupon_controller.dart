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
  /// 1 = 固定金额引
  /// 2 = 百分比折扣引
  /// 3 = 条件付割引
  final selectedType = 1.obs;

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
  final startDateText = '开始日期'.obs;

  /// 页面显示用结束时间
  final endDateText = '结束日期'.obs;

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
  bool get isFixedAmount => selectedType.value == 1;

  /// 是否是百分比折扣引
  bool get isPercentageDiscount => selectedType.value == 2;

  /// 是否是条件付割引
  bool get isConditionDiscount => selectedType.value == 3;

  /// 是否禁用
  bool get isDisabled => disableStatus.value == 1;

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

    if (selectedShopIds.isEmpty) {
      shopTextController.clear();
    } else {
      shopTextController.text = '已选择 ${selectedShopIds.length} 家门店';
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
      initialTime: startDate.value ??
          DateTime(
            date.year,
            date.month,
            date.day,
            0,
            0,
            0,
          ),
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
      initialTime: endDate.value ??
          DateTime(
            date.year,
            date.month,
            date.day,
            23,
            59,
            59,
          ),
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
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            ),
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
                  const Text(
                    '选择时间',
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
                        title: '时',
                        itemCount: 24,
                        initialItem: selectedHour,
                        onSelectedItemChanged: (value) {
                          selectedHour = value;
                        },
                      ),
                    ),
                    Expanded(
                      child: TimePickerColumn(
                        title: '分',
                        itemCount: 60,
                        initialItem: selectedMinute,
                        onSelectedItemChanged: (value) {
                          selectedMinute = value;
                        },
                      ),
                    ),
                    Expanded(
                      child: TimePickerColumn(
                        title: '秒',
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


  /// 保存草稿
  Future<void> saveDraft(BuildContext context) async {
    await submit(context, isDraft: true);
  }

  /// 立即发布
  Future<void> publish(BuildContext context) async {
    await submit(context, isDraft: false);
  }

  /// 提交
  Future<void> submit(
      BuildContext context, {
        required bool isDraft,
      }) async {
    if (!_validate(isDraft: isDraft)) return;

    if (isSubmitting.value) return;

    isSubmitting.value = true;

    try {
      final request = _buildRequest(isDraft: isDraft);

      final success = await ApiRequest.addCoupons(request: request);

      if (!success) return;

      errorMessage.value = null;

      Get.back();
      ToastUtils.showToast(message: "优惠券发布成功。",type: ToastType.success);
    } finally {
      isSubmitting.value = false;
    }
  }

  /// 表单校验
  bool _validate({required bool isDraft}) {
    final name = nameController.text.trim();
    final desc = descriptionController.text.trim();

    if (name.isEmpty) {
      errorMessage.value = '请输入优惠券名称';
      return false;
    }

    if (desc.isEmpty) {
      errorMessage.value = '请输入优惠券描述';
      return false;
    }

    if (isFixedAmount) {
      final minAmount = _doubleValue(fixedMinAmountController.text);
      final discountAmount = _doubleValue(fixedDiscountAmountController.text);

      if (minAmount <= 0) {
        errorMessage.value = '请输入门槛金额';
        return false;
      }

      if (discountAmount <= 0) {
        errorMessage.value = '请输入减免金额';
        return false;
      }

      if (discountAmount > minAmount) {
        errorMessage.value = '减免金额不能大于门槛金额';
        return false;
      }
    }

    if (isPercentageDiscount) {
      final rate = _doubleValue(discountRateController.text);

      if (rate <= 0 || rate > 100) {
        errorMessage.value = '请输入正确的折扣率';
        return false;
      }
    }

    if (isConditionDiscount) {
      final minAmount = _doubleValue(conditionMinAmountController.text);
      final discountAmount = _doubleValue(conditionDiscountAmountController.text);

      if (minAmount <= 0) {
        errorMessage.value = '请输入满足门槛金额';
        return false;
      }

      if (discountAmount <= 0) {
        errorMessage.value = '请输入减免金额';
        return false;
      }

      if (discountAmount > minAmount) {
        errorMessage.value = '减免金额不能大于门槛金额';
        return false;
      }
    }

    if (selectedShopIds.isEmpty) {
      errorMessage.value = '请选择适用门店';
      return false;
    }

    if (startDate.value == null) {
      errorMessage.value = '请选择开始日期';
      return false;
    }

    if (endDate.value == null) {
      errorMessage.value = '请选择结束日期';
      return false;
    }

    if (endDate.value!.isBefore(startDate.value!)) {
      errorMessage.value = '结束时间不能早于开始时间';
      return false;
    }

    if (isDisabled && disableReasonController.text.trim().isEmpty) {
      errorMessage.value = '请输入禁用原因';
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

    if (type == 1) {
      /// 固定金额引
      minOrderAmount = _doubleValue(fixedMinAmountController.text);
      value = _doubleValue(fixedDiscountAmountController.text);
      maxDiscountAmount = value;
    } else if (type == 2) {
      /// 百分比折扣引
      value = _doubleValue(discountRateController.text);
      minOrderAmount = 0;
      maxDiscountAmount = 0;
    } else if (type == 3) {
      /// 条件付割引
      minOrderAmount = _doubleValue(conditionMinAmountController.text);
      value = _doubleValue(conditionDiscountAmountController.text);
      maxDiscountAmount = value;
    }

    final userId = SessionController.current.userInfo.value?.id ?? 0;

    return CouponRequest(
      couponId: 0,
      userId: userId,
      name: nameController.text.trim(),
      description: descriptionController.text.trim(),
      type: type,
      value: value,
      minOrderAmount: minOrderAmount,
      maxDiscountAmount: maxDiscountAmount,
      startTime: _formatDateTime(startDate.value),
      endTime: _formatDateTime(endDate.value),

      /// 保存草稿时这里先按禁用处理。
      ///
      /// 如果后端后续有 draftStatus 字段，再单独传草稿状态。
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