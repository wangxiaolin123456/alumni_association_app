/// Activity data returned by activity-list and activity-detail APIs.
class ActivityResponse {
  const ActivityResponse({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.date,
    required this.timeRange,
    required this.location,
    required this.address,
    required this.registeredCount,
    required this.capacity,
    required this.isFree,
    required this.accentColors,
  });

  final String id;
  final String title;
  final String subtitle;
  final String category;
  final String date;
  final String timeRange;
  final String location;
  final String address;
  final int registeredCount;
  final int capacity;
  final bool isFree;
  final List<int> accentColors;

  factory ActivityResponse.fromJson(Map<String, dynamic> json) {
    return ActivityResponse(
      id: _stringValue(json['id']),
      title: _stringValue(json['title']),
      subtitle: _stringValue(json['subtitle']),
      category: _stringValue(json['category']),
      date: _stringValue(json['date']),
      timeRange: _stringValue(json['timeRange']),
      location: _stringValue(json['location']),
      address: _stringValue(json['address']),
      registeredCount: _intValue(json['registeredCount']),
      capacity: _intValue(json['capacity']),
      isFree: _boolValue(json['isFree']),
      accentColors: _intListValue(json['accentColors']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'category': category,
      'date': date,
      'timeRange': timeRange,
      'location': location,
      'address': address,
      'registeredCount': registeredCount,
      'capacity': capacity,
      'isFree': isFree,
      'accentColors': accentColors,
    };
  }

  static String _stringValue(Object? value) => value?.toString() ?? '';

  static int _intValue(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static bool _boolValue(Object? value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    return false;
  }

  static List<int> _intListValue(Object? value) {
    if (value is List) {
      return value.map(_intValue).toList();
    }
    return <int>[];
  }
}
