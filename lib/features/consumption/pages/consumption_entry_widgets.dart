import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/store/model/response/store_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 消费入单页面通用的卡片装饰样式。
///
/// 统一处理白色背景、圆角和浅色阴影，避免每个卡片重复写样式。
BoxDecoration get consumptionCardDecoration => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(16.r),
  boxShadow: [
    BoxShadow(
      color: const Color(0xFF245CA6).withValues(alpha: 0.05),
      blurRadius: 18,
      offset: const Offset(0, 6),
    ),
  ],
);



/// 商家视觉展示组件。
///
/// 当前用商家的主题渐变色和店铺图标做占位展示。
/// 后续如果接口返回商家封面图，可以在这里统一替换成网络图片。
class ConsumptionMerchantVisual extends StatelessWidget {
  const ConsumptionMerchantVisual({
    required this.merchant,
    this.width,
    this.height,
    super.key,
  });

  /// 商家数据，主要用于读取商家的主题色等展示信息。
  final StoreResponse merchant;

  /// 组件宽度，不传时由父组件约束决定。
  final double? width;

  /// 组件高度，不传时由父组件约束决定。
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(Icons.storefront_rounded, color: Colors.white, size: 34.sp),
    );
  }
}

/// 已选择商家的信息卡片。
///
/// 用在消费入单流程中，展示当前选中的商家名称、分类、距离等信息。
/// 如果传入 [onReselect]，右侧会显示“重新选择”按钮。
class SelectedMerchantCard extends StatelessWidget {
  const SelectedMerchantCard({
    required this.merchant,
    this.onReselect,
    super.key,
  });

  /// 当前已选中的商家信息。
  final StoreResponse merchant;

  /// 重新选择商家的点击回调。
  ///
  /// 为 null 时不显示“重新选择”按钮。
  final VoidCallback? onReselect;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: consumptionCardDecoration,
      child: Row(
        children: [
          ConsumptionMerchantVisual(
            merchant: merchant,
            width: 74.r,
            height: 74.r,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  merchant.names,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(merchant.typeName, style: consumptionSecondaryText),
              ],
            ),
          ),
          if (onReselect != null)
            TextButton(
              onPressed: onReselect,
              child: Text(context.l10n.reselect),
            ),
        ],
      ),
    );
  }
}

/// 消费入单页面通用的辅助文字样式。
///
/// 适用于商家分类、距离、说明文字等弱提示信息。
TextStyle get consumptionSecondaryText =>
    TextStyle(fontSize: 11.sp, color: AppColors.textSecondary);
