import 'package:alumni_association_app/features/consumption/model/response/order_response.dart';

/// 创建订单接口入参模型。
///
/// 后端 `/api/order/addOrder` 只接收订单基础字段，不再把优惠券对象等额外数据塞进请求体。
/// 页面侧统一通过这个模型传参，后续字段变化时也更容易维护。
class OrderRequest {
  const OrderRequest({
    this.orderId = 0,
    required this.shopId,
    required this.userId,
    this.orderNum = '',
    this.total = 0,
    this.actualTotal = 0,
    this.reduceAmount = 0,
    this.peopleNum = 0,
    this.orderType = 0,
    this.orderStatus = 0,
    this.coupontId = 0,
    this.createTime = '',
    this.appointmentTime = '',
    this.finallyTime = '',
    this.cancelTime = '',
    this.remark = '',
    this.contactName = '',
    this.contactPhone = '',
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

  /// 从订单详情复制一份请求参数。
  ///
  /// “我的订单-去使用”等场景会先拉取订单详情，再把详情里的联系人信息继续带入后续提交。
  factory OrderRequest.fromOrderResponse(
    OrderResponse order, {
    String? contactName,
    String? contactPhone,
    double? total,
    double? actualTotal,
    double? reduceAmount,
    String? remark,
  }) {
    return OrderRequest(
      orderId: order.orderId,
      shopId: order.shopId,
      userId: order.userId,
      orderNum: order.orderNum,
      total: total ?? order.total,
      actualTotal: actualTotal ?? order.actualTotal,
      reduceAmount: reduceAmount ?? order.reduceAmount,
      peopleNum: order.peopleNum,
      orderType: order.orderType,
      orderStatus: order.orderStatus,
      coupontId: order.coupontId,
      createTime: order.createTime,
      appointmentTime: order.appointmentTime,
      finallyTime: order.finallyTime,
      cancelTime: order.cancelTime,
      remark: remark ?? order.remark,
      contactName: contactName ?? order.contactName,
      contactPhone: contactPhone ?? order.contactPhone,
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
    };
  }
}
