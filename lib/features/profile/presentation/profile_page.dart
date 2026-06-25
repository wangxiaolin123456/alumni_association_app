import 'package:alumni_association_app/app/router/app_router.dart';
import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/auth/domain/session_controller.dart';
import 'package:alumni_association_app/features/auth/model/response/user_info_response.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

///我的首页
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Get.find<SessionController>();
    return Obx(() {
      if (!session.isAuthenticated.value) return const _GuestProfileView();
      final userInfo = session.userInfo.value;
      return _MemberMineView(

        userInfo: userInfo,

        isMerchant: userInfo?.merchant ?? session.isMerchant,

        onRefresh: () async {
          await SessionController.current.refreshUserInfo();
        },

      );
    });
  }
}

class _GuestProfileView extends StatelessWidget {
  const _GuestProfileView();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(18.w, 30.h, 18.w, 28.h),
      children: [
        _Card(
          child: Column(
            children: [
              CircleAvatar(
                radius: 38.r,
                backgroundColor: const Color(0xFFEAF2FF),
                child: Icon(
                  Icons.person_outline,
                  color: AppColors.primary,
                  size: 42.sp,
                ),
              ),
              SizedBox(height: 14.h),
              Text(
                context.l10n.notLoggedIn,
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 8.h),
              Text(
                context.l10n.loginToViewProfileHint,
                textAlign: TextAlign.center,
                style: _hintStyle,
              ),
              SizedBox(height: 18.h),
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: FilledButton(
                  onPressed: () => Get.toNamed(Pages.login),
                  child: Text(context.l10n.goLoginRegister),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MemberMineView extends StatelessWidget {
  const _MemberMineView({
    required this.userInfo,
    required this.isMerchant,
    required this.onRefresh,
  });

  final UserInfoResponse? userInfo;
  final bool isMerchant;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return _MineScaffold(
      onRefresh: onRefresh,
      header: _MineHeader(
        avatarIcon: Icons.apartment_rounded,
        roleTag: isMerchant ? l10n.merchant : l10n.campus,
        name:
        userInfo?.displayName ??
            (isMerchant ? l10n.merchantProfileName : l10n.profileName),
        badge: isMerchant ? l10n.verifiedMerchant : l10n.verified,
        subline: _profileSubline(
          defaultRole: isMerchant ? l10n.merchant : l10n.alumniMember,
          memberNumber: l10n.memberNumber,
          email: userInfo?.email ?? '',
          phone: userInfo?.phone ?? '',
        ),
        avatarUrl: userInfo?.avatar ?? '',
      ),
      children: [
        _MemberCard(),
        _GridSection(
          title: l10n.myOrdersRecords,
          items: [
            _ActionItem(
              Icons.assignment_add,
              l10n.myOrders,
                  () => Get.toNamed(Pages.myOrdersPage),
            ),
            _ActionItem(
              Icons.payments_rounded,
              l10n.registrationRecords,
                  () => Get.toNamed(Pages.memberRegistrationRecords),
              color: const Color(0xFFFF6B3D),
            ),
            _ActionItem(
              Icons.storefront_rounded,
              l10n.favoriteMerchants,
                  () => Get.toNamed(Pages.memberFavoriteMerchants),
              color: AppColors.success,
            ),
            _ActionItem(
              Icons.schedule_rounded,
              l10n.browsingRecords,
                  () => Get.toNamed(Pages.memberBrowsingRecords),
            ),
          ],
        ),
        _GridSection(
          title: l10n.myServices,
          items: [
            _ActionItem(
              Icons.verified_user_rounded,
              l10n.alumniCertification,
                  () => Get.toNamed(Pages.memberCertification),
            ),
            _ActionItem(
              Icons.business_center_rounded,
              l10n.opportunityManagement,
                  () => Get.toNamed(Pages.opportunityManagementPage),
            ),
            _ActionItem(
              Icons.event_available_rounded,
              l10n.activityManagement,
                  () => Get.toNamed(Pages.activityManagementPage),
            ),
            _ActionItem(
              Icons.confirmation_number_rounded,
              l10n.myCoupons,
                  () => Get.toNamed(Pages.myBenefits),
            ),
            _ActionItem(
              Icons.storefront_rounded,
              isMerchant ? l10n.myMerchant : l10n.merchantOnboarding,
                  () => Get.toNamed(Pages.merchantOnboardingPage),
              isNew: !isMerchant,
            ),
            _ActionItem(
              Icons.support_agent_rounded,
              l10n.helpCenter,
                  () => Get.toNamed(Pages.helpCenter),
            ),
            _ActionItem(
              Icons.chat_rounded,
              l10n.feedback,
                  () => Get.toNamed(Pages.feedback),
            ),
          ],
        ),
      ],
    );
  }
}

class _MineScaffold extends StatelessWidget {
  const _MineScaffold({
    required this.header,
    required this.children,
    required this.onRefresh,
  });

  final Widget header;
  final List<Widget> children;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      header: ClassicHeader(
        position: IndicatorPosition.above,
        dragText: '下拉刷新个人信息',
        armedText: '松开立即刷新',
        readyText: '正在刷新...',
        processingText: '正在刷新...',
        processedText: '刷新完成',
        noMoreText: '没有更多数据',
        failedText: '刷新失败',
        messageText: '最后更新于 %T',
        iconTheme: IconThemeData(
          color: AppColors.primary,
          size: 22.sp,
        ),
        textStyle: TextStyle(
          color: AppColors.primary,
          fontSize: 13.sp,
          fontWeight: FontWeight.w700,
        ),
        messageStyle: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 11.sp,
        ),
        spacing: 8.w,
      ),
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(18.w, 10.h, 18.w, 28.h),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () => Get.toNamed(Pages.settings),
                icon: Icon(Icons.settings_outlined, size: 28.sp),
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    onPressed: () => Get.toNamed(Pages.memberMessages),
                    icon: Icon(Icons.chat_bubble_outline_rounded, size: 27.sp),
                  ),
                  Positioned(
                    top: 5.h,
                    right: 8.w,
                    child: CircleAvatar(
                      radius: 4.r,
                      backgroundColor: AppColors.danger,
                    ),
                  ),
                ],
              ),
            ],
          ),
          header,
          SizedBox(height: 18.h),
          ...children.expand((child) => [child, SizedBox(height: 14.h)]),
        ],
      ),
    );
  }
}

class _MineHeader extends StatelessWidget {
  const _MineHeader({
    required this.avatarIcon,
    required this.roleTag,
    required this.name,
    required this.badge,
    required this.subline,
    this.avatarUrl = '',
  });

  final IconData avatarIcon;
  final String roleTag;
  final String name;
  final String badge;
  final String subline;
  final String avatarUrl;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(Pages.personalInfo),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 43.r,
                backgroundColor: const Color(0xFFE0ECFF),
                backgroundImage: avatarUrl.isEmpty
                    ? null
                    : NetworkImage(avatarUrl),
                child: avatarUrl.isEmpty
                    ? Icon(avatarIcon, color: AppColors.primary, size: 48.sp)
                    : null,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  roleTag,
                  style: TextStyle(color: Colors.white, fontSize: 11.sp),
                ),
              ),
            ],
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.verified_rounded,
                      color: AppColors.primary,
                      size: 20.sp,
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  subline,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _hintStyle,
                ),
                SizedBox(height: 6.h),
                _Tag(label: badge),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textSecondary,
            size: 30.sp,
          ),
        ],
      ),
    );
  }
}

String _profileSubline({
  required String defaultRole,
  required String memberNumber,
  required String email,
  required String phone,
}) {
  final contact = phone.isNotEmpty ? phone : email;
  if (contact.isEmpty) return '$defaultRole  |  $memberNumber';
  return '$defaultRole  |  $contact';
}

class _MemberCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _DarkCard(
      title: context.l10n.electronicMemberCard,
      subtitle: context.l10n.exclusiveBenefits,
      button: context.l10n.viewMemberCode,
      onTap: () => Get.toNamed(Pages.memberQr),
    );
  }
}

class _DarkCard extends StatelessWidget {
  const _DarkCard({
    required this.title,
    required this.subtitle,
    required this.button,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String button;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 116.h,
      padding: EdgeInsets.symmetric(horizontal: 22.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF102342), Color(0xFF081A34)],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                ),
              ],
            ),
          ),
          FilledButton.icon(
            onPressed: onTap,
            icon: const Icon(Icons.qr_code_2_rounded),
            label: Text(button, style: TextStyle(fontSize: 14.sp)),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFFFD37A),
              foregroundColor: const Color(0xFF151515),
            ),
          ),
        ],
      ),
    );
  }
}

class _GridSection extends StatelessWidget {
  const _GridSection({required this.title, required this.items});

  final String title;
  final List<_ActionItem> items;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: _sectionTitleStyle),
          SizedBox(height: 20.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisExtent: 70.h,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) => _ActionTile(item: items[index]),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.item});

  final _ActionItem item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(
            child: Column(
              children: [
                Icon(item.icon, color: item.color, size: 35.sp),
                SizedBox(height: 4.h),
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14.sp,color: AppColors.textPrimary,fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          if (item.isNew)
            Positioned(top: -4.h, right: 18.w, child: _NewBadge()),
        ],
      ),
    );
  }
}

class _ActionItem {
  _ActionItem(
    this.icon,
    this.title,
    this.onTap, {
    this.isNew = false,
    this.color = AppColors.primary,
  });
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isNew;
  final Color color;
}

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: _cardDecoration,
      child: child,
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE9D8),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        label,
        style: TextStyle(color: const Color(0xFFE26B21), fontSize: 12.sp),
      ),
    );
  }
}

class _NewBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppColors.danger,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        'NEW',
        style: TextStyle(color: Colors.white, fontSize: 8.sp),
      ),
    );
  }
}

BoxDecoration get _cardDecoration => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(18.r),
  boxShadow: [
    BoxShadow(
      color: const Color(0xFF1E5AA8).withValues(alpha: 0.06),
      blurRadius: 20,
      offset: const Offset(0, 6),
    ),
  ],
);

TextStyle get _sectionTitleStyle =>
    TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w900);

TextStyle get _hintStyle =>
    TextStyle(color: AppColors.textSecondary, fontSize: 13.sp, height: 1.4);
