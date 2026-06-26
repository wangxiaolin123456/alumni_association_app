import 'package:alumni_association_app/app/router/app_router.dart';
import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/consumption/pages/consumption_entry_controller.dart';
import 'package:alumni_association_app/features/consumption/pages/consumption_entry_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// 消费入单 第三步：填写消费金额
class ConsumptionAmountPage extends StatelessWidget {
  const ConsumptionAmountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ConsumptionEntryController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.consumptionEntry,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(14.w, 4.h, 14.w, 105.h),
        children: [
          SizedBox(height: 24.h),

          /// 已选商户
          Obx(() {
            final store = controller.selectedStore.value;

            if (store == null || store.shopId <= 0) {
              return const SizedBox.shrink();
            }

            return Container(
              padding: EdgeInsets.all(14.r),
              decoration: consumptionCardDecoration,
              child: Row(
                children: [
                  Container(
                    width: 44.r,
                    height: 44.r,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF2FF),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.storefront_rounded,
                      color: AppColors.primary,
                      size: 25.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          store.shopName.trim().isEmpty
                              ? context.l10n.unnamedStore
                              : store.shopName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          store.typeName.trim().isEmpty
                              ? context.l10n.allCategories
                              : store.typeName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: consumptionSecondaryText,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),

          SizedBox(height: 14.h),

          /// 金额填写
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: consumptionCardDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.fillConsumptionAmount,
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 18.h),

                TextField(
                  controller: controller.amountController,
                  onChanged: controller.updateAmount,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*\.?\d{0,2}'),
                    ),
                  ],
                  decoration: InputDecoration(
                    labelText: context.l10n.originalAmount,
                    prefixText: '¥ ',
                    suffixText: context.l10n.currencyYuan,
                    hintText: context.l10n.enterAmountHint,
                  ),
                ),

                SizedBox(height: 8.h),

                Text(
                  context.l10n.originalAmountHint,
                  style: consumptionSecondaryText,
                ),

                Divider(height: 28.h),

                /// 已选优惠券
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        context.l10n.selectedCoupon,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text(context.l10n.changeCoupon),
                    ),
                  ],
                ),

                Obx(
                      () => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFFFFF1E8),
                      child: Icon(
                        Icons.percent_rounded,
                        color: const Color(0xFFFF5B22),
                        size: 22.sp,
                      ),
                    ),
                    title: Text(
                      controller.selectedCouponTitle(context),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    subtitle: Text(
                      controller.selectedCouponRule(context),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: consumptionSecondaryText,
                    ),
                  ),
                ),

                Divider(height: 28.h),

                /// 优惠金额 / 应付金额
                Obx(
                      () => Column(
                    children: [
                      _AmountRow(
                        label: context.l10n.discountAmount,
                        value:
                        '- ¥${controller.discountAmount.toStringAsFixed(2)}',
                        color: const Color(0xFFFF5B22),
                      ),
                      SizedBox(height: 16.h),
                      _AmountRow(
                        label: context.l10n.payableAmount,
                        value:
                        '¥ ${controller.payableAmount.toStringAsFixed(2)}',
                        color: Colors.red,
                        emphasized: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 14.h),

          /// 备注
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: consumptionCardDecoration,
            child: TextField(
              controller: controller.noteController,
              maxLength: 100,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: context.l10n.notesOptional,
                hintText: context.l10n.consumptionNoteHint,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(14.w, 8.h, 14.w, 12.h),
          child: Obx(
                () => FilledButton(
              onPressed: controller.canContinueFromAmount
                  ? () {
                controller.submit();
                Get.toNamed(Pages.consumptionSuccess);
              }
                  : null,
              child: Text(context.l10n.nextConfirmSubmit),
            ),
          ),
        ),
      ),
    );
  }
}

class _AmountRow extends StatelessWidget {
  const _AmountRow({
    required this.label,
    required this.value,
    required this.color,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final Color color;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: emphasized ? 20.sp : 14.sp,
            fontWeight: emphasized ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}