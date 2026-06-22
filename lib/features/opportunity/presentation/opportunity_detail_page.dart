import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/opportunity/presentation/opportunity_controller.dart';
import 'package:alumni_association_app/features/opportunity/presentation/opportunity_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OpportunityDetailPage extends StatelessWidget {
  const OpportunityDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OpportunityController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.opportunityDetails,
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
                size: 26.sp,
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        final opportunity = controller.selectedOpportunity;
        return ListView(
          padding: EdgeInsets.fromLTRB(14.w, 6.h, 14.w, 110.h),
          children: [
            OpportunitySectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _Tag(text: context.l10n.cooperationNeeds),
                      const Spacer(),
                      _Tag(text: context.l10n.inProgress),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    opportunity.title,
                    style: TextStyle(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(opportunity.summary, style: opportunitySecondaryText),
                  Divider(height: 24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _Metric(
                        icon: Icons.schedule_rounded,
                        title: context.l10n.publishDate,
                        value: opportunity.publishedAt,
                      ),
                      _Metric(
                        icon: Icons.timer_outlined,
                        title: context.l10n.validUntil,
                        value: opportunity.expiresAt,
                      ),
                      _Metric(
                        icon: Icons.visibility_outlined,
                        title: context.l10n.views,
                        value: '${opportunity.views}',
                      ),
                      _Metric(
                        icon: Icons.star_border_rounded,
                        title: context.l10n.favorites,
                        value: '${opportunity.favorites}',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            OpportunitySectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Title(context.l10n.opportunityInfo),
                  _KeyValue(context.l10n.industry, opportunity.industry),
                  _KeyValue(
                    context.l10n.cooperationType,
                    context.l10n.supplyChainCooperation,
                  ),
                  _KeyValue(context.l10n.projectRegion, opportunity.region),
                  _KeyValue(context.l10n.budgetRange, opportunity.budget),
                  _KeyValue(
                    context.l10n.cooperationMethod,
                    context.l10n.longTermCooperation,
                  ),
                  _KeyValue(context.l10n.publisher, context.l10n.profileName),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            OpportunitySectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Title(context.l10n.opportunityDescription),
                  SizedBox(height: 8.h),
                  Text(
                    context.l10n.opportunityDescriptionText,
                    maxLines: controller.isDescriptionExpanded.value ? null : 6,
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
                      icon: const Icon(Icons.expand_more_rounded),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            OpportunitySectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Title(context.l10n.requirementList),
                  SizedBox(height: 10.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: opportunity.requirements
                        .map((item) => Chip(label: Text(item)))
                        .toList(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            OpportunitySectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Title(context.l10n.cooperationAdvantages),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: _Advantage(
                          icon: Icons.verified_user_outlined,
                          text: context.l10n.stableCooperation,
                        ),
                      ),
                      Expanded(
                        child: _Advantage(
                          icon: Icons.workspace_premium_outlined,
                          text: context.l10n.brandResources,
                        ),
                      ),
                      Expanded(
                        child: _Advantage(
                          icon: Icons.trending_up_rounded,
                          text: context.l10n.marketExpansion,
                        ),
                      ),
                      Expanded(
                        child: _Advantage(
                          icon: Icons.groups_outlined,
                          text: context.l10n.flexibleModel,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            OpportunitySectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Title(context.l10n.contactInfo),
                  _KeyValue(context.l10n.contact, context.l10n.profileName),
                  _KeyValue(context.l10n.phoneNumber, '138 **** 5678'),
                  _KeyValue(context.l10n.email, 'zhangsan@example.com'),
                  _KeyValue(context.l10n.contactAddress, '上海市浦东新区张江高科技园区88号'),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF5FF),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(context.l10n.opportunitySafetyTip),
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
                icon: const Icon(Icons.phone_outlined),
                label: Text(context.l10n.contactPublisher),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Obx(
                  () => FilledButton(
                    onPressed: controller.requestCooperation,
                    child: Text(
                      controller.cooperationRequested.value
                          ? context.l10n.intentSubmitted
                          : context.l10n.interestedInCooperation,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
    decoration: BoxDecoration(
      color: const Color(0xFFEDF4FF),
      borderRadius: BorderRadius.circular(5.r),
    ),
    child: Text(
      text,
      style: TextStyle(color: AppColors.primary, fontSize: 10.sp),
    ),
  );
}

class _Title extends StatelessWidget {
  const _Title(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
  );
}

class _Metric extends StatelessWidget {
  const _Metric({required this.icon, required this.title, required this.value});
  final IconData icon;
  final String title;
  final String value;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 72.w,
    child: Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 22.sp),
        Text(
          title,
          textAlign: TextAlign.center,
          style: opportunitySecondaryText,
        ),
        Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 10.sp),
        ),
      ],
    ),
  );
}

class _KeyValue extends StatelessWidget {
  const _KeyValue(this.label, this.value);
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(top: 12.h),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 82.w,
          child: Text(label, style: opportunitySecondaryText),
        ),
        Expanded(child: Text(value)),
      ],
    ),
  );
}

class _Advantage extends StatelessWidget {
  const _Advantage({required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Icon(icon, color: AppColors.primary, size: 25.sp),
      SizedBox(height: 5.h),
      Text(
        text,
        maxLines: 2,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 9.sp),
      ),
    ],
  );
}
