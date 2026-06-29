import 'package:alumni_association_app/app/router/app_router.dart';
import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/consumption/pages/consumption_entry_controller.dart';
import 'package:alumni_association_app/features/consumption/pages/consumption_entry_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/config/app_config.dart';
import '../../store/model/response/store_response.dart';

/// 消费入单 第三步：填写消费金额
class ConsumptionAmountPage extends StatelessWidget {
  const ConsumptionAmountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ConsumptionEntryController>();

    return Scaffold(
      backgroundColor: AppColors.background,
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


          /// 已选商户
          Obx(() {
            final store = controller.selectedStore.value;

            if (store == null || store.shopId <= 0) {
              return const SizedBox.shrink();
            }

            return Container(
              padding: EdgeInsets.all(10.r),
              decoration: consumptionCardDecoration,
              child: Row(
                children: [
                  ///商户logo图
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: _storeImage(store),
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
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF2E9),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            store.typeName.trim().isEmpty
                                ? context.l10n.allCategories
                                : store.typeName,
                            style: TextStyle(
                              fontSize: 8.sp,
                              color: const Color(0xFFFF5B22),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
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
                    labelText: context.l10n.actualConsumptionPrice,
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

                  ],
                ),

                Obx(() {
                  final coupon = controller.selectedStoreCoupon.value;
                  final type = coupon?.type ?? 0;

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: _couponTypeBgColor(type),
                      child: Icon(
                        _couponTypeIcon(type),
                        color: _couponTypeColor(type),
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
                  );
                }),

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
                      ///原价
                      _AmountRow(
                        label: context.l10n.originalAmount,
                        value:
                            '¥ ${controller.originalAmount.toStringAsFixed(2)}',
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
                  ? () async {
                      final success = await controller.submitOrder();
                      if (success) {
                        Get.toNamed(Pages.consumptionSuccess);
                      }
                    }
                  : null,
              child: Text(
                controller.isSubmittingOrder.value
                    ? context.l10n.submitting
                    : context.l10n.nextConfirmSubmit,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
IconData _couponTypeIcon(int type) {
  switch (type) {
    case 0:
    // 固定金额
      return Icons.confirmation_number_rounded;
    case 1:
    // 百分比
      return Icons.percent_rounded;
    case 2:
    // 满减
      return Icons.local_offer_rounded;
    default:
      return Icons.confirmation_number_rounded;
  }
}

Color _couponTypeColor(int type) {
  switch (type) {
    case 0:
      return const Color(0xFFFF5B22);
    case 1:
      return const Color(0xFF0B5CFF);
    case 2:
      return const Color(0xFF12B76A);
    default:
      return const Color(0xFFFF5B22);
  }
}

Color _couponTypeBgColor(int type) {
  switch (type) {
    case 0:
      return const Color(0xFFFFF1E8);
    case 1:
      return const Color(0xFFEAF2FF);
    case 2:
      return const Color(0xFFE8FAF1);
    default:
      return const Color(0xFFFFF1E8);
  }
}

///商店logo图
Widget _storeImage(StoreResponse store) {
  final logo = store.shopLogo.trim();

  if (logo.isEmpty) {
    return Image.asset(
      "assets/default_image.png",
      width: 68.w,
      height: 68.h,
      fit: BoxFit.cover,
    );
  }

  return Image.network(
    AppConfig.apiBaseUrl + logo,
    width: 68.w,
    height: 68.h,
    fit: BoxFit.cover,

    // 加载失败显示默认图
    errorBuilder: (context, error, stackTrace) {
      return Image.asset(
        "assets/default_image.png",
        width: 68.w,
        height: 68.h,
        fit: BoxFit.cover,
      );
    },

    // 加载中显示默认图或者 loading
    loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) {
        return child;
      }

      return Image.asset(
        "assets/default_image.png",
        width: 68.w,
        height: 68.h,
        fit: BoxFit.cover,
      );
    },
  );
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
