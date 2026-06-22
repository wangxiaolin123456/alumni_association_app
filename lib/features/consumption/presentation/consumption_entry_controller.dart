import 'package:alumni_association_app/features/consumption/model/response/consumption_entry_response.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
//消费入单
/// Owns the complete four-step consumption-entry workflow.
class ConsumptionEntryController extends GetxController {
  /// Search, amount and note inputs survive route transitions between steps.
  final searchController = TextEditingController();
  final amountController = TextEditingController();
  final noteController = TextEditingController();

  /// Reactive workflow and selection state.
  final currentStep = 1.obs;
  final keyword = ''.obs;
  final selectedMerchantIndex = 0.obs;
  final selectedCouponIndex = 0.obs;
  final amount = 0.0.obs;
  final submittedOrder = Rxn<ConsumptionOrderResponse>();

  final selectedCategory = 'all'.obs;
  final merchantCategories = <String>[
    '全部分类',
    '餐饮美食',
    '酒店住宿',
    '旅游出行',
    '教育培训',
    '医疗健康',
    '零售购物',
    '生活服务',
  ];


  /// Mock responses used until consumption-entry APIs are connected.
  final merchants = const <ConsumptionMerchantResponse>[
    ConsumptionMerchantResponse(
      id: 'merchant-001',
      name: '华创科技咖啡（静安店）',
      category: '咖啡饮品 · 休闲空间',
      distance: '1.2km',
      rating: 4.8,
      accentColors: [0xFF6B422C, 0xFFD0A26D],
    ),
    ConsumptionMerchantResponse(
      id: 'merchant-002',
      name: '创享餐饮（静安店）',
      category: '中餐 · 快餐',
      distance: '2.3km',
      rating: 4.6,
      accentColors: [0xFF29384A, 0xFFDD5D32],
    ),
    ConsumptionMerchantResponse(
      id: 'merchant-003',
      name: '动感健身中心（静安店）',
      category: '健身 · 运动',
      distance: '3.1km',
      rating: 4.9,
      accentColors: [0xFF26303B, 0xFF748597],
    ),
    ConsumptionMerchantResponse(
      id: 'merchant-004',
      name: '创享银泰酒店（静安店）',
      category: '酒店住宿 · 商务出行',
      distance: '5.6km',
      rating: 4.7,
      accentColors: [0xFF174F88, 0xFF78B7EA],
    ),
    ConsumptionMerchantResponse(
      id: 'merchant-005',
      name: '东方书店（静安店）',
      category: '书店 · 文创',
      distance: '4.8km',
      rating: 4.5,
      accentColors: [0xFF6D4324, 0xFFD6A36A],
    ),
  ];

  final coupons = const <ConsumptionCouponResponse>[
    ConsumptionCouponResponse(
      id: 'coupon-001',
      title: '会员专享9折券',
      rule: '消费满100元可用',
      validity: '2026.06.01-2026.06.30',
      type: 'discount',
      value: 0.9,
      minimumAmount: 100,
      badge: '9折',
    ),
    ConsumptionCouponResponse(
      id: 'coupon-002',
      title: '满100减20券',
      rule: '消费满100元可用',
      validity: '2026.06.01-2026.06.30',
      type: 'reduction',
      value: 20,
      minimumAmount: 100,
      badge: '满100减20',
    ),
    ConsumptionCouponResponse(
      id: 'coupon-003',
      title: '满200减50券',
      rule: '消费满200元可用',
      validity: '2026.06.01-2026.06.30',
      type: 'reduction',
      value: 50,
      minimumAmount: 200,
      badge: '满200减50',
    ),
  ];

  ConsumptionMerchantResponse get selectedMerchant =>
      merchants[selectedMerchantIndex.value];

  /// A null coupon represents the explicit "do not use coupon" choice.
  ConsumptionCouponResponse? get selectedCoupon =>
      selectedCouponIndex.value >= coupons.length
      ? null
      : coupons[selectedCouponIndex.value];

  List<ConsumptionMerchantResponse> get filteredMerchants {
    final query = keyword.value.trim().toLowerCase();
    return merchants.where((merchant) {
      return query.isEmpty ||
          merchant.name.toLowerCase().contains(query) ||
          merchant.category.toLowerCase().contains(query);
    }).toList();
  }

  double get discountAmount {
    final coupon = selectedCoupon;
    if (coupon == null || amount.value < coupon.minimumAmount) return 0;
    if (coupon.type == 'discount') {
      return _roundMoney(amount.value * (1 - coupon.value));
    }
    return _roundMoney(coupon.value.clamp(0, amount.value));
  }

  double get payableAmount =>
      _roundMoney((amount.value - discountAmount).clamp(0, double.infinity));

  bool get canContinueFromMerchant => selectedMerchantIndex.value >= 0;
  bool get canContinueFromAmount => amount.value > 0;

  /// Starts a clean workflow every time the home shortcut is opened.
  void resetWorkflow() {
    currentStep.value = 1;
    keyword.value = '';
    selectedMerchantIndex.value = 0;
    selectedCouponIndex.value = 0;
    amount.value = 0;
    searchController.clear();
    amountController.clear();
    noteController.clear();
    submittedOrder.value = null;
  }

  ///选中全部分类的item
  void selectCategory(String category) {
    selectedCategory.value = category;
    search(searchController.text);
  }

  void search(String value) => keyword.value = value.trim();

  void selectMerchant(ConsumptionMerchantResponse merchant) {
    selectedMerchantIndex.value = merchants.indexWhere(
      (item) => item.id == merchant.id,
    );
  }

  void selectCoupon(int index) => selectedCouponIndex.value = index;

  /// Parses numeric amount input and updates derived discount/payable values.
  void updateAmount(String value) {
    amount.value = double.tryParse(value.trim()) ?? 0;
  }

  void goToStep(int step) => currentStep.value = step.clamp(1, 4);

  /// Creates a local submission result; replace with the create-order API.
  void submit() {
    if (!canContinueFromAmount) return;
    currentStep.value = 4;
    submittedOrder.value = const ConsumptionOrderResponse(
      orderNumber: '20260612123456789',
      submittedAt: '2026-06-12 12:36:56',
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    amountController.dispose();
    noteController.dispose();
    super.onClose();
  }
}

/// Rounds currency calculations to cents before values reach order creation.
double _roundMoney(double value) => (value * 100).roundToDouble() / 100;
