class ApiBizException implements Exception {
  final int? code;
  final String message;
  ApiBizException({this.code, required this.message});

  @override
  String toString() => 'ApiBizException(code=$code, message=$message)';
}