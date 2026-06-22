/// Standard API envelope returned by the backend.
///
/// [raw] keeps the original payload available for logging and troubleshooting,
/// while business code normally only consumes the typed [data] field.
class ApiResponse<T> {
  const ApiResponse({
    required this.code,
    required this.message,
    required this.data,
    required this.raw,
  });

  final int code;
  final String message;
  final T? data;
  final Map<String, dynamic> raw;

  bool get isSuccess => code == 0 || code == 200;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json)? parser,
  ) {
    final rawCode = json['code'];
    return ApiResponse<T>(
      code: rawCode is int ? rawCode : int.tryParse('$rawCode') ?? -1,
      message: '${json['message'] ?? json['msg'] ?? ''}',
      data: parser == null ? json['data'] as T? : parser(json['data']),
      raw: json,
    );
  }
}
