import 'package:alumni_association_app/features/member/consumption_records/model/response/consumption_record_response.dart';
import 'package:get/get.dart';

class ConsumptionRecordsController extends GetxController {
  final selectedTab = 0.obs;

  /// 页面演示数据，后续接入消费记录接口后可直接替换此列表。
  final records = const <ConsumptionRecordResponse>[
    ConsumptionRecordResponse(
      id: 'record-001',
      merchantName: '创享餐饮商会',
      offerName: '双人套餐',
      date: '2024-05-15 18:20',
      originalAmount: 268,
      paidAmount: 198,
      status: 'verified',
      accentColor: 0xFFFF7A1A,
    ),
    ConsumptionRecordResponse(
      id: 'record-002',
      merchantName: '悦享酒店集团',
      offerName: '会员房型优惠',
      date: '2024-06-10 20:05',
      originalAmount: 680,
      paidAmount: 612,
      status: 'verified',
      accentColor: 0xFF0967F2,
    ),
    ConsumptionRecordResponse(
      id: 'record-003',
      merchantName: '康健体检中心',
      offerName: '体检套餐9折',
      date: '2024-06-02 09:30',
      originalAmount: 500,
      paidAmount: 450,
      status: 'pending',
      accentColor: 0xFF1687E8,
    ),
  ];

  List<ConsumptionRecordResponse> get filteredRecords {
    return switch (selectedTab.value) {
      2 => records.where((item) => item.status == 'pending').toList(),
      3 => records.where((item) => item.status == 'verified').toList(),
      _ => records,
    };
  }

  double get totalPaid =>
      records.fold(0, (total, item) => total + item.paidAmount);
  double get totalDiscount => records.fold(
    0,
    (total, item) => total + item.originalAmount - item.paidAmount,
  );
}
