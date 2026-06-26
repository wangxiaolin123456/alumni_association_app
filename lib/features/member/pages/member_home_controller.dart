import 'package:alumni_association_app/features/member/model/response/popular_activity_response.dart';
import 'package:alumni_association_app/features/member/model/response/recommended_merchant_response.dart';
import 'package:alumni_association_app/features/member/model/response/member_banner_response.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

/// Holds member-home mock data and search interaction state.
///
/// The mock collections can later be replaced by repositories without moving
/// list state or search-history behavior back into the widgets.
class MemberHomeController extends GetxController {
  /// Controls the text displayed in the search input.
  final searchController = TextEditingController();

  /// Current normalized keyword used to filter local mock data.
  final keyword = ''.obs;
  final bannerPageController = PageController();
  final currentBannerIndex = 0.obs;

  /// 首页轮播图模拟接口数据，视图根据 code 获取多语言文案。
  final banners = const <MemberBannerResponse>[
    MemberBannerResponse(
      id: 'banner-001',
      titleCode: 'resources',
      subtitleCode: 'resources',
      iconCode: 0xe80b,
      gradientColors: [0xFF063CCA, 0xFF1687E8],
    ),
    MemberBannerResponse(
      id: 'banner-002',
      titleCode: 'benefits',
      subtitleCode: 'benefits',
      iconCode: 0xe8f6,
      gradientColors: [0xFF6845D6, 0xFFA46EEB],
    ),
    MemberBannerResponse(
      id: 'banner-003',
      titleCode: 'activities',
      subtitleCode: 'activities',
      iconCode: 0xe878,
      gradientColors: [0xFF087FBA, 0xFF22B7A4],
    ),
    MemberBannerResponse(
      id: 'banner-004',
      titleCode: 'opportunities',
      subtitleCode: 'opportunities',
      iconCode: 0xe0af,
      gradientColors: [0xFFFF7B12, 0xFFFFAE29],
    ),
  ];

  void selectBanner(int index) => currentBannerIndex.value = index;

  /// Mock merchant responses. Replace this assignment with an API repository.
  final merchants = const <RecommendedMerchantResponse>[
    RecommendedMerchantResponse(
      id: 'merchant-001',
      name: '华创科技咖啡',
      location: '上海 · 浦东新区',
      category: '咖啡饮品',
      distance: '9.2km',
      visualType: 'cafe',
      gradientColors: [0xFF613A2A, 0xFFD0955D],
    ),
    RecommendedMerchantResponse(
      id: 'merchant-002',
      name: '创享银泰酒店',
      location: '上海 · 静安区',
      category: '酒店住宿',
      distance: '5.6km',
      visualType: 'hotel',
      gradientColors: [0xFF174F88, 0xFF78B7EA],
    ),
    RecommendedMerchantResponse(
      id: 'merchant-003',
      name: '动感健身中心',
      location: '上海 · 徐汇区',
      category: '运动健身',
      distance: '3.1km',
      visualType: 'fitness',
      gradientColors: [0xFF26303B, 0xFF7A8998],
    ),
    RecommendedMerchantResponse(
      id: 'merchant-004',
      name: '校友健康中心',
      location: '上海 · 黄浦区',
      category: '医疗体检',
      distance: '6.8km',
      visualType: 'health',
      gradientColors: [0xFF119A8E, 0xFF7ED7CE],
    ),
  ];

  /// Mock activity responses displayed by the popular-activity list.
  final activities = const <PopularActivityResponse>[
    PopularActivityResponse(
      id: 'activity-001',
      title: '全球校友联谊会',
      date: '2026-06-15 14:00',
      location: '上海 · 浦东新区',
      registeredCount: 256,
      gradientColors: [0xFF073CCA, 0xFF1687E8],
    ),
    PopularActivityResponse(
      id: 'activity-002',
      title: '校友企业资源对接会',
      date: '2026-06-22 10:00',
      location: '上海 · 静安区',
      registeredCount: 128,
      gradientColors: [0xFF5B36C9, 0xFFA06BEE],
    ),
  ];

  /// Suggested keywords displayed before the user starts searching.
  final hotSearches = const [
    '餐饮优惠',
    '酒店套餐',
    '旅游线路',
    '校友活动',
    '合作需求',
    '资源对接',
    '教育培训',
    '医疗体检',
  ];

  /// Local search history; later this can be persisted through StorageService.
  final searchHistory = <String>['创享餐饮商会', '全球校友联谊会', '寻找供应链合作伙伴'].obs;

  /// Filters merchant responses against name, category and location.
  List<RecommendedMerchantResponse> get filteredMerchants {
    final query = keyword.value.trim().toLowerCase();
    if (query.isEmpty) return merchants;
    return merchants
        .where(
          (item) =>
              item.name.toLowerCase().contains(query) ||
              item.category.toLowerCase().contains(query) ||
              item.location.toLowerCase().contains(query),
        )
        .toList();
  }

  /// Applies a search keyword and moves it to the top of search history.
  void search(String value) {
    final normalized = value.trim();
    keyword.value = normalized;
    if (normalized.isNotEmpty) {
      searchHistory.remove(normalized);
      searchHistory.insert(0, normalized);
    }
  }

  /// Copies a suggested/history term into the input before searching.
  void useSearchTerm(String value) {
    searchController.text = value;
    search(value);
  }

  /// Removes one local history item.
  void removeHistory(String value) => searchHistory.remove(value);

  /// Resets the active keyword and clears the visible search input.
  void clearSearch() {
    searchController.clear();
    keyword.value = '';
  }

  /// Disposes the Flutter text controller when GetX releases this controller.
  @override
  void onClose() {
    searchController.dispose();
    bannerPageController.dispose();
    super.onClose();
  }
}
