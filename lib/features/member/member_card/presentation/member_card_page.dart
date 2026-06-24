import 'package:alumni_association_app/app/router/app_router.dart';
import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/member/member_card/presentation/member_card_controller.dart';
import 'package:alumni_association_app/features/member/widgets/member_feature_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

///电子会员卡
class MemberCardPage extends StatelessWidget {
  const MemberCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MemberCardController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.electronicMemberCard,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 28.h),
        children: [
          _DigitalCard(),
          SizedBox(height: 14.h),
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: memberFeatureCardDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.memberBarcode,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 12.h),
                InkWell(
                  // 条形码与二维码共用刷新计数，点击后生成新的动态会员码。
                  onTap: controller.refreshQr,
                  child: SizedBox(
                    height: 42.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        42,
                        (index) => Container(
                          width: index.isEven ? 3.w : 1.w,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    context.l10n.tapBarcodeToRefresh,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: memberFeatureCardDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.memberLevel,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  '2680',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 25.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const LinearProgressIndicator(value: 0.65),
              ],
            ),
          ),
          SizedBox(height: 14.h),
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: memberFeatureCardDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.memberBenefits,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _Right(
                      icon: Icons.badge_outlined,
                      label: context.l10n.identityMark,
                    ),
                    _Right(
                      icon: Icons.local_offer_outlined,
                      label: context.l10n.merchantBenefits,
                    ),
                    _Right(
                      icon: Icons.event_available_rounded,
                      label: context.l10n.activityPriority,
                    ),
                    _Right(
                      icon: Icons.volunteer_activism_outlined,
                      label: context.l10n.serviceSupport,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: memberFeatureCardDecoration,
            child: Text(
              context.l10n.memberCardRules,
              style: const TextStyle(height: 1.8),
            ),
          ),
          SizedBox(height: 20.h),
          FilledButton(
            onPressed: () => Get.toNamed(Pages.memberQr),
            child: Text(context.l10n.showMemberQr),
          ),
        ],
      ),
    );
  }
}

class _DigitalCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 188.h,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF081C40), Color(0xFF173B72)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  context.l10n.alumniElectronicCard,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Chip(label: Text(context.l10n.verified)),
            ],
          ),
          SizedBox(height: 14.h),
          Text(
            context.l10n.alumniMember,
            style: TextStyle(
              color: const Color(0xFFFFE29C),
              fontSize: 23.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${context.l10n.memberIdLabel}\nXYH20240001',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              Text(
                '${context.l10n.validUntil}\n2026-06-12',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Right extends StatelessWidget {
  const _Right({required this.icon, required this.label});
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72.w,
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 30.sp),
          SizedBox(height: 7.h),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10.sp),
          ),
        ],
      ),
    );
  }
}
