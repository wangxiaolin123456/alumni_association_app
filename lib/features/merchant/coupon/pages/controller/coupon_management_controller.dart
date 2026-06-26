import 'dart:async';

import 'package:alumni_association_app/app/api/api_request.dart';
import 'package:alumni_association_app/app/router/app_router.dart';
import 'package:alumni_association_app/features/merchant/coupon/model/request/coupon_request.dart';
import 'package:alumni_association_app/features/store/model/response/store_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 优惠券管理 Controller。
///
/// 负责优惠券搜索、顶部状态 Tab、列表接口请求，以及下架/上架/删除操作。
class CouponManagementController extends GetxController {
  /// 搜索框控制器
  final searchController = TextEditingController();

  /// 优惠券列表
  final coupons = <StoreCouponResponse>[].obs;

  /// 当前选中的 Tab 下标：0 全部，1 生效中，2 已下架，3 已过期
  final selectedTabIndex = 0.obs;

  /// 当前搜索关键词
  final keyword = ''.obs;

  /// 页面加载中
  final isLoading = false.obs;

  /// 搜索防抖，避免每输入一个字都立即请求接口。
  Timer? _searchDebounce;

  /// 顶部 Tab 对应的接口参数。
  ///
  /// 按需求：全部传 0；其余状态按后端列表筛选约定依次传 1/2/3。
  final tabDisableStatusValues = const [0, 1, 2, 3];

  @override
  void onInit() {
    super.onInit();
    fetchCoupons();
  }

  /// 当前 Tab 对应接口参数
  int get currentDisableStatus {
    final index = selectedTabIndex.value;
    if (index < 0 || index >= tabDisableStatusValues.length) return 0;
    return tabDisableStatusValues[index];
  }

  /// 搜索优惠券名称
  void onSearchChanged(String value) {
    keyword.value = value.trim();
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), fetchCoupons);
  }

  /// 切换顶部 Tab
  Future<void> selectTab(int index) async {
    if (selectedTabIndex.value == index) return;
    selectedTabIndex.value = index;
    await fetchCoupons();
  }

  /// 获取我的优惠券列表
  Future<void> fetchCoupons() async {
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      final result = await ApiRequest.myCoupons(
        couponName: keyword.value,
        disableStatus: currentDisableStatus,
      );
      coupons.assignAll(result);
    } finally {
      isLoading.value = false;
    }
  }

  /// 新增优惠券
  Future<void> addCoupon() async {
    final changed = await Get.toNamed(Pages.publishCoupon);
    if (changed == true) {
      await fetchCoupons();
    }
  }

  /// 编辑优惠券
  Future<void> editCoupon(StoreCouponResponse coupon) async {
    final changed = await Get.toNamed(Pages.publishCoupon, arguments: coupon);
    if (changed == true) {
      await fetchCoupons();
    }
  }

  /// 下架优惠券
  Future<void> disableCoupon(StoreCouponResponse coupon) async {
    final success = await ApiRequest.updateCoupons(
      request: CouponRequest.fromCoupon(coupon, disableStatus: 1),
    );
    if (success) await fetchCoupons();
  }

  /// 重新上架优惠券
  Future<void> enableCoupon(StoreCouponResponse coupon) async {
    final success = await ApiRequest.updateCoupons(
      request: CouponRequest.fromCoupon(coupon, disableStatus: 0),
    );
    if (success) await fetchCoupons();
  }

  /// 删除优惠券
  Future<void> deleteCoupon(StoreCouponResponse coupon) async {
    final success = await ApiRequest.updateCoupons(
      request: CouponRequest.fromCoupon(coupon, isDeleted: 1),
    );
    if (success) await fetchCoupons();
  }

  @override
  void onClose() {
    _searchDebounce?.cancel();
    searchController.dispose();
    super.onClose();
  }
}
