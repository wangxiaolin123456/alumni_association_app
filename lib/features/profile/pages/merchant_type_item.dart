/// 商户行业类型。
///
/// 对应 `/api/merchant/merchantType` 返回的数据结构。
class MerchantTypeItem {
  const MerchantTypeItem({
    required this.id,
    required this.typeName,
    required this.isDeleted,
  });

  final int id;
  final String typeName;
  final int isDeleted;

  factory MerchantTypeItem.fromJson(Map<String, dynamic> json) {
    return MerchantTypeItem(
      id: _parseInt(json['id']),
      typeName: json['typeName']?.toString() ?? '',
      isDeleted: _parseInt(json['isDeleted']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'typeName': typeName, 'isDeleted': isDeleted};
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }
}
