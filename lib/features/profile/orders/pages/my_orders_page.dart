import 'package:alumni_association_app/app/router/app_router.dart';
import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/profile/orders/model/profile_order_item.dart';
import 'package:alumni_association_app/features/profile/orders/pages/my_orders_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


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
        actions: [
          IconButton(
            onPressed: controller.fetchInitial,
            icon: Icon(Icons.search_rounded, size: 28.sp),
          ),
        ],
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
                  child: ListView.separated(
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
                        onCancel: () =>
                            controller.cancelOrder(controller.orders[index]),
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
  const _OrderCard({required this.order, required this.onCancel});
  final ProfileOrderItem order;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(Pages.orderDetail),
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
                    '${context.l10n.orderNo}:  ${order.orderNo}',
                    style: _metaStyle,
                  ),
                ),
                Text(
                  _statusText(context, order.status),
                  style: TextStyle(
                    color: _statusColor(order.status),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FoodImage(seed: order.imageSeed, size: 104.w),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              order.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: _itemTitleStyle,
                            ),
                          ),
                          _CouponTag(),
                        ],
                      ),
                      SizedBox(height: 7.h),
                      Text(order.merchantName, style: _metaStyle),
                      SizedBox(height: 5.h),
                      Text(
                        '${context.l10n.useDate}:  ${order.useTime}',
                        style: _metaStyle,
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Text(
                            '¥${order.price.toStringAsFixed(2)}',
                            style: _priceStyle,
                          ),
                          SizedBox(width: 18.w),
                          Text(
                            '¥${order.originalPrice.toStringAsFixed(2)}',
                            style: _originPriceStyle,
                          ),
                          const Spacer(),
                          Text(
                            '${context.l10n.totalCountPrefix}${order.count}${context.l10n.portion}',
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
              children: [
                OutlinedButton.icon(
                  onPressed: () =>
                      _toast(context, context.l10n.contactMerchant),
                  icon: Icon(Icons.phone_outlined, size: 16.sp),
                  label: Text(context.l10n.contactMerchant),
                ),
                const Spacer(),
                if (order.status == ProfileOrderStatus.pending)
                  FilledButton(
                    onPressed: onCancel,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFFF4B16),
                    ),
                    child: Text(context.l10n.cancelReservation),
                  )
                else
                  OutlinedButton(
                    onPressed: () =>
                        Get.toNamed(Pages.orderDetail),
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

class _FoodImage extends StatelessWidget {
  const _FoodImage({required this.seed, required this.size});
  final int seed;
  final double size;

  @override
  Widget build(BuildContext context) {
    final gradients = [
      const [Color(0xFF402312), Color(0xFFC57A2E)],
      const [Color(0xFF263B59), Color(0xFFE1A15B)],
      const [Color(0xFF5A2418), Color(0xFFE57E33)],
      const [Color(0xFF20140E), Color(0xFFA96836)],
      const [Color(0xFF14446F), Color(0xFFB88E58)],
    ];
    final colors = gradients[seed % gradients.length];
    return Container(
      width: size,
      height: size * 0.72,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        gradient: LinearGradient(colors: colors),
      ),
      child: Icon(Icons.restaurant_rounded, color: Colors.white, size: 34.sp),
    );
  }
}

class _CouponTag extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFFF5A1F)),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        context.l10n.memberOffer,
        style: TextStyle(color: const Color(0xFFFF5A1F), fontSize: 10.sp),
      ),
    );
  }
}

String _statusText(BuildContext context, ProfileOrderStatus status) {
  return switch (status) {
    ProfileOrderStatus.pending => context.l10n.pendingUse,
    ProfileOrderStatus.used => context.l10n.used,
    ProfileOrderStatus.cancelled => context.l10n.cancelled,
  };
}

Color _statusColor(ProfileOrderStatus status) {
  return switch (status) {
    ProfileOrderStatus.pending => const Color(0xFFFF4B16),
    ProfileOrderStatus.used => AppColors.success,
    ProfileOrderStatus.cancelled => AppColors.textSecondary,
  };
}

void _toast(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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
