/// 分页接口统一返回模型。
class PageResponse<T> {
  const PageResponse({
    required this.rows,
    required this.total,
    required this.pageNum,
    required this.pageSize,
  });

  final List<T> rows;
  final int total;
  final int pageNum;
  final int pageSize;

  /// 当前页之后是否仍有数据。
  bool get hasMore => pageNum * pageSize < total;

  factory PageResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) parser,
  ) {
    final rawRows = json['rows'];

    return PageResponse<T>(
      rows: rawRows is List
          ? rawRows.map((item) => parser(item)).toList()
          : <T>[],
      total: _parseInt(json['total']),
      pageNum: _parseInt(json['pageNum']),
      pageSize: _parseInt(json['pageSize']),
    );
  }

  static int _parseInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
