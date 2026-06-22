/// Opportunity data returned by opportunity-list and detail APIs.
class OpportunityResponse {
  const OpportunityResponse({
    required this.id,
    required this.title,
    required this.summary,
    required this.category,
    required this.industry,
    required this.region,
    required this.budget,
    required this.publishedAt,
    required this.expiresAt,
    required this.views,
    required this.favorites,
    required this.status,
    required this.accentColors,
    required this.requirements,
  });

  final String id;
  final String title;
  final String summary;
  final String category;
  final String industry;
  final String region;
  final String budget;
  final String publishedAt;
  final String expiresAt;
  final int views;
  final int favorites;
  final String status;
  final List<int> accentColors;
  final List<String> requirements;

  factory OpportunityResponse.fromJson(Map<String, dynamic> json) {
    return OpportunityResponse(
      id: '${json['id'] ?? ''}',
      title: '${json['title'] ?? ''}',
      summary: '${json['summary'] ?? ''}',
      category: '${json['category'] ?? ''}',
      industry: '${json['industry'] ?? ''}',
      region: '${json['region'] ?? ''}',
      budget: '${json['budget'] ?? ''}',
      publishedAt: '${json['publishedAt'] ?? ''}',
      expiresAt: '${json['expiresAt'] ?? ''}',
      views: _intValue(json['views']),
      favorites: _intValue(json['favorites']),
      status: '${json['status'] ?? ''}',
      accentColors: _intList(json['accentColors']),
      requirements: _stringList(json['requirements']),
    );
  }

  static int _intValue(Object? value) =>
      value is num ? value.toInt() : int.tryParse('$value') ?? 0;
  static List<int> _intList(Object? value) =>
      value is List ? value.map(_intValue).toList() : <int>[];
  static List<String> _stringList(Object? value) =>
      value is List ? value.map((item) => '$item').toList() : <String>[];
}
