class ProfileServiceItem {
  const ProfileServiceItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.meta,
    required this.status,
    required this.iconCode,
    required this.color,
  });

  final String id;
  final String title;
  final String subtitle;
  final String meta;
  final String status;
  final int iconCode;
  final int color;

  factory ProfileServiceItem.fromJson(Map<String, dynamic> json) {
    return ProfileServiceItem(
      id: '${json['id'] ?? ''}',
      title: '${json['title'] ?? ''}',
      subtitle: '${json['subtitle'] ?? ''}',
      meta: '${json['meta'] ?? ''}',
      status: '${json['status'] ?? ''}',
      iconCode: _intValue(json['iconCode']),
      color: _intValue(json['color']),
    );
  }

  static int _intValue(Object? value) =>
      value is num ? value.toInt() : int.tryParse('$value') ?? 0;
}
