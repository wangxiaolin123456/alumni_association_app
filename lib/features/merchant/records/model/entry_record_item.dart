/// 商家端入单记录展示模型。
///
/// 当前由 controller 构造假数据；真实接口返回后可以直接增加 fromJson/toJson。
class EntryRecordItem {
  const EntryRecordItem({
    required this.name,
    required this.packageName,
    required this.orderNo,
    required this.phone,
    required this.time,
    required this.receivableAmount,
    required this.paidAmount,
    required this.avatarText,
    required this.avatarColor,
    this.isVip = true,
  });

  final String name;
  final String packageName;
  final String orderNo;
  final String phone;
  final String time;
  final double receivableAmount;
  final double paidAmount;
  final String avatarText;
  final int avatarColor;
  final bool isVip;
}
