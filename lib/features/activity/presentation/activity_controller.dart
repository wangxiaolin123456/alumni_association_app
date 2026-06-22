import 'package:alumni_association_app/core/network/api_request.dart';
import 'package:alumni_association_app/core/network/model/page_response.dart';
import 'package:alumni_association_app/features/activity/model/response/activity_response.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

/// Owns activity-list filtering and activity-detail interaction state.
class ActivityController extends GetxController {
  /// Search input shown in the activity page header.
  final searchController = TextEditingController();

  /// Reactive state shared by activity list and detail pages.
  final keyword = ''.obs;
  final selectedCategory = 0.obs;
  final selectedActivityIndex = 0.obs;
  final isFavorite = false.obs;
  final isDescriptionExpanded = false.obs;
  final registeredActivityIds = <String>{}.obs;
  final activityList = <ActivityResponse>[].obs;
  final isLoading = false.obs;
  final isRefreshing = false.obs;
  final isLoadingMore = false.obs;
  final hasMore = true.obs;
  int pageNum = 1;
  final int pageSize = 10;

  /// Category codes map to localized labels in the activity-list page.
  final categoryCodes = const ['all', 'alumni', 'forum', 'training', 'sports'];

  /// 接口暂未接通时使用的活动假数据，仅由 Controller 管理。
  final activities = const <ActivityResponse>[
    ActivityResponse(
      id: 'activity-001',
      title: '全球校友联谊会',
      subtitle: '连接校友资源 共创价值生态',
      category: 'alumni',
      date: '2026-06-15',
      timeRange: '14:00-17:30',
      location: '上海 · 浦东新区',
      address: '浦东国际会议中心 3楼 大宴会厅',
      registeredCount: 200,
      capacity: 500,
      isFree: true,
      accentColors: [0xFF061A69, 0xFF0759D5],
    ),
    ActivityResponse(
      id: 'activity-002',
      title: '创享餐饮行业交流会',
      subtitle: '餐饮行业校友经验分享',
      category: 'alumni',
      date: '2026-06-20',
      timeRange: '14:00-16:30',
      location: '上海 · 静安区',
      address: '静安创新中心',
      registeredCount: 86,
      capacity: 150,
      isFree: true,
      accentColors: [0xFF234F7D, 0xFF85B6DE],
    ),
    ActivityResponse(
      id: 'activity-003',
      title: '东南亚旅游资源对接会',
      subtitle: '链接旅游行业优质资源',
      category: 'forum',
      date: '2026-06-22',
      timeRange: '09:30-12:00',
      location: '上海 · 浦东新区',
      address: '浦东文旅中心',
      registeredCount: 120,
      capacity: 200,
      isFree: true,
      accentColors: [0xFF068EB4, 0xFF68D1C0],
    ),
    ActivityResponse(
      id: 'activity-004',
      title: 'AI赋能企业增长实战课',
      subtitle: 'AI商业应用与增长方法',
      category: 'training',
      date: '2026-06-25',
      timeRange: '19:00-21:00',
      location: '上海 · 长宁区',
      address: '长宁校友中心',
      registeredCount: 76,
      capacity: 100,
      isFree: false,
      accentColors: [0xFF392765, 0xFF9C66D5],
    ),
    ActivityResponse(
      id: 'activity-005',
      title: '华创科技年度峰会',
      subtitle: '科技创新与产业协同',
      category: 'forum',
      date: '2026-07-05',
      timeRange: '13:30-17:00',
      location: '上海 · 徐汇区',
      address: '徐汇科技会堂',
      registeredCount: 310,
      capacity: 500,
      isFree: true,
      accentColors: [0xFF081B6B, 0xFF2B78E6],
    ),
    ActivityResponse(
      id: 'activity-006',
      title: '校友羽毛球友谊赛',
      subtitle: '运动交流 健康同行',
      category: 'sports',
      date: '2026-07-12',
      timeRange: '09:00-12:00',
      location: '上海 · 杨浦区',
      address: '杨浦体育中心',
      registeredCount: 64,
      capacity: 80,
      isFree: false,
      accentColors: [0xFF0B8B76, 0xFF48D6A4],
    ),
  ];

  ActivityResponse get featuredActivity => activities.first;
  ActivityResponse get selectedActivity =>
      activities[selectedActivityIndex.value];

  @override
  void onInit() {
    super.onInit();
    fetchInitial();
  }

  Future<void> search(String value) async {
    keyword.value = value.trim();
    await fetchInitial();
  }

  Future<void> selectCategory(int index) async {
    selectedCategory.value = index;
    await fetchInitial();
  }

  List<ActivityResponse> get visibleActivities => activityList;
  bool get hasMoreActivities => hasMore.value;

  /// 重置分页并重新请求第一页。
  Future<void> fetchInitial() async {
    pageNum = 1;
    hasMore.value = true;
    await fetchActivityList(isRefresh: true);
  }

  Future<void> refreshActivities() => fetchInitial();

  Future<void> loadMoreActivities() => fetchActivityList();

  /// 模拟请求活动分页接口；刷新替换列表，加载更多追加列表。
  Future<void> fetchActivityList({bool isRefresh = false}) async {
    if (isLoading.value || (!isRefresh && !hasMore.value)) return;
    isLoading.value = true;
    isRefreshing.value = isRefresh;
    isLoadingMore.value = !isRefresh;
    try {
      final result =
          await ApiRequest.activityList(
            pageNum: pageNum,
            pageSize: pageSize,
            keyword: keyword.value,
            category: categoryCodes[selectedCategory.value],
          ) ??
          _mockPage();
      isRefresh
          ? activityList.assignAll(result.rows)
          : activityList.addAll(result.rows);
      hasMore.value = result.hasMore;
      if (result.hasMore) pageNum++;
    } finally {
      isLoading.value = false;
      isRefreshing.value = false;
      isLoadingMore.value = false;
    }
  }

  /// 接口无数据时，在 Controller 中按当前筛选条件制造分页假数据。
  PageResponse<ActivityResponse> _mockPage() {
    final query = keyword.value.trim().toLowerCase();
    final category = categoryCodes[selectedCategory.value];
    final rows = activities.where((activity) {
      final matchesCategory =
          category == 'all' || activity.category == category;
      final matchesKeyword =
          query.isEmpty ||
          activity.title.toLowerCase().contains(query) ||
          activity.location.toLowerCase().contains(query);
      return matchesCategory && matchesKeyword;
    }).toList();
    final start = ((pageNum - 1) * pageSize).clamp(0, rows.length);
    final end = (start + pageSize).clamp(0, rows.length);
    return PageResponse(
      rows: rows.sublist(start, end),
      total: rows.length,
      pageNum: pageNum,
      pageSize: pageSize,
    );
  }

  /// Stores the selected activity before navigating to its detail page.
  void selectActivity(ActivityResponse activity) {
    selectedActivityIndex.value = activities.indexWhere(
      (item) => item.id == activity.id,
    );
    isDescriptionExpanded.value = false;
  }

  void toggleFavorite() => isFavorite.toggle();
  void toggleDescription() => isDescriptionExpanded.toggle();

  /// Toggles the local registration state; replace with register/cancel APIs.
  void toggleRegistration() {
    final id = selectedActivity.id;
    if (registeredActivityIds.contains(id)) {
      registeredActivityIds.remove(id);
    } else {
      registeredActivityIds.add(id);
    }
  }

  bool isRegistered(String id) => registeredActivityIds.contains(id);

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
