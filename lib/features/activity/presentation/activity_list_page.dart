import 'package:alumni_association_app/app/router/app_router.dart';
import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/core/widgets/pagination_footer.dart';
import 'package:alumni_association_app/features/activity/model/response/activity_response.dart';
import 'package:alumni_association_app/features/activity/presentation/activity_controller.dart';
import 'package:alumni_association_app/features/activity/presentation/activity_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

///活动首页
class ActivityListPage extends StatelessWidget {
  const ActivityListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ActivityController>();
    final categories = [
      context.l10n.allActivities,
      context.l10n.alumniActivities,
      context.l10n.industryForums,
      context.l10n.trainingLectures,
      context.l10n.sportsEntertainment,
    ];

    return Stack(
      children: [

        NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollUpdateNotification &&
                notification.dragDetails != null &&
                notification.metrics.pixels > 0 &&
                notification.metrics.extentAfter < 120) {
              controller.loadMoreActivities();
            }
            return false;
          },
          child: RefreshIndicator(
            onRefresh: controller.refreshActivities,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(14.w, 18.h, 14.w, 24.h),
              children: [
                SizedBox(
                  height: 34.h,
                  child: Obx(() {
                    final selected = controller.selectedCategory.value;
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      separatorBuilder: (_, _) => SizedBox(width: 24.w),
                      itemBuilder: (_, index) => InkWell(
                        onTap: () => controller.selectCategory(index),
                        child: Column(
                          children: [
                            Text(
                              categories[index],
                              style: TextStyle(
                                color: selected == index
                                    ? AppColors.primary
                                    : AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (selected == index)
                              Container(
                                width: 28.w,
                                height: 2.h,
                                margin: EdgeInsets.only(top: 6.h),
                                color: AppColors.primary,
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: 8.h),
                InkWell(
                  onTap: () => _openDetail(context, controller.featuredActivity),
                  child: Stack(
                    children: [
                      ActivityVisual(
                        activity: controller.featuredActivity,
                        width: MediaQuery.of(context).size.width,
                        height: 162.h,
                        showText: true,
                      ),
                      Positioned(
                        left: 16.w,
                        bottom: 16.h,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${controller.featuredActivity.date} ${controller.featuredActivity.timeRange.split('-').first}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.sp,
                              ),
                            ),
                            Text(
                              controller.featuredActivity.location,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 15.w,
                        bottom: 14.h,
                        child: FilledButton(
                          onPressed: () =>
                              _openDetail(context, controller.featuredActivity),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primary,
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                          ),
                          child: Text(
                            context.l10n.registerNow,
                            style: TextStyle(fontSize: 10.sp),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 18.h),
                _SectionTitle(title: context.l10n.upcomingActivities),
                SizedBox(height: 8.h),
                Obx(() {
                  final activities = controller.visibleActivities
                      .where(
                        (activity) => activity.id != controller.featuredActivity.id,
                  )
                      .toList();
                  final loading = controller.isLoadingMore.value;
                  return Column(
                    children: [
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: activities.length,
                        separatorBuilder: (_, _) => SizedBox(height: 10.h),
                        itemBuilder: (_, index) => _ActivityListItem(
                          activity: activities[index],
                          onTap: () => _openDetail(context, activities[index]),
                        ),
                      ),
                      PaginationFooter(
                        loading: loading,
                        hasMore: controller.hasMoreActivities,
                      ),
                    ],
                  );
                }),
                SizedBox(height: 18.h),
                _SectionTitle(title: context.l10n.popularActivities),
                SizedBox(height: 8.h),
                _ActivityListItem(
                  activity: controller.activities.last,
                  onTap: () => _openDetail(context, controller.activities.last),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 14.w,
          bottom: 10.h,
          child: GestureDetector(
            onTap: () {
              context.push(Pages.opportunityPublish);
            },

            child: Stack(
              children: [
                Image.asset("assets/publishbusiness.png", height: 70.h),
                Positioned(
                  left: 60.w,
                  top: 19.h,
                  child: Text(
                    context.l10n.publishActivity,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _openDetail(BuildContext context, ActivityResponse activity) {
    Get.find<ActivityController>().selectActivity(activity);
    context.push(Pages.activityDetail);
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w700),
          ),
        ),
        Text(context.l10n.viewMore, style: TextStyle(fontSize: 11.sp)),
        Icon(Icons.chevron_right_rounded, size: 18.sp),
      ],
    );
  }
}

class _ActivityListItem extends StatelessWidget {
  const _ActivityListItem({required this.activity, required this.onTap});
  final ActivityResponse activity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(10.r),
        decoration: activityCardDecoration,
        child: Row(
          children: [
            ActivityVisual(activity: activity, width: 112.w, height: 76.h),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  ActivityInfoLine(
                    icon: Icons.calendar_month_outlined,
                    text:
                        '${activity.date} ${activity.timeRange.split('-').first}',
                  ),
                  ActivityInfoLine(
                    icon: Icons.location_on_outlined,
                    text: activity.location,
                  ),
                ],
              ),
            ),
            SizedBox(width: 6.w),
            FilledButton(
              onPressed: onTap,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFFF6A1A),
                padding: EdgeInsets.symmetric(horizontal: 10.w),
              ),
              child: Text(
                context.l10n.registerNow,
                style: TextStyle(fontSize: 9.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
