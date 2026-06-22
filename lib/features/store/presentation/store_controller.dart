import 'package:alumni_association_app/core/network/api_request.dart';
import 'package:alumni_association_app/core/network/model/page_response.dart';
import 'package:alumni_association_app/features/store/model/response/store_response.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

/// Owns merchant browsing, offer selection and reservation form state.
class StoreController extends GetxController {
  /// Search input shown at the top of the merchant-list page.
  final searchController = TextEditingController();

  /// Contact and note inputs kept outside widgets for GetX lifecycle control.
  final contactController = TextEditingController(text: '');
  final phoneController = TextEditingController(text: '');
  final noteController = TextEditingController();

  /// Reactive filters and selections shared by the store flow pages.
  final keyword = ''.obs;
  final selectedCategory = 0.obs;
  final selectedStoreIndex = 0.obs;
  final selectedOfferIndex = 0.obs;
  final selectedDateIndex = 0.obs;
  /// 更多日期选择后的自定义日期
  final selectedCustomDate = Rxn<DateTime>();
  final selectedTimeIndex = 0.obs;
  final guestCount = 2.obs;
  final agreementAccepted = false.obs;
  final isFavorite = false.obs;
  final qrRefreshCount = 0.obs;
  final storeList = <StoreResponse>[].obs;
  final isLoading = false.obs;
  final isRefreshing = false.obs;
  final isLoadingMore = false.obs;
  final hasMore = true.obs;
  int pageNum = 1;
  final int pageSize = 3;

  /// Categories rendered by the list page. Labels are localized in the view.
  final categoryCodes = const [
    'all',
    'food',
    'hotel',
    'travel',
    'education',
    'medical',
    'retail',
  ];

  /// Mock API responses used until the real store endpoints are connected.
  final stores = const <StoreResponse>[
    StoreResponse(
      id: 'store-001',
      name: '创享餐饮商会',
      address: '上海市 · 静安区南京西路123号',
      category: 'food',
      distance: '1.2km',
      rating: 4.8,
      monthlySales: 1200,
      accentColors: [0xFF173F78, 0xFF71A9DB],
      imageUrls: [

        'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=1200&q=80',

        'https://images.unsplash.com/photo-1552566626-52f8b828add9?auto=format&fit=crop&w=1200&q=80',

        'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=1200&q=80',

        'https://images.unsplash.com/photo-1544148103-0773bf10d330?auto=format&fit=crop&w=1200&q=80',

      ],
      offers: [
        StoreOfferResponse(
          id: 'offer-001',
          title: '双人套餐会员价',
          subtitle: '含招牌菜3选+饮品2杯',
          price: 198,
          originalPrice: 268,
          discountLabel: '8.5折',
        ),
        StoreOfferResponse(
          id: 'offer-002',
          title: '全场通用',
          subtitle: '单笔消费满300元可用',
          price: 300,
          originalPrice: 300,
          discountLabel: '满300减50',
        ),
      ],
    ),
    StoreResponse(
      id: 'store-002',
      name: '悦享酒店集团',
      address: '上海市 · 浦东新区',
      category: 'hotel',
      distance: '2.4km',
      rating: 4.7,
      monthlySales: 860,
      accentColors: [0xFF174F88, 0xFF78B7EA],
      offers: [],
    ),
    StoreResponse(
      id: 'store-003',
      name: '乐游国际旅行社',
      address: '上海市 · 黄浦区',
      category: 'travel',
      distance: '3.6km',
      rating: 4.9,
      monthlySales: 730,
      accentColors: [0xFF087FBA, 0xFF63D4C5],
      offers: [],
    ),
    StoreResponse(
      id: 'store-004',
      name: '智汇教育培训中心',
      address: '上海市 · 徐汇区',
      category: 'education',
      distance: '4.1km',
      rating: 4.6,
      monthlySales: 640,
      accentColors: [0xFF7A5438, 0xFFD6A471],
      offers: [],
    ),
    StoreResponse(
      id: 'store-005',
      name: '康健体检中心',
      address: '上海市 · 长宁区',
      category: 'medical',
      distance: '5.3km',
      rating: 4.8,
      monthlySales: 510,
      accentColors: [0xFF139B9B, 0xFF98DCD5],
      offers: [],
    ),
  ];

  /// Dates and times presented by the reservation page.
  final reservationDates = const ['05-20', '05-21', '05-22', '05-23', '05-24'];
  final reservationTimes = const [
    '10:00',
    '11:00',
    '12:00',
    '13:00',
    '14:00',
    '17:00',
    '18:00',
    '19:00',
    '20:00',
  ];

  StoreResponse get selectedStore => stores[selectedStoreIndex.value];

  /// Uses the first demo package as a fallback until every store API response
  /// provides its own reservable products.
  StoreOfferResponse get selectedOffer => selectedStore.offers.isEmpty
      ? stores.first.offers.first
      : selectedStore.offers[selectedOfferIndex.value];

  /// Applies both the selected category and the current search keyword.
  List<StoreResponse> get filteredStores {
    final query = keyword.value.trim().toLowerCase();
    final category = categoryCodes[selectedCategory.value];
    return stores.where((store) {
      final matchesCategory = category == 'all' || store.category == category;
      final matchesQuery =
          query.isEmpty ||
          store.name.toLowerCase().contains(query) ||
          store.address.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchInitial();
  }

  /// Selects a merchant before opening its detail page.
  void selectStore(StoreResponse store) {
    selectedStoreIndex.value = stores.indexWhere((item) => item.id == store.id);
    selectedOfferIndex.value = 0;
  }

  Future<void> search(String value) async {
    keyword.value = value.trim();
    await fetchInitial();
  }

  Future<void> selectCategory(int index) async {
    selectedCategory.value = index;
    await fetchInitial();
  }

  List<StoreResponse> get visibleStores => storeList;
  bool get hasMoreStores => hasMore.value;

  /// 重置分页并重新请求第一页。
  Future<void> fetchInitial() async {
    pageNum = 1;
    hasMore.value = true;
    await fetchStoreList(isRefresh: true);
  }

  Future<void> refreshStores() => fetchInitial();

  Future<void> loadMoreStores() => fetchStoreList();

  /// 模拟请求商家分页接口；刷新替换列表，加载更多追加列表。
  Future<void> fetchStoreList({bool isRefresh = false}) async {
    if (isLoading.value || (!isRefresh && !hasMore.value)) return;
    isLoading.value = true;
    isRefreshing.value = isRefresh;
    isLoadingMore.value = !isRefresh;
    try {
      final result =
          await ApiRequest.storeList(pageNum: pageNum, pageSize: pageSize) ??
          _mockPage(filteredStores);
      isRefresh
          ? storeList.assignAll(result.rows)
          : storeList.addAll(result.rows);
      hasMore.value = result.hasMore;
      if (result.hasMore) pageNum++;
    } finally {
      isLoading.value = false;
      isRefreshing.value = false;
      isLoadingMore.value = false;
    }
  }

  /// 接口暂未接通时，由 Controller 使用本地数据模拟当前分页结果。
  PageResponse<StoreResponse> _mockPage(List<StoreResponse> rows) {
    final start = ((pageNum - 1) * pageSize).clamp(0, rows.length);
    final end = (start + pageSize).clamp(0, rows.length);
    return PageResponse(
      rows: rows.sublist(start, end),
      total: rows.length,
      pageNum: pageNum,
      pageSize: pageSize,
    );
  }

  void selectOffer(int index) => selectedOfferIndex.value = index;

  void selectDate(int index) {
    selectedDateIndex.value = index;
    selectedCustomDate.value = null;
  }

  void selectCustomDate(DateTime date) {
    selectedCustomDate.value = date;
    selectedDateIndex.value = -1;
  }
  void selectTime(int index) => selectedTimeIndex.value = index;
  void toggleAgreement(bool? value) => agreementAccepted.value = value ?? false;
  void toggleFavorite() => isFavorite.toggle();
  void refreshQrCode() => qrRefreshCount.value++;

  /// Adjusts guest count while enforcing a practical 1-20 range.
  void changeGuestCount(int delta) {
    guestCount.value = (guestCount.value + delta).clamp(1, 20);
  }

  @override
  void onClose() {
    searchController.dispose();
    contactController.dispose();
    phoneController.dispose();
    noteController.dispose();
    super.onClose();
  }

  String formatCustomDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$month-$day';
  }

  String customWeekday(DateTime date) {
    const weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    return weekdays[date.weekday - 1];
  }
}
