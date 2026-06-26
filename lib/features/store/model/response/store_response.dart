/// 商户列表数据返回模型
class StoreResponse {
  const StoreResponse({
    required this.shopId,
    required this.userId,
    required this.shopName,
    required this.typeId,
    required this.typeName,
    required this.names,
    required this.phone,
    required this.postalCode,
    required this.province,
    required this.city,
    required this.area,
    required this.address,
    required this.businessStartTime,
    required this.businessEndTime,
    required this.shopLogo,
    required this.shopImgs,
    required this.licenseImages,
    required this.shopStatus,
    required this.createTime,
    required this.updateTime,
    required this.isDeleted,
    this.coupons = const [],
  });

  /// 商户ID
  final int shopId;

  /// 用户ID / 商户所属用户ID
  final int userId;

  /// 店铺名称
  final String shopName;

  /// 商户类型ID
  final int typeId;

  /// 商户类型名称，例如：餐饮美食
  final String typeName;

  /// 联系人姓名
  final String names;

  /// 联系电话
  final String phone;

  /// 邮政编码
  final String postalCode;

  /// 省份
  final String province;

  /// 城市
  final String city;

  /// 区 / 县
  final String area;

  /// 详细地址
  final String address;

  /// 营业开始时间
  final String businessStartTime;

  /// 营业结束时间
  final String businessEndTime;

  /// 店铺Logo
  final String shopLogo;

  /// 店铺图片，多个图片通常用逗号分隔
  final String shopImgs;

  /// 营业执照 / 资质图片，多个图片通常用逗号分隔
  final String licenseImages;

  /// 商户状态
  ///
  /// 例如：
  /// 1 = 正常
  /// 0 = 待审核 / 禁用
  final int shopStatus;

  /// 创建时间
  final String createTime;

  /// 更新时间
  final String updateTime;

  /// 是否删除
  ///
  /// 0 = 未删除
  /// 1 = 已删除
  final int isDeleted;

  /// 商户优惠券列表
  ///
  /// 详情接口没有优惠券时会返回空数组，页面需要据此隐藏优惠区块。
  final List<StoreCouponResponse> coupons;

  factory StoreResponse.fromJson(Map<String, dynamic> json) {
    return StoreResponse(
      shopId: _intValue(json['shopId']),
      userId: _intValue(json['userId']),
      shopName: _stringValue(json['shopName']),
      typeId: _intValue(json['typeId']),
      typeName: _stringValue(json['typeName']),
      names: _stringValue(json['names']),
      phone: _stringValue(json['phone']),
      postalCode: _stringValue(json['postalCode']),
      province: _stringValue(json['province']),
      city: _stringValue(json['city']),
      area: _stringValue(json['area']),
      address: _stringValue(json['address']),
      businessStartTime: _stringValue(json['businessStartTime']),
      businessEndTime: _stringValue(json['businessEndTime']),
      shopLogo: _stringValue(json['shopLogo']),
      shopImgs: _stringValue(json['shopImgs']),
      licenseImages: _stringValue(json['licenseImages']),
      shopStatus: _intValue(json['shopStatus']),
      createTime: _stringValue(json['createTime']),
      updateTime: _stringValue(json['updateTime']),
      isDeleted: _intValue(json['isDeleted']),
      coupons: _couponList(json['coupons']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shopId': shopId,
      'userId': userId,
      'shopName': shopName,
      'typeId': typeId,
      'typeName': typeName,
      'names': names,
      'phone': phone,
      'postalCode': postalCode,
      'province': province,
      'city': city,
      'area': area,
      'address': address,
      'businessStartTime': businessStartTime,
      'businessEndTime': businessEndTime,
      'shopLogo': shopLogo,
      'shopImgs': shopImgs,
      'licenseImages': licenseImages,
      'shopStatus': shopStatus,
      'createTime': createTime,
      'updateTime': updateTime,
      'isDeleted': isDeleted,
      'coupons': coupons.map((item) => item.toJson()).toList(),
    };
  }

  /// 完整地址，用于列表展示
  String get fullAddress {
    return [
      province,
      city,
      area,
      address,
    ].where((item) => item.trim().isNotEmpty).join(' · ');
  }

  /// 商户图片列表
  ///
  /// 优先展示 shopLogo，然后展示 shopImgs
  List<String> get imageUrls {
    final images = <String>[];

    if (shopLogo.trim().isNotEmpty) {
      images.add(shopLogo.trim());
    }

    if (shopImgs.trim().isNotEmpty) {
      images.addAll(
        shopImgs
            .split(',')
            .map((item) => item.trim())
            .where((item) => item.isNotEmpty),
      );
    }

    return images.toSet().toList();
  }

  /// 空对象，避免页面取值时报错
  factory StoreResponse.empty() {
    return const StoreResponse(
      shopId: 0,
      userId: 0,
      shopName: '',
      typeId: 0,
      typeName: '',
      names: '',
      phone: '',
      postalCode: '',
      province: '',
      city: '',
      area: '',
      address: '',
      businessStartTime: '',
      businessEndTime: '',
      shopLogo: '',
      shopImgs: '',
      licenseImages: '',
      shopStatus: 0,
      createTime: '',
      updateTime: '',
      isDeleted: 0,
    );
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

  static List<StoreCouponResponse> _couponList(Object? value) {
    if (value is! List) return const [];

    return value
        .whereType<Map>()
        .map(
          (item) =>
              StoreCouponResponse.fromJson(Map<String, dynamic>.from(item)),
        )
        .where((item) => item.isDeleted == 0)
        .toList();
  }
}

/// 商户详情里的优惠券模型
///
/// 当前优惠券由商户详情接口一并返回，字段保持和后端 JSON 对齐。
class StoreCouponResponse {
  const StoreCouponResponse({
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
    required this.isLose,
    required this.shopIds,
  });

  /// 优惠券ID
  final int couponId;

  /// 所属用户ID
  final int userId;

  /// 优惠券名称
  final String name;

  /// 优惠券说明
  final String description;

  /// 优惠类型，具体含义以后端定义为准
  final int type;

  /// 优惠值，例如折扣值或满减金额
  final double value;

  /// 最低使用金额
  final double minOrderAmount;

  /// 最大优惠金额
  final double maxDiscountAmount;

  /// 开始时间
  final String startTime;

  /// 结束时间
  final String endTime;

  /// 禁用状态
  final int disableStatus;

  /// 禁用原因
  final String disableMsg;

  /// 创建时间
  final String createTime;

  /// 更新时间
  final String updateTime;

  /// 是否删除
  final int isDeleted;

  final int isLose;

  /// 适用商户ID集合，后端通常用逗号分隔
  final String shopIds;

  factory StoreCouponResponse.fromJson(Map<String, dynamic> json) {
    return StoreCouponResponse(
      couponId: StoreResponse._intValue(json['couponId']),
      userId: StoreResponse._intValue(json['userId']),
      name: StoreResponse._stringValue(json['name']),
      description: StoreResponse._stringValue(json['description']),
      type: StoreResponse._intValue(json['type']),
      value: _doubleValue(json['value']),
      minOrderAmount: _doubleValue(json['minOrderAmount']),
      maxDiscountAmount: _doubleValue(json['maxDiscountAmount']),
      startTime: StoreResponse._stringValue(json['startTime']),
      endTime: StoreResponse._stringValue(json['endTime']),
      disableStatus: StoreResponse._intValue(json['disableStatus']),
      disableMsg: StoreResponse._stringValue(json['disableMsg']),
      createTime: StoreResponse._stringValue(json['createTime']),
      updateTime: StoreResponse._stringValue(json['updateTime']),
      isDeleted: StoreResponse._intValue(json['isDeleted']),
      isLose: StoreResponse._intValue(json['isLose']),
      shopIds: StoreResponse._stringValue(json['shopIds']),
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
      'isLose': isLose,
      'shopIds': shopIds,
    };
  }

  /// 优惠券是否可用
  bool get isEnabled => disableStatus == 0;

  /// 页面展示用主文案
  String get displayTitle => name.trim().isEmpty ? '会员优惠' : name;


  /// 页面展示用优惠值
  String get displayValue {
    if (type == 1) {
      return '${_formatAmount(value)}折';
    }
    if (type == 2 && minOrderAmount > 0&& maxDiscountAmount > 0) {
      return '满${_formatAmount(maxDiscountAmount)}减${_formatAmount(minOrderAmount)}';
    }
    return '¥${_formatAmount(value)}';
  }

  static double _doubleValue(Object? value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  static String _formatAmount(double value) {
    if (value % 1 == 0) return value.toInt().toString();
    return value.toStringAsFixed(1);
  }
}
