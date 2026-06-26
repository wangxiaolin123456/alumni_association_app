import 'package:alumni_association_app/features/profile/management/model/profile_management_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 商机管理控制器。
///
/// 负责商机列表的筛选、搜索、分页和上下架状态修改。
class OpportunityManagementController extends GetxController {
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

  /// 上架或下架当前商机。
  void toggleStatus(ProfileManagementItem item) {
    final index = items.indexOf(item);
    if (index == -1) return;
    final nextStatus = item.status == ProfileManageStatus.online
        ? ProfileManageStatus.offline
        : ProfileManageStatus.online;
    items[index] = item.copyWith(status: nextStatus);
  }

  /// 删除商机，模拟接口删除成功后本地移除。
  void deleteItem(ProfileManagementItem item) {
    items.remove(item);
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
          item.category.contains(keyword);
      return matchStatus && matchKeyword;
    }).toList();
    final start = (pageNum - 1) * pageSize;
    if (start >= filtered.length) return const [];
    final end = (start + pageSize).clamp(0, filtered.length);
    return filtered.sublist(start, end);
  }

  List<ProfileManagementItem> get _mockItems => const [
    ProfileManagementItem(
      title: 'AI智能客服项目',
      category: '软件开发',
      publishTime: '2026-06-18 14:30',
      status: ProfileManageStatus.online,
      icon: Icons.business_center_rounded,
      iconColor: Color(0xFF126DFF),
      views: 286,
      inquiries: 12,
    ),
    ProfileManagementItem(
      title: '校友供应链合作项目',
      category: '供应链',
      publishTime: '2026-06-15 10:20',
      status: ProfileManageStatus.offline,
      icon: Icons.warehouse_rounded,
      iconColor: Color(0xFF126DFF),
      views: 156,
      inquiries: 5,
    ),
    ProfileManagementItem(
      title: '校友培训课程合作',
      category: '教育培训',
      publishTime: '2026-06-10 09:15',
      status: ProfileManageStatus.online,
      icon: Icons.school_rounded,
      iconColor: Color(0xFF126DFF),
      views: 312,
      inquiries: 18,
    ),
    ProfileManagementItem(
      title: '企业数字化转型咨询',
      category: '企业服务',
      publishTime: '2026-06-05 16:45',
      status: ProfileManageStatus.offline,
      icon: Icons.handshake_rounded,
      iconColor: Color(0xFF126DFF),
      views: 98,
      inquiries: 3,
    ),
  ];

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
