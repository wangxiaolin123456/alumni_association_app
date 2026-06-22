import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

BoxDecoration get memberFeatureCardDecoration => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(16.r),
  boxShadow: [
    BoxShadow(
      color: const Color(0xFF1E5AA8).withValues(alpha: 0.05),
      blurRadius: 18,
      offset: const Offset(0, 6),
    ),
  ],
);

class MemberFeatureTabs extends StatelessWidget {
  const MemberFeatureTabs({
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: labels.asMap().entries.map((entry) {
        final selected = selectedIndex == entry.key;
        return Expanded(
          child: InkWell(
            onTap: () => onSelected(entry.key),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Column(
                children: [
                  Text(
                    entry.value,
                    style: TextStyle(
                      color: selected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 7.h),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: selected ? 28.w : 0,
                    height: 3.h,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
