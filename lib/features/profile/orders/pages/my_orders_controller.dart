import 'package:alumni_association_app/app/api/api_request.dart';
import 'package:alumni_association_app/features/profile/orders/model/profile_order_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 我的订单列表控制器。
///
/// 列表分页、Tab 状态筛选和详情请求都集中放在 Controller，
/// 页面只负责展示和触发交互。
class MyOrdersController extends GetxController {
  /// 当前选中的订单状态 Tab。
  final selectedTab = 0.obs;

  /// 订单列表数据。
  final orders = <ProfileOrderItem>[].obs;

  /// 当前详情页订单。
  final detailOrder = Rxn<ProfileOrderItem>();

  /// 是否正在加载列表。
  final isLoading = false.obs;

  /// 是否正在加载详情。
  final isDetailLoading = false.obs;

  /// 是否还有更多数据。
  final hasMore = true.obs;

  /// 搜索框控制器。
  final searchController = TextEditingController();

  /// 当前页码。
  int pageNum = 1;

  /// 每页条数。
  final int pageSize = 10;

  @override
  void onInit() {
    super.onInit();
    fetchInitial();
  }

  /// 当前 Tab 对应后端订单状态。
  ///
  /// null 表示全部订单。
  int? get currentOrderStatus {
    return switch (selectedTab.value) {
      1 => 0,
      2 => 1,
      3 => 2,
      _ => null,
    };
  }

  /// 切换 Tab 后重新请求第一页数据。
  Future<void> switchTab(int index) async {
    if (selectedTab.value == index) return;
    selectedTab.value = index;
    await fetchInitial();
  }

  /// 下拉刷新入口。
  Future<void> fetchInitial() async {
    pageNum = 1;
    hasMore.value = true;
    await fetchOrders(isRefresh: true);
  }

  /// 上拉加载更多入口。
  Future<void> loadMore() async {
    if (!hasMore.value || isLoading.value) return;
    await fetchOrders();
  }

  /// 获取订单列表数据。
  Future<void> fetchOrders({bool isRefresh = false}) async {
    if (isLoading.value) return;

    isLoading.value = true;
    try {
      final result = await ApiRequest.userOrders(
        orderStatus: currentOrderStatus,
        pageNum: pageNum,
        pageSize: pageSize,
      );

      if (result == null) {
        if (isRefresh) orders.clear();
        hasMore.value = false;
        return;
      }

      final rows = result.rows.map(ProfileOrderItem.fromOrderResponse).toList();
      if (isRefresh) {
        orders.assignAll(rows);
      } else {
        orders.addAll(rows);
      }

      hasMore.value = orders.length < result.total;
      if (hasMore.value) pageNum++;
    } finally {
      isLoading.value = false;
    }
  }

  /// 获取订单详情。
  ///
  /// 详情页进入时通过 orderId 请求完整详情；如果接口失败，
  /// 会保留列表传入的订单做兜底展示。
  Future<void> fetchOrderDetail({
    required int orderId,
    ProfileOrderItem? fallback,
  }) async {
    if (orderId <= 0) {
      detailOrder.value = fallback;
      return;
    }
    if (isDetailLoading.value) return;
    if (detailOrder.value?.orderId == orderId) return;

    detailOrder.value = fallback;
    isDetailLoading.value = true;
    try {
      final result = await ApiRequest.orderInfo(orderId: orderId);
      if (result == null) return;

      detailOrder.value = ProfileOrderItem.fromOrderResponse(result);
    } finally {
      isDetailLoading.value = false;
    }
  }

  /// 取消预约时只更新当前列表的本地状态，后续可替换为取消订单接口。
  void cancelOrder(ProfileOrderItem item) {
    final index = orders.indexWhere((order) => order.orderId == item.orderId);
    if (index == -1) return;
    orders[index] = orders[index].copyWith(
      status: ProfileOrderStatus.cancelled,
    );

    if (detailOrder.value?.orderId == item.orderId) {
      detailOrder.value = detailOrder.value?.copyWith(
        status: ProfileOrderStatus.cancelled,
      );
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
