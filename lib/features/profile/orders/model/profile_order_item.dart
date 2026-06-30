import 'package:alumni_association_app/features/consumption/model/response/order_response.dart';

/// 个人中心订单状态。
enum ProfileOrderStatus { pending, used, cancelled }

/// 我的订单列表和订单详情共用展示模型。
class ProfileOrderItem {
  const ProfileOrderItem({
    required this.orderId,
    required this.shopId,
    required this.userId,
    required this.orderNo,
    required this.title,
    required this.merchantName,
    required this.packageContent,
    required this.useTime,
    required this.createTime,
    required this.address,
    required this.price,
    required this.originalPrice,
    required this.discount,
    required this.count,
    required this.orderType,
    required this.status,
    required this.imageSeed,
    required this.paymentMethod,
    required this.userName,
    required this.userPhone,
    required this.merchantPhone,
    required this.remark,
    required this.couponId,
  });

  final int orderId;
  final int shopId;
  final int userId;
  final String orderNo;

  /// 优惠券名称 / 默认订单标题
  final String title;

  /// 当前接口没有返回商户名称，先用 shopId 兜底
  final String merchantName;

  /// 优惠券描述 / 备注
  final String packageContent;

  /// 使用时间：已使用取 finallyTime，预约单取 appointmentTime，否则取 createTime
  final String useTime;

  final String createTime;
  final String address;

  /// 实付金额 actualTotal
  final double price;

  /// 原价 total
  final double originalPrice;

  /// 优惠金额 reduceAmount
  final double discount;

  /// 人数 peopleNum
  final int count;

  /// 订单类型：0-直接支付 1-预约单
  final int orderType;

  final ProfileOrderStatus status;
  final int imageSeed;
  final String paymentMethod;
  final String userName;
  final String userPhone;
  final String merchantPhone;
  final String remark;

  /// 后端字段是 coupontId，先按接口拼写接
  final int couponId;

  ProfileOrderItem copyWith({
    ProfileOrderStatus? status,
  }) {
    return ProfileOrderItem(
      orderId: orderId,
      shopId: shopId,
      userId: userId,
      orderNo: orderNo,
      title: title,
      merchantName: merchantName,
      packageContent: packageContent,
      useTime: useTime,
      createTime: createTime,
      address: address,
      price: price,
      originalPrice: originalPrice,
      discount: discount,
      count: count,
      orderType: orderType,
      status: status ?? this.status,
      imageSeed: imageSeed,
      paymentMethod: paymentMethod,
      userName: userName,
      userPhone: userPhone,
      merchantPhone: merchantPhone,
      remark: remark,
      couponId: couponId,
    );
  }

  factory ProfileOrderItem.fromOrderResponse(OrderResponse response) {
    final orderNo = response.orderNum.trim().isNotEmpty
        ? response.orderNum.trim()
        : response.orderId.toString();

    final couponName = response.coupons?.name.trim() ?? '';
    final couponDesc = response.coupons?.description.trim() ?? '';

    final title = couponName.isNotEmpty ? couponName : '会员优惠订单';

    final useTime = response.finallyTime.trim().isNotEmpty
        ? response.finallyTime
        : response.appointmentTime.trim().isNotEmpty
        ? response.appointmentTime
        : response.createTime;

    return ProfileOrderItem(
      orderId: response.orderId,
      shopId: response.shopId,
      userId: response.userId,
      orderNo: orderNo,
      title: title,
      merchantName: '商户 #${response.shopId}',
      packageContent: couponDesc.isNotEmpty ? couponDesc : response.remark,
      useTime: useTime,
      createTime: response.createTime,
      address: '',
      price: response.actualTotal,
      originalPrice: response.total,
      discount: response.reduceAmount,
      count: response.peopleNum <= 0 ? 1 : response.peopleNum,
      orderType: response.orderType,
      status: _statusFromApi(response.orderStatus),
      imageSeed: response.orderId,
      paymentMethod: '',
      userName: response.contactName,
      userPhone: response.contactPhone,
      merchantPhone: '',
      remark: response.remark,
      couponId: response.coupontId,
    );
  }
}

ProfileOrderStatus _statusFromApi(int value) {
  return switch (value) {
    1 => ProfileOrderStatus.used,
    2 => ProfileOrderStatus.cancelled,
    _ => ProfileOrderStatus.pending,
  };
}