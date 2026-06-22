/// Contract implemented by request parameter models.
abstract interface class JsonRequest {
  Map<String, dynamic> toJson();
}

/// 通用 Map 请求参数。
/// 用于不想单独创建 Request 类的简单接口参数。
class MapJsonRequest implements JsonRequest {
  const MapJsonRequest(this.map);

  final Map<String, dynamic> map;

  @override
  Map<String, dynamic> toJson() => map;
}