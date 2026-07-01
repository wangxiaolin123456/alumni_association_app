import 'package:alumni_association_app/app/router/app_router.dart';
import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/config/app_config.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/consumption/model/response/order_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../auth/domain/session_controller.dart';
import 'entry_records_controller.dart';

/// 商家端入单记录页面。
///
/// 顶部 Tab 和我的订单保持一致：全部、待使用、已使用、已取消。
class EntryRecordsPage extends StatelessWidget {
  const EntryRecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EntryRecordsController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: BackButton(onPressed: () => Get.back()),
        title: Text(context.l10n.entryRecords, style: _titleStyle),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _RecordTabs(controller: controller),
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
                  child:
                      controller.records.isEmpty && !controller.isLoading.value
                      ? _EmptyRecords()
                      : ListView.separated(
                          padding: EdgeInsets.fromLTRB(16.w, 0.h, 16.w, 28.h),
                          itemCount:
                              controller.records.length +
                              (controller.hasMore.value ? 1 : 0),
                          separatorBuilder: (_, _) => SizedBox(height: 12.h),
                          itemBuilder: (context, index) {
                            if (index >= controller.records.length) {
                              return const Center(
                                child: CircularProgressIndicator.adaptive(),
                              );
                            }

                            final order = controller.records[index];
                            return _EntryRecordCard(
                              order: order,
                              onTap: () => Get.toNamed(
                                Pages.entryRecordDetail,
                                arguments: order,
                              ),
                            );
                          },
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecordTabs extends StatelessWidget {
  const _RecordTabs({required this.controller});

  final EntryRecordsController controller;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      context.l10n.all,
      context.l10n.pendingUse,
      context.l10n.used,
      context.l10n.cancelled,
    ];

    return Obx(
      () => Row(
        children: List.generate(tabs.length, (index) {
          final selected = controller.selectedTab.value == index;
          return Expanded(
            child: InkWell(
              onTap: () => controller.switchTab(index),
              child: Padding(
                padding: EdgeInsets.only(top: 12.h, bottom: 10.h),
                child: Column(
                  children: [
                    Text(
                      tabs[index],
                      style: TextStyle(
                        color: selected
                            ? AppColors.primary
                            : AppColors.textPrimary,
                        fontSize: 15.sp,
                        fontWeight: selected
                            ? FontWeight.w800
                            : FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: selected ? 42.w : 0,
                      height: 3.h,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(99.r),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _EntryRecordCard extends StatelessWidget {
  const _EntryRecordCard({required this.order, required this.onTap});

  final OrderResponse order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final contactName = order.nickName.trim().isNotEmpty
        ? order.nickName
        :  SessionController.current.userInfo.value?.email ?? '';



    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.r),
      child: Container(
        padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 14.h),
        decoration: _cardDecoration,
        child: Column(
          children: [
            /// 顶部：订单号 + 状态
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${context.l10n.orderNo}: ${_orderNo(order)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _orderNoStyle,
                  ),
                ),
                _StatusTag(status: order.orderStatus),
              ],
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Divider(
                height: 1,
                color: const Color(0xFFEAF0F7),
              ),
            ),

            /// 内容区
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipOval(
                  child: SizedBox(
                    width: 52.w,
                    height: 52.w,
                    child: _storeImage(order),
                  ),
                ),
                SizedBox(width: 12.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _shopName(context, order),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: _itemTitleStyle,
                      ),
                      SizedBox(height: 6.h),

                      Text(
                        '${context.l10n.user}：$contactName',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: _metaStyle,
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          Icon(
                            Icons.phone_rounded,
                            size: 14.sp,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              order.userPhone.trim().isEmpty ? '-' :  order.userPhone,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: _metaStyle,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        '${context.l10n.createTime}：${order.createTime}',
                        style: _timeStyle,
                      ),
                      SizedBox(height: 6.h),

                      Text(
                        '${context.l10n.finallyTime}：${order.finallyTime}',
                        style: _timeStyle,
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          Text(
                            '${context.l10n.paidTotal} ¥${order.actualTotal.toStringAsFixed(0)}',
                            style: _paidStyle,
                          ),
                          SizedBox(width: 10.h),
                          Text(
                            '${context.l10n.receivableTotal} ¥${order.total.toStringAsFixed(0)}',
                            style: _amountMetaStyle,
                          ),
                        ],
                      )

                    ],
                  ),
                ),

                SizedBox(width: 2.w),


                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textSecondary,
                  size: 24.sp,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusTag extends StatelessWidget {
  const _StatusTag({required this.status});

  final int status;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(99.r),
      ),
      child: Text(
        _statusText(context, status),
        style: TextStyle(
          color: color,
          fontSize: 11.sp,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _EmptyRecords extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: 180.h),
        Icon(
          Icons.receipt_long_outlined,
          size: 58.sp,
          color: AppColors.textSecondary,
        ),
        SizedBox(height: 12.h),
        Center(
          child: Text(
            context.l10n.noRecords,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

Widget _storeImage(OrderResponse order) {
  final logo = order.shopLogo.trim();
  if (logo.isEmpty) {
    return _defaultImage();
  }

  return Image.network(
    AppConfig.apiBaseUrl + logo,
    width: 50.w,
    height: 50.h,
    fit: BoxFit.cover,
    errorBuilder: (_, _, _) => _defaultImage(),
    loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) return child;
      return _defaultImage();
    },
  );
}

Widget _defaultImage() {
  return Image.asset(
    'assets/default_image.png',
    width: 50.w,
    height: 50.h,
    fit: BoxFit.cover,
  );
}

String _shopName(BuildContext context, OrderResponse order) {
  final name = order.shopName.trim();
  if (name.isNotEmpty) return name;
  return '${context.l10n.merchant} #${order.shopId}';
}

String _orderNo(OrderResponse order) {
  if (order.orderNum.trim().isNotEmpty) return order.orderNum;
  return order.orderId.toString();
}

String _orderTime(OrderResponse order) {
  if (order.finallyTime.trim().isNotEmpty) return order.finallyTime;
  if (order.appointmentTime.trim().isNotEmpty) return order.appointmentTime;
  return order.createTime;
}

String _statusText(BuildContext context, int status) {
  return switch (status) {
    1 => context.l10n.used,
    2 => context.l10n.cancelled,
    _ => context.l10n.pendingUse,
  };
}

Color _statusColor(int status) {
  return switch (status) {
    1 => AppColors.success,
    2 => AppColors.textSecondary,
    _ => const Color(0xFFFF4B16),
  };
}

final _titleStyle = TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w900);
final _itemTitleStyle = TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w900);
final _metaStyle = TextStyle(color: AppColors.textSecondary, fontSize: 12.sp);
final _amountMetaStyle = TextStyle(
  color: AppColors.textSecondary,
  fontSize: 12.sp,
);
final _paidStyle = TextStyle(
  color: const Color(0xFFFF4B16),
  fontSize: 16.sp,
  fontWeight: FontWeight.w900,
);
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
final _orderNoStyle = TextStyle(
  color: AppColors.textSecondary,
  fontSize: 12.sp,
  fontWeight: FontWeight.w600,
);

final _timeStyle = TextStyle(
  color: AppColors.textSecondary,
  fontSize: 11.sp,
  fontWeight: FontWeight.w500,
);

String _shortOrderTime(OrderResponse order) {
  final text = _orderTime(order);
  if (text.length >= 16) {
    return text.substring(5, 16);
  }
  return text;
}