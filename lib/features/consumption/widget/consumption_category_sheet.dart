import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 显示消费入单商家分类选择弹窗。
///
/// [categories] 分类列表。
/// [selectedCategory] 当前选中的分类。
/// [onSelected] 点击分类后的回调。
void showConsumptionCategorySheet({
  required BuildContext context,
  required List<String> categories,
  required String selectedCategory,
  required ValueChanged<String> onSelected,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) {
      return ConsumptionCategorySheet(
        categories: categories,
        selectedCategory: selectedCategory,
        onSelected: onSelected,
      );
    },
  );
}

/// 消费入单分类选择底部弹窗。
class ConsumptionCategorySheet extends StatelessWidget {
  const ConsumptionCategorySheet({
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
    super.key,
  });

  /// 分类列表。
  final List<String> categories;

  /// 当前选中的分类。
  final String selectedCategory;

  /// 选择分类后的回调。
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24.r),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 顶部拖拽提示条。
            Container(
              width: 38.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFFD8E2F0),
                borderRadius: BorderRadius.circular(99.r),
              ),
            ),

            SizedBox(height: 18.h),

            // 标题和关闭按钮。
            Row(
              children: [
                Text(
                  context.l10n.selectCategory,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close_rounded,
                    size: 22.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),

            SizedBox(height: 8.h),

            // 分类标签区域。
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 10.w,
                runSpacing: 12.h,
                children: categories.map((category) {
                  final selected =
                      selectedCategory == category ||
                          (selectedCategory.isEmpty &&
                              category == context.l10n.allCategories);

                  return InkWell(
                    borderRadius: BorderRadius.circular(18.r),
                    onTap: () {
                      onSelected(category);
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 9.h,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.primary.withValues(alpha: 0.10)
                            : const Color(0xFFF5F7FB),
                        borderRadius: BorderRadius.circular(18.r),
                        border: Border.all(
                          color: selected
                              ? AppColors.primary
                              : const Color(0xFFE6ECF5),
                        ),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: selected
                              ? AppColors.primary
                              : AppColors.textPrimary,
                          fontWeight:
                          selected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}