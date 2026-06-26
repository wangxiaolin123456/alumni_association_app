import 'package:alumni_association_app/app/router/app_router.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/consumption/pages/consumption_entry_controller.dart';
import 'package:alumni_association_app/features/consumption/pages/consumption_entry_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

///消费入单 第三步
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
          const ConsumptionStepIndicator(currentStep: 3),
          SizedBox(height: 24.h),
          SelectedMerchantCard(merchant: controller.selectedMerchant),
          SizedBox(height: 14.h),
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
                Row(
                  children: [
                    Expanded(child: Text(context.l10n.selectedCoupon)),
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text(context.l10n.changeCoupon),
                    ),
                  ],
                ),
                Obx(
                  () => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const CircleAvatar(
                      child: Icon(Icons.percent_rounded),
                    ),
                    title: Text(
                      controller.selectedCoupon?.title ??
                          context.l10n.doNotUseCoupon,
                    ),
                    subtitle: Text(
                      controller.selectedCoupon?.rule ??
                          context.l10n.calculateOriginalPrice,
                    ),
                  ),
                ),
                Divider(height: 28.h),
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
          child: FilledButton(
            onPressed: () {
              if (controller.canContinueFromAmount) {
                controller.submit();
                Get.toNamed(Pages.consumptionSuccess);
              }
            },
            child: Text(context.l10n.nextConfirmSubmit),
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
        Expanded(child: Text(label)),
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
