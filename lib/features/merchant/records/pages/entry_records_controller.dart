import 'package:alumni_association_app/app/api/api_request.dart';
import 'package:alumni_association_app/features/consumption/model/response/order_response.dart';
import 'package:alumni_association_app/features/merchant/center/pages/controller/merchant_dashboard_controller.dart';
import 'package:alumni_association_app/features/store/model/response/store_response.dart';
import 'package:get/get.dart';

/// 入单记录控制器。
///
/// 商家端入单记录直接走 `/api/order/shopOrder`，分页、顶部 Tab 筛选、
/// 详情请求都集中在 controller，页面只负责展示。
class EntryRecordsController extends GetxController {
  /// 顶部 Tab：0 全部，1 待使用，2 已使用，3 已取消。
  final selectedTab = 0.obs;

  /// 入单记录列表。
  final records = <OrderResponse>[].obs;

  /// 当前详情页订单。
  final detailOrder = Rxn<OrderResponse>();

  /// 是否正在加载列表。
  final isLoading = false.obs;

  /// 是否正在加载详情。
  final isDetailLoading = false.obs;

  /// 是否还有更多。
  final hasMore = true.obs;

  /// 当前商户 id。
  late final int shopId = _resolveShopId();

  int pageNum = 1;
  final int pageSize = 10;

  /// 应收合计，仅统计当前已加载列表。
  double get receivableTotal =>
      records.fold(0, (sum, item) => sum + item.total);

  /// 实付合计，仅统计当前已加载列表。
  double get paidTotal =>
      records.fold(0, (sum, item) => sum + item.actualTotal);

  /// 当前接口筛选状态。
  ///
  /// null = 全部；0 = 待使用；1 = 已使用；2 = 已取消。
  int? get currentOrderStatus {
    return switch (selectedTab.value) {
      1 => 0,
      2 => 1,
      3 => 2,
      _ => null,
    };
  }

  @override
  void onInit() {
    super.onInit();
    fetchInitial();
  }

  /// 切换顶部 Tab，并重新拉取第一页。
  Future<void> switchTab(int index) async {
    if (selectedTab.value == index) return;
    selectedTab.value = index;
    await fetchInitial();
  }

  /// 下拉刷新。
  Future<void> fetchInitial() async {
    pageNum = 1;
    hasMore.value = true;
    await fetchRecords(isRefresh: true);
  }

  /// 上拉加载更多。
  Future<void> loadMore() async {
    if (!hasMore.value || isLoading.value) return;
    await fetchRecords();
  }

  /// 获取商家入单记录列表。
  Future<void> fetchRecords({bool isRefresh = false}) async {
    if (isLoading.value) return;

    if (shopId <= 0) {
      records.clear();
      hasMore.value = false;
      return;
    }

    isLoading.value = true;
    try {
      final result = await ApiRequest.shopOrders(
        shopId: shopId,
        orderStatus: currentOrderStatus,
        pageNum: pageNum,
        pageSize: pageSize,
      );

      if (result == null) {
        if (isRefresh) records.clear();
        hasMore.value = false;
        return;
      }

      if (isRefresh) {
        records.assignAll(result.rows);
      } else {
        records.addAll(result.rows);
      }

      hasMore.value = records.length < result.total;
      if (hasMore.value) pageNum++;
    } finally {
      isLoading.value = false;
    }
  }

  /// 获取入单记录详情。
  ///
  /// 列表返回的数据可能不是完整详情，点击卡片后再通过订单详情接口刷新一次。
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
      if (result != null) {
        detailOrder.value = result;
      }
    } finally {
      isDetailLoading.value = false;
    }
  }

  /// 解析商户 id。
  ///
  /// 支持从路由参数传 int/String/StoreResponse，也支持从商家首页 controller 兜底读取。
  int _resolveShopId() {
    final args = Get.arguments;
    if (args is StoreResponse) return args.shopId;
    if (args is int) return args;
    if (args is String) return int.tryParse(args) ?? 0;
    if (args is Map) {
      final raw = args['shopId'];
      if (raw is int) return raw;
      final parsed = int.tryParse(raw?.toString() ?? '');
      if (parsed != null) return parsed;
    }

    if (Get.isRegistered<MerchantDashboardController>()) {
      final dashboard = Get.find<MerchantDashboardController>();
      return dashboard.currentStore.value?.shopId ?? dashboard.shopId ?? 0;
    }

    return 0;
  }
}
