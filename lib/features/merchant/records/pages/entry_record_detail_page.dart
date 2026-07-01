import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/config/app_config.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/consumption/model/response/order_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../auth/domain/session_controller.dart';
import 'entry_records_controller.dart';

/// 商家端入单记录详情页。
///
/// 列表点击后会带入一份订单摘要，这里再请求 `/api/order/orderInfo`
/// 获取更完整的详情，避免列表字段缺失时页面信息不准。
class EntryRecordDetailPage extends StatelessWidget {
  const EntryRecordDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<EntryRecordsController>()
        ? Get.find<EntryRecordsController>()
        : Get.put(EntryRecordsController());
    final initialOrder = _parseOrderArgument(Get.arguments);
    final orderId = initialOrder?.orderId ?? 0;

    if (orderId > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.fetchOrderDetail(orderId: orderId, fallback: initialOrder);
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: BackButton(onPressed: () => Get.back()),
        centerTitle: true,
        title: Text(context.l10n.orderDetail, style: _titleStyle),
      ),
      body: Obx(() {
        final order = controller.detailOrder.value ?? initialOrder;

        if (controller.isDetailLoading.value && order == null) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        if (order == null) {
          return Center(
            child: Text(
              context.l10n.noRecords,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 15.sp),
            ),
          );
        }

        return ListView(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 28.h),
          children: [
            _StatusCard(order: order),
            SizedBox(height: 12.h),
            _StoreCard(order: order),
            SizedBox(height: 12.h),
            _InfoCard(
              title: context.l10n.orderInfo,
              rows: [
                _InfoRow(context.l10n.orderNo, _orderNo(order)),
                _InfoRow(context.l10n.orderCreateTime, order.createTime),
                _InfoRow(
                  context.l10n.orderStatus,
                  _statusText(context, order.orderStatus),
                  highlight: true,
                ),
                _InfoRow(context.l10n.remark, _emptyText(order.remark)),
              ],
            ),
            SizedBox(height: 12.h),
            _InfoCard(
              title: context.l10n.useInfo,
              rows: [
                _InfoRow(context.l10n.useStore, _shopName(context, order)),
                _InfoRow(context.l10n.useAddress, _fullAddress(order)),
                _InfoRow(context.l10n.user, _userText(order)),
                _InfoRow(
                  context.l10n.contactPhone,
                  _emptyText(order.userPhone),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            _AmountCard(order: order),
          ],
        );
      }),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.order});

  final OrderResponse order;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF126DFF), Color(0xFF3E7FF1)],
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24.r,
            backgroundColor: Colors.white,
            child: Icon(Icons.receipt_long_rounded, color: AppColors.primary),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _statusText(context, order.orderStatus),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  _orderTime(order),
                  style: TextStyle(color: Colors.white, fontSize: 13.sp),
                ),
              ],
            ),
          ),
          Text(
            '¥${order.actualTotal.toStringAsFixed(2)}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _StoreCard extends StatelessWidget {
  const _StoreCard({required this.order});

  final OrderResponse order;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: _cardDecoration,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: _storeImage(order),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_shopName(context, order), style: _itemTitleStyle),
                SizedBox(height: 8.h),
                Text(order.typeName, style: _metaStyle),
                SizedBox(height: 6.h),
                Text(_fullAddress(order), style: _metaStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.rows});

  final String title;
  final List<_InfoRow> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: _sectionTitleStyle),
          SizedBox(height: 14.h),
          ...rows.map(
            (row) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: row,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value, {this.highlight = false});

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 96.w,
          child: Text(label, style: _metaStyle),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: highlight
                  ? const Color(0xFFFF4B16)
                  : AppColors.textPrimary,
              fontSize: 14.sp,
              fontWeight: highlight ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _AmountCard extends StatelessWidget {
  const _AmountCard({required this.order});

  final OrderResponse order;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.paidAmount, style: _sectionTitleStyle),
          SizedBox(height: 14.h),
          _AmountRow(context.l10n.receivable, order.total),
          SizedBox(height: 10.h),
          _AmountRow(context.l10n.usedCoupon, -order.reduceAmount),
          Divider(height: 24.h, color: const Color(0xFFEAF0F7)),
          _AmountRow(context.l10n.paid, order.actualTotal, highlight: true),
        ],
      ),
    );
  }
}

class _AmountRow extends StatelessWidget {
  const _AmountRow(this.label, this.amount, {this.highlight = false});

  final String label;
  final double amount;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label, style: _metaStyle)),
        Text(
          '¥${amount.toStringAsFixed(2)}',
          style: TextStyle(
            color: highlight ? const Color(0xFFFF4B16) : AppColors.textPrimary,
            fontSize: highlight ? 18.sp : 14.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

OrderResponse? _parseOrderArgument(Object? value) {
  if (value is OrderResponse) return value;
  return null;
}

Widget _storeImage(OrderResponse order) {
  final logo = order.shopLogo.trim();
  if (logo.isEmpty) return _defaultImage();

  return Image.network(
    AppConfig.apiBaseUrl + logo,
    width: 88.w,
    height: 88.h,
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
    width: 88.w,
    height: 88.h,
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

String _fullAddress(OrderResponse order) {
  final parts = [
    order.province,
    order.city,
    order.area,
    order.address,
  ].where((item) => item.trim().isNotEmpty).toList();
  return parts.isEmpty ? '-' : parts.join(' ');
}

String _userText(OrderResponse order) {
  if (order.nickName.trim().isNotEmpty) return order.nickName;
  return SessionController.current.userInfo.value?.email ?? '-';
}

String _emptyText(String value) {
  final text = value.trim();
  return text.isEmpty ? '-' : text;
}

String _statusText(BuildContext context, int status) {
  return switch (status) {
    1 => context.l10n.used,
    2 => context.l10n.cancelled,
    _ => context.l10n.pendingUse,
  };
}

final _titleStyle = TextStyle(fontSize: 19.sp, fontWeight: FontWeight.w900);
final _itemTitleStyle = TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w900);
final _sectionTitleStyle = TextStyle(
  fontSize: 17.sp,
  fontWeight: FontWeight.w900,
);
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
