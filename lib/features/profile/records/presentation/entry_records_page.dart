import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/profile/records/model/entry_record_item.dart';
import 'package:alumni_association_app/features/profile/records/presentation/entry_records_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

///入单记录
class EntryRecordsPage extends StatelessWidget {
  const EntryRecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EntryRecordsController());
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => Get.back()),
        title: Text(context.l10n.entryRecords, style: _titleStyle),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.calendar_month_outlined, size: 24.sp),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.searchController,
                    onSubmitted: (_) => controller.fetchInitial(),
                    decoration: InputDecoration(
                      hintText: context.l10n.entryRecordSearchHint,
                      prefixIcon: const Icon(Icons.search_rounded),
                      fillColor: const Color(0xFFF2F5FA),
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: controller.fetchInitial,
                  icon: const Icon(Icons.filter_alt_outlined),
                  label: Text(context.l10n.filter),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(
              () => RefreshIndicator(
                onRefresh: controller.fetchInitial,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification.metrics.pixels >
                        notification.metrics.maxScrollExtent - 80.h) {
                      controller.loadMore();
                    }
                    return false;
                  },
                  child: ListView.separated(
                    padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 112.h),
                    itemCount:
                        controller.records.length +
                        (controller.hasMore.value ? 1 : 0),
                    separatorBuilder: (_, _) => SizedBox(height: 10.h),
                    itemBuilder: (context, index) {
                      if (index >= controller.records.length) {
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      }
                      return _EntryRecordCard(item: controller.records[index]);
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Obx(() => _SummaryBar(controller: controller)),
    );
  }
}

class _EntryRecordCard extends StatelessWidget {
  const _EntryRecordCard({required this.item});
  final EntryRecordItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: _cardDecoration,
      child: Row(
        children: [
          CircleAvatar(
            radius: 31.r,
            backgroundColor: Color(item.avatarColor).withValues(alpha: 0.1),
            child: Text(
              item.avatarText,
              style: TextStyle(
                color: Color(item.avatarColor),
                fontSize: 24.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(item.name, style: _itemTitleStyle),
                    if (item.isVip) ...[SizedBox(width: 6.w), _VipTag()],
                  ],
                ),
                SizedBox(height: 5.h),
                Text(item.packageName, style: _metaStyle),
                Text(
                  '${context.l10n.orderNo}:  ${item.orderNo}',
                  style: _metaStyle,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.phone,
                      size: 14.sp,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: 4.w),
                    Text(item.phone, style: _metaStyle),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(item.time, style: _metaStyle),
              SizedBox(height: 22.h),
              Text(
                '${context.l10n.receivable} ¥${item.receivableAmount.toStringAsFixed(0)}',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13.sp,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                '${context.l10n.paid} ¥${item.paidAmount.toStringAsFixed(0)}',
                style: TextStyle(
                  color: const Color(0xFFFF4B16),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          SizedBox(width: 4.w),
          Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}

class _SummaryBar extends StatelessWidget {
  const _SummaryBar({required this.controller});
  final EntryRecordsController controller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        margin: EdgeInsets.all(12.r),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: _cardDecoration,
        child: Row(
          children: [
            _SummaryItem(
              icon: Icons.receipt_long_rounded,
              title: context.l10n.todayEntryCount,
              value: '${controller.records.length}${context.l10n.recordUnit}',
              color: AppColors.primary,
            ),
            _DividerLine(),
            _SummaryItem(
              icon: Icons.account_balance_wallet_rounded,
              title: context.l10n.receivableTotal,
              value: '¥${controller.receivableTotal.toStringAsFixed(0)}',
              color: const Color(0xFFFF6A00),
            ),
            _DividerLine(),
            _SummaryItem(
              icon: Icons.check_circle_rounded,
              title: context.l10n.paidTotal,
              value: '¥${controller.paidTotal.toStringAsFixed(0)}',
              color: AppColors.success,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24.sp),
          SizedBox(width: 7.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: _metaStyle),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VipTag extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE7B5),
        borderRadius: BorderRadius.circular(7.r),
      ),
      child: Text(
        'VIP',
        style: TextStyle(
          color: const Color(0xFFC97900),
          fontSize: 10.sp,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _DividerLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 34.h, color: const Color(0xFFE6EBF3));
}

final _titleStyle = TextStyle(fontSize: 19.sp, fontWeight: FontWeight.w900);
final _itemTitleStyle = TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800);
final _metaStyle = TextStyle(color: AppColors.textSecondary, fontSize: 13.sp);
final _cardDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(18.r),
  boxShadow: [
    BoxShadow(
      color: const Color(0xFF1E5AA8).withValues(alpha: 0.06),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ],
);
