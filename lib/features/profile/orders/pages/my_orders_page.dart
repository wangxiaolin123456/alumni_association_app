import 'package:alumni_association_app/app/router/app_router.dart';
import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/profile/orders/pages/my_orders_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/config/app_config.dart';
import '../../../consumption/model/response/order_response.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});


  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyOrdersController());
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => Get.back()),
        title: Text(context.l10n.myOrders, style: _titleStyle),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _OrderTabs(controller: controller),
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
                      controller.orders.isEmpty && !controller.isLoading.value
                      ? ListView(
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
                        )
                      : ListView.separated(
                          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
                          itemCount:
                              controller.orders.length +
                              (controller.hasMore.value ? 1 : 0),
                          separatorBuilder: (_, _) => SizedBox(height: 12.h),
                          itemBuilder: (context, index) {
                            if (index >= controller.orders.length) {
                              return const Center(
                                child: CircularProgressIndicator.adaptive(),
                              );
                            }
                            return _OrderCard(
                              order: controller.orders[index],
                              onCancel: () => controller.cancelOrder(
                                controller.orders[index],
                              ),
                              onUse: () async {
                                final success = await controller
                                    .prepareUseOrder(controller.orders[index]);
                                if (!success) return;

                                Get.toNamed(Pages.consumptionAmount);
                              },
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

class _OrderTabs extends StatelessWidget {
  const _OrderTabs({required this.controller});
  final MyOrdersController controller;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      context.l10n.allOrders,
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

class _OrderCard extends StatelessWidget {
  const _OrderCard({
    required this.order,
    required this.onCancel,
    required this.onUse,
  });

  final OrderResponse order;
  final VoidCallback onCancel;
  final Future<void> Function() onUse;

  @override
  Widget build(BuildContext context) {
    final orderNo = order.orderNum.trim().isNotEmpty
        ? order.orderNum
        : order.orderId.toString();

    final title = order.coupons?.name.trim().isNotEmpty == true
        ? order.coupons!.name
        : order.typeName.trim().isNotEmpty
        ? order.typeName
        : context.l10n.memberOffer;

    return InkWell(
      onTap: () => Get.toNamed(Pages.orderDetail, arguments: order),
      borderRadius: BorderRadius.circular(18.r),
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: _cardDecoration,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${context.l10n.orderNo}:  $orderNo',
                    style: _metaStyle,
                  ),
                ),
                Text(
                  _statusText(context, order.orderStatus),
                  style: TextStyle(
                    color: _statusColor(order.orderStatus),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: _storeImage(order),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              order.shopName.trim().isEmpty
                                  ? '${context.l10n.merchant} #${order.shopId}'
                                  : order.shopName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: _itemTitleStyle,
                            ),
                          ),
                          _OrderTypeTag(orderType: order.orderType),
                        ],
                      ),
                      SizedBox(height: 7.h),
                      _Tag(text: title),
                      SizedBox(height: 5.h),
                      Text(
                        '${context.l10n.useDate}:  ${_orderUseTime(order)}',
                        style: _metaStyle,
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Text(
                            '¥${order.actualTotal.toStringAsFixed(2)}',
                            style: _priceStyle,
                          ),
                          SizedBox(width: 18.w),
                          Text(
                            '¥${order.total.toStringAsFixed(2)}',
                            style: _originPriceStyle,
                          ),
                          const Spacer(),
                          Text(
                            '${context.l10n.totalCountPrefix}${order.peopleNum <= 0 ? 1 : order.peopleNum}${context.l10n.portion}',
                            style: _metaStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (order.orderStatus == 0) ...[
                  if (order.orderType == 1) ...[
                    OutlinedButton(
                      onPressed: onCancel,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFFF4B16),
                        side: const BorderSide(color: Color(0xFFFF4B16)),
                      ),
                      child: Text(context.l10n.cancelReservation),
                    ),
                    SizedBox(width: 8.w),
                  ],
                  FilledButton(
                    onPressed: onUse,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: Text(context.l10n.goUse),
                  ),
                  SizedBox(width: 8.w),
                ],
                OutlinedButton(
                  onPressed: () => Get.toNamed(Pages.orderDetail, arguments: order),
                  child: Text(context.l10n.viewDetail),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


///商店logo图
Widget _storeImage(OrderResponse store) {
  final logo = store.shopLogo.trim();

  if (logo.isEmpty) {
    return Image.asset(
      "assets/default_image.png",
      width: 78.w,
      height: 78.h,
      fit: BoxFit.cover,
    );
  }

  return Image.network(
    AppConfig.apiBaseUrl + logo,
    width: 78.w,
    height: 78.h,
    fit: BoxFit.cover,

    // 加载失败显示默认图
    errorBuilder: (context, error, stackTrace) {
      return Image.asset(
        "assets/default_image.png",
        width: 78.w,
        height: 78.h,
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
        width: 78.w,
        height: 78.h,
        fit: BoxFit.cover,
      );
    },
  );
}

class _Tag extends StatelessWidget {
  const _Tag({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    if (text.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF2E9),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.sp,
          color: const Color(0xFFFF5B22),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
class _OrderTypeTag extends StatelessWidget {
  const _OrderTypeTag({required this.orderType});

  final int orderType;

  @override
  Widget build(BuildContext context) {
    if (orderType != 1) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF2FF),
        border: Border.all(color: AppColors.primary),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        context.l10n.reservationOrder,
        style: TextStyle(
          color: AppColors.primary,
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
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


String _orderUseTime(OrderResponse order) {
  if (order.finallyTime.trim().isNotEmpty) return order.finallyTime;
  if (order.appointmentTime.trim().isNotEmpty) return order.appointmentTime;
  return order.createTime;
}

final _titleStyle = TextStyle(fontSize: 19.sp, fontWeight: FontWeight.w900);
final _itemTitleStyle = TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w800);
final _metaStyle = TextStyle(color: AppColors.textSecondary, fontSize: 13.sp);
final _priceStyle = TextStyle(
  color: const Color(0xFFFF4B16),
  fontSize: 17.sp,
  fontWeight: FontWeight.w800,
);
final _originPriceStyle = TextStyle(
  color: AppColors.textSecondary,
  fontSize: 13.sp,
  decoration: TextDecoration.lineThrough,
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
