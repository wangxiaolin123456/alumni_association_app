import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/activity/pages/activity_list_page.dart';
import 'package:alumni_association_app/features/member/pages/member_dashboard_page.dart';
import 'package:alumni_association_app/features/opportunity/pages/opportunity_list_page.dart';
import 'package:alumni_association_app/features/profile/pages/profile_page.dart';
import 'package:alumni_association_app/features/store/pages/store_list_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 控制底部导航选中的页面。
class RoleHomeController extends GetxController {
  /// 底部导航和 IndexedStack 共享的下标。
  final selectedIndex = 0.obs;

  /// 切换页面并保留各 Tab 已构建的状态。
  void selectTab(int index) => selectedIndex.value = index;
}

class RoleHomePage extends StatelessWidget {
  const RoleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RoleHomeController());

    return Obx(() {
      return Scaffold(
        body: SafeArea(
          bottom: false,
          child: IndexedStack(
            index: controller.selectedIndex.value,
            children: _memberPages,
          ),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: controller.selectTab,
          destinations: _memberDestinations(context),
        ),
      );
    });
  }
}

const _memberPages = <Widget>[
  MemberDashboardPage(),
  StoreListPage(),
  ActivityListPage(),
  OpportunityListPage(),
  ProfilePage(),
];

List<NavigationDestination> _memberDestinations(BuildContext context) => [
  NavigationDestination(
    icon: const Icon(Icons.home_outlined),
    selectedIcon: const Icon(Icons.home_rounded),
    label: context.l10n.home,
  ),
  NavigationDestination(
    icon: const Icon(Icons.storefront_outlined),
    selectedIcon: const Icon(Icons.storefront_rounded),
    label: context.l10n.merchants,
  ),
  NavigationDestination(
    icon: const Icon(Icons.event_outlined),
    selectedIcon: const Icon(Icons.event_rounded),
    label: context.l10n.activities,
  ),
  NavigationDestination(
    icon: const Icon(Icons.business_center_outlined),
    selectedIcon: const Icon(Icons.business_center_rounded),
    label: context.l10n.opportunityHall,
  ),
  NavigationDestination(
    icon: const Icon(Icons.person_outline),
    selectedIcon: const Icon(Icons.person_rounded),
    label: context.l10n.mine,
  ),
];
