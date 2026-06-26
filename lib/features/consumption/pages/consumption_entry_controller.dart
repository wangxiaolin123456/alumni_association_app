import 'dart:async';

import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/profile/pages/merchant_type_item.dart';
import 'package:alumni_association_app/features/store/model/response/store_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/api/api_request.dart';

/// 消费入单
class ConsumptionEntryController extends GetxController {
  /// 输入框
  final searchController = TextEditingController();
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
  bool get canContinueFromAmount => amount.value > 0;

  /// 优惠金额
  double get discountAmount {
    final coupon = selectedStoreCoupon.value;
    final currentAmount = amount.value;

    if (coupon == null || currentAmount <= 0) {
      return 0;
    }

    /// 没达到最低消费金额，不优惠
    if (coupon.minOrderAmount > 0 &&
        currentAmount < coupon.minOrderAmount) {
      return 0;
    }

    /// type:
    /// 1 = 固定金额引 / 定额优惠
    /// 2 = 百分比折扣
    /// 3 = 条件付割引 / 满减
    if (coupon.type == 1 || coupon.type == 3) {
      return _roundMoney(coupon.value.clamp(0, currentAmount));
    }

    if (coupon.type == 2) {
      final rate = coupon.value;
      double discount = 0;

      /// 兼容后端可能传的几种折扣格式：
      /// 0.9 = 9折
      /// 9 = 9折
      /// 90 = 90%
      if (rate > 0 && rate <= 1) {
        discount = currentAmount * (1 - rate);
      } else if (rate > 1 && rate <= 10) {
        discount = currentAmount * (1 - rate / 10);
      } else if (rate > 10 && rate <= 100) {
        discount = currentAmount * (1 - rate / 100);
      }

      /// 最大优惠金额
      if (coupon.maxDiscountAmount > 0) {
        discount = discount.clamp(0, coupon.maxDiscountAmount);
      }

      return _roundMoney(discount.clamp(0, currentAmount));
    }

    return 0;
  }

  /// 应付金额
  double get payableAmount {
    return _roundMoney(
      (amount.value - discountAmount).clamp(0, double.infinity),
    );
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
      const MerchantTypeItem(
        id: 0,
        typeName: '全部',
        isDeleted: 0,
      ),
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
    final index = merchantTypes.indexWhere(
          (item) => item.typeName == category,
    );

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

    final index = merchants.indexWhere(
          (item) => item.shopId == store.shopId,
    );

    selectedMerchantIndex.value = index;

    /// 每次换商户，清空优惠券
    selectedStoreCoupon.value = null;
    selectedCouponIndex.value = -1;
  }

  /// 从商户详情选择优惠券
  void selectStoreCoupon({
    required StoreResponse store,
    required int index,
  }) {
    selectedStore.value = store;
    selectedCouponIndex.value = index;

    if (index >= 0 && index < store.coupons.length) {
      selectedStoreCoupon.value = store.coupons[index];
    } else {
      selectedStoreCoupon.value = null;
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

    selectedStore.value = null;
    selectedStoreCoupon.value = null;

    searchController.clear();
    amountController.clear();
    noteController.clear();

    await fetchInitial();
  }

  /// 提交，后续替换成真实创建订单接口
  void submit() {
    if (!canContinueFromAmount) return;

    /// TODO:
    /// 后续这里调用真实提交接口。
    /// 需要提交的核心字段：
    ///
    /// shopId: selectedMerchant.shopId
    /// couponId: selectedStoreCoupon.value?.couponId ?? 0
    /// originalAmount: amount.value
    /// discountAmount: discountAmount
    /// paidAmount: payableAmount
    /// note: noteController.text.trim()
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