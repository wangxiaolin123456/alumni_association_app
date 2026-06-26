/// 商户入驻提交入参。
///
/// 字段命名与后端 `/api/merchant/addMerchant` 保持一致，页面层只负责收集表单，
/// 这里统一整理成接口需要的 JSON，后续真实上传图片后只需要替换图片 URL 字符串。
class MerchantOnboardingRequest {
  const MerchantOnboardingRequest({
    required this.userId,
    required this.shopName,
    required this.typeId,
    required this.typeName,
    required this.types,
    required this.names,
    required this.phone,
    required this.province,
    required this.city,
    required this.area,
    required this.address,
    required this.businessStartTime,
    required this.businessEndTime,
    this.postalCode = '',
    this.shopUrl = '',
    this.shopLogo = '',
    this.shopImgs = '',
    this.licenseImages = '',
    this.shopId,
  });

  final int? shopId;
  final int userId;
  final String shopName;
  final int typeId;
  final String typeName;
  final String types;
  final String names;
  final String phone;
  final String postalCode;
  final String province;
  final String city;
  final String area;
  final String address;
  final String businessStartTime;
  final String businessEndTime;
  final String shopUrl;
  final String shopLogo;
  final String shopImgs;
  final String licenseImages;

  Map<String, dynamic> toJson() {
    final json = {
      'id': 0,
      'userId': userId,
      'shopName': shopName,
      'typeId': typeId,
      'typeName': typeName,
      'types': types,
      'names': names,
      'phone': phone,
      'postalCode': postalCode,
      'province': province,
      'city': city,
      'area': area,
      'address': address,
      'businessStartTime': businessStartTime,
      'businessEndTime': businessEndTime,
      'shopUrl': shopUrl,
      'shopLogo': shopLogo,
      'shopImgs': shopImgs,
      'licenseImages': licenseImages,
      'shopStatus': 1,
      'createTime': '',
      'updateTime': '',
      'isDeleted': 0,
    };
    if (shopId != null) {
      json['shopId'] = shopId!;
    }
    return json;
  }
}
