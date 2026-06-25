import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/activity/pages/activity_controller.dart';
import 'package:alumni_association_app/features/activity/pages/activity_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ActivityDetailPage extends StatelessWidget {
  const ActivityDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ActivityController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.activityDetails,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),),
        centerTitle: true,
        actions: [
          Obx(
            () => IconButton(
              onPressed: controller.toggleFavorite,
              icon: Icon(
                controller.isFavorite.value
                    ? Icons.star_rounded
                    : Icons.star_border_rounded,
                color: controller.isFavorite.value
                    ? AppColors.warning
                    : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        final activity = controller.selectedActivity;
        return ListView(
          padding: EdgeInsets.fromLTRB(14.w, 6.h, 14.w, 110.h),
          children: [
            Stack(
              children: [
                ActivityVisual(
                  activity: activity,
                  width: MediaQuery.of(context).size.width,
                  height: 238.h,
                  showText: true,
                ),
                Positioned(
                  left: 18.w,
                  bottom: 20.h,
                  child: SizedBox(
                    width: 270.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _HeroInfo(
                          icon: Icons.calendar_month_outlined,
                          text:
                              '${activity.date} ${activity.timeRange.split('-').first}',
                        ),
                        _HeroInfo(
                          icon: Icons.location_on_outlined,
                          text: '${activity.location}\n${activity.address}',
                        ),
                        _HeroInfo(
                          icon: Icons.people_outline_rounded,
                          text: context.l10n.registeredPeople(
                            activity.registeredCount,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            _DetailCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _Metric(
                    icon: Icons.schedule_rounded,
                    title: context.l10n.activityTime,
                    value: '${activity.date}\n${activity.timeRange}',
                  ),
                  _Metric(
                    icon: Icons.location_on_outlined,
                    title: context.l10n.activityLocation,
                    value: activity.address,
                  ),
                  _Metric(
                    icon: Icons.groups_outlined,
                    title: context.l10n.activityScale,
                    value: context.l10n.limitedPeople(activity.capacity),
                  ),
                  _Metric(
                    icon: Icons.currency_yen_rounded,
                    title: context.l10n.activityFee,
                    value: activity.isFree
                        ? context.l10n.free
                        : context.l10n.paid,
                  ),
                ],
              ),
            ),
            SizedBox(height: 14.h),
            _DetailCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Title(context.l10n.activityIntroduction),
                  SizedBox(height: 8.h),
                  Text(
                    context.l10n.activityIntroductionText,
                    maxLines: controller.isDescriptionExpanded.value ? null : 4,
                    overflow: controller.isDescriptionExpanded.value
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                    style: TextStyle(height: 1.7, fontSize: 12.sp),
                  ),
                  Center(
                    child: TextButton.icon(
                      onPressed: controller.toggleDescription,
                      label: Text(
                        controller.isDescriptionExpanded.value
                            ? context.l10n.collapse
                            : context.l10n.expandAll,
                      ),
                      icon: Icon(
                        controller.isDescriptionExpanded.value
                            ? Icons.expand_less_rounded
                            : Icons.expand_more_rounded,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 14.h),
            _DetailCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Title(context.l10n.activityHighlights),
                  SizedBox(height: 14.h),
                  Row(
                    children: [
                      Expanded(
                        child: _Highlight(
                          icon: Icons.stars_rounded,
                          title: context.l10n.topicSharing,
                        ),
                      ),
                      Expanded(
                        child: _Highlight(
                          icon: Icons.handshake_rounded,
                          title: context.l10n.resourceMatching,
                        ),
                      ),
                      Expanded(
                        child: _Highlight(
                          icon: Icons.groups_rounded,
                          title: context.l10n.alumniNetworking,
                        ),
                      ),
                      Expanded(
                        child: _Highlight(
                          icon: Icons.card_giftcard_rounded,
                          title: context.l10n.specialGifts,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 14.h),
            _DetailCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Title(context.l10n.registrationNotice),
                  SizedBox(height: 8.h),
                  Text(context.l10n.registrationNoticeText),
                ],
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(18.w, 8.h, 18.w, 12.h),
          child: Row(
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.support_agent_rounded),
                label: Text(context.l10n.contactService),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Obx(() {
                  final registered = controller.isRegistered(
                    controller.selectedActivity.id,
                  );
                  return FilledButton(
                    onPressed: controller.toggleRegistration,
                    child: Text(
                      registered
                          ? context.l10n.cancelRegistration
                          : context.l10n.registerNow,
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroInfo extends StatelessWidget {
  const _HeroInfo({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 15.sp),
          SizedBox(width: 6.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: 11.sp),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: activityCardDecoration,
      child: child,
    );
  }
}

class _Title extends StatelessWidget {
  const _Title(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w700),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.icon, required this.title, required this.value});
  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 76.w,
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 27.sp),
          SizedBox(height: 6.h),
          Text(title, textAlign: TextAlign.center),
          Text(
            value,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 9.sp, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _Highlight extends StatelessWidget {
  const _Highlight({required this.icon, required this.title});
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 29.sp),
        SizedBox(height: 6.h),
        Text(
          title,
          maxLines: 2,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 10.sp),
        ),
      ],
    );
  }
}
