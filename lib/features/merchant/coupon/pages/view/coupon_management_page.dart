import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/merchant/coupon/pages/controller/coupon_management_controller.dart';
import 'package:alumni_association_app/features/store/model/response/store_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// 优惠券管理页面。
class CouponManagementPage extends StatelessWidget {
  const CouponManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CouponManagementController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: Get.back,
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20.sp,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        title: Text(
          context.l10n.couponManage,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: FilledButton.icon(
              onPressed: controller.addCoupon,
              icon: Icon(Icons.add_rounded, size: 20.sp),
              label: Text(context.l10n.addCouponButton,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w900,
                ),),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                minimumSize: Size(0, 38.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _HeaderTools(controller: controller),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.coupons.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.coupons.isEmpty) {
                return Center(
                  child: Text(
                    context.l10n.noCouponData,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14.sp,
                    ),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.fetchCoupons,
                child: ListView.separated(
                  padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 28.h),
                  itemCount: controller.coupons.length + 1,
                  separatorBuilder: (_, index) => SizedBox(
                    height: index == controller.coupons.length - 1
                        ? 18.h
                        : 12.h,
                  ),
                  itemBuilder: (context, index) {
                    if (index == controller.coupons.length) {
                      return Center(
                        child: Text(
                          context.l10n.noMoreData,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13.sp,
                          ),
                        ),
                      );
                    }

                    return _CouponCard(
                      coupon: controller.coupons[index],
                      onEdit: () =>
                          controller.editCoupon(controller.coupons[index]),
                      onDisable: () =>
                          controller.disableCoupon(controller.coupons[index]),
                      onEnable: () =>
                          controller.enableCoupon(controller.coupons[index]),
                      onDelete: () =>
                          controller.deleteCoupon(controller.coupons[index]),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _HeaderTools extends StatelessWidget {
  const _HeaderTools({required this.controller});

  final CouponManagementController controller;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      context.l10n.all,
      context.l10n.couponTabActive,
      context.l10n.couponTabDisabled,
      context.l10n.couponTabExpired,
    ];

    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 0),
      child: Column(
        children: [
          Container(
            height: 42.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F5FA),
              borderRadius: BorderRadius.circular(23.r),
            ),
            child: TextField(
              controller: controller.searchController,
              onChanged: controller.onSearchChanged,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: context.l10n.searchCouponName,
                hintStyle: TextStyle(
                  color: const Color(0xFF9AA8BD),
                  fontSize: 14.sp,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  size: 20.sp,
                  color: const Color(0xFF7E8DA3),
                ),
                filled: true,
                fillColor: AppColors.searchBox,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: const BorderSide(
                    color: Color(0xFF4F8CFF),
                    width: 1.2,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 14.h),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(tabs.length, (index) {
                final selected = controller.selectedTabIndex.value == index;
                return GestureDetector(
                  onTap: () => controller.selectTab(index),
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(
                    width: 74.w,
                    child: Column(
                      children: [
                        Text(
                          tabs[index],
                          style: TextStyle(
                            color: selected
                                ? AppColors.primary
                                : AppColors.textSecondary,
                            fontSize: 14.sp,
                            fontWeight: selected
                                ? FontWeight.w900
                                : FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: selected ? 35.w : 0,
                          height: 3.h,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(99.r),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }
}

class _CouponCard extends StatelessWidget {
  const _CouponCard({
    required this.coupon,
    required this.onEdit,
    required this.onDisable,
    required this.onEnable,
    required this.onDelete,
  });

  final StoreCouponResponse coupon;
  final VoidCallback onEdit;
  final VoidCallback onDisable;
  final VoidCallback onEnable;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final status = _CouponUiStatus.fromCoupon(coupon);
    final canDisable = status == _CouponUiStatus.active;
    final canEnable = status == _CouponUiStatus.disabled;
    final canEditOnly = status == _CouponUiStatus.expired;

    return Container(
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1D5CA8).withValues(alpha: 0.06),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TicketFace(coupon: coupon, status: status),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            coupon.displayTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        _StatusBadge(status: status),
                      ],
                    ),
                    SizedBox(height: 9.h),
                    _TypeBadge(coupon: coupon),
                    SizedBox(height: 8.h),
                    Text(
                      '${context.l10n.validPeriodLabel}: ${_dateText(coupon.startTime)} ~ ${_dateText(coupon.endTime)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _metaStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Divider(color: const Color(0xFFEAF0F7), height: 1.h),
          ),
          Row(
            children: [
              const Spacer(),

              _OutlineAction(
                text: context.l10n.edit,
                color: AppColors.primary,
                onTap: onEdit,
              ),

              if (!canEditOnly) ...[
                SizedBox(width: 10.w),

                if (canDisable)
                  _OutlineAction(
                    text: context.l10n.disableCoupon,
                    color: AppColors.danger,
                    onTap: onDisable,
                  )
                else if (canEnable)
                  _OutlineAction(
                    text: context.l10n.enableCoupon,
                    color: AppColors.primary,
                    onTap: onEnable,
                  ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _TicketFace extends StatelessWidget {
  const _TicketFace({required this.coupon, required this.status});

  final StoreCouponResponse coupon;
  final _CouponUiStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = _ticketColors(coupon, status);

    return Container(
      width: 88.w,
      height: 88.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _ticketMainText(coupon),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            _ticketSubText(coupon),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final _CouponUiStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      _CouponUiStatus.active => AppColors.success,
      _CouponUiStatus.disabled => AppColors.textSecondary,
      _CouponUiStatus.expired => const Color(0xFFFF6B22),
    };
    final text = switch (status) {
      _CouponUiStatus.active => context.l10n.couponTabActive,
      _CouponUiStatus.disabled => context.l10n.couponTabDisabled,
      _CouponUiStatus.expired => context.l10n.couponTabExpired,
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7.w,
          height: 7.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 5.w),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 13.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}


Color _couponTypeColor(int type) {
  switch (type) {
    case 0:
    /// 固定金额 / 立减券
      return const Color(0xFFFF6B22);
    case 1:
    /// 折扣券 / 百分比折扣
      return AppColors.primary;
    case 2:
    /// 满减券 / 条件优惠
      return const Color(0xFF12B76A);
    default:
      return const Color(0xFF667085);
  }
}


class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.coupon});
  final StoreCouponResponse coupon;

  @override
  Widget build(BuildContext context) {
    final color = _couponTypeColor(coupon.type);
    final text = switch (coupon.type) {
      1 => context.l10n.couponTypePercentageShort,
      2 => context.l10n.couponTypeConditionalShort,
      _ => context.l10n.couponTypeFixedAmountShort,
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(99.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11.sp,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _OutlineAction extends StatelessWidget {
  const _OutlineAction({
    required this.text,
    required this.color,
    required this.onTap,
  });

  final String text;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(7.r),
      child: Container(
        height: 34.h,
        padding: EdgeInsets.symmetric(horizontal: 17.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(7.r),
          border: Border.all(color: color.withValues(alpha: 0.82)),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 13.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

enum _CouponUiStatus {
  active,
  disabled,
  expired;

  static _CouponUiStatus fromCoupon(StoreCouponResponse coupon) {
    /// disableStatus == 1：早期終了 / 禁用
    if (coupon.disableStatus == 1) {
      return _CouponUiStatus.disabled;
    }

    /// isLose == 0：発行中 / 进行中
    if (coupon.isLose == 0) {
      return _CouponUiStatus.active;
    }

    /// 其他：期限切れ / 已过期
    return _CouponUiStatus.expired;
  }
}

TextStyle get _metaStyle => TextStyle(
  color: AppColors.textSecondary,
  fontSize: 13.sp,
  fontWeight: FontWeight.w500,
);

List<Color> _ticketColors(StoreCouponResponse coupon, _CouponUiStatus status) {
  if (status == _CouponUiStatus.expired) {
    return const [Color(0xFFFFA044), Color(0xFFFF6A1A)];
  }
  if (status == _CouponUiStatus.disabled) {
    return const [Color(0xFF8E5CFF), Color(0xFF6E42E8)];
  }
  if (coupon.type == 2) {
    return const [Color(0xFF3E8BFF), Color(0xFF1262F4)];
  }
  return const [Color(0xFFFF655A), Color(0xFFFF3D2E)];
}
// type 优惠券类型 0-固定金额 1-百分比 2-满减
String _ticketMainText(StoreCouponResponse coupon) {
  if (coupon.type == 1) return '${_formatAmount(coupon.value)}折';
  return '¥${_formatAmount(coupon.value)}';
}

String _ticketSubText(StoreCouponResponse coupon) {
  if (coupon.type == 2 && coupon.maxDiscountAmount > 0 && coupon.minOrderAmount > 0) {
    return '满${_formatAmount(coupon.maxDiscountAmount)}减${_formatAmount(coupon.minOrderAmount)}';
  }
  if (coupon.type == 0) {
    return '立减${_formatAmount(coupon.value)}元';
  }
  if (coupon.type == 1) {
    return '优惠${_formatAmount(coupon.value)}%';
  }
  return '会员专享';
}

String _dateText(String value) {
  final text = value.trim();
  if (text.length >= 10) {
    return text.substring(0, 10).replaceAll('-', '.');
  }
  return text.isEmpty ? '--' : text;
}

String _formatAmount(double value) {
  if (value % 1 == 0) return value.toInt().toString();
  return value.toStringAsFixed(1);
}
