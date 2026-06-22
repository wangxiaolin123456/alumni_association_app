class MerchantBenefitResponse {
  const MerchantBenefitResponse({
    required this.id,
    required this.merchantName,
    required this.category,
    required this.address,
    required this.distance,
    required this.offers,
    required this.accentColor,
  });

  final String id;
  final String merchantName;
  final String category;
  final String address;
  final String distance;
  final List<String> offers;
  final int accentColor;
}
