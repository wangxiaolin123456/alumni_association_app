/// Merchant item returned by the consumption-entry merchant API.
class ConsumptionMerchantResponse {
  const ConsumptionMerchantResponse({
    required this.id,
    required this.name,
    required this.category,
    required this.distance,
    required this.rating,
    required this.accentColors,
  });

  final String id;
  final String name;
  final String category;
  final String distance;
  final double rating;
  final List<int> accentColors;
}

/// Coupon item returned by the consumption-entry coupon API.
class ConsumptionCouponResponse {
  const ConsumptionCouponResponse({
    required this.id,
    required this.title,
    required this.rule,
    required this.validity,
    required this.type,
    required this.value,
    required this.minimumAmount,
    required this.badge,
  });

  final String id;
  final String title;
  final String rule;
  final String validity;
  final String type;
  final double value;
  final double minimumAmount;
  final String badge;
}

/// Submission result returned after a consumption entry is created.
class ConsumptionOrderResponse {
  const ConsumptionOrderResponse({
    required this.orderNumber,
    required this.submittedAt,
  });

  final String orderNumber;
  final String submittedAt;
}
