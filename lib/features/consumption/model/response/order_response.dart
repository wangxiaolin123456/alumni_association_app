import 'package:alumni_association_app/features/store/model/response/store_response.dart';

/// 订单接口返回模型。
///
/// 对应 `/api/order/addOrder` 返回的订单信息，同时也作为确认订单后页面展示的数据。
class OrderResponse {
  const OrderResponse({
    required this.orderId,
    required this.shopId,
    required this.userId,
    required this.orderNum,
    required this.total,
    required this.actualTotal,
    required this.reduceAmount,
    required this.peopleNum,
    required this.orderType,
    required this.orderStatus,
    required this.coupontId,
    required this.createTime,
    required this.appointmentTime,
    required this.finallyTime,
    required this.cancelTime,
    required this.remark,
    required this.contactName,
    required this.contactPhone,
    this.coupons,
  });

  final int orderId;
  final int shopId;
  final int userId;
  final String orderNum;
  final double total;
  final double actualTotal;
  final double reduceAmount;
  final int peopleNum;
  final int orderType;
  final int orderStatus;
  final int coupontId;
  final String createTime;
  final String appointmentTime;
  final String finallyTime;
  final String cancelTime;
  final String remark;
  final String contactName;
  final String contactPhone;
  final StoreCouponResponse? coupons;

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      orderId: _intValue(json['orderId']),
      shopId: _intValue(json['shopId']),
      userId: _intValue(json['userId']),
      orderNum: _stringValue(json['orderNum']),
      total: _doubleValue(json['total']),
      actualTotal: _doubleValue(json['actualTotal']),
      reduceAmount: _doubleValue(json['reduceAmount']),
      peopleNum: _intValue(json['peopleNum']),
      orderType: _intValue(json['orderType']),
      orderStatus: _intValue(json['orderStatus']),
      coupontId: _intValue(json['coupontId'] ?? json['couponId']),
      createTime: _stringValue(json['createTime']),
      appointmentTime: _stringValue(json['appointmentTime']),
      finallyTime: _stringValue(json['finallyTime']),
      cancelTime: _stringValue(json['cancelTime']),
      remark: _stringValue(json['remark']),
      contactName: _stringValue(json['contactName']),
      contactPhone: _stringValue(json['contactPhone']),
      coupons: _couponValue(json['coupons']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'shopId': shopId,
      'userId': userId,
      'orderNum': orderNum,
      'total': total,
      'actualTotal': actualTotal,
      'reduceAmount': reduceAmount,
      'peopleNum': peopleNum,
      'orderType': orderType,
      'orderStatus': orderStatus,
      'coupontId': coupontId,
      'createTime': createTime,
      'appointmentTime': appointmentTime,
      'finallyTime': finallyTime,
      'cancelTime': cancelTime,
      'remark': remark,
      'contactName': contactName,
      'contactPhone': contactPhone,
      'coupons': coupons?.toJson(),
    };
  }

  factory OrderResponse.empty() {
    return const OrderResponse(
      orderId: 0,
      shopId: 0,
      userId: 0,
      orderNum: '',
      total: 0,
      actualTotal: 0,
      reduceAmount: 0,
      peopleNum: 0,
      orderType: 0,
      orderStatus: 0,
      coupontId: 0,
      createTime: '',
      appointmentTime: '',
      finallyTime: '',
      cancelTime: '',
      remark: '',
      contactName: '',
      contactPhone: '',
    );
  }

  static StoreCouponResponse? _couponValue(Object? value) {
    if (value is! Map) return null;
    return StoreCouponResponse.fromJson(Map<String, dynamic>.from(value));
  }

  static String _stringValue(Object? value) {
    if (value == null) return '';
    return value.toString();
  }

  static int _intValue(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static double _doubleValue(Object? value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }
}
