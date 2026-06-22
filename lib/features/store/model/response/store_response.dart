/// Merchant data returned by the store-list and store-detail APIs.
class StoreResponse {
  const StoreResponse({
    required this.id,
    required this.name,
    required this.address,
    required this.category,
    required this.distance,
    required this.rating,
    required this.monthlySales,
    required this.accentColors,
    required this.offers,
    this.imageUrls = const [],
  });

  final String id;
  final String name;
  final String address;
  final String category;
  final String distance;
  final double rating;
  final int monthlySales;
  final List<int> accentColors;
  final List<StoreOfferResponse> offers;
  /// 商家详情轮播图

  final List<String> imageUrls;
  factory StoreResponse.fromJson(Map<String, dynamic> json) {
    return StoreResponse(
      id: _stringValue(json['id']),
      name: _stringValue(json['name']),
      address: _stringValue(json['address']),
      category: _stringValue(json['category']),
      distance: _stringValue(json['distance']),
      rating: _doubleValue(json['rating']),
      monthlySales: _intValue(json['monthlySales']),
      accentColors: _intListValue(json['accentColors']),
      offers: _offerListValue(json['offers']),
      imageUrls: (json['imageUrls'] as List<dynamic>?)
          ?.map((item) => item.toString())
          .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'category': category,
      'distance': distance,
      'rating': rating,
      'monthlySales': monthlySales,
      'accentColors': accentColors,
      'offers': offers.map((item) => item.toJson()).toList(),
      'imageUrls': imageUrls.map((url) => url).toList(),
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

  static int _intValue(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static List<int> _intListValue(Object? value) {
    if (value is List) {
      return value.map((item) => _intValue(item)).toList();
    }
    return <int>[];
  }

  static List<StoreOfferResponse> _offerListValue(Object? value) {
    if (value is List) {
      return value
          .whereType<Map<String, dynamic>>()
          .map(StoreOfferResponse.fromJson)
          .toList();
    }
    return <StoreOfferResponse>[];
  }
}

/// Preferential product or service returned by a merchant API.
class StoreOfferResponse {
  const StoreOfferResponse({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.originalPrice,
    required this.discountLabel,
  });

  final String id;
  final String title;
  final String subtitle;
  final double price;
  final double originalPrice;
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