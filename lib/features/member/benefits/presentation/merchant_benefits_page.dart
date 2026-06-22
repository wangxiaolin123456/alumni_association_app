import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/member/benefits/model/response/merchant_benefit_response.dart';
import 'package:alumni_association_app/features/member/benefits/presentation/merchant_benefits_controller.dart';
import 'package:alumni_association_app/features/member/widgets/member_feature_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
/// 商家优惠
class MerchantBenefitsPage extends StatelessWidget {
  const MerchantBenefitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MerchantBenefitsController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.merchantBenefits,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),),
        centerTitle: true,
      ),
      body: Obx(() {
        final selectedCategory = controller.selectedCategory.value;
        final benefits = controller.filteredBenefits;
        final claimedIds = controller.claimedIds.toSet();
        return ListView(
          padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 24.h),
          children: [
            TextField(
              controller: controller.searchController,
              onChanged: (value) => controller.keyword.value = value,
              decoration: InputDecoration(
                hintText: context.l10n.benefitSearchHint,
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: IconButton(
                  // 点击筛选按钮时循环切换分类，便于在演示数据中直接查看筛选效果。
                  onPressed: () => controller.selectedCategory.value =
                      (selectedCategory + 1) % 4,
                  icon: const Icon(Icons.filter_alt_outlined),
                ),
              ),
            ),
            SizedBox(height: 14.h),
            _BenefitBanner(),
            SizedBox(height: 8.h),
            MemberFeatureTabs(
              labels: [
                context.l10n.all,
                context.l10n.food,
                context.l10n.shopping,
                context.l10n.lifeServices,
              ],
              selectedIndex: selectedCategory,
              onSelected: (index) => controller.selectedCategory.value = index,
            ),
            SizedBox(height: 10.h),
            ...benefits.map(
              (benefit) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: _BenefitCard(
                  benefit: benefit,
                  claimed: claimedIds.contains(benefit.id),
                  onClaim: () => controller.claim(benefit.id),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _BenefitBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104.h,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF064AD9), Color(0xFF1687E8)],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  context.l10n.memberExclusiveBenefits,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  context.l10n.benefitsNeverStop,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          Icon(Icons.redeem_rounded, color: Colors.white70, size: 66.sp),
        ],
      ),
    );
  }
}

class _BenefitCard extends StatelessWidget {
  const _BenefitCard({
    required this.benefit,
    required this.claimed,
    required this.onClaim,
  });
  final MerchantBenefitResponse benefit;
  final bool claimed;
  final VoidCallback onClaim;

  @override
  Widget build(BuildContext context) {
    final accent = Color(benefit.accentColor);
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: memberFeatureCardDecoration,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 86.w,
            height: 112.h,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(Icons.storefront_rounded, color: accent, size: 42.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  benefit.merchantName,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${benefit.address}  ${benefit.distance}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                ...benefit.offers.map(
                  (offer) => Padding(
                    padding: EdgeInsets.only(bottom: 6.h),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: accent.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          child: Icon(
                            Icons.local_offer_outlined,
                            color: accent,
                            size: 13.sp,
                          ),
                        ),
                        SizedBox(width: 7.w),
                        Expanded(child: Text(offer)),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton(
                    onPressed: claimed ? null : onClaim,
                    child: Text(
                      claimed ? context.l10n.claimed : context.l10n.claimNow,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
