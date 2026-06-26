import 'package:alumni_association_app/features/member/record_center/model/response/member_record_response.dart';
import 'package:get/get.dart';

import '../../../../app/api/api_request.dart';
import '../../../../http/model/page_response.dart';

class MemberRecordCenterController extends GetxController {
  final registrationList = <MemberRecordResponse>[].obs;
  final favoriteList = <MemberRecordResponse>[].obs;
  final browsingList = <MemberRecordResponse>[].obs;

  final registrationLoading = false.obs;
  final favoriteLoading = false.obs;
  final browsingLoading = false.obs;
  final registrationLoadingMore = false.obs;
  final favoriteLoadingMore = false.obs;
  final browsingLoadingMore = false.obs;
  final registrationHasMore = true.obs;
  final favoriteHasMore = true.obs;
  final browsingHasMore = true.obs;

  int registrationPageNum = 1;
  int favoritePageNum = 1;
  int browsingPageNum = 1;
  final int pageSize = 3;

  final cancelledRegistrationIds = <String>{}.obs;
  final favoriteIds = <String>{
    'favorite-001',
    'favorite-002',
    'favorite-003',
    'favorite-004',
    'favorite-005',
    'favorite-006',
  }.obs;
  final browsingRecords = <MemberRecordResponse>[
    ..._initialBrowsingRecords,
  ].obs;

  final registrations = const <MemberRecordResponse>[
    MemberRecordResponse(
      id: 'registration-001',
      title: '全球校友联谊会',
      subtitle: '2026-06-15 14:00 · 上海浦东国际会议中心',
      meta: '报名编号：HD20260615001',
      status: 'upcoming',
      accentColors: [0xFF073CCA, 0xFF1687E8],
    ),
    MemberRecordResponse(
      id: 'registration-002',
      title: '创享餐饮行业交流会',
      subtitle: '2026-06-20 14:00 · 上海静安创新中心',
      meta: '报名编号：HD20260620018',
      status: 'upcoming',
      accentColors: [0xFF234F7D, 0xFF85B6DE],
    ),
    MemberRecordResponse(
      id: 'registration-003',
      title: 'AI赋能企业增长实战课',
      subtitle: '2026-06-25 19:00 · 长宁校友中心',
      meta: '报名编号：HD20260625026',
      status: 'upcoming',
      accentColors: [0xFF392765, 0xFF9C66D5],
    ),
    MemberRecordResponse(
      id: 'registration-004',
      title: '校友企业资源对接会',
      subtitle: '2026-05-10 13:30 · 徐汇科技会堂',
      meta: '已签到',
      status: 'completed',
      accentColors: [0xFF087FBA, 0xFF63D4C5],
    ),
    MemberRecordResponse(
      id: 'registration-005',
      title: '教育行业校友论坛',
      subtitle: '2026-04-22 09:30 · 浦东校友中心',
      meta: '活动已结束',
      status: 'completed',
      accentColors: [0xFFFF7B12, 0xFFFFAE29],
    ),
  ];

  final favorites = const <MemberRecordResponse>[
    MemberRecordResponse(
      id: 'favorite-001',
      title: '创享餐饮商会',
      subtitle: '中餐 · 快餐 · 静安区',
      meta: '1.2km · 会员8.5折',
      status: 'favorite',
      accentColors: [0xFF173F78, 0xFF71A9DB],
    ),
    MemberRecordResponse(
      id: 'favorite-002',
      title: '悦享酒店集团',
      subtitle: '酒店住宿 · 浦东新区',
      meta: '2.4km · 会员房型优惠',
      status: 'favorite',
      accentColors: [0xFF174F88, 0xFF78B7EA],
    ),
    MemberRecordResponse(
      id: 'favorite-003',
      title: '乐游国际旅行社',
      subtitle: '旅游出行 · 黄浦区',
      meta: '3.6km · 专属线路立减',
      status: 'favorite',
      accentColors: [0xFF087FBA, 0xFF63D4C5],
    ),
    MemberRecordResponse(
      id: 'favorite-004',
      title: '智汇教育培训中心',
      subtitle: '教育培训 · 徐汇区',
      meta: '4.1km · 课程立减500元',
      status: 'favorite',
      accentColors: [0xFF7A5438, 0xFFD6A471],
    ),
    MemberRecordResponse(
      id: 'favorite-005',
      title: '康健体检中心',
      subtitle: '医疗体检 · 长宁区',
      meta: '5.3km · 体检套餐9折',
      status: 'favorite',
      accentColors: [0xFF139B9B, 0xFF98DCD5],
    ),
    MemberRecordResponse(
      id: 'favorite-006',
      title: '东方书店',
      subtitle: '书店文创 · 静安区',
      meta: '4.8km · 全场图书8.5折',
      status: 'favorite',
      accentColors: [0xFF6D4324, 0xFFD6A36A],
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    refreshRegistrations();
    refreshFavorites();
    refreshBrowsing();
  }

  List<MemberRecordResponse> get visibleRegistrations => registrationList;
  List<MemberRecordResponse> get activeFavorites =>
      favorites.where((item) => favoriteIds.contains(item.id)).toList();
  List<MemberRecordResponse> get visibleFavorites => favoriteList;
  List<MemberRecordResponse> get visibleBrowsing => browsingList;

  bool get hasMoreRegistrations => registrationHasMore.value;
  bool get hasMoreFavorites => favoriteHasMore.value;
  bool get hasMoreBrowsing => browsingHasMore.value;

  Future<void> refreshRegistrations() async {
    registrationPageNum = 1;
    registrationHasMore.value = true;
    await fetchRegistrationList(isRefresh: true);
  }

  Future<void> refreshFavorites() async {
    favoritePageNum = 1;
    favoriteHasMore.value = true;
    await fetchFavoriteList(isRefresh: true);
  }

  Future<void> refreshBrowsing() async {
    browsingPageNum = 1;
    browsingHasMore.value = true;
    await fetchBrowsingList(isRefresh: true);
  }

  Future<void> loadMoreRegistrations() => fetchRegistrationList();

  Future<void> loadMoreFavorites() => fetchFavoriteList();

  Future<void> loadMoreBrowsing() => fetchBrowsingList();

  /// 获取报名记录分页数据。
  Future<void> fetchRegistrationList({bool isRefresh = false}) async {
    if (registrationLoading.value ||
        (!isRefresh && !registrationHasMore.value)) {
      return;
    }
    registrationLoading.value = true;
    registrationLoadingMore.value = !isRefresh;
    try {
      // final result =
      //     await ApiRequest.registrationRecords(
      //       pageNum: registrationPageNum,
      //       pageSize: pageSize,
      //     ) ??
          _mockPage(registrations, registrationPageNum);
      // isRefresh
      //     ? registrationList.assignAll(result.rows)
      //     : registrationList.addAll(result.rows);
      // registrationHasMore.value = result.hasMore;
      // if (result.hasMore) registrationPageNum++;
    } finally {
      registrationLoading.value = false;
      registrationLoadingMore.value = false;
    }
  }

  /// 获取收藏商家分页数据。
  Future<void> fetchFavoriteList({bool isRefresh = false}) async {
    if (favoriteLoading.value || (!isRefresh && !favoriteHasMore.value)) return;
    favoriteLoading.value = true;
    favoriteLoadingMore.value = !isRefresh;
    try {
      // final result =
      //     await ApiRequest.favoriteMerchants(
      //       pageNum: favoritePageNum,
      //       pageSize: pageSize,
      //     ) ??
          _mockPage(activeFavorites, favoritePageNum);
      // isRefresh
      //     ? favoriteList.assignAll(result.rows)
      //     : favoriteList.addAll(result.rows);
      // favoriteHasMore.value = result.hasMore;
      // if (result.hasMore) favoritePageNum++;
    } finally {
      favoriteLoading.value = false;
      favoriteLoadingMore.value = false;
    }
  }

  /// 获取浏览记录分页数据。
  Future<void> fetchBrowsingList({bool isRefresh = false}) async {
    if (browsingLoading.value || (!isRefresh && !browsingHasMore.value)) return;
    browsingLoading.value = true;
    browsingLoadingMore.value = !isRefresh;
    try {
      // final result =
      //     await ApiRequest.browsingRecords(
      //       pageNum: browsingPageNum,
      //       pageSize: pageSize,
      //     ) ??
          _mockPage(browsingRecords, browsingPageNum);
      // isRefresh
      //     ? browsingList.assignAll(result.rows)
      //     : browsingList.addAll(result.rows);
      // browsingHasMore.value = result.hasMore;
      // if (result.hasMore) browsingPageNum++;
    } finally {
      browsingLoading.value = false;
      browsingLoadingMore.value = false;
    }
  }

  /// 报名记录允许用户取消尚未开始的活动。
  void cancelRegistration(String id) => cancelledRegistrationIds.add(id);

  /// 收藏页取消收藏后重新请求第一页，确保分页总数同步。
  Future<void> toggleFavorite(String id) async {
    favoriteIds.contains(id) ? favoriteIds.remove(id) : favoriteIds.add(id);
    await refreshFavorites();
  }

  Future<void> removeBrowsing(String id) async {
    browsingRecords.removeWhere((item) => item.id == id);
    await refreshBrowsing();
  }

  Future<void> clearBrowsing() async {
    browsingRecords.clear();
    await refreshBrowsing();
  }

  /// 接口暂未接通时，由 Controller 使用对应列表模拟分页结果。
  PageResponse<MemberRecordResponse> _mockPage(
    List<MemberRecordResponse> rows,
    int currentPage,
  ) {
    final start = ((currentPage - 1) * pageSize).clamp(0, rows.length);
    final end = (start + pageSize).clamp(0, rows.length);
    return PageResponse(
      rows: rows.sublist(start, end),
      total: rows.length,
      pageNum: currentPage,
      pageSize: pageSize,
    );
  }
}

const _initialBrowsingRecords = <MemberRecordResponse>[
  MemberRecordResponse(
    id: 'history-001',
    title: '创享餐饮商会',
    subtitle: '商家 · 中餐快餐',
    meta: '今天 10:25',
    status: 'store',
    accentColors: [0xFF173F78, 0xFF71A9DB],
  ),
  MemberRecordResponse(
    id: 'history-002',
    title: '全球校友联谊会',
    subtitle: '活动 · 校友活动',
    meta: '今天 09:40',
    status: 'activity',
    accentColors: [0xFF073CCA, 0xFF1687E8],
  ),
  MemberRecordResponse(
    id: 'history-003',
    title: '寻找餐饮供应链合作伙伴',
    subtitle: '商机 · 合作需求',
    meta: '昨天 18:20',
    status: 'opportunity',
    accentColors: [0xFF1687E8, 0xFF315DF5],
  ),
  MemberRecordResponse(
    id: 'history-004',
    title: '悦享酒店集团',
    subtitle: '商家 · 酒店住宿',
    meta: '昨天 14:08',
    status: 'store',
    accentColors: [0xFF174F88, 0xFF78B7EA],
  ),
  MemberRecordResponse(
    id: 'history-005',
    title: 'AI赋能企业增长实战课',
    subtitle: '活动 · 培训讲座',
    meta: '2026-06-12',
    status: 'activity',
    accentColors: [0xFF392765, 0xFF9C66D5],
  ),
  MemberRecordResponse(
    id: 'history-006',
    title: '智能教育项目寻求天使投资',
    subtitle: '商机 · 投资融资',
    meta: '2026-06-10',
    status: 'opportunity',
    accentColors: [0xFFFF7B12, 0xFFFFAE29],
  ),
];
