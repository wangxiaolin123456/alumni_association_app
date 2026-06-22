import 'package:alumni_association_app/app/router/app_router.dart';
import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/auth/domain/session_controller.dart';
import 'package:alumni_association_app/features/auth/domain/user_role.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

///我的首页
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Get.find<SessionController>();
    return Obx(() {
      if (!session.isAuthenticated.value) return const _GuestProfileView();
      return session.role.value == UserRole.merchant
          ? const _MerchantMineView()
          : const _MemberMineView();
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
                  onPressed: () => context.push(Pages.login),
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
  const _MemberMineView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _MineScaffold(
      header: _MineHeader(
        avatarIcon: Icons.apartment_rounded,
        roleTag: l10n.campus,
        name: l10n.profileName,
        badge: l10n.verified,
        subline: '${l10n.alumniMember}  |  ${l10n.memberNumber}',
      ),
      children: [
        _MemberCard(),
        _GridSection(
          title: l10n.myOrdersRecords,
          items: [
            _ActionItem(
              Icons.assignment_add,
              l10n.myOrders,
              () => context.push(Pages.myOrdersPage),
            ),
            _ActionItem(
              Icons.payments_rounded,
              l10n.registrationRecords,
              () => context.push(Pages.memberRegistrationRecords),
              color: const Color(0xFFFF6B3D),
            ),
            _ActionItem(
              Icons.storefront_rounded,
              l10n.favoriteMerchants,
              () => context.push(Pages.memberFavoriteMerchants),
              color: AppColors.success,
            ),
            _ActionItem(
              Icons.schedule_rounded,
              l10n.browsingRecords,
              () => context.push(Pages.memberBrowsingRecords),
            ),
          ],
        ),
        _GridSection(
          title: l10n.myServices,
          items: [
            _ActionItem(
              Icons.verified_user_rounded,
              l10n.alumniCertification,
              () => context.push(Pages.memberCertification),
            ),
            _ActionItem(
              Icons.business_center_rounded,
              l10n.opportunityManagement,
              () => context.push(Pages.opportunityManagementPage),
            ),
            _ActionItem(
              Icons.event_available_rounded,
              l10n.activityManagement,
              () => context.push(Pages.activityManagementPage),
            ),
            _ActionItem(
              Icons.confirmation_number_rounded,
              l10n.myCoupons,
              () => context.push(Pages.myBenefits),
            ),
            _ActionItem(
              Icons.storefront_rounded,
              l10n.merchantOnboarding,
              () => context.push(Pages.merchantOnboardingPage),
              isNew: true,
            ),
            _ActionItem(
              Icons.support_agent_rounded,
              l10n.helpCenter,
              () => context.push(Pages.helpCenter),
            ),
            _ActionItem(
              Icons.chat_rounded,
              l10n.feedback,
              () => context.push(Pages.feedback),
            ),
          ],
        ),
      ],
    );
  }
}

class _MerchantMineView extends StatelessWidget {
  const _MerchantMineView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _MineScaffold(
      header: _MineHeader(
        avatarIcon: Icons.apartment_rounded,
        roleTag: l10n.merchant,
        name: l10n.merchantProfileName,
        badge: l10n.verifiedMerchant,
        subline: l10n.memberNumber,
      ),
      children: [
        _MyMerchantCard(),
        _GridSection(
          title: l10n.myOrdersRecords,
          // columns: 5,
          items: [
            _ActionItem(
              Icons.assignment_add,
              l10n.myOrders,
              () => context.push(Pages.myOrdersPage),
            ),
            _ActionItem(
              Icons.payments_rounded,
              l10n.registrationRecords,
              () => context.push(Pages.memberRegistrationRecords),
              color: const Color(0xFFFF6B3D),
            ),
            _ActionItem(
              Icons.storefront_rounded,
              l10n.favoriteMerchants,
              () => context.push(Pages.memberFavoriteMerchants),
              color: AppColors.success,
            ),
            _ActionItem(
              Icons.receipt_long_rounded,
              l10n.entryRecords,
              () => context.push(Pages.entryRecordsPage),
            ),
            _ActionItem(
              Icons.account_balance_wallet_rounded,
              l10n.revenueRecords,
              () {},
            ),
          ],
        ),
        _GridSection(
          title: l10n.myServices,
          items: [
            _ActionItem(
              Icons.verified_user_rounded,
              l10n.alumniCertification,
              () => context.push(Pages.memberCertification),
            ),
            _ActionItem(
              Icons.business_center_rounded,
              l10n.opportunityManagement,
              () => context.push(Pages.opportunityManagementPage),
            ),
            _ActionItem(
              Icons.event_available_rounded,
              l10n.activityManagement,
              () => context.push(Pages.activityManagementPage),
            ),
            _ActionItem(
              Icons.confirmation_number_rounded,
              l10n.couponManage,
              () {},
            ),
            _ActionItem(Icons.bar_chart_rounded, l10n.dataStatistics, () {}),
            _ActionItem(
              Icons.support_agent_rounded,
              l10n.helpCenter,
              () => context.push(Pages.helpCenter),
            ),
            _ActionItem(
              Icons.chat_rounded,
              l10n.feedback,
              () => context.push(Pages.feedback),
            ),
          ],
        ),
      ],
    );
  }
}

class _MineScaffold extends StatelessWidget {
  const _MineScaffold({required this.header, required this.children});

  final Widget header;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(18.w, 10.h, 18.w, 28.h),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () => context.push(Pages.settings),
              icon: Icon(Icons.settings_outlined, size: 28.sp),
            ),
            Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  onPressed: () => context.push(Pages.memberMessages),
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
  });

  final IconData avatarIcon;
  final String roleTag;
  final String name;
  final String badge;
  final String subline;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(Pages.personalInfo),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 43.r,
                backgroundColor: const Color(0xFFE0ECFF),
                child: Icon(avatarIcon, color: AppColors.primary, size: 48.sp),
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
          SizedBox(width: 16.w),
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
                          fontSize: 23.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    SizedBox(width: 7.w),
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

class _MemberCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _DarkCard(
      title: context.l10n.electronicMemberCard,
      subtitle: context.l10n.exclusiveBenefits,
      button: context.l10n.viewMemberCode,
      onTap: () => context.push(Pages.memberQr),
    );
  }
}

class _MyMerchantCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Row(
        children: [
          Icon(Icons.storefront_rounded, color: AppColors.primary, size: 58.sp),
          SizedBox(width: 18.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.myMerchant, style: _sectionTitleStyle),
                SizedBox(height: 6.h),
                Text(context.l10n.myMerchantDesc, style: _hintStyle),
              ],
            ),
          ),
          FilledButton(
            onPressed: () {},
            child: Text(context.l10n.viewMerchant),
          ),
          Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
        ],
      ),
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
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                ),
              ],
            ),
          ),
          FilledButton.icon(
            onPressed: onTap,
            icon: const Icon(Icons.qr_code_2_rounded),
            label: Text(button),
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
              mainAxisExtent: 88.h,
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
                Icon(item.icon, color: item.color, size: 34.sp),
                SizedBox(height: 10.h),
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13.sp),
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
