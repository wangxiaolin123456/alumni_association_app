import 'dart:async';

import 'package:alumni_association_app/features/auth/domain/session_controller.dart';
import 'package:alumni_association_app/features/consumption/model/request/order_request.dart';
import 'package:alumni_association_app/features/consumption/model/response/order_response.dart';
import 'package:alumni_association_app/features/profile/pages/merchant_type_item.dart';
import 'package:alumni_association_app/features/store/model/response/store_response.dart';
import 'package:alumni_association_app/util/loading_util.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../app/api/api_request.dart';

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

  /// 当前预约订单草稿。
  ///
  /// 从商户详情点击“立即预约”时先创建 orderType=1 的订单，
  /// 后续预约页、确认页继续补充预约信息。
  final currentReservationOrder = Rxn<OrderResponse>();

  /// 是否正在提交预约订单
  final isReservationSubmitting = false.obs;

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

  /// 预约日期：从当天开始连续 5 天，格式 MM-dd
  List<String> get reservationDates {
    final now = DateTime.now();

    return List.generate(5, (index) {
      final date = now.add(Duration(days: index));
      final month = date.month.toString().padLeft(2, '0');
      final day = date.day.toString().padLeft(2, '0');
      return '$month-$day';
    });
  }

  /// 预约时间
  /// 根据商户营业时间自动生成预约时间
  List<String> get reservationTimes {
    final startText = selectedStore.businessStartTime.trim();
    final endText = selectedStore.businessEndTime.trim();

    final start = _parseHourMinute(startText) ?? const _HourMinute(9, 0);
    final end = _parseHourMinute(endText) ?? const _HourMinute(18, 0);

    final result = <String>[];

    var current = start;

    while (current.compareTo(end) <= 0) {
      result.add(current.format());
      current = current.addHour();
    }

    return result.isEmpty ? const ['09:00'] : result;
  }

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

  /// 当前选中的后端优惠券。
  ///
  /// 商户详情接口返回 coupons 时优先使用真实优惠券；没有时返回 null。
  StoreCouponResponse? get selectedCoupon {
    final coupons = selectedStore.coupons;
    if (coupons.isEmpty) return null;

    final index = selectedOfferIndex.value;
    if (index < 0 || index >= coupons.length) {
      return coupons.first;
    }
    return coupons[index];
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
    selectedTimeIndex.value = 0;

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

  /// 从商户详情点击“立即预约”。
  ///
  /// 和“立即使用”一样先调用创建订单接口，只是这里 orderType=1，
  /// 表示后续会进入预约信息填写流程。
  Future<bool> prepareReservationOrder() async {
    final store = selectedStore;
    if (store.shopId <= 0) return false;

    final coupon = selectedCoupon;
    LoadingUtil.showSafe();
    try {
      final userInfo = SessionController.current.userInfo.value;
      final order = await ApiRequest.addOrder(
        request: OrderRequest(
          shopId: store.shopId,
          userId: userInfo?.userId ?? 0,
          coupontId: coupon?.couponId ?? 0,
          orderType: 1,
          contactName: store.names.isEmpty?userInfo?.displayName ?? '':store.names,
          contactPhone: store.phone.isEmpty?userInfo?.phone ?? '':store.phone,
        ),
      );

      if (order == null || order.orderId <= 0) return false;

      currentReservationOrder.value = order;
      return true;
    } finally {
      LoadingUtil.dismissSafe();
    }
  }

  /// 预约日期文本，格式：yyyy-MM-dd。
  String get reservationDateParam {
    final custom = selectedCustomDate.value;
    if (custom != null) {
      return _formatDate(custom);
    }

    final now = DateTime.now();
    final index = selectedDateIndex.value;

    final safeIndex = index >= 0 && index < reservationDates.length ? index : 0;
    final date = now.add(Duration(days: safeIndex));

    return _formatDate(date);
  }

  /// 预约时间文本，格式：yyyy-MM-dd HH:mm:ss。
  String get reservationAppointmentTime {
    final times = reservationTimes;
    final index = selectedTimeIndex.value;

    final time = index >= 0 && index < times.length
        ? times[index]
        : times.first;

    return '$reservationDateParam $time:00';
  }

  /// 提交完整预约订单。
  Future<bool> submitReservationOrder() async {
    if (isReservationSubmitting.value) return false;

    final store = selectedStore;
    if (store.shopId <= 0) return false;

    isReservationSubmitting.value = true;
    LoadingUtil.showSafe();
    try {
      final draft = currentReservationOrder.value;
      final userId = SessionController.current.userInfo.value?.userId ?? 0;
      final coupon = selectedCoupon;

      final result = await ApiRequest.addReservationOrder(
        orderId: draft?.orderId ?? 0,
        shopId: store.shopId,
        userId: draft?.userId == 0 || draft?.userId == null
            ? userId
            : draft!.userId,
        orderNum: draft?.orderNum ?? '',
        peopleNum: guestCount.value,
        orderStatus: draft?.orderStatus ?? 0,
        couponId: coupon?.couponId ?? draft?.coupontId ?? 0,
        appointmentTime: reservationAppointmentTime,
        remark: noteController.text.trim(),
        contactName: contactController.text.trim(),
        contactPhone: phoneController.text.trim(),
      );

      if (result == null || result.orderId <= 0) return false;

      currentReservationOrder.value = result;
      return true;
    } finally {
      LoadingUtil.dismissSafe();
      isReservationSubmitting.value = false;
    }
  }

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

String _formatDate(DateTime date) {
  final year = date.year.toString().padLeft(4, '0');
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}

_HourMinute? _parseHourMinute(String value) {
  final text = value.trim();
  if (text.isEmpty) return null;

  final parts = text.split(':');
  if (parts.length < 2) return null;

  final hour = int.tryParse(parts[0]);
  final minute = int.tryParse(parts[1]);

  if (hour == null || minute == null) return null;
  if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;

  return _HourMinute(hour, minute);
}

class _HourMinute {
  const _HourMinute(this.hour, this.minute);

  final int hour;
  final int minute;

  _HourMinute addHour() {
    final nextHour = hour + 1;
    if (nextHour > 23) return const _HourMinute(23, 59);
    return _HourMinute(nextHour, minute);
  }

  int compareTo(_HourMinute other) {
    final currentMinutes = hour * 60 + minute;
    final otherMinutes = other.hour * 60 + other.minute;
    return currentMinutes.compareTo(otherMinutes);
  }

  String format() {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
