import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/member/consumption_records/model/response/consumption_record_response.dart';
import 'package:alumni_association_app/features/member/consumption_records/pages/consumption_records_controller.dart';
import 'package:alumni_association_app/features/member/widgets/member_feature_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
///消费记录
class ConsumptionRecordsPage extends StatelessWidget {
  const ConsumptionRecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ConsumptionRecordsController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.consumptionRecords,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: true,

      ),
      body: Obx(() {
        final selectedTab = controller.selectedTab.value;
        final records = controller.filteredRecords;
        return ListView(
          padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 24.h),
          children: [
            MemberFeatureTabs(
              labels: [
                context.l10n.all,
                context.l10n.thisMonth,
                context.l10n.pendingVerification,
                context.l10n.verified,
              ],
              selectedIndex: selectedTab,
              onSelected: (index) => controller.selectedTab.value = index,
            ),
            SizedBox(height: 16.h),
            _SummaryCard(controller: controller),
            SizedBox(height: 16.h),
            ...records.map(
              (record) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: _RecordCard(record: record),
              ),
            ),
            if (records.isEmpty)
              Padding(
                padding: EdgeInsets.only(top: 80.h),
                child: Center(child: Text(context.l10n.noRecords)),
              ),
          ],
        );
      }),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.controller});
  final ConsumptionRecordsController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 22.h),
      decoration: memberFeatureCardDecoration,
      child: Row(
        children: [
          _SummaryItem(
            label: context.l10n.monthlyConsumption,
            value: '¥ ${controller.totalPaid.toStringAsFixed(0)}',
            color: AppColors.primary,
          ),
          Container(width: 1, height: 48.h, color: const Color(0xFFE6ECF5)),
          _SummaryItem(
            label: context.l10n.discountAmount,
            value: '¥ ${controller.totalDiscount.toStringAsFixed(0)}',
            color: const Color(0xFFFF5B13),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.label,
    required this.value,
    required this.color,
  });
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          SizedBox(height: 12.h),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecordCard extends StatelessWidget {
  const _RecordCard({required this.record});
  final ConsumptionRecordResponse record;

  @override
  Widget build(BuildContext context) {
    final verified = record.status == 'verified';
    final accent = Color(record.accentColor);
    return InkWell(
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.orderDetailsComingSoon)),
      ),
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: memberFeatureCardDecoration,
        child: Row(
          children: [
            Container(
              width: 58.r,
              height: 58.r,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.receipt_long_rounded,
                color: accent,
                size: 30.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.merchantName,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    record.offerName,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '${context.l10n.amountDue} ¥${record.originalAmount.toStringAsFixed(0)}  ${context.l10n.paidAmount} ¥${record.paidAmount.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Color(0xFFFF5B13),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  record.date,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10.sp,
                  ),
                ),
                SizedBox(height: 20.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: verified
                        ? const Color(0xFFE6F9EF)
                        : const Color(0xFFFFF5E9),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Text(
                    verified
                        ? context.l10n.verified
                        : context.l10n.pendingVerification,
                    style: TextStyle(
                      color: verified ? AppColors.success : AppColors.warning,
                      fontSize: 10.sp,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
