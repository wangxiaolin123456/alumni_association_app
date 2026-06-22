/// 个人中心订单状态。
///
/// 后续接接口时可以把后端 status 字段统一转换成这里的枚举，页面只关心展示含义。
enum ProfileOrderStatus { pending, used, cancelled }

/// 我的订单列表和订单详情共用的展示模型。
///
/// 目前数据由 controller 模拟接口分页返回，字段命名尽量贴近接口响应，便于之后替换真实接口。
class ProfileOrderItem {
  const ProfileOrderItem({
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
    required this.status,
    required this.imageSeed,
    required this.paymentMethod,
    required this.userName,
    required this.userPhone,
    required this.merchantPhone,
  });

  final String orderNo;
  final String title;
  final String merchantName;
  final String packageContent;
  final String useTime;
  final String createTime;
  final String address;
  final double price;
  final double originalPrice;
  final double discount;
  final int count;
  final ProfileOrderStatus status;
  final int imageSeed;
  final String paymentMethod;
  final String userName;
  final String userPhone;
  final String merchantPhone;

  /// 用于取消预约后刷新列表状态。
  ProfileOrderItem copyWith({ProfileOrderStatus? status}) {
    return ProfileOrderItem(
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
      status: status ?? this.status,
      imageSeed: imageSeed,
      paymentMethod: paymentMethod,
      userName: userName,
      userPhone: userPhone,
      merchantPhone: merchantPhone,
    );
  }

  static ProfileOrderItem fallback() => const ProfileOrderItem(
    orderNo: '202406151856001234',
    title: '双人套餐会员价',
    merchantName: '创享餐饮商会',
    packageContent: '招牌菜3选+饮品2杯',
    useTime: '2024-06-20 18:30',
    createTime: '2024-06-15 18:56:00',
    address: '上海市 · 静安区南京西路123号',
    price: 198,
    originalPrice: 228,
    discount: 30,
    count: 1,
    status: ProfileOrderStatus.pending,
    imageSeed: 0,
    paymentMethod: '微信支付',
    userName: '张同学',
    userPhone: '158****1234',
    merchantPhone: '021-1234 5678',
  );
}
