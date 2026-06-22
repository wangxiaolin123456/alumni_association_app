/// Activity item returned by the member-home activity API.
class PopularActivityResponse {
  const PopularActivityResponse({
    required this.id,
    required this.title,
    required this.date,
    required this.location,
    required this.registeredCount,
    required this.gradientColors,
  });

  final String id;
  final String title;
  final String date;
  final String location;
  final int registeredCount;
  final List<int> gradientColors;

  factory PopularActivityResponse.fromJson(Map<String, dynamic> json) {
    return PopularActivityResponse(
      id: '${json['id'] ?? ''}',
      title: '${json['title'] ?? ''}',
      date: '${json['date'] ?? ''}',
      location: '${json['location'] ?? ''}',
      registeredCount: json['registeredCount'] as int? ?? 0,
      gradientColors:
          (json['gradientColors'] as List<dynamic>?)
              ?.map((color) => color as int)
              .toList() ??
          const [0xFF073CCA, 0xFF1687E8],
    );
  }
}
