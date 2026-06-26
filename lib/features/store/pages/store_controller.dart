import 'dart:async';

import 'package:alumni_association_app/features/profile/pages/merchant_type_item.dart';
import 'package:alumni_association_app/features/store/model/response/store_response.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../app/api/api_request.dart';
import '../model/response/store_offer_response.dart';

/// 商家列表、商家详情、预约流程状态控制器
class StoreController extends GetxController {
  /// 搜索输入框
  final searchController = TextEditingController();

  /// 预约页联系人信息
  final contactController = TextEditingController(text: '');
  final phoneController = TextEditingController(text: '');
  final noteController = TextEditingController();

  /// 搜索关键词，对应接口 shopName
  final keyword = ''.obs;

  /// 当前选中的顶部商户类型下标
  final selectedCategory = 0.obs;

  /// 顶部商户类型列表
  ///
  /// 第一个“全部”由前端手动追加，typeId = 0
  final merchantTypes = <MerchantTypeItem>[].obs;

  /// 商户列表
  final storeList = <StoreResponse>[].obs;

  /// 当前选中的商户下标
  final selectedStoreIndex = 0.obs;

  /// 当前选中的优惠下标
  final selectedOfferIndex = 0.obs;

  /// 当前选中的日期下标
  final selectedDateIndex = 0.obs;

  /// 更多日期选择后的自定义日期
  final selectedCustomDate = Rxn<DateTime>();

  /// 当前选中的时间下标
  final selectedTimeIndex = 0.obs;

  /// 预约人数
  final guestCount = 2.obs;

  /// 是否同意协议
  final agreementAccepted = false.obs;

  /// 是否收藏
  final isFavorite = false.obs;

  /// 二维码刷新计数
  final qrRefreshCount = 0.obs;

  /// 加载状态
  final isLoading = false.obs;
  final isRefreshing = false.obs;
  final isLoadingMore = false.obs;
  final isDetailLoading = false.obs;

  /// 是否还有更多
  final hasMore = true.obs;

  /// 分页参数
  int pageNum = 1;
  final int pageSize = 10;

  /// 搜索防抖
  Timer? _searchDebounce;

  /// 预约日期
  final reservationDates = const ['05-20', '05-21', '05-22', '05-23', '05-24'];

  /// 预约时间
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

  /// 当前选中的商户
  StoreResponse get selectedStore {
    if (storeList.isEmpty) {
      return StoreResponse.empty();
    }

    final index = selectedStoreIndex.value;
    if (index < 0 || index >= storeList.length) {
      return storeList.first;
    }

    return storeList[index];
  }

  /// 页面展示用商户列表
  List<StoreResponse> get visibleStores => storeList;

  /// 是否还有更多商户
  bool get hasMoreStores => hasMore.value;

  /// 当前选中的商户类型 ID
  ///
  /// 0 = 全部
  int get currentTypeId {
    if (merchantTypes.isEmpty) return 0;

    final index = selectedCategory.value;
    if (index < 0 || index >= merchantTypes.length) return 0;

    return merchantTypes[index].id;
  }

  /// 当前接口暂未返回商户优惠数据，
  /// 为了保证商家详情页、预约页逻辑不报错，先使用假数据。
  final fakeOffers = const <StoreOfferResponse>[
    StoreOfferResponse(
      id: 'offer-001',
      title: '会员专享优惠',
      subtitle: '到店消费可享会员优惠价格',
      price: 198,
      originalPrice: 268,
      discountLabel: '8.5折',
    ),
    StoreOfferResponse(
      id: 'offer-002',
      title: '全场通用优惠',
      subtitle: '单笔消费满足条件可使用',
      price: 300,
      originalPrice: 350,
      discountLabel: '满300减50',
    ),
  ];

  /// 当前选中的优惠
  ///
  /// 商户列表接口目前没有返回优惠数据，
  /// 所以后续页面需要 offer 时，先从 fakeOffers 里取。
  StoreOfferResponse get selectedOffer {
    if (fakeOffers.isEmpty) {
      return const StoreOfferResponse(
        id: '',
        title: '',
        subtitle: '',
        price: 0,
        originalPrice: 0,
        discountLabel: '',
      );
    }

    final index = selectedOfferIndex.value;
    if (index < 0 || index >= fakeOffers.length) {
      return fakeOffers.first;
    }

    return fakeOffers[index];
  }

  @override
  void onInit() {
    super.onInit();
    initStorePage();
  }

  /// 初始化商家页面
  ///
  /// 1. 获取商户类型
  /// 2. 获取商户列表第一页
  Future<void> initStorePage() async {
    await fetchMerchantTypes();
    await fetchInitial();
  }

  /// 获取商户类型
  ///
  /// 接口返回行业分类，前端手动追加“全部”
  Future<void> fetchMerchantTypes() async {
    final result = await ApiRequest.merchantTypes();

    merchantTypes.assignAll([
      const MerchantTypeItem(id: 0, typeName: '全部', isDeleted: 0),
      ...result,
    ]);

    selectedCategory.value = 0;
  }

  /// 搜索商户
  ///
  /// 搜索框内容作为 shopName 传给接口
  void search(String value) {
    keyword.value = value.trim();

    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      fetchInitial();
    });
  }

  /// 选择商户类型 Tab
  Future<void> selectCategory(int index) async {
    if (selectedCategory.value == index) return;

    selectedCategory.value = index;
    await fetchInitial();
  }

  /// 进入详情前选中商户
  void selectStore(StoreResponse store) {
    final index = storeList.indexWhere((item) => item.shopId == store.shopId);

    selectedStoreIndex.value = index < 0 ? 0 : index;
    selectedOfferIndex.value = 0;

    /// 列表接口返回的是摘要数据，进入详情后再按 shopId 拉完整详情。
    fetchStoreDetail(store.shopId);
  }

  /// 获取商户详情
  ///
  /// 详情接口会返回优惠券 coupons 等完整字段，回来后替换列表中的当前商户，
  /// 页面通过 selectedStore 自动刷新。
  Future<void> fetchStoreDetail(int shopId) async {
    if (shopId <= 0 || isDetailLoading.value) return;

    isDetailLoading.value = true;

    try {
      final detail = await ApiRequest.merchantInfo(shopId: shopId);
      if (detail == null) return;

      final index = storeList.indexWhere((item) => item.shopId == shopId);
      if (index >= 0) {
        storeList[index] = detail;
        selectedStoreIndex.value = index;
      } else {
        storeList.insert(0, detail);
        selectedStoreIndex.value = 0;
      }
    } finally {
      isDetailLoading.value = false;
    }
  }

  /// 首次加载 / 重新加载第一页
  Future<void> fetchInitial() async {
    pageNum = 1;
    hasMore.value = true;
    await fetchStoreList(isRefresh: true);
  }

  /// 下拉刷新
  Future<void> refreshStores() => fetchInitial();

  /// 加载更多
  Future<void> loadMoreStores() => fetchStoreList();

  /// 请求商户列表
  ///
  /// 接口参数：
  /// shopName: 搜索店铺名称
  /// typeId: 商户类型，0 表示全部
  /// pageNum: 页码
  /// pageSize: 每页数量
  Future<void> fetchStoreList({bool isRefresh = false}) async {
    if (isLoading.value) return;
    if (!isRefresh && !hasMore.value) return;

    isLoading.value = true;
    isRefreshing.value = isRefresh;
    isLoadingMore.value = !isRefresh;

    try {
      final result = await ApiRequest.storeList(
        shopName: keyword.value,
        typeId: currentTypeId,
        pageNum: pageNum,
        pageSize: pageSize,
      );

      if (result == null) {
        return;
      }

      if (isRefresh) {
        storeList.assignAll(result.rows);
      } else {
        storeList.addAll(result.rows);
      }

      /// 判断是否还有下一页
      hasMore.value = storeList.length < result.total;

      if (hasMore.value) {
        pageNum++;
      }
    } finally {
      isLoading.value = false;
      isRefreshing.value = false;
      isLoadingMore.value = false;
    }
  }

  /// 选择优惠
  void selectOffer(int index) => selectedOfferIndex.value = index;

  /// 选择预约日期
  void selectDate(int index) {
    selectedDateIndex.value = index;
    selectedCustomDate.value = null;
  }

  /// 选择自定义预约日期
  void selectCustomDate(DateTime date) {
    selectedCustomDate.value = date;
    selectedDateIndex.value = -1;
  }

  /// 选择预约时间
  void selectTime(int index) => selectedTimeIndex.value = index;

  /// 同意协议
  void toggleAgreement(bool? value) {
    agreementAccepted.value = value ?? false;
  }

  /// 收藏 / 取消收藏
  void toggleFavorite() => isFavorite.toggle();

  /// 刷新二维码
  void refreshQrCode() => qrRefreshCount.value++;

  /// 修改预约人数
  void changeGuestCount(int delta) {
    guestCount.value = (guestCount.value + delta).clamp(1, 20);
  }

  /// 格式化自定义日期
  String formatCustomDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$month-$day';
  }

  /// 自定义日期星期
  String customWeekday(DateTime date) {
    const weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    return weekdays[date.weekday - 1];
  }

  @override
  void onClose() {
    _searchDebounce?.cancel();

    searchController.dispose();
    contactController.dispose();
    phoneController.dispose();
    noteController.dispose();

    super.onClose();
  }
}
