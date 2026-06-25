import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../store/model/response/store_response.dart';
import '../controller/publish_coupon_controller.dart';

/// 新增优惠券 / 发布优惠券
class PublishCouponPage extends StatelessWidget {
  const PublishCouponPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PublishCouponController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: Get.back,
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 22.sp,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        title: Text(
          '新增优惠券',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
        children: [
          _CouponFormCard(controller: controller),
          SizedBox(height: 16.h),
          Obx(
                () => controller.errorMessage.value == null
                ? const SizedBox.shrink()
                : Text(
              controller.errorMessage.value!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.danger,
                fontSize: 12.sp,
              ),
            ),
          ),
          SizedBox(height: 14.h),
          _BottomActions(controller: controller),
        ],
      ),
    );
  }
}

class _CouponFormCard extends StatelessWidget {
  const _CouponFormCard({required this.controller});

  final PublishCouponController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(14.w, 16.h, 14.w, 18.h),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Field(
            label: '优惠券名称 *',
            hint: '请输入优惠券名称',
            controller: controller.nameController,
            maxLength: 20,
          ),
          SizedBox(height: 16.h),
          _DescriptionField(controller: controller),
          SizedBox(height: 20.h),
          _RequiredLabel('优惠券类型 *'),
          SizedBox(height: 14.h),
          _CouponTypeSelector(controller: controller),
          SizedBox(height: 18.h),
          _CouponAmountForms(controller: controller),
          SizedBox(height: 14.h),
          _StoreSelector(controller: controller),
          SizedBox(height: 14.h),
          _ValidTimeRow(controller: controller),
          SizedBox(height: 18.h),
          _StatusRow(controller: controller),
          Obx(
                () => controller.isDisabled
                ? Padding(
              padding: EdgeInsets.only(top: 14.h),
              child: _DisableReasonField(controller: controller),
            )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

/// 优惠券描述
class _DescriptionField extends StatelessWidget {
  const _DescriptionField({required this.controller});

  final PublishCouponController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _RequiredLabel('优惠券描述 *'),
        SizedBox(height: 12.h),
        SizedBox(
          height: 132.h,
          child: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller.descriptionController,
            builder: (context, value, child) {
              return TextField(
                controller: controller.descriptionController,
                maxLength: 500,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textPrimary,
                ),
                decoration: _inputDecoration(
                  hint: '请输入优惠券描述，例如：满299减30元，适用于店内所有商品，部分商品除外。',
                  maxLength: 500,
                  currentLength: value.text.length,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// 优惠券类型选择
class _CouponTypeSelector extends StatelessWidget {
  const _CouponTypeSelector({required this.controller});

  final PublishCouponController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Row(
        children: [
          Expanded(
            child: _TypeCard(
              selected: controller.selectedType.value == 1,
              icon: Icons.confirmation_number_rounded,
              iconColor: AppColors.primary,
              title: '固定金额引',
              subtitle: '固定金额立减',
              example: '如：满199减20元',
              onTap: () => controller.selectCouponType(1),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _TypeCard(
              selected: controller.selectedType.value == 2,
              icon: Icons.percent_rounded,
              iconColor: const Color(0xFF667085),
              title: '百分比折扣引',
              subtitle: '按百分比折扣',
              example: '如：全场9折',
              onTap: () => controller.selectCouponType(2),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _TypeCard(
              selected: controller.selectedType.value == 3,
              icon: Icons.local_offer_rounded,
              iconColor: const Color(0xFF667085),
              title: '条件付割引',
              subtitle: '满足指定条件享优惠',
              example: '如：满299减30元',
              onTap: () => controller.selectCouponType(3),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeCard extends StatelessWidget {
  const _TypeCard({
    required this.selected,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.example,
    required this.onTap,
  });

  final bool selected;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String example;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final activeColor = selected ? AppColors.primary : const Color(0xFF667085);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        height: 128.h,
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF3F8FF) : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: selected ? AppColors.primary : const Color(0xFFDDE6F6),
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Stack(
          children: [
            if (selected)
              Positioned(
                right: 0,
                top: 0,
                child: CircleAvatar(
                  radius: 12.r,
                  backgroundColor: AppColors.primary,
                  child: Icon(
                    Icons.check_rounded,
                    size: 15.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 30.sp, color: selected ? AppColors.primary : iconColor),
                  SizedBox(height: 10.h),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: activeColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 11.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    example,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10.sp,
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
}

/// 根据类型显示金额设置
class _CouponAmountForms extends StatelessWidget {
  const _CouponAmountForms({required this.controller});

  final PublishCouponController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          if (controller.isFixedAmount)
            _AmountSection(
              title: '固定金额引',
              icon: Icons.confirmation_number_rounded,
              iconColor: AppColors.primary,
              backgroundColor: const Color(0xFFF6F9FF),
              children: [
                _Field(
                  label: '门槛金额 *',
                  hint: '请输入满减门槛金额',
                  controller: controller.fixedMinAmountController,
                  keyboardType: TextInputType.number,
                  suffixText: '元',
                ),
                _Field(
                  label: '减免金额 *',
                  hint: '请输入减免金额',
                  controller: controller.fixedDiscountAmountController,
                  keyboardType: TextInputType.number,
                  suffixText: '元',
                  bottomPadding: 0,
                ),
              ],
            ),
          if (controller.isPercentageDiscount)
            _AmountSection(
              title: '百分比折扣引',
              icon: Icons.percent_rounded,
              iconColor: AppColors.success,
              backgroundColor: const Color(0xFFF4FBF7),
              children: [
                _Field(
                  label: '折扣率 *',
                  hint: '请输入折扣率',
                  controller: controller.discountRateController,
                  keyboardType: TextInputType.number,
                  suffixText: '%',
                  bottomPadding: 0,
                ),
              ],
            ),
          if (controller.isConditionDiscount)
            _AmountSection(
              title: '条件付割引',
              icon: Icons.local_offer_rounded,
              iconColor: const Color(0xFFFF6B22),
              backgroundColor: const Color(0xFFFFF8F3),
              children: [
                _Field(
                  label: '门槛金额 *',
                  hint: '请输入满足门槛金额',
                  controller: controller.conditionMinAmountController,
                  keyboardType: TextInputType.number,
                  suffixText: '元',
                ),
                _Field(
                  label: '减免金额 *',
                  hint: '请输入减免金额',
                  controller: controller.conditionDiscountAmountController,
                  keyboardType: TextInputType.number,
                  suffixText: '元',
                  bottomPadding: 0,
                ),
              ],
            ),
        ],
      );
    });
  }
}

class _AmountSection extends StatelessWidget {
  const _AmountSection({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.children,
  });

  final String title;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: iconColor,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ...children,
        ],
      ),
    );
  }
}

/// 适用门店
/// 适用门店
class _StoreSelector extends StatelessWidget {
  const _StoreSelector({required this.controller});

  final PublishCouponController controller;

  @override
  Widget build(BuildContext context) {
    return _Field(
      label: '适用门店 *',
      hint: '请选择适用的门店',
      controller: controller.shopTextController,
      readOnly: true,
      trailing: Icons.chevron_right_rounded,
      onTap: () => _showStorePicker(context),
    );
  }

  Future<void> _showStorePicker(BuildContext context) async {
    await controller.prepareStorePicker();
    if (!context.mounted) return;

    Get.bottomSheet<void>(
      _StorePickerSheet(controller: controller),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}

class _StorePickerSheet extends StatelessWidget {
  const _StorePickerSheet({required this.controller});

  final PublishCouponController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 560.h,
      padding: EdgeInsets.fromLTRB(18.w, 12.h, 18.w, 20.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFF),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24.r),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 42.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: const Color(0xFFD5DFEF),
              borderRadius: BorderRadius.circular(999.r),
            ),
          ),
          SizedBox(height: 16.h),

          /// 标题栏
          Row(
            children: [
              Text(
                '选择适用门店',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Obx(() {
                final allSelected = controller.myStores.isNotEmpty &&
                    controller.tempSelectedShopIds.length ==
                        controller.myStores.length;

                return TextButton(
                  onPressed: controller.myStores.isEmpty
                      ? null
                      : controller.toggleSelectAllStores,
                  child: Text(
                    allSelected ? '取消全选' : '全选',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
              }),
              IconButton(
                onPressed: Get.back,
                icon: Icon(
                  Icons.close_rounded,
                  size: 22.sp,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          SizedBox(height: 8.h),

          /// 已选提示
          Obx(
                () => Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF2FF),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                controller.tempSelectedShopIds.isEmpty
                    ? '请选择一个或多个门店'
                    : '已选择 ${controller.tempSelectedShopIds.length} 家门店',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          SizedBox(height: 12.h),

          Expanded(
            child: Obx(() {
              if (controller.isLoadingStores.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final stores = controller.myStores;

              if (stores.isEmpty) {
                return Center(
                  child: Text(
                    '暂无可用门店',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14.sp,
                    ),
                  ),
                );
              }

              return ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: stores.length,
                separatorBuilder: (_, _) => SizedBox(height: 10.h),
                itemBuilder: (context, index) {
                  final store = stores[index];

                  return Obx(() {
                    final selected =
                    controller.tempSelectedShopIds.contains(store.shopId);

                    return _StorePickerItem(
                      store: store,
                      selected: selected,
                      onTap: () => controller.toggleTempStore(store),
                    );
                  });
                },
              );
            }),
          ),

          SizedBox(height: 14.h),

          /// 底部按钮
          Row(
            children: [
              Expanded(
                child: _SheetCancelButton(
                  text: '取消',
                  onTap: Get.back,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Obx(
                      () => _SheetConfirmButton(
                    text: '确认选择',
                    disabled: controller.tempSelectedShopIds.isEmpty,
                    onTap: () {
                      controller.confirmSelectedStores();
                      Get.back();
                    },
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


class _SheetCancelButton extends StatelessWidget {
  const _SheetCancelButton({
    required this.text,
    required this.onTap,
  });

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        height: 48.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: const Color(0xFFDDE6F6),
            width: 1,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 15.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _SheetConfirmButton extends StatelessWidget {
  const _SheetConfirmButton({
    required this.text,
    required this.disabled,
    required this.onTap,
  });

  final String text;
  final bool disabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: disabled ? null : onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        height: 48.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: disabled
              ? null
              : const LinearGradient(
            colors: [
              Color(0xFF0B5CFF),
              Color(0xFF0052F5),
            ],
          ),
          color: disabled ? const Color(0xFFB8C5D8) : null,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            if (!disabled)
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.20),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
class _StorePickerItem extends StatelessWidget {
  const _StorePickerItem({
    required this.store,
    required this.selected,
    required this.onTap,
  });

  final StoreResponse store;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final address = store.fullAddress.isEmpty ? '暂无地址' : store.fullAddress;
    final phone = store.phone.isEmpty ? '暂无电话' : store.phone;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: selected ? AppColors.primary : const Color(0xFFEAF0F7),
            width: selected ? 1.4 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1E5AA8).withValues(alpha: 0.045),
              blurRadius: 16,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42.w,
              height: 42.w,
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFFEAF2FF)
                    : const Color(0xFFF4F7FC),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.storefront_rounded,
                color: selected ? AppColors.primary : AppColors.textSecondary,
                size: 22.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store.shopName.isEmpty ? '未命名门店' : store.shopName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    phone,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    address,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10.w),
            Icon(
              selected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: selected ? AppColors.primary : const Color(0xFFB5C0D0),
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }
}

/// 有效期
/// 有效期
class _ValidTimeRow extends StatelessWidget {
  const _ValidTimeRow({required this.controller});

  final PublishCouponController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _RequiredLabel('有效期间范围'),
        Expanded(
          child: Obx(
                () => _DateRangeBox(
              startText: controller.startDate.value == null
                  ? '开始日期'
                  : controller.startDateText.value,
              endText: controller.endDate.value == null
                  ? '结束日期'
                  : controller.endDateText.value,
              startPlaceholder: controller.startDate.value == null,
              endPlaceholder: controller.endDate.value == null,
              onTapStart: () => controller.pickStartDate(context),
              onTapEnd: () => controller.pickEndDate(context),
            ),
          ),
        ),
      ],
    );
  }
}

class _DateRangeBox extends StatelessWidget {
  const _DateRangeBox({
    required this.startText,
    required this.endText,
    required this.startPlaceholder,
    required this.endPlaceholder,
    required this.onTapStart,
    required this.onTapEnd,
  });

  final String startText;
  final String endText;
  final bool startPlaceholder;
  final bool endPlaceholder;
  final VoidCallback onTapStart;
  final VoidCallback onTapEnd;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.r),
        border: Border.all(
          color: const Color(0xFFDDE6F6),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          SizedBox(width: 10.w),
          Icon(
            Icons.access_time_rounded,
            size: 15.sp,
            color: const Color(0xFF9AA8BD),
          ),
          SizedBox(width: 8.w),

          /// 开始时间
          Expanded(
            child: InkWell(
              onTap: onTapStart,
              child: Text(
                startText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: startPlaceholder
                      ? const Color(0xFF9AA8BD)
                      : const Color(0xFF4D5872),
                  fontWeight:
                  startPlaceholder ? FontWeight.w400 : FontWeight.w500,
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Text(
              '-',
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF4D5872),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          /// 结束时间
          Expanded(
            child: InkWell(
              onTap: onTapEnd,
              child: Text(
                endText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: endPlaceholder
                      ? const Color(0xFF9AA8BD)
                      : const Color(0xFF4D5872),
                  fontWeight:
                  endPlaceholder ? FontWeight.w400 : FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),
        ],
      ),
    );
  }
}

/// 状态
class _StatusRow extends StatelessWidget {
  const _StatusRow({required this.controller});

  final PublishCouponController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _RequiredLabel('优惠券状态 *'),
        Expanded(
          child: Obx(
                () => Row(
              children: [
                _RadioItem(
                  text: '进行中',
                  selected: controller.disableStatus.value == 0,
                  onTap: () => controller.changeStatus(0),
                ),
                SizedBox(width: 32.w),
                _RadioItem(
                  text: '禁用',
                  selected: controller.disableStatus.value == 1,
                  onTap: () => controller.changeStatus(1),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _RadioItem extends StatelessWidget {
  const _RadioItem({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  final String text;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Row(
        children: [
          Icon(
            selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
            color: selected ? AppColors.primary : const Color(0xFFB5C0D0),
            size: 20.sp,
          ),
          SizedBox(width: 8.w),
          Text(
            text,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// 禁用原因
class _DisableReasonField extends StatelessWidget {
  const _DisableReasonField({required this.controller});

  final PublishCouponController controller;

  @override
  Widget build(BuildContext context) {
    return _Field(
      label: '禁用原因 *',
      hint: '请选择禁用原因',
      controller: controller.disableReasonController,
      trailing: Icons.keyboard_arrow_down_rounded,
      readOnly: false,
      bottomPadding: 0,
    );
  }
}

/// 底部按钮
class _BottomActions extends StatelessWidget {
  const _BottomActions({required this.controller});

  final PublishCouponController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Row(
        children: [
          Expanded(
            child: _PrimaryActionButton(
              text: '立即发布',
              disabled: controller.isSubmitting.value,
              onTap: () => controller.publish(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _OutlineActionButton extends StatelessWidget {
  const _OutlineActionButton({
    required this.text,
    required this.disabled,
    required this.onTap,
  });

  final String text;
  final bool disabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: disabled ? null : onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        height: 52.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.primary, width: 1.2),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 15.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _PrimaryActionButton extends StatelessWidget {
  const _PrimaryActionButton({
    required this.text,
    required this.disabled,
    required this.onTap,
  });

  final String text;
  final bool disabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: disabled ? null : onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        height: 52.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: disabled
              ? null
              : const LinearGradient(
            colors: [
              Color(0xFF0B5CFF),
              Color(0xFF0052F5),
            ],
          ),
          color: disabled ? const Color(0xFFB8C5D8) : null,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            if (!disabled)
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.20),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
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
    this.suffixText,
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
  final String? suffixText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding.h),
      child: Row(
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
                      suffixText: suffixText,
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
      width: 90.w,
      child: Text.rich(
        TextSpan(
          text: cleanText,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF102342),
          ),
          children: [
            if (hasRequiredMark)
              TextSpan(
                text: ' *',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.danger,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

InputDecoration _inputDecoration({
  required String hint,
  IconData? trailing,
  int? maxLength,
  int currentLength = 0,
  String? suffixText,
}) {
  return InputDecoration(
    hintText: hint,
    counterText: '',
    filled: true,
    fillColor: Colors.white,
    contentPadding: EdgeInsets.symmetric(horizontal: 14.w),
    hintStyle: TextStyle(
      fontSize: 13.sp,
      color: const Color(0xFF9AA8BD),
    ),
    suffixIconConstraints: BoxConstraints(
      minWidth: 48.w,
      minHeight: 45.h,
    ),
    suffixIcon: trailing != null
        ? Icon(
      trailing,
      color: AppColors.textSecondary,
      size: 22.sp,
    )
        : maxLength != null
        ? Padding(
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
    )
        : suffixText != null
        ? Padding(
      padding: EdgeInsets.only(right: 12.w),
      child: Center(
        widthFactor: 1,
        child: Text(
          suffixText,
          style: TextStyle(
            fontSize: 13.sp,
            color: const Color(0xFF7E8DA3),
          ),
        ),
      ),
    )
        : null,
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
  border: Border.all(
    color: const Color(0xFFEAF0F7),
    width: 1,
  ),
  boxShadow: [
    BoxShadow(
      color: const Color(0xFF1E5AA8).withValues(alpha: 0.045),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ],
);