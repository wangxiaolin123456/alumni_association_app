/// 商户订单统计接口返回项。
///
/// 对应 `/api/order/orderSum` 返回数组中的每个月份数据。
class OrderSummaryResponse {
  const OrderSummaryResponse({
    required this.month,
    required this.orderCount,
    required this.orderCountGrowth,
    required this.orderCountGrowthDesc,
    required this.actualTotal,
    required this.actualTotalGrowth,
    required this.actualTotalGrowthDesc,
    required this.reduceAmount,
    required this.reduceAmountGrowth,
    required this.reduceAmountGrowthDesc,
  });

  /// 月份，格式 yyyy-MM。
  final String month;

  /// 订单数。
  final int orderCount;

  /// 订单数环比。
  final double? orderCountGrowth;

  /// 订单数环比描述。
  final String orderCountGrowthDesc;

  /// 实付金额。
  final double actualTotal;

  /// 实付金额环比。
  final double? actualTotalGrowth;

  /// 实付金额环比描述。
  final String actualTotalGrowthDesc;

  /// 优惠金额。
  final double reduceAmount;

  /// 优惠金额环比。
  final double? reduceAmountGrowth;

  /// 优惠金额环比描述。
  final String reduceAmountGrowthDesc;

  factory OrderSummaryResponse.fromJson(Map<String, dynamic> json) {
    return OrderSummaryResponse(
      month: _stringValue(json['month']),
      orderCount: _intValue(json['orderCount']),
      orderCountGrowth: _nullableDouble(json['orderCountGrowth']),
      orderCountGrowthDesc: _stringValue(json['orderCountGrowthDesc']),
      actualTotal: _doubleValue(json['actualTotal']),
      actualTotalGrowth: _nullableDouble(json['actualTotalGrowth']),
      actualTotalGrowthDesc: _stringValue(json['actualTotalGrowthDesc']),
      reduceAmount: _doubleValue(json['reduceAmount']),
      reduceAmountGrowth: _nullableDouble(json['reduceAmountGrowth']),
      reduceAmountGrowthDesc: _stringValue(json['reduceAmountGrowthDesc']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'orderCount': orderCount,
      'orderCountGrowth': orderCountGrowth,
      'orderCountGrowthDesc': orderCountGrowthDesc,
      'actualTotal': actualTotal,
      'actualTotalGrowth': actualTotalGrowth,
      'actualTotalGrowthDesc': actualTotalGrowthDesc,
      'reduceAmount': reduceAmount,
      'reduceAmountGrowth': reduceAmountGrowth,
      'reduceAmountGrowthDesc': reduceAmountGrowthDesc,
    };
  }

  static String _stringValue(Object? value) => value?.toString() ?? '';

  static int _intValue(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static double _doubleValue(Object? value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  static double? _nullableDouble(Object? value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
