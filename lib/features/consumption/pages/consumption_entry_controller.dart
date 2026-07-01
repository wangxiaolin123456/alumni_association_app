import 'dart:async';

import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/auth/domain/session_controller.dart';
import 'package:alumni_association_app/features/consumption/model/request/order_request.dart';
import 'package:alumni_association_app/features/consumption/model/response/order_response.dart';
import 'package:alumni_association_app/features/profile/pages/merchant_type_item.dart';
import 'package:alumni_association_app/features/store/model/response/store_response.dart';
import 'package:alumni_association_app/util/loading_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/api/api_request.dart';

/// 消费入单
class ConsumptionEntryController extends GetxController {
  /// 输入框
  final searchController = TextEditingController();

  ///实际价格
  final amountController = TextEditingController();
  final noteController = TextEditingController();

  /// 搜索关键词，对应接口 shopName
  final keyword = ''.obs;

  /// 当前选中的商户下标
  final selectedMerchantIndex = (-1).obs;

  /// 当前选中的优惠券下标
  ///
  /// -1 = 不使用优惠券
  final selectedCouponIndex = (-1).obs;

  /// 消费金额
  final amount = 0.0.obs;

  /// 创建订单后接口返回的订单信息
  final currentOrder = Rxn<OrderResponse>();

  /// 提交订单中
  final isSubmittingOrder = false.obs;

  /// 提交后的订单号
  final submittedOrderNumber = ''.obs;

  /// 提交时间
  final submittedAtText = ''.obs;

  /// 当前消费入单选中的商户
  final selectedStore = Rxn<StoreResponse>();

  /// 当前消费入单选中的优惠券
  final selectedStoreCoupon = Rxn<StoreCouponResponse>();

  /// 商户分类列表
  ///
  /// 第一个“全部”由前端手动追加，id = 0
  final merchantTypes = <MerchantTypeItem>[].obs;

  /// 当前选中的分类下标
  final selectedCategoryIndex = 0.obs;

  /// 商户列表，接口返回
  final merchants = <StoreResponse>[].obs;

  /// 加载状态
  final isLoading = false.obs;
  final isRefreshing = false.obs;
  final isLoadingMore = false.obs;

  /// 是否还有下一页
  final hasMore = true.obs;

  /// 分页参数
  int pageNum = 1;
  final int pageSize = 10;

  Timer? _searchDebounce;

  /// 当前分类 ID
  int get currentTypeId {
    if (merchantTypes.isEmpty) return 0;

    final index = selectedCategoryIndex.value;
    if (index < 0 || index >= merchantTypes.length) return 0;

    return merchantTypes[index].id;
  }

  /// 当前分类名称
  String selectedCategoryName(BuildContext context) {
    if (merchantTypes.isEmpty) return context.l10n.allCategories;

    final index = selectedCategoryIndex.value;
    if (index < 0 || index >= merchantTypes.length) {
      return context.l10n.allCategories;
    }

    final item = merchantTypes[index];

    if (item.id == 0) return context.l10n.allCategories;

    return item.typeName;
  }

  /// 当前选中的商户
  StoreResponse get selectedMerchant {
    final store = selectedStore.value;
    if (store != null && store.shopId > 0) {
      return store;
    }

    if (merchants.isEmpty) return StoreResponse.empty();

    final index = selectedMerchantIndex.value;
    if (index < 0 || index >= merchants.length) {
      return merchants.first;
    }

    return merchants[index];
  }

  /// 是否已经选择商户
  bool get canContinueFromMerchant {
    final store = selectedStore.value;
    if (store != null && store.shopId > 0) return true;

    return merchants.isNotEmpty &&
        selectedMerchantIndex.value >= 0 &&
        selectedMerchantIndex.value < merchants.length;
  }

  /// 是否可以提交金额
  bool get canContinueFromAmount =>
      amount.value > 0 &&
      currentOrder.value != null &&
      currentOrder.value!.orderId > 0 &&
      !isSubmittingOrder.value;

  /// 实际消费金额

  double get actualConsumptionAmount => _roundMoney(amount.value);

  /// 优惠金额
  double get discountAmount {
    final coupon = selectedStoreCoupon.value;

    final actualAmount = actualConsumptionAmount;

    if (coupon == null || actualAmount <= 0) {
      return 0;
    }

    /// type:

    /// 0 = 固定金额

    /// 1 = 百分比

    /// 2 = 满减

    if (coupon.type == 0) {
      final discount = coupon.value;

      return _roundMoney(discount.clamp(0, double.infinity));
    }

    if (coupon.type == 1) {
      final rate = _discountPayRate(coupon.value);

      if (rate <= 0 || rate >= 1) {
        return 0;
      }

      final original = actualAmount / rate;

      return _roundMoney((original - actualAmount).clamp(0, double.infinity));
    }

    if (coupon.type == 2) {
      ///消费满多少有优惠金额
      final thresholdAmount = coupon.minOrderAmount;

      ///折扣金额
      final discountAmount = coupon.maxDiscountAmount;

      if (discountAmount <= 0) return 0;

      final possibleOriginal = actualAmount + discountAmount;

      if (thresholdAmount > 0 && possibleOriginal < thresholdAmount) {
        return 0;
      }

      return _roundMoney(discountAmount);
    }

    return 0;
  }

  /// 消费原价

  double get originalAmount {
    return _roundMoney(
      (actualConsumptionAmount + discountAmount).clamp(0, double.infinity),
    );
  }

  /// 折扣后的支付比例
  ///
  /// 0.9 = 9折
  /// 9 = 9折
  /// 90 = 90%
  double _discountPayRate(double value) {
    if (value <= 0) return 1;

    if (value > 0 && value <= 1) {
      return value;
    }

    if (value > 1 && value <= 10) {
      return value / 10;
    }

    if (value > 10 && value <= 100) {
      return value / 100;
    }

    return 1;
  }

  @override
  void onInit() {
    super.onInit();
    initMerchantPage();
  }

  /// 初始化商户选择页面
  Future<void> initMerchantPage() async {
    await fetchMerchantTypes();
    await fetchInitial();
  }

  /// 获取商户分类
  Future<void> fetchMerchantTypes() async {
    final result = await ApiRequest.merchantTypes();

    merchantTypes.assignAll([
      const MerchantTypeItem(id: 0, typeName: '全部', isDeleted: 0),
      ...result,
    ]);

    selectedCategoryIndex.value = 0;
  }

  /// 重新加载第一页
  Future<void> fetchInitial() async {
    pageNum = 1;
    hasMore.value = true;
    selectedMerchantIndex.value = -1;

    await fetchMerchantList(isRefresh: true);
  }

  /// 下拉刷新
  Future<void> refreshMerchants() async {
    await fetchInitial();
  }

  /// 加载更多
  Future<void> loadMore() async {
    await fetchMerchantList();
  }

  /// 获取商户列表
  Future<void> fetchMerchantList({bool isRefresh = false}) async {
    if (isLoading.value) return;
    if (!isRefresh && !hasMore.value) return;

    isLoading.value = true;
    isRefreshing.value = isRefresh;
    isLoadingMore.value = !isRefresh;

    try {
      final result = await ApiRequest.storeList(
        typeId: currentTypeId,
        pageNum: pageNum,
        pageSize: pageSize,
        shopName: keyword.value,
      );

      if (result == null) return;

      if (isRefresh) {
        merchants.assignAll(result.rows);
      } else {
        merchants.addAll(result.rows);
      }

      hasMore.value = merchants.length < result.total;

      if (hasMore.value) {
        pageNum++;
      }
    } finally {
      isLoading.value = false;
      isRefreshing.value = false;
      isLoadingMore.value = false;
    }
  }

  /// 搜索
  void search(String value) {
    keyword.value = value.trim();

    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      fetchInitial();
    });
  }

  /// 选择分类
  void selectCategoryByIndex(int index) {
    if (selectedCategoryIndex.value == index) return;

    selectedCategoryIndex.value = index;

    /// 切换分类时清空选择
    selectedMerchantIndex.value = -1;
    selectedStore.value = null;
    selectedStoreCoupon.value = null;
    selectedCouponIndex.value = -1;

    fetchInitial();
  }

  /// 兼容旧 String 分类选择
  void selectCategory(String category) {
    final index = merchantTypes.indexWhere((item) => item.typeName == category);

    if (index >= 0) {
      selectCategoryByIndex(index);
    }
  }

  /// 从商户列表选择商户
  void selectMerchant(StoreResponse merchant) {
    final index = merchants.indexWhere(
      (item) => item.shopId == merchant.shopId,
    );

    selectedMerchantIndex.value = index;
    selectedStore.value = merchant;

    /// 换商户时清空优惠券
    selectedStoreCoupon.value = null;
    selectedCouponIndex.value = -1;
  }

  /// 从商户详情进入消费入单时保存商户
  void selectStoreMerchant(StoreResponse store) {
    selectedStore.value = store;

    final index = merchants.indexWhere((item) => item.shopId == store.shopId);

    selectedMerchantIndex.value = index;

    /// 每次换商户，清空优惠券
    selectedStoreCoupon.value = null;
    selectedCouponIndex.value = -1;
  }

  /// 从商户详情选择优惠券
  void selectStoreCoupon({required StoreResponse store, required int index}) {
    selectedStore.value = store;
    selectedCouponIndex.value = index;

    if (index >= 0 && index < store.coupons.length) {
      selectedStoreCoupon.value = store.coupons[index];
    } else {
      selectedStoreCoupon.value = null;
    }
  }

  /// 从商户详情页进入“立即使用”。
  ///
  /// 页面层只负责把商户和优惠券下标传进来；创建订单、loading、
  /// 返回订单保存、金额表单清空都统一放在 Controller 内处理。
  Future<bool> prepareOrderFromStore({
    required StoreResponse store,
    required int selectedCouponIndex,
  }) async {
    if (store.shopId <= 0) return false;

    selectStoreMerchant(store);

    StoreCouponResponse? selectedCoupon;
    if (selectedCouponIndex >= 0 &&
        selectedCouponIndex < store.coupons.length) {
      selectedCoupon = store.coupons[selectedCouponIndex];
      selectStoreCoupon(store: store, index: selectedCouponIndex);
    } else {
      clearStoreCoupon();
    }

    /// 清空上一次填写的金额、备注和订单，避免跨商户残留。
    amount.value = 0;
    currentOrder.value = null;
    amountController.clear();
    noteController.clear();

    LoadingUtil.showSafe();
    try {
      final userInfo = SessionController.current.userInfo.value;
      final order = await ApiRequest.addOrder(
        request: OrderRequest(
          shopId: store.shopId,
          userId: userInfo?.userId ?? 0,
          coupontId: selectedCoupon?.couponId ?? 0,
          contactName: store.names.isEmpty?userInfo?.displayName ?? '':store.names,
          contactPhone: store.phone.isEmpty?userInfo?.phone ?? '':store.phone,
        ),
      );
      if (order == null || order.orderId <= 0) return false;

      setCreatedOrder(order);
      return true;
    } finally {
      LoadingUtil.dismissSafe();
    }
  }

  /// 保存创建订单接口返回的信息。
  ///
  /// 从商户详情点击“立即使用”时会先创建订单，再把返回值带到金额填写页。
  void setCreatedOrder(OrderResponse order) {
    currentOrder.value = order;
    submittedOrderNumber.value = order.orderNum;
    submittedAtText.value = order.createTime;

    if (order.coupons != null) {
      selectedStoreCoupon.value = order.coupons;
    }
  }

  /// 不使用优惠券
  void clearStoreCoupon() {
    selectedStoreCoupon.value = null;
    selectedCouponIndex.value = -1;
  }

  /// 当前优惠券标题
  String selectedCouponTitle(BuildContext context) {
    final coupon = selectedStoreCoupon.value;

    if (coupon == null) {
      return context.l10n.doNotUseCoupon;
    }

    return coupon.displayTitle;
  }

  /// 当前优惠券说明
  String selectedCouponRule(BuildContext context) {
    final coupon = selectedStoreCoupon.value;

    if (coupon == null) {
      return context.l10n.calculateOriginalPrice;
    }

    return coupon.description;
  }

  /// 更新金额
  void updateAmount(String value) {
    amount.value = double.tryParse(value.trim()) ?? 0;
  }

  /// 重置流程
  Future<void> resetWorkflow() async {
    keyword.value = '';
    selectedCategoryIndex.value = 0;
    selectedMerchantIndex.value = -1;
    selectedCouponIndex.value = -1;
    amount.value = 0;
    currentOrder.value = null;
    isSubmittingOrder.value = false;

    selectedStore.value = null;
    selectedStoreCoupon.value = null;

    searchController.clear();
    amountController.clear();
    noteController.clear();

    await fetchInitial();
  }

  /// 提交订单。
  ///
  /// 用户填写消费原价后，前端按优惠券规则计算 actualTotal，
  /// 再调用 `/api/order/confirmOrder` 完成提交。
  Future<bool> submitOrder() async {
    final order = currentOrder.value;
    if (order == null || order.orderId <= 0 || !canContinueFromAmount) {
      return false;
    }

    isSubmittingOrder.value = true;
    LoadingUtil.showSafe();
    try {
      final success = await ApiRequest.confirmOrder(
        orderId: order.orderId,
        actualTotal: double.tryParse(amountController.text.trim()) ?? 0,
        remark: noteController.text.trim(),
      );
      if (!success) return false;

      final now = DateTime.now();
      submittedOrderNumber.value = order.orderNum.isEmpty
          ? order.orderId.toString()
          : order.orderNum;
      submittedAtText.value = order.createTime.isEmpty
          ? _formatDateTime(now)
          : order.createTime;

      return true;
    } finally {
      LoadingUtil.dismissSafe();
      isSubmittingOrder.value = false;
    }
  }

  @override
  void onClose() {
    _searchDebounce?.cancel();

    searchController.dispose();
    amountController.dispose();
    noteController.dispose();

    super.onClose();
  }
}

/// 金额保留两位小数
double _roundMoney(double value) => (value * 100).roundToDouble() / 100;

/// 本地提交时间展示。
String _formatDateTime(DateTime value) {
  final year = value.year.toString().padLeft(4, '0');
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  final hour = value.hour.toString().padLeft(2, '0');
  final minute = value.minute.toString().padLeft(2, '0');
  final second = value.second.toString().padLeft(2, '0');
  return '$year-$month-$day $hour:$minute:$second';
}
