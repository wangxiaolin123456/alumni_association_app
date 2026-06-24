import 'model/factory.dart';

///接口应该要改 统一data返回
class ApiResponse<T> {
  T? data;
  Map<String, dynamic> raw = {};
  late int code;
  late String msg;

  ApiResponse({
    required this.code,
    required this.msg,
    this.data,
    Map<String, dynamic>? originalJson,
  }) {
    if (originalJson != null) {
      raw = originalJson;
    }
  }

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    final res = ApiResponse<T>(
      code: json['code'] ?? -1,
      msg: json['msg'] ?? '',
      originalJson: json,
    );
    if(json['code'] == 200){
      // 优先使用通用 data 字段解析（如果有）
      if (json['data'] != null && json['data'] != 'null') {
        res.data = FactoryModel.generateModel<T>(json['data']);
      }
      // 如果没有 data 字段，就用整个 json 传给 T 的解析器
      else {
        res.data = FactoryModel.generateModel<T>(json);
      }
    }
    return res;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data;
    }
    data['code'] = this.code;
    data['message'] = this.msg;
    return data;
  }
}