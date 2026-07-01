import 'package:alumni_association_app/app/api/api_request.dart';
import 'package:alumni_association_app/features/consumption/model/response/order_response.dart';
import 'package:alumni_association_app/features/consumption/pages/consumption_entry_controller.dart';
import 'package:alumni_association_app/features/store/model/response/store_response.dart';
import 'package:alumni_association_app/util/loading_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 我的订单列表控制器。
///
/// 列表分页、Tab 状态筛选和详情请求都集中放在 Controller，
/// 页面只负责展示和触发交互。
class MyOrdersController extends GetxController {
  final selectedTab = 0.obs;

  /// 直接使用接口订单模型
  final orders = <OrderResponse>[].obs;

  /// 当前详情页订单
  final detailOrder = Rxn<OrderResponse>();

  final isLoading = false.obs;
  final isDetailLoading = false.obs;
  final isPreparingUse = false.obs;
  final hasMore = true.obs;

  final searchController = TextEditingController();

  int pageNum = 1;
  final int pageSize = 10;

  @override
  void onInit() {
    super.onInit();
    fetchInitial();
  }

  int? get currentOrderStatus {
    return switch (selectedTab.value) {
      1 => 0,
      2 => 1,
      3 => 2,
      _ => null,
    };
  }

  Future<void> switchTab(int index) async {
    if (selectedTab.value == index) return;
    selectedTab.value = index;
    await fetchInitial();
  }

  Future<void> fetchInitial() async {
    pageNum = 1;
    hasMore.value = true;
    await fetchOrders(isRefresh: true);
  }

  Future<void> loadMore() async {
    if (!hasMore.value || isLoading.value) return;
    await fetchOrders();
  }

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

      if (isRefresh) {
        orders.assignAll(result.rows);
      } else {
        orders.addAll(result.rows);
      }

      hasMore.value = orders.length < result.total;
      if (hasMore.value) pageNum++;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchOrderDetail({
    required int orderId,
    OrderResponse? fallback,
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

      detailOrder.value = result;
    } finally {
      isDetailLoading.value = false;
    }
  }

  void cancelOrder(OrderResponse item) {
    // final index = orders.indexWhere((order) => order.orderId == item.orderId);
    // if (index == -1) return;
    //
    // orders[index] = orders[index].copyWith(orderStatus: 2);
    //
    // if (detailOrder.value?.orderId == item.orderId) {
    //   detailOrder.value = detailOrder.value?.copyWith(orderStatus: 2);
    // }
  }

  Future<bool> prepareUseOrder(OrderResponse item) async {
    if (item.orderId <= 0 || isPreparingUse.value) return false;

    isPreparingUse.value = true;
    LoadingUtil.showSafe();

    try {
      final order = await ApiRequest.orderInfo(orderId: item.orderId);
      if (order == null || order.orderId <= 0) return false;

      final store = await ApiRequest.merchantInfo(shopId: order.shopId);
      if (store == null || store.shopId <= 0) return false;

      final consumptionController =
      Get.isRegistered<ConsumptionEntryController>()
          ? Get.find<ConsumptionEntryController>()
          : Get.put(ConsumptionEntryController());

      _fillConsumptionController(
        consumptionController: consumptionController,
        order: order,
        store: store,
      );

      return true;
    } finally {
      LoadingUtil.dismissSafe();
      isPreparingUse.value = false;
    }
  }

  void _fillConsumptionController({
    required ConsumptionEntryController consumptionController,
    required OrderResponse order,
    required StoreResponse store,
  }) {
    consumptionController.selectStoreMerchant(store);
    consumptionController.setCreatedOrder(order);

    final couponIndex = store.coupons.indexWhere(
          (coupon) => coupon.couponId == order.coupontId,
    );

    if (couponIndex >= 0) {
      consumptionController.selectStoreCoupon(
        store: store,
        index: couponIndex,
      );
    } else if (order.coupons == null) {
      consumptionController.clearStoreCoupon();
    }

    consumptionController.amount.value = 0;
    consumptionController.amountController.clear();
    consumptionController.noteController.text = order.remark;
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}