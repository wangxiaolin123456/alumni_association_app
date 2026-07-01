import 'package:alumni_association_app/app/router/app_router.dart';
import 'package:alumni_association_app/app/api/api_request.dart';
import 'package:alumni_association_app/features/store/model/response/store_response.dart';
import 'package:get/get.dart';

/// 商户工作台 Controller
class MerchantDashboardController extends GetxController {
  /// 路由传入的商户 id。
  ///
  /// 从“我的商户”列表进入时会传 shopId；如果没有传，则兜底取我的商户列表第一条。
  late final int? shopId = _parseShopId(Get.arguments);

  /// 当前商户
  final currentStore = Rxn<StoreResponse>();

  /// 是否加载中
  final isLoading = false.obs;

  /// 当前底部 Tab
  final currentTabIndex = 0.obs;

  /// 当前选择的统计月份
  final selectedMonth = DateTime.now().obs;

  /// 是否选择过月份
  final hasSelectedMonth = false.obs;

  /// 顶部按钮显示文字
  String get selectedMonthText {
    if (!hasSelectedMonth.value) {
      return '';
    }

    return _dateParam(selectedMonth.value);
  }

  /// 从路由参数中解析 shopId，兼容 int / String / StoreResponse 三种形态。
  static int? _parseShopId(dynamic arguments) {
    if (arguments is StoreResponse) return arguments.shopId;
    if (arguments is! Map) return null;
    final raw = arguments['shopId'];
    if (raw is int) return raw;
    return int.tryParse(raw?.toString() ?? '');
  }

  /// 可选月份列表
  ///
  /// 当前月往前推 24 个月
  List<DateTime> get selectableMonths {
    final now = DateTime.now();

    return List.generate(24, (index) {
      return DateTime(now.year, now.month - index, 1);
    });
  }

  /// 选择月份
  void selectMonth(DateTime date) {
    selectedMonth.value = DateTime(date.year, date.month, 1);
    hasSelectedMonth.value = true;

    loadOverviewByMonth();
  }

  /// 重新请求经营概览
  Future<void> loadOverviewByMonth() async {
    await loadDashboard();
  }

  ///数据部分
  final businessData = Rxn<StoreOrderStatisticsResponse>();

  @override
  void onInit() {
    super.onInit();
    loadDashboard();
  }

  /// 加载商户工作台数据
  Future<void> loadDashboard() async {
    isLoading.value = true;

    try {
      final store = await _loadMerchantInfo();
      if (store != null) {
        currentStore.value = store;
        businessData.value = store.orderStatistics;
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// 获取当前工作台对应的商户信息和经营统计。
  ///
  /// 有 shopId：直接请求工作台接口；
  Future<StoreResponse?> _loadMerchantInfo() async {
    final targetShopId = currentStore.value?.shopId ?? shopId;
    if (targetShopId == null) {
      return null;
    }
    final dateParam = _dateParam(selectedMonth.value);

    if (targetShopId > 0) {
      return ApiRequest.myMerchantInfo(
        shopId: targetShopId,
        dateParam: dateParam,
      );
    }
    return null;
  }

  /// 下拉刷新
  Future<void> refreshDashboard() async {
    await loadDashboard();
  }

  /// 新增商户
  void addMerchant() {
    Get.toNamed(Pages.merchantOnboardingPage);
  }

  /// 修改商户信息
  void editMerchantInfo() {
    final store = currentStore.value;
    if (store == null || store.shopId <= 0) {
      Get.toNamed(Pages.merchantOnboardingPage);
      return;
    }

    /// 复用商户入驻页面作为编辑页。
    /// 这里把完整 StoreResponse 传进去，编辑页可以直接回填字段和图片入参。
    Get.toNamed(
      Pages.merchantOnboardingPage,
      arguments: {'shopId': store.shopId, 'store': store},
    );
  }

  /// 入单记录
  void openEntryRecords() {
    final store = currentStore.value;
    Get.toNamed(
      Pages.entryRecordsPage,
      arguments: {'shopId': store?.shopId ?? shopId ?? 0},
    );
  }

  /// 数据统计
  void openStatistics() {
    Get.toNamed(Pages.merchantStatistics);
  }

  /// 优惠券管理
  void openCouponManagement() {
    Get.toNamed(Pages.couponManagement);
  }

  /// 接口月份参数，格式：yyyy-MM。
  String _dateParam(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$year-$month';
  }
}
