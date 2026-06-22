/// Merchant item returned by the member-home recommendation API.
class RecommendedMerchantResponse {
  const RecommendedMerchantResponse({
    required this.id,
    required this.name,
    required this.location,
    required this.category,
    required this.distance,
    required this.visualType,
    required this.gradientColors,
  });

  final String id;
  final String name;
  final String location;
  final String category;
  final String distance;

  /// Temporary presentation hint used until the API provides merchant images.
  final String visualType;
  final List<int> gradientColors;

  factory RecommendedMerchantResponse.fromJson(Map<String, dynamic> json) {
    return RecommendedMerchantResponse(
      id: '${json['id'] ?? ''}',
      name: '${json['name'] ?? ''}',
      location: '${json['location'] ?? ''}',
      category: '${json['category'] ?? ''}',
      distance: '${json['distance'] ?? ''}',
      visualType: '${json['visualType'] ?? 'store'}',
      gradientColors:
          (json['gradientColors'] as List<dynamic>?)
              ?.map((color) => color as int)
              .toList() ??
          const [0xFF0967F2, 0xFF78B7EA],
    );
  }
}
