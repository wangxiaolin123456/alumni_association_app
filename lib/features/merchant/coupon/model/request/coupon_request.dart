import 'package:alumni_association_app/features/store/model/response/store_response.dart';

class CouponRequest {
  const CouponRequest({
    required this.couponId,
    required this.userId,
    required this.name,
    required this.description,
    required this.type,
    required this.value,
    required this.minOrderAmount,
    required this.maxDiscountAmount,
    required this.startTime,
    required this.endTime,
    required this.disableStatus,
    required this.disableMsg,
    required this.createTime,
    required this.updateTime,
    required this.isDeleted,
    required this.shopIds,
  });

  /// 优惠券ID，新增时传 0
  final int couponId;

  /// 用户ID
  final int userId;

  /// 优惠券名称
  final String name;

  /// 优惠券描述
  final String description;

  /// 优惠券类型
  ///
  /// 1 = 固定金额引
  /// 2 = 百分比折扣引
  /// 3 = 条件付割引
  final int type;

  /// 优惠值
  ///
  /// 固定金额：减免金额
  /// 百分比：折扣率
  /// 条件付割引：减免金额
  final double value;

  /// 门槛金额
  final double minOrderAmount;

  /// 最大优惠金额
  ///
  /// 固定金额和条件付割引用 value 也可以。
  /// 百分比折扣时可以作为封顶金额，暂无封顶时传 0。
  final double maxDiscountAmount;

  /// 开始时间
  final String startTime;

  /// 结束时间
  final String endTime;

  /// 优惠券状态
  ///
  /// 0 = 进行中
  /// 1 = 禁用
  final int disableStatus;

  /// 禁用原因
  final String disableMsg;

  /// 创建时间
  final String createTime;

  /// 更新时间
  final String updateTime;

  /// 是否删除
  ///
  /// 0 = 未删除
  /// 1 = 已删除
  final int isDeleted;

  /// 适用门店ID，多个用逗号拼接
  final String shopIds;

  /// 从优惠券详情构造请求对象。
  ///
  /// 修改、下架、重新上架、删除都需要带完整字段，避免后端把未传字段覆盖为空。
  factory CouponRequest.fromCoupon(
    StoreCouponResponse coupon, {
    int? disableStatus,
    int? isDeleted,
  }) {
    return CouponRequest(
      couponId: coupon.couponId,
      userId: coupon.userId,
      name: coupon.name,
      description: coupon.description,
      type: coupon.type,
      value: coupon.value,
      minOrderAmount: coupon.minOrderAmount,
      maxDiscountAmount: coupon.maxDiscountAmount,
      startTime: coupon.startTime,
      endTime: coupon.endTime,
      disableStatus: disableStatus ?? coupon.disableStatus,
      disableMsg: coupon.disableMsg,
      createTime: coupon.createTime,
      updateTime: coupon.updateTime,
      isDeleted: isDeleted ?? coupon.isDeleted,
      shopIds: coupon.shopIds,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'couponId': couponId,
      'userId': userId,
      'name': name,
      'description': description,
      'type': type,
      'value': value,
      'minOrderAmount': minOrderAmount,
      'maxDiscountAmount': maxDiscountAmount,
      'startTime': startTime,
      'endTime': endTime,
      'disableStatus': disableStatus,
      'disableMsg': disableMsg,
      'createTime': createTime,
      'updateTime': updateTime,
      'isDeleted': isDeleted,
      'shopIds': shopIds,
    };
  }
}
