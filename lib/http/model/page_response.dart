class PageResponse<T> {
  final List<T> rows;

  final int total;

  final int pageNum;

  final int pageSize;

  const PageResponse({
    required this.rows,
    required this.total,
    required this.pageNum,
    required this.pageSize,
  });

  /// 是否还有更多数据
  bool get hasMore => pageNum * pageSize < total;

  /// 分页数据解析
  ///
  /// 用法：
  /// PageResponse<StoreResponse>.fromJson(
  ///   json,
  ///   (item) => StoreResponse.fromJson(item),
  /// );
  factory PageResponse.fromJson(
      Map<String, dynamic> json,
      T Function(Map<String, dynamic> json) fromJsonT,
      ) {
    final rowsRaw = json['rows'];

    return PageResponse<T>(
      rows: rowsRaw is List
          ? rowsRaw
          .whereType<Map>()
          .map(
            (item) => fromJsonT(
          Map<String, dynamic>.from(item),
        ),
      )
          .toList()
          : <T>[],
      total: _intValue(json['total']),
      pageNum: _intValue(json['pageNum']),
      pageSize: _intValue(json['pageSize']),
    );
  }

  Map<String, dynamic> toJson(
      Map<String, dynamic> Function(T item) toJsonT,
      ) {
    return {
      'rows': rows.map(toJsonT).toList(),
      'total': total,
      'pageNum': pageNum,
      'pageSize': pageSize,
    };
  }

  static int _intValue(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}