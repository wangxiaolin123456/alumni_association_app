import 'package:get/get.dart';

/// 商户数据统计 Controller。
///
/// 当前后端统计接口未提供，先把页面所需数据集中放在 Controller，
/// 后续接接口时只需要替换 `loadStatistics` 内的数据来源。
class MerchantStatisticsController extends GetxController {
  /// 当前统计月份
  final selectedMonth = DateTime(2024, 5).obs;

  /// 趋势图当前指标
  final trendTabIndex = 0.obs;

  /// 渠道占比当前指标
  final channelMetricIndex = 0.obs;

  /// 核心指标
  final metrics = <MerchantStatisticMetric>[].obs;

  /// 趋势数据
  final trendPoints = <MerchantTrendPoint>[].obs;

  /// 渠道数据
  final channels = <MerchantChannelRatio>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadStatistics();
  }

  /// 加载统计数据。
  ///
  /// 这里先用设计图假数据，结构已经按接口返回可替换的方式组织。
  Future<void> loadStatistics() async {
    metrics.assignAll(const [
      MerchantStatisticMetric(
        iconCodePoint: 0xe873,
        titleKey: MerchantStatisticMetricKey.orderCount,
        value: '56',
        changeText: '+12.45%',
        increased: true,
      ),
      MerchantStatisticMetric(
        iconCodePoint: 0xe227,
        titleKey: MerchantStatisticMetricKey.receivedAmount,
        value: '12,345.67',
        changeText: '+8.21%',
        increased: true,
      ),
      MerchantStatisticMetric(
        iconCodePoint: 0xe7fd,
        titleKey: MerchantStatisticMetricKey.memberCount,
        value: '2,345',
        changeText: '+6.32%',
        increased: true,
      ),
      MerchantStatisticMetric(
        iconCodePoint: 0xe53e,
        titleKey: MerchantStatisticMetricKey.discountAmount,
        value: '5,678.90',
        changeText: '-6.21%',
        increased: false,
      ),
    ]);

    trendPoints.assignAll(const [
      MerchantTrendPoint(label: '12月', value: 28),
      MerchantTrendPoint(label: '1月', value: 36),
      MerchantTrendPoint(label: '2月', value: 45),
      MerchantTrendPoint(label: '3月', value: 52),
      MerchantTrendPoint(label: '4月', value: 49),
      MerchantTrendPoint(label: '5月', value: 56),
    ]);

    channels.assignAll(const [
      MerchantChannelRatio(
        nameKey: MerchantStatisticsChannelKey.storeVerification,
        value: 58,
      ),
      MerchantChannelRatio(
        nameKey: MerchantStatisticsChannelKey.memberReservation,
        value: 26,
      ),
      MerchantChannelRatio(
        nameKey: MerchantStatisticsChannelKey.activityConversion,
        value: 16,
      ),
    ]);
  }

  /// 切换上一月
  void previousMonth() {
    selectedMonth.value = DateTime(
      selectedMonth.value.year,
      selectedMonth.value.month - 1,
    );
    loadStatistics();
  }

  /// 切换下一月
  void nextMonth() {
    selectedMonth.value = DateTime(
      selectedMonth.value.year,
      selectedMonth.value.month + 1,
    );
    loadStatistics();
  }

  /// 选择趋势指标
  void selectTrendTab(int index) {
    trendTabIndex.value = index;
  }

  /// 选择渠道统计指标
  void selectChannelMetric(int index) {
    channelMetricIndex.value = index;
  }
}

enum MerchantStatisticMetricKey {
  orderCount,
  receivedAmount,
  memberCount,
  discountAmount,
}

enum MerchantStatisticsChannelKey {
  storeVerification,
  memberReservation,
  activityConversion,
}

class MerchantStatisticMetric {
  const MerchantStatisticMetric({
    required this.iconCodePoint,
    required this.titleKey,
    required this.value,
    required this.changeText,
    required this.increased,
  });

  final int iconCodePoint;
  final MerchantStatisticMetricKey titleKey;
  final String value;
  final String changeText;
  final bool increased;
}

class MerchantTrendPoint {
  const MerchantTrendPoint({required this.label, required this.value});

  final String label;
  final double value;
}

class MerchantChannelRatio {
  const MerchantChannelRatio({required this.nameKey, required this.value});

  final MerchantStatisticsChannelKey nameKey;
  final double value;
}
