import 'package:alumni_association_app/features/profile/records/model/entry_record_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 入单记录控制器。
///
/// 按照项目里列表页的写法，刷新、加载更多、假数据分页都集中在 controller 中。
class EntryRecordsController extends GetxController {
  /// 入单记录列表。
  final records = <EntryRecordItem>[].obs;

  /// 是否正在加载。
  final isLoading = false.obs;

  /// 是否还有更多。
  final hasMore = true.obs;

  /// 搜索框控制器。
  final searchController = TextEditingController();

  int pageNum = 1;
  final int pageSize = 6;

  double get receivableTotal =>
      records.fold(0, (sum, item) => sum + item.receivableAmount);

  double get paidTotal => records.fold(0, (sum, item) => sum + item.paidAmount);

  @override
  void onInit() {
    super.onInit();
    fetchInitial();
  }

  Future<void> fetchInitial() async {
    pageNum = 1;
    hasMore.value = true;
    await fetchRecords(isRefresh: true);
  }

  Future<void> loadMore() async {
    if (!hasMore.value || isLoading.value) return;
    await fetchRecords();
  }

  Future<void> fetchRecords({bool isRefresh = false}) async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      await Future<void>.delayed(const Duration(milliseconds: 220));
      final rows = _requestRecordPage(pageNum: pageNum, pageSize: pageSize);
      if (isRefresh) {
        records.assignAll(rows);
      } else {
        records.addAll(rows);
      }
      hasMore.value = rows.length >= pageSize;
      if (hasMore.value) pageNum++;
    } finally {
      isLoading.value = false;
    }
  }

  /// 模拟搜索接口筛选。
  List<EntryRecordItem> _requestRecordPage({
    required int pageNum,
    required int pageSize,
  }) {
    final keyword = searchController.text.trim();
    final filtered = _mockRecords.where((item) {
      return keyword.isEmpty ||
          item.name.contains(keyword) ||
          item.phone.contains(keyword) ||
          item.orderNo.contains(keyword);
    }).toList();
    final start = (pageNum - 1) * pageSize;
    if (start >= filtered.length) return const [];
    final end = (start + pageSize).clamp(0, filtered.length);
    return filtered.sublist(start, end);
  }

  List<EntryRecordItem> get _mockRecords => const [
    EntryRecordItem(
      name: '张三',
      packageName: '校友双人套餐',
      orderNo: '202406151856001234',
      phone: '138****1234',
      time: '2024-06-15 18:20',
      receivableAmount: 268,
      paidAmount: 198,
      avatarText: '张',
      avatarColor: 0xFF1A73E8,
    ),
    EntryRecordItem(
      name: '李四',
      packageName: '会员菜品8.5折',
      orderNo: '202406151705002345',
      phone: '139****5678',
      time: '2024-06-15 17:05',
      receivableAmount: 520,
      paidAmount: 442,
      avatarText: '李',
      avatarColor: 0xFF22A447,
    ),
    EntryRecordItem(
      name: '王五',
      packageName: '满300减50',
      orderNo: '202406151230003456',
      phone: '137****9012',
      time: '2024-06-15 12:30',
      receivableAmount: 360,
      paidAmount: 310,
      avatarText: '王',
      avatarColor: 0xFF7650DC,
    ),
    EntryRecordItem(
      name: '赵六',
      packageName: '商务套餐A',
      orderNo: '202406151015004567',
      phone: '136****3456',
      time: '2024-06-15 10:15',
      receivableAmount: 888,
      paidAmount: 780,
      avatarText: '赵',
      avatarColor: 0xFFFF7A00,
      isVip: false,
    ),
    EntryRecordItem(
      name: '刘七',
      packageName: '精致下午茶套餐',
      orderNo: '202406150945005678',
      phone: '135****7890',
      time: '2024-06-15 09:45',
      receivableAmount: 128,
      paidAmount: 118,
      avatarText: '刘',
      avatarColor: 0xFF1A73E8,
    ),
    EntryRecordItem(
      name: '陈八',
      packageName: '会员特价菜品',
      orderNo: '202406150830006789',
      phone: '132****2468',
      time: '2024-06-15 08:30',
      receivableAmount: 268,
      paidAmount: 228,
      avatarText: '陈',
      avatarColor: 0xFF21A33A,
    ),
  ];

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
