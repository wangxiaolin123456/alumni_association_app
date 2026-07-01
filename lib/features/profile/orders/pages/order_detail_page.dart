import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/profile/orders/pages/my_orders_controller.dart';
import 'package:alumni_association_app/util/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/config/app_config.dart';
import '../../../consumption/model/response/order_response.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({this.order, super.key});

  final OrderResponse? order;

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<MyOrdersController>()
        ? Get.find<MyOrdersController>()
        : Get.put(MyOrdersController());
    final initialOrder = order ?? _parseOrderArgument(Get.arguments);
    final orderId = initialOrder?.orderId;

    if (orderId! > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.fetchOrderDetail(orderId: orderId, fallback: initialOrder);
      });
    }

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => Get.back()),
        title: Text(context.l10n.orderDetail, style: _titleStyle),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              final phone = initialOrder?.contactPhone ?? '';
              _callPhone(context, phone);
            },
            icon: Icon(Icons.support_agent_rounded, size: 25.sp),
          ),
        ],
      ),
      body: Obx(() {
        final item = controller.detailOrder.value ?? initialOrder;

        if (controller.isDetailLoading.value && initialOrder == null) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        return ListView(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 28.h),
          children: [
            _StatusHero(order: item!),
            SizedBox(height: 12.h),
            _PackageCard(order: item),
            SizedBox(height: 12.h),
            _InfoCard(
              title: context.l10n.orderInfo,
              rows: [
                _InfoRow(
                  context.l10n.orderNo,
                  _orderNo(item),
                  action: context.l10n.copy,
                  onActionTap: () => _copyText(context, _orderNo(item)),
                ),
                _InfoRow(context.l10n.orderCreateTime, item.createTime),
                _InfoRow(
                  context.l10n.orderStatus,
                  _statusText(context, item.orderStatus),
                ),
                if (item.peopleNum > 0)
                  _InfoRow(
                    context.l10n.quantity,
                    '${item.peopleNum <= 0 ? 1 : item.peopleNum}${context.l10n.portion}',
                  ),
                _InfoRow(
                  context.l10n.paidAmount,
                  '¥${item.actualTotal.toStringAsFixed(2)}',
                  highlight: true,
                ),

                _InfoRow(
                  context.l10n.remark,
                  item.remark.trim().isEmpty ? '-' : item.remark,
                ),
              ],
            ),
            SizedBox(height: 12.h),
            _InfoCard(
              title: context.l10n.useInfo,
              rows: [
                _InfoRow(context.l10n.useTime, _orderUseTime(item)),
                _InfoRow(context.l10n.useStore, _shopName(context, item)),
                _InfoRow(context.l10n.useAddress, _fullAddress(item)),
                _InfoRow(context.l10n.user, _userText(item), link: true),
                _InfoRow(context.l10n.contactPhone, item.contactPhone),
              ],
            ),
            SizedBox(height: 12.h),
            _AmountCard(order: item),
          ],
        );
      }),
    );
  }
}

class _StatusHero extends StatelessWidget {
  const _StatusHero({required this.order});

  final OrderResponse order;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 108.h,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF126DFF), Color(0xFF3E7FF1)],
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24.r,
            backgroundColor: Colors.white,
            child: Icon(Icons.schedule_rounded, color: AppColors.primary),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _statusText(context, order.orderStatus),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  context.l10n.orderReservedHint,
                  style: TextStyle(color: Colors.white, fontSize: 13.sp),
                ),
              ],
            ),
          ),
          Icon(
            Icons.apartment_rounded,
            color: Colors.white.withValues(alpha: 0.22),
            size: 78.sp,
          ),
        ],
      ),
    );
  }
}

class _PackageCard extends StatelessWidget {
  const _PackageCard({required this.order});

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
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _shopName(context, order),
                        style: _itemTitleStyle,
                      ),
                    ),
                    _OrderTypeTag(orderType: order.orderType),
                  ],
                ),
                SizedBox(height: 7.h),
                _Tag(text: order.typeName),
                SizedBox(height: 5.h),
                Text(
                  '${context.l10n.useDate}:  ${_orderUseTime(order)}',
                  style: _metaStyle,
                ),
                SizedBox(height: 5.h),
                Row(
                  children: [
                    Text(
                      '¥${order.actualTotal.toStringAsFixed(2)}',
                      style: _priceStyle,
                    ),
                    SizedBox(width: 16.w),
                    Text(
                      '¥${order.total.toStringAsFixed(2)}',
                      style: _originPriceStyle,
                    ),
                    const Spacer(),
                    if (order.peopleNum > 0)
                      Text(
                        '${context.l10n.totalCountPrefix}${order.peopleNum}${context.l10n.portion}',
                        style: _metaStyle,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 100.w,
                    child: Text(row.label, style: _metaStyle),
                  ),
                  Expanded(
                    child: Text(
                      row.value,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: row.highlight
                            ? const Color(0xFFFF4B16)
                            : row.link
                            ? AppColors.primary
                            : AppColors.textPrimary,
                        fontWeight: row.highlight
                            ? FontWeight.w800
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                  if (row.action != null) ...[
                    SizedBox(width: 8.w),
                    InkWell(
                      onTap: row.onActionTap,
                      child: Text(
                        row.action!,
                        style: const TextStyle(color: AppColors.primary),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
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
          Text(context.l10n.orderAmountDetail, style: _sectionTitleStyle),
          SizedBox(height: 12.h),
          _AmountRow(
            context.l10n.productAmount,
            '¥${order.total.toStringAsFixed(2)}',
          ),
          _AmountRow(
            context.l10n.memberDiscountAmount,
            '-¥${order.reduceAmount.toStringAsFixed(2)}',
            danger: true,
          ),
          const Divider(height: 24),
          _AmountRow(
            context.l10n.paidAmount,
            '¥${order.actualTotal.toStringAsFixed(2)}',
            danger: true,
            bold: true,
          ),
        ],
      ),
    );
  }
}

class _InfoRow {
  const _InfoRow(
    this.label,
    this.value, {
    this.action,
    this.onActionTap,
    this.highlight = false,
    this.link = false,
  });

  final String label;
  final String value;
  final String? action;
  final VoidCallback? onActionTap;
  final bool highlight;
  final bool link;
}

class _AmountRow extends StatelessWidget {
  const _AmountRow(
    this.label,
    this.value, {
    this.danger = false,
    this.bold = false,
  });

  final String label;
  final String value;
  final bool danger;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          Expanded(child: Text(label, style: _metaStyle)),
          Text(
            value,
            style: TextStyle(
              color: danger ? const Color(0xFFFF4B16) : AppColors.textPrimary,
              fontSize: bold ? 20.sp : 14.sp,
              fontWeight: bold ? FontWeight.w900 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

final _sectionTitleStyle = TextStyle(
  fontSize: 16.sp,
  fontWeight: FontWeight.w800,
);
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

String _orderNo(OrderResponse order) {
  return order.orderNum.trim().isNotEmpty
      ? order.orderNum
      : order.orderId.toString();
}

String _shopName(BuildContext context, OrderResponse order) {
  return order.shopName.trim().isNotEmpty
      ? order.shopName
      : '${context.l10n.merchant} #${order.shopId}';
}

String _orderUseTime(OrderResponse order) {
  if (order.finallyTime.trim().isNotEmpty) return order.finallyTime;
  if (order.appointmentTime.trim().isNotEmpty) return order.appointmentTime;
  return order.createTime;
}

String _fullAddress(OrderResponse order) {
  return [
    order.province,
    order.city,
    order.area,
    order.address,
  ].where((item) => item.trim().isNotEmpty).join('');
}

String _userText(OrderResponse item) {
  final name = item.nickName.trim();
  final name1 = item.contactName.trim();

  if (name.isEmpty && name1.isEmpty) return '';
  if (name.isEmpty) return name1;
  if (name1.isEmpty) return name;
  return '$name（$name1）';
}

String _statusText(BuildContext context, int status) {
  return switch (status) {
    1 => context.l10n.used,
    2 => context.l10n.cancelled,
    _ => context.l10n.pendingUse,
  };
}

OrderResponse? _parseOrderArgument(dynamic arguments) {
  if (arguments is OrderResponse) return arguments;
  if (arguments is Map && arguments['order'] is OrderResponse) {
    return arguments['order'] as OrderResponse;
  }
  return null;
}

Future<void> _callPhone(BuildContext context, String phone) async {
  final value = phone
      .trim()
      .replaceAll(' ', '')
      .replaceAll('-', '')
      .replaceAll('－', '');

  if (value.isEmpty) {
    ToastUtils.showToast(
      message: context.l10n.contactNotProvided,
      type: ToastType.error,
    );
    return;
  }

  final uri = Uri(scheme: 'tel', path: value);

  final success = await launchUrl(uri, mode: LaunchMode.externalApplication);

  if (!success) {
    ToastUtils.showToast(
      message: context.l10n.contactNotProvided,
      type: ToastType.error,
    );
  }
}

Future<void> _copyText(BuildContext context, String text) async {
  final value = text.trim();

  if (value.isEmpty) {
    ToastUtils.showToast(
      message: context.l10n.noCopyContent,
      type: ToastType.error,
    );
    return;
  }

  await Clipboard.setData(ClipboardData(text: value));

  ToastUtils.showToast(
    message: context.l10n.copySuccess,
    type: ToastType.success,
  );
}
