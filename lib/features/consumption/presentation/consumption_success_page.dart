import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/consumption/presentation/consumption_entry_controller.dart';
import 'package:alumni_association_app/features/consumption/presentation/consumption_entry_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


import '../../../app/router/app_router.dart';
///消费入单 第四步
class ConsumptionSuccessPage extends StatelessWidget {
  const ConsumptionSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ConsumptionEntryController>();
    final order = controller.submittedOrder.value;

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
        padding: EdgeInsets.fromLTRB(14.w, 4.h, 14.w, 24.h),
        children: [
          const ConsumptionStepIndicator(currentStep: 4),
          SizedBox(height: 30.h),
          Icon(
            Icons.assignment_turned_in_rounded,
            color: AppColors.primary,
            size: 120.sp,
          ),
          SizedBox(height: 12.h),
          Text(
            context.l10n.submissionSuccessful,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 8.h),
          Text(
            context.l10n.submissionSuccessHint,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, height: 1.6),
          ),
          SizedBox(height: 24.h),
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: consumptionCardDecoration,
            child: Column(
              children: [
                _ResultRow(
                  label: context.l10n.orderNumber,
                  value: order?.orderNumber ?? '--',
                ),
                _ResultRow(
                  label: context.l10n.merchantName,
                  value: controller.selectedMerchant.name,
                ),
                _ResultRow(
                  label: context.l10n.submissionTime,
                  value: order?.submittedAt ?? '--',
                ),
                const Divider(),
                _ResultRow(
                  label: context.l10n.originalAmount,
                  value: '¥ ${controller.amount.value.toStringAsFixed(2)}',
                ),
                _ResultRow(
                  label: context.l10n.usedCoupon,
                  value:
                      controller.selectedCoupon?.title ??
                      context.l10n.doNotUseCoupon,
                ),
                _ResultRow(
                  label: context.l10n.discountAmount,
                  value: '- ¥ ${controller.discountAmount.toStringAsFixed(2)}',
                ),
                const Divider(),
                _ResultRow(
                  label: context.l10n.payableAmount,
                  value: '¥ ${controller.payableAmount.toStringAsFixed(2)}',
                  emphasized: true,
                ),
              ],
            ),
          ),
          SizedBox(height: 18.h),
          OutlinedButton(
            onPressed: () {
              Get.toNamed(Pages.memberRecords);
              Get.offAllNamed('/');
            },
            child: Text(context.l10n.viewOrder),
          ),
          SizedBox(height: 10.h),
          FilledButton(
            onPressed: () {
              controller.resetWorkflow();
              Get.offAllNamed('/');
            },
            child: Text(context.l10n.returnHome),
          ),
        ],
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.label,
    required this.value,
    this.emphasized = false,
  });
  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 9.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: emphasized ? Colors.red : AppColors.textPrimary,
                fontSize: emphasized ? 18.sp : 13.sp,
                fontWeight: emphasized ? FontWeight.w800 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
