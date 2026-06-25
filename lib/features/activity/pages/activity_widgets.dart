import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/features/activity/model/response/activity_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

List<Color> activityGradient(ActivityResponse activity) =>
    activity.accentColors.map(Color.new).toList();

BoxDecoration get activityCardDecoration => BoxDecoration(
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

class ActivityVisual extends StatelessWidget {
  const ActivityVisual({
    required this.activity,
    this.width,
    this.height,
    this.showText = false,
    super.key,
  });

  final ActivityResponse activity;
  final double? width;
  final double? height;
  final bool showText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: activityGradient(activity)),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -18.w,
            bottom: -12.h,
            child: Icon(
              Icons.location_city_rounded,
              color: Colors.white24,
              size: 118.sp,
            ),
          ),
          Positioned(
            right: 46.w,
            bottom: 20.h,
            child: Icon(
              Icons.groups_rounded,
              color: Colors.white70,
              size: 72.sp,
            ),
          ),
          if (showText)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  activity.subtitle,
                  style: TextStyle(color: Colors.white70, fontSize: 11.sp),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class ActivityInfoLine extends StatelessWidget {
  const ActivityInfoLine({required this.icon, required this.text, super.key});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5.h),
      child: Row(
        children: [
          Icon(icon, size: 14.sp, color: AppColors.textSecondary),
          SizedBox(width: 5.w),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
