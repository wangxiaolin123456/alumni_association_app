import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaginationFooter extends StatelessWidget {
  const PaginationFooter({
    required this.loading,
    required this.hasMore,
    super.key,
  });

  final bool loading;
  final bool hasMore;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18.h),
      child: Center(
        child: loading
            ? SizedBox(
                width: 20.r,
                height: 20.r,
                child: const CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(
                hasMore
                    ? context.l10n.pullUpToLoadMore
                    : context.l10n.noMoreData,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11.sp,
                ),
              ),
      ),
    );
  }
}
