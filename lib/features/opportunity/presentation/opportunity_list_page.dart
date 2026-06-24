import 'package:alumni_association_app/app/router/app_router.dart';
import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/core/widgets/pagination_footer.dart';
import 'package:alumni_association_app/features/opportunity/model/response/opportunity_response.dart';
import 'package:alumni_association_app/features/opportunity/presentation/opportunity_controller.dart';
import 'package:alumni_association_app/features/opportunity/presentation/opportunity_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


///商机管理
class OpportunityListPage extends StatelessWidget {
  const OpportunityListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OpportunityController>();
    final categories = [
      context.l10n.allOpportunities,
      context.l10n.cooperationNeeds,
      context.l10n.resourceConnection,
      context.l10n.investmentFinancing,
      context.l10n.franchiseRecruitment,
    ];

    return Stack(
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollUpdateNotification &&
                notification.dragDetails != null &&
                notification.metrics.pixels > 0 &&
                notification.metrics.extentAfter < 120) {
              controller.loadMoreOpportunities();
            }
            return false;
          },
          child: RefreshIndicator(
            onRefresh: controller.refreshOpportunities,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(14.w, 18.h, 14.w, 88.h),
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

                Obx(() {
                  final opportunities = controller.visibleOpportunities;
                  final loading = controller.isLoadingMore.value;
                  return Column(
                    children: [
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: opportunities.length,
                        separatorBuilder: (_, _) => SizedBox(height: 10.h),
                        itemBuilder: (_, index) => _OpportunityItem(
                          opportunity: opportunities[index],
                          onTap: () {
                            controller.selectOpportunity(opportunities[index]);
                            Get.toNamed(Pages.opportunityDetail);
                          },
                        ),
                      ),
                      PaginationFooter(
                        loading: loading,
                        hasMore: controller.hasMoreOpportunities,
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
        Positioned(
          right: 14.w,
          bottom: 10.h,
          child: GestureDetector(
            onTap: () {
              Get.toNamed(Pages.opportunityPublish);
            },

            child: Stack(
              children: [
                Image.asset("assets/publishbusiness.png", height: 70.h),
                Positioned(
                  left: 60.w,
                  top: 19.h,
                  child: Text(
                    context.l10n.publishOpportunity,
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
}

class _OpportunityItem extends StatelessWidget {
  const _OpportunityItem({required this.opportunity, required this.onTap});

  final OpportunityResponse opportunity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: opportunityCardDecoration,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OpportunityVisual(opportunity: opportunity),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5.w,
                          vertical: 2.h,
                        ),
                        color: const Color(0xFFEDF4FF),
                        child: Text(
                          _categoryLabel(context, opportunity.category),
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 9.sp,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        context.l10n.hoursAgo(2),
                        style: opportunitySecondaryText,
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    opportunity.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    opportunity.summary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: opportunitySecondaryText,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '${opportunity.industry}   |   ${opportunity.region}',
                    style: opportunitySecondaryText,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _categoryLabel(BuildContext context, String category) =>
    switch (category) {
      'cooperation' => context.l10n.cooperationNeeds,
      'resource' => context.l10n.resourceConnection,
      'investment' => context.l10n.investmentFinancing,
      'franchise' => context.l10n.franchiseRecruitment,
      _ => context.l10n.allOpportunities,
    };
