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
}