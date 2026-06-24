import 'package:alumni_association_app/app/router/app_router.dart';
import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/auth/domain/session_controller.dart';
import 'package:alumni_association_app/features/consumption/presentation/consumption_entry_controller.dart';
import 'package:alumni_association_app/features/member/model/response/popular_activity_response.dart';
import 'package:alumni_association_app/features/member/model/response/recommended_merchant_response.dart';
import 'package:alumni_association_app/features/member/presentation/member_home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';



class MemberDashboardPage extends StatelessWidget {
  const MemberDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MemberHomeController>();

    return ListView(
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 28.h),
      children: [
        _MemberHeader(
          onSearch: () => Get.toNamed(Pages.memberSearch),
          onMessages: () => Get.toNamed(Pages.memberMessages),
        ),
        SizedBox(height: 14.h),
        _MemberHeroBanner(controller: controller),
        SizedBox(height: 14.h),
        const _MemberQuickActions(),
        SizedBox(height: 14.h),
        _RecommendedMerchantSection(merchants: controller.merchants),
        SizedBox(height: 14.h),
        _PopularActivitySection(activities: controller.activities),
      ],
    );
  }
}

/// 头布局
class _MemberHeader extends StatelessWidget {
  const _MemberHeader({required this.onSearch, required this.onMessages});

  final VoidCallback onSearch;
  final VoidCallback onMessages;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      children: [
        Container(
          width: 42.r,
          height: 42.r,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.hub_rounded, color: Colors.white, size: 25.sp),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(24.r),
            onTap: onSearch,
            child: Container(
              height: 43.h,
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search_rounded,
                    color: AppColors.textSecondary,
                    size: 21.sp,
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      l10n.searchHint,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // SizedBox(width: 4.w),
        Badge(
          label: const Text('3'),
          child: IconButton(
            onPressed: onMessages,
            icon: Icon(
              Icons.notifications_none_rounded,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

class _MemberHeroBanner extends StatelessWidget {
  const _MemberHeroBanner({required this.controller});

  final MemberHomeController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160.h,
      child: Stack(
        children: [
          PageView.builder(
            controller: controller.bannerPageController,
            itemCount: controller.banners.length,
            onPageChanged: controller.selectBanner,
            itemBuilder: (context, index) {
              final banner = controller.banners[index];
              return Container(
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18.r),
                  gradient: LinearGradient(
                    colors: banner.gradientColors.map(Color.new).toList(),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -12.w,
                      bottom: -20.h,
                      child: Icon(
                        IconData(banner.iconCode, fontFamily: 'MaterialIcons'),
                        color: Colors.white.withValues(alpha: 0.22),
                        size: 145.sp,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _bannerTitle(context, banner.titleCode),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19.sp,
                            fontWeight: FontWeight.w800,
                            height: 1.3,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          _bannerSubtitle(context, banner.subtitleCode),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 10.h,
            child: Obx(() {
              final selected = controller.currentBannerIndex.value;
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  controller.banners.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: selected == index ? 18.w : 6.r,
                    height: 6.r,
                    margin: EdgeInsets.symmetric(horizontal: 3.w),
                    decoration: BoxDecoration(
                      color: selected == index ? Colors.white : Colors.white54,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  String _bannerTitle(BuildContext context, String code) => switch (code) {
    'benefits' => context.l10n.bannerBenefitsTitle,
    'activities' => context.l10n.bannerActivitiesTitle,
    'opportunities' => context.l10n.bannerOpportunitiesTitle,
    _ => context.l10n.heroTitle,
  };

  String _bannerSubtitle(BuildContext context, String code) => switch (code) {
    'benefits' => context.l10n.bannerBenefitsSubtitle,
    'activities' => context.l10n.bannerActivitiesSubtitle,
    'opportunities' => context.l10n.bannerOpportunitiesSubtitle,
    _ => context.l10n.heroSubtitle,
  };
}

class _MemberQuickActions extends StatelessWidget {
  const _MemberQuickActions();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final actions = [
      (
        Icons.receipt_long_rounded,
        l10n.consumptionEntry,
        l10n.consumptionEntryDesc,
        const Color(0xFFFF4057),
        () => _openAfterLogin(context, () {
          Get.find<ConsumptionEntryController>().resetWorkflow();
          Get.toNamed(Pages.consumptionMerchant);
        }),
      ),
      (
        Icons.history_rounded,
        l10n.consumptionRecords,
        l10n.consumptionRecordsDesc,
        AppColors.success,
        () => _openAfterLogin(context, () => Get.toNamed(Pages.memberRecords)),
      ),
      (
        Icons.storefront_rounded,
        l10n.discountMerchants,
        l10n.discountMerchantsDesc,
        const Color(0xFFFFA51F),
        () =>
            _openAfterLogin(context, () => Get.toNamed(Pages.memberBenefits)),
      ),
      (
        Icons.badge_outlined,
        l10n.electronicMemberCard,
        l10n.memberBenefits,
        const Color(0xFF6856F5),
        () => _openAfterLogin(context, () => Get.toNamed(Pages.memberCard)),
      ),
    ];

    return Container(
      padding: EdgeInsets.fromLTRB(6.w, 14.h, 6.w, 2.h),
      decoration: _cardDecoration,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisExtent: 94.h,
        ),
        itemCount: actions.length,
        itemBuilder: (context, index) {
          final item = actions[index];
          return InkWell(
            onTap: item.$5,
            child: Column(
              children: [
                Container(
                  width: 47.r,
                  height: 47.r,
                  decoration: BoxDecoration(
                    color: item.$4,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(item.$1, color: Colors.white, size: 27.sp),
                ),
                SizedBox(height: 6.h),
                Text(
                  item.$2,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  item.$3,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 8.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// 首页核心功能需要登录后使用；未登录时先进入统一登录页。
  void _openAfterLogin(BuildContext context, VoidCallback action) {
    final session = Get.find<SessionController>();
    if (!session.isAuthenticated.value) {
      Get.toNamed(Pages.login);
      return;
    }
    action();
  }
}

class _RecommendedMerchantSection extends StatelessWidget {
  const _RecommendedMerchantSection({required this.merchants});

  final List<RecommendedMerchantResponse> merchants;

  @override
  Widget build(BuildContext context) {
    return _HomeSection(
      title: context.l10n.recommendedMerchants,
      child: SizedBox(
        height: 148.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: merchants.length,
          separatorBuilder: (context, index) => SizedBox(width: 10.w),
          itemBuilder: (context, index) =>
              _MerchantCard(merchant: merchants[index]),
        ),
      ),
    );
  }
}

class _MerchantCard extends StatelessWidget {
  const _MerchantCard({required this.merchant});

  final RecommendedMerchantResponse merchant;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 142.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFEDF1F7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 70.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(11.r)),
              gradient: LinearGradient(
                colors: _gradient(merchant.gradientColors),
              ),
            ),
            child: Center(
              child: Icon(
                _merchantIcon(merchant.visualType),
                color: Colors.white,
                size: 40.sp,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(7.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        merchant.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.verified_rounded,
                      color: AppColors.primary,
                      size: 15.sp,
                    ),
                  ],
                ),
                Text(merchant.location, maxLines: 1, style: _secondaryText),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        merchant.category,
                        maxLines: 1,
                        style: _secondaryText,
                      ),
                    ),
                    Text(merchant.distance, style: _secondaryText),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PopularActivitySection extends StatelessWidget {
  const _PopularActivitySection({required this.activities});

  final List<PopularActivityResponse> activities;

  @override
  Widget build(BuildContext context) {
    return _HomeSection(
      title: context.l10n.popularActivities,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: activities.length,
        separatorBuilder: (context, index) => SizedBox(height: 12.h),
        itemBuilder: (context, index) =>
            _ActivityCard(activity: activities[index]),
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({required this.activity});

  final PopularActivityResponse activity;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 130.w,
          height: 92.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _gradient(activity.gradientColors),
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Stack(
            children: [
              Positioned(
                right: 8.w,
                bottom: 8.h,
                child: Icon(
                  Icons.public_rounded,
                  color: Colors.white24,
                  size: 55.sp,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.r),
                child: Text(
                  context.l10n.registering,
                  style: TextStyle(color: Colors.white, fontSize: 11.sp),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                activity.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 7.h),
              _ActivityInfo(
                icon: Icons.calendar_month_outlined,
                text: activity.date,
              ),
              _ActivityInfo(
                icon: Icons.location_on_outlined,
                text: activity.location,
              ),
              _ActivityInfo(
                icon: Icons.people_outline_rounded,
                text: context.l10n.registeredPeople(activity.registeredCount),
              ),
            ],
          ),
        ),
        SizedBox(width: 5.w),
        FilledButton(
          onPressed: () {},
          style: FilledButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
          ),
          child: Text(
            context.l10n.registerNow,
            style: TextStyle(fontSize: 10.sp),
          ),
        ),
      ],
    );
  }
}

class _ActivityInfo extends StatelessWidget {
  const _ActivityInfo({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 3.h),
      child: Row(
        children: [
          Icon(icon, size: 13.sp, color: AppColors.textSecondary),
          SizedBox(width: 4.w),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeSection extends StatelessWidget {
  const _HomeSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                context.l10n.viewMore,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11.sp,
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary,
                size: 18.sp,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          child,
        ],
      ),
    );
  }
}

BoxDecoration get _cardDecoration => BoxDecoration(
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

TextStyle get _secondaryText =>
    TextStyle(fontSize: 9.sp, color: AppColors.textSecondary);

List<Color> _gradient(List<int> colors) => colors.map(Color.new).toList();

IconData _merchantIcon(String visualType) => switch (visualType) {
  'cafe' => Icons.local_cafe_rounded,
  'hotel' => Icons.apartment_rounded,
  'fitness' => Icons.fitness_center_rounded,
  'health' => Icons.health_and_safety_rounded,
  _ => Icons.storefront_rounded,
};
