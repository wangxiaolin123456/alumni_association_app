class MemberRecordResponse {
  const MemberRecordResponse({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.meta,
    required this.status,
    required this.accentColors,
  });

  final String id;
  final String title;
  final String subtitle;
  final String meta;
  final String status;
  final List<int> accentColors;

  factory MemberRecordResponse.fromJson(Map<String, dynamic> json) {
    return MemberRecordResponse(
      id: '${json['id'] ?? ''}',
      title: '${json['title'] ?? ''}',
      subtitle: '${json['subtitle'] ?? ''}',
      meta: '${json['meta'] ?? ''}',
      status: '${json['status'] ?? ''}',
      accentColors: json['accentColors'] is List
          ? (json['accentColors'] as List)
                .map((item) => item is num ? item.toInt() : 0)
                .toList()
          : <int>[],
    );
  }
}
