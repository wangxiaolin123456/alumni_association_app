import 'package:alumni_association_app/app/api/api_request.dart';
import 'package:alumni_association_app/features/merchant/center/pages/controller/merchant_dashboard_controller.dart';
import 'package:alumni_association_app/features/merchant/statistics/model/order_summary_response.dart';
import 'package:alumni_association_app/features/store/model/response/store_response.dart';
import 'package:get/get.dart';

/// 商户数据统计 Controller。
///
/// 统计页走 `/api/order/orderSum`，接口返回从年初到查询月份的月度数组。
/// 页面所需的核心概览、趋势图、明细行都从这份数组中派生。
class MerchantStatisticsController extends GetxController {
  /// 当前统计月份。
  final selectedMonth = DateTime.now().obs;

  /// 趋势图当前指标：0 订单数，1 实收金额，2 优惠金额。
  final trendTabIndex = 0.obs;

  /// 接口返回的月度统计列表。
  final summaries = <OrderSummaryResponse>[].obs;

  /// 页面加载状态。
  final isLoading = false.obs;

  /// 当前商户 id。
  late final int shopId = _resolveShopId();

  /// 当前选中月份对应的统计项。
  OrderSummaryResponse get currentSummary {
    final key = dateParam;
    return summaries.firstWhereOrNull((item) => item.month == key) ??
        const OrderSummaryResponse(
          month: '',
          orderCount: 0,
          orderCountGrowth: null,
          orderCountGrowthDesc: '',
          actualTotal: 0,
          actualTotalGrowth: null,
          actualTotalGrowthDesc: '',
          reduceAmount: 0,
          reduceAmountGrowth: null,
          reduceAmountGrowthDesc: '',
        );
  }

  /// 当前月份接口参数，格式：yyyy-MM。
  String get dateParam => _dateParam(selectedMonth.value);

  /// 核心指标。
  List<MerchantStatisticMetric> get metrics {
    final item = currentSummary;
    return [
      MerchantStatisticMetric(
        icon: 0xe873,
        key: MerchantStatisticMetricKey.orderCount,
        value: item.orderCount.toDouble(),
        displayValue: item.orderCount.toString(),
        growth: item.orderCountGrowth,
        growthDesc: item.orderCountGrowthDesc,
      ),
      MerchantStatisticMetric(
        icon: 0xe227,
        key: MerchantStatisticMetricKey.receivedAmount,
        value: item.actualTotal,
        displayValue: _formatMoney(item.actualTotal),
        growth: item.actualTotalGrowth,
        growthDesc: item.actualTotalGrowthDesc,
      ),
      MerchantStatisticMetric(
        icon: 0xe53e,
        key: MerchantStatisticMetricKey.discountAmount,
        value: item.reduceAmount,
        displayValue: _formatMoney(item.reduceAmount),
        growth: item.reduceAmountGrowth,
        growthDesc: item.reduceAmountGrowthDesc,
      ),
    ];
  }

  /// 趋势图数据。
  List<MerchantTrendPoint> get trendPoints {
    return summaries.map((item) {
      return MerchantTrendPoint(
        label: _monthLabel(item.month),
        value: _trendValue(item),
      );
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    loadStatistics();
  }

  /// 加载统计数据。
  Future<void> loadStatistics() async {
    if (isLoading.value) return;
    if (shopId <= 0) {
      summaries.clear();
      return;
    }

    isLoading.value = true;
    try {
      final result = await ApiRequest.orderSum(
        shopId: shopId,
        dateParam: dateParam,
      );
      summaries.assignAll(result);
    } finally {
      isLoading.value = false;
    }
  }

  /// 切换上一月。
  void previousMonth() {
    selectedMonth.value = DateTime(
      selectedMonth.value.year,
      selectedMonth.value.month - 1,
    );
    loadStatistics();
  }

  /// 切换下一月。
  void nextMonth() {
    selectedMonth.value = DateTime(
      selectedMonth.value.year,
      selectedMonth.value.month + 1,
    );
    loadStatistics();
  }

  /// 选择趋势指标。
  void selectTrendTab(int index) {
    trendTabIndex.value = index;
  }

  double _trendValue(OrderSummaryResponse item) {
    return switch (trendTabIndex.value) {
      1 => item.actualTotal,
      2 => item.reduceAmount,
      _ => item.orderCount.toDouble(),
    };
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

  String _dateParam(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$year-$month';
  }

  String _monthLabel(String month) {
    final parts = month.split('-');
    if (parts.length != 2) return month;
    final parsed = int.tryParse(parts.last);
    if (parsed == null) return month;
    return '$parsed月';
  }

  String _formatMoney(double value) {
    final fixed = value.toStringAsFixed(2);
    final parts = fixed.split('.');
    final integer = parts.first.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => ',',
    );
    return '$integer.${parts.last}';
  }
}

enum MerchantStatisticMetricKey { orderCount, receivedAmount, discountAmount }

class MerchantStatisticMetric {
  const MerchantStatisticMetric({
    required this.icon,
    required this.key,
    required this.value,
    required this.displayValue,
    required this.growth,
    required this.growthDesc,
  });

  final int icon;
  final MerchantStatisticMetricKey key;
  final double value;
  final String displayValue;
  final double? growth;
  final String growthDesc;

  bool get increased => (growth ?? 0) >= 0;

  String get normalizedGrowthDesc {
    final text = growthDesc.trim();
    if (text.isNotEmpty) return text;
    if (growth == null) return '-';
    if (growth == 0) return '-';
    final prefix = growth! > 0 ? '+' : '';
    return '$prefix${growth!.toStringAsFixed(2)}%';
  }
}

class MerchantTrendPoint {
  const MerchantTrendPoint({required this.label, required this.value});

  final String label;
  final double value;
}
