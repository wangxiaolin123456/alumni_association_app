import 'package:alumni_association_app/app/router/app_router.dart';
import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/consumption/model/response/consumption_entry_response.dart';
import 'package:alumni_association_app/features/consumption/presentation/consumption_entry_controller.dart';
import 'package:alumni_association_app/features/consumption/presentation/consumption_entry_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
///消费入单 第二步
class ConsumptionCouponPage extends StatelessWidget {
  const ConsumptionCouponPage({super.key});

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
          const ConsumptionStepIndicator(currentStep: 2),
          SizedBox(height: 24.h),
          SelectedMerchantCard(
            merchant: controller.selectedMerchant,
            onReselect: () => context.pop(),
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  context.l10n.selectCoupon,
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () {},
                label: Text(context.l10n.couponInstructions),
                icon: const Icon(Icons.help_outline_rounded),
              ),
            ],
          ),
          Obx(() {
            final selectedIndex = controller.selectedCouponIndex.value;
            return Column(
              children: [
                ...controller.coupons.asMap().entries.map(
                  (entry) => _CouponItem(
                    coupon: entry.value,
                    selected: selectedIndex == entry.key,
                    onTap: () => controller.selectCoupon(entry.key),
                  ),
                ),
                _NoCouponItem(
                  selected: selectedIndex == controller.coupons.length,
                  onTap: () =>
                      controller.selectCoupon(controller.coupons.length),
                ),
              ],
            );
          }),
          Container(
            margin: EdgeInsets.only(top: 14.h),
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF5E9),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              context.l10n.singleCouponHint,
              style: const TextStyle(color: Color(0xFFFF6A1A)),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(14.w, 8.h, 14.w, 12.h),
          child: FilledButton(
            onPressed: () {
              controller.goToStep(3);
              context.push(Pages.consumptionAmount);
            },
            child: Text(context.l10n.nextEnterAmount),
          ),
        ),
      ),
    );
  }
}

class _CouponItem extends StatelessWidget {
  const _CouponItem({
    required this.coupon,
    required this.selected,
    required this.onTap,
  });
  final ConsumptionCouponResponse coupon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: selected ? AppColors.primary : const Color(0xFFEAF0F7),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 80.w,
              height: 72.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: coupon.type == 'discount'
                    ? const Color(0xFFEDF4FF)
                    : const Color(0xFFFFF5E9),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                coupon.badge,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: coupon.type == 'discount'
                      ? AppColors.primary
                      : const Color(0xFFFF6A1A),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coupon.title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(coupon.rule, style: consumptionSecondaryText),
                  SizedBox(height: 5.h),
                  Text(
                    '${context.l10n.validUntil}: ${coupon.validity}',
                    style: consumptionSecondaryText,
                  ),
                ],
              ),
            ),
            Icon(
              selected ? Icons.check_circle_rounded : Icons.circle_outlined,
              color: selected ? AppColors.primary : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _NoCouponItem extends StatelessWidget {
  const _NoCouponItem({required this.selected, required this.onTap});
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(
          color: selected ? AppColors.primary : const Color(0xFFEAF0F7),
        ),
      ),
      tileColor: Colors.white,
      title: Text(context.l10n.doNotUseCoupon),
      subtitle: Text(context.l10n.calculateOriginalPrice),
      trailing: Icon(
        selected ? Icons.check_circle_rounded : Icons.circle_outlined,
        color: selected ? AppColors.primary : AppColors.textSecondary,
      ),
    );
  }
}
