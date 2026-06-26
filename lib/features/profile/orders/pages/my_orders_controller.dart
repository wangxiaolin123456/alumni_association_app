import 'package:alumni_association_app/features/profile/orders/model/profile_order_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 我的订单列表控制器。
///
/// 这里模拟真实接口分页：刷新时重置页码，加载更多时追加下一页。
/// 后续接入接口时，只需要把 [_requestOrderPage] 替换成 ApiRequest 调用即可。
class MyOrdersController extends GetxController {
  /// 当前选中的订单状态 Tab。
  final selectedTab = 0.obs;

  /// 订单列表数据。
  final orders = <ProfileOrderItem>[].obs;

  /// 是否正在加载。
  final isLoading = false.obs;

  /// 是否还有更多数据。
  final hasMore = true.obs;

  /// 搜索框控制器。
  final searchController = TextEditingController();

  /// 当前页码。
  int pageNum = 1;

  /// 每页条数。
  final int pageSize = 4;

  @override
  void onInit() {
    super.onInit();
    fetchInitial();
  }

  /// 切换 Tab 后重新模拟请求第一页数据。
  Future<void> switchTab(int index) async {
    selectedTab.value = index;
    await fetchInitial();
  }

  /// 下拉刷新入口。
  Future<void> fetchInitial() async {
    pageNum = 1;
    hasMore.value = true;
    await fetchOrders(isRefresh: true);
  }

  /// 上拉加载更多入口。
  Future<void> loadMore() async {
    if (!hasMore.value || isLoading.value) return;
    await fetchOrders();
  }

  /// 获取订单列表数据。
  Future<void> fetchOrders({bool isRefresh = false}) async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      await Future<void>.delayed(const Duration(milliseconds: 250));
      final rows = _requestOrderPage(pageNum: pageNum, pageSize: pageSize);
      if (isRefresh) {
        orders.assignAll(rows);
      } else {
        orders.addAll(rows);
      }
      hasMore.value = rows.length >= pageSize;
      if (hasMore.value) pageNum++;
    } finally {
      isLoading.value = false;
    }
  }

  /// 取消预约时只更新当前列表的本地状态，模拟接口提交成功后的返回。
  void cancelOrder(ProfileOrderItem item) {
    final index = orders.indexWhere((order) => order.orderNo == item.orderNo);
    if (index == -1) return;
    orders[index] = orders[index].copyWith(
      status: ProfileOrderStatus.cancelled,
    );
  }

  /// 根据 Tab 和搜索关键字模拟后端筛选。
  List<ProfileOrderItem> _requestOrderPage({
    required int pageNum,
    required int pageSize,
  }) {
    final keyword = searchController.text.trim();
    final status = switch (selectedTab.value) {
      1 => ProfileOrderStatus.pending,
      2 => ProfileOrderStatus.used,
      3 => ProfileOrderStatus.cancelled,
      _ => null,
    };
    final filtered = _mockOrders.where((order) {
      final matchStatus = status == null || order.status == status;
      final matchKeyword =
          keyword.isEmpty ||
          order.orderNo.contains(keyword) ||
          order.title.contains(keyword) ||
          order.merchantName.contains(keyword);
      return matchStatus && matchKeyword;
    }).toList();
    final start = (pageNum - 1) * pageSize;
    if (start >= filtered.length) return const [];
    final end = (start + pageSize).clamp(0, filtered.length);
    return filtered.sublist(start, end);
  }

  List<ProfileOrderItem> get _mockOrders => const [
    ProfileOrderItem(
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
    ),
    ProfileOrderItem(
      orderNo: '202406141230000567',
      title: '双人套餐会员价',
      merchantName: '创享餐饮商会',
      packageContent: '招牌菜3选+饮品2杯',
      useTime: '2024-06-14 19:00',
      createTime: '2024-06-14 12:30:00',
      address: '上海市 · 静安区南京西路123号',
      price: 198,
      originalPrice: 228,
      discount: 30,
      count: 1,
      status: ProfileOrderStatus.used,
      imageSeed: 1,
      paymentMethod: '微信支付',
      userName: '张同学',
      userPhone: '158****1234',
      merchantPhone: '021-1234 5678',
    ),
    ProfileOrderItem(
      orderNo: '202406121045003333',
      title: '单人套餐',
      merchantName: '创享餐饮商会',
      packageContent: '主厨精选单人餐',
      useTime: '2024-06-12 10:45',
      createTime: '2024-06-12 10:45:00',
      address: '上海市 · 静安区南京西路123号',
      price: 128,
      originalPrice: 158,
      discount: 30,
      count: 1,
      status: ProfileOrderStatus.pending,
      imageSeed: 2,
      paymentMethod: '微信支付',
      userName: '张同学',
      userPhone: '158****1234',
      merchantPhone: '021-1234 5678',
    ),
    ProfileOrderItem(
      orderNo: '202406081530009876',
      title: '双人套餐',
      merchantName: '创享餐饮商会',
      packageContent: '双人招牌套餐',
      useTime: '2024-06-08 15:30',
      createTime: '2024-06-08 15:30:00',
      address: '上海市 · 静安区南京西路123号',
      price: 198,
      originalPrice: 228,
      discount: 30,
      count: 1,
      status: ProfileOrderStatus.cancelled,
      imageSeed: 3,
      paymentMethod: '微信支付',
      userName: '张同学',
      userPhone: '158****1234',
      merchantPhone: '021-1234 5678',
    ),
    ProfileOrderItem(
      orderNo: '202406041900002468',
      title: '下午茶双人券',
      merchantName: '星巴克校友店',
      packageContent: '咖啡2杯+甜品2份',
      useTime: '2024-06-24 15:00',
      createTime: '2024-06-04 19:00:00',
      address: '上海市 · 浦东新区世纪大道8号',
      price: 88,
      originalPrice: 108,
      discount: 20,
      count: 1,
      status: ProfileOrderStatus.pending,
      imageSeed: 4,
      paymentMethod: '支付宝',
      userName: '张同学',
      userPhone: '158****1234',
      merchantPhone: '021-8888 1234',
    ),
  ];

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
