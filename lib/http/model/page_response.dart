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

  bool get hasMore => pageNum * pageSize < total;

}