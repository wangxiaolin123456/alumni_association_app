/// 商家优惠 / 套餐假数据模型
///
/// 当前商户列表接口暂时没有返回优惠数据，
/// 但商家详情页、预约页还在使用 selectedOffer，
/// 所以这里先保留该模型，后续接优惠券接口时再替换成真实数据。
class StoreOfferResponse {
  const StoreOfferResponse({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.originalPrice,
    required this.discountLabel,
  });

  /// 优惠ID
  final String id;

  /// 优惠标题
  final String title;

  /// 优惠说明
  final String subtitle;

  /// 当前价格
  final double price;

  /// 原价
  final double originalPrice;

  /// 折扣文案
  final String discountLabel;

  factory StoreOfferResponse.fromJson(Map<String, dynamic> json) {
    return StoreOfferResponse(
      id: _stringValue(json['id']),
      title: _stringValue(json['title']),
      subtitle: _stringValue(json['subtitle']),
      price: _doubleValue(json['price']),
      originalPrice: _doubleValue(json['originalPrice']),
      discountLabel: _stringValue(json['discountLabel']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'price': price,
      'originalPrice': originalPrice,
      'discountLabel': discountLabel,
    };
  }

  static String _stringValue(Object? value) {
    if (value == null) return '';
    return value.toString();
  }

  static double _doubleValue(Object? value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}