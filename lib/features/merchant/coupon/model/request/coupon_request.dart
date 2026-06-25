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