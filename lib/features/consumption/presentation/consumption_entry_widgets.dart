import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/consumption/model/response/consumption_entry_response.dart';
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

/// 消费入单流程步骤指示器。
///
/// 当前流程一共分为 4 步：
/// 1. 选择商家
/// 2. 选择优惠券
/// 3. 输入消费金额
/// 4. 确认并提交
///
/// [currentStep] 表示当前所在步骤，从 1 开始。
class ConsumptionStepIndicator extends StatelessWidget {
  const ConsumptionStepIndicator({required this.currentStep, super.key});

  /// 当前所在步骤，从 1 开始。
  ///
  /// 小于当前步骤的节点显示完成状态，等于当前步骤的节点高亮显示。
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    final labels = [
      context.l10n.selectMerchant,
      context.l10n.selectCoupon,
      context.l10n.enterAmount,
      context.l10n.confirmSubmit,
    ];

    return Center(
      child: SizedBox(
        width: 340.w,
        height: 62.h,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final totalWidth = constraints.maxWidth;

            final circleSize = 35.r;
            final labelWidth = 74.w;
            final circleRadius = circleSize / 2;

            // 第一个圆和最后一个圆的中心点。
            final startX = circleRadius;
            final endX = totalWidth - circleRadius;

            // 4 个步骤之间的间距。
            final stepSpace = (endX - startX) / (labels.length - 1);

            return Stack(
              clipBehavior: Clip.none,
              children: [
                // 圆圈之间的横线。
                Positioned(
                  top: circleRadius - 0.5,
                  left: startX,
                  right: startX,
                  child: Row(
                    children: List.generate(labels.length - 1, (index) {
                      final lineCompleted = currentStep > index + 1;

                      return Expanded(
                        child: Container(
                          height: 1,
                          color: lineCompleted
                              ? AppColors.primary
                              : const Color(0xFFD5DCE8),
                        ),
                      );
                    }),
                  ),
                ),

                // 4 个圆圈。
                ...List.generate(labels.length, (index) {
                  final step = index + 1;
                  final active = currentStep == step;
                  final completed = currentStep > step;

                  final centerX = startX + stepSpace * index;

                  return Positioned(
                    left: centerX - circleRadius,
                    top: 0,
                    child: Container(
                      width: circleSize,
                      height: circleSize,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: active ? AppColors.primary : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: completed || active
                              ? AppColors.primary
                              : const Color(0xFFD5DCE8),
                          width: 1.5,
                        ),
                      ),
                      child: completed
                          ? Icon(
                        Icons.check_rounded,
                        color: AppColors.primary,
                        size: 21.sp,
                      )
                          : Text(
                        '$step',
                        style: TextStyle(
                          color: active
                              ? Colors.white
                              : AppColors.textSecondary,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  );
                }),

                // 4 个文字，和圆圈使用同一个 centerX，所以文字会正好在圆圈下面。
                ...List.generate(labels.length, (index) {
                  final step = index + 1;
                  final active = currentStep == step;

                  final centerX = startX + stepSpace * index;

                  return Positioned(
                    left: centerX - labelWidth / 2,
                    top: 43.h,
                    width: labelWidth,
                    child: Text(
                      labels[index],
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: active
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        fontWeight:
                        active ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }
}

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
  final ConsumptionMerchantResponse merchant;

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
        // 使用商家配置的强调色生成渐变背景，让不同商家有轻微区分。
        gradient: LinearGradient(
          colors: merchant.accentColors.map(Color.new).toList(),
        ),
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
  final ConsumptionMerchantResponse merchant;

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
                  merchant.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(merchant.category, style: consumptionSecondaryText),
                Text(merchant.distance, style: consumptionSecondaryText),
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
