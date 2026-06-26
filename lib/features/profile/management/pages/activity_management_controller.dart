import 'package:alumni_association_app/features/profile/management/model/profile_management_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 活动管理控制器。
///
/// 管理活动列表分页、搜索和上下架操作。
class ActivityManagementController extends GetxController {
  final items = <ProfileManagementItem>[].obs;
  final selectedTab = 0.obs;
  final isLoading = false.obs;
  final hasMore = true.obs;
  final searchController = TextEditingController();

  int pageNum = 1;
  final int pageSize = 4;

  @override
  void onInit() {
    super.onInit();
    fetchInitial();
  }

  Future<void> switchTab(int index) async {
    selectedTab.value = index;
    await fetchInitial();
  }

  Future<void> fetchInitial() async {
    pageNum = 1;
    hasMore.value = true;
    await fetchItems(isRefresh: true);
  }

  Future<void> loadMore() async {
    if (!hasMore.value || isLoading.value) return;
    await fetchItems();
  }

  Future<void> fetchItems({bool isRefresh = false}) async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      await Future<void>.delayed(const Duration(milliseconds: 220));
      final rows = _requestPage(pageNum: pageNum, pageSize: pageSize);
      if (isRefresh) {
        items.assignAll(rows);
      } else {
        items.addAll(rows);
      }
      hasMore.value = rows.length >= pageSize;
      if (hasMore.value) pageNum++;
    } finally {
      isLoading.value = false;
    }
  }

  /// 活动上下架状态切换。
  void toggleStatus(ProfileManagementItem item) {
    final index = items.indexOf(item);
    if (index == -1) return;
    final nextStatus = item.status == ProfileManageStatus.online
        ? ProfileManageStatus.offline
        : ProfileManageStatus.online;
    items[index] = item.copyWith(status: nextStatus);
  }

  List<ProfileManagementItem> _requestPage({
    required int pageNum,
    required int pageSize,
  }) {
    final keyword = searchController.text.trim();
    final status = switch (selectedTab.value) {
      1 => ProfileManageStatus.online,
      2 => ProfileManageStatus.offline,
      _ => null,
    };
    final filtered = _mockItems.where((item) {
      final matchStatus = status == null || item.status == status;
      final matchKeyword =
          keyword.isEmpty ||
          item.title.contains(keyword) ||
          item.location?.contains(keyword) == true;
      return matchStatus && matchKeyword;
    }).toList();
    final start = (pageNum - 1) * pageSize;
    if (start >= filtered.length) return const [];
    final end = (start + pageSize).clamp(0, filtered.length);
    return filtered.sublist(start, end);
  }

  List<ProfileManagementItem> get _mockItems => const [
    ProfileManagementItem(
      title: '全球校友联谊会',
      category: '校友活动',
      publishTime: '2026-07-15 14:00',
      status: ProfileManageStatus.online,
      icon: Icons.groups_rounded,
      iconColor: Color(0xFF126DFF),
      location: '上海市浦东新区世纪大道100号',
      participantCount: 286,
    ),
    ProfileManagementItem(
      title: 'AI企业增长实战课',
      category: '培训讲座',
      publishTime: '2026-08-20 19:00',
      status: ProfileManageStatus.offline,
      icon: Icons.co_present_rounded,
      iconColor: Color(0xFF126DFF),
      location: '东京都新宿区西新宿2-8-1',
      participantCount: 128,
    ),
    ProfileManagementItem(
      title: '校友海边音乐派对',
      category: '体育文娱',
      publishTime: '2026-06-28 18:30',
      status: ProfileManageStatus.online,
      icon: Icons.beach_access_rounded,
      iconColor: Color(0xFF126DFF),
      location: '三亚市亚龙湾海滩中心广场',
      participantCount: 156,
    ),
    ProfileManagementItem(
      title: '户外徒步登山活动',
      category: '体育文娱',
      publishTime: '2026-05-18 08:00',
      status: ProfileManageStatus.offline,
      icon: Icons.landscape_rounded,
      iconColor: Color(0xFF126DFF),
      location: '杭州市临安区大明山景区',
      participantCount: 98,
    ),
  ];

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
