import 'package:alumni_association_app/features/member/benefits/model/response/merchant_benefit_response.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class MerchantBenefitsController extends GetxController {
  final searchController = TextEditingController();
  final keyword = ''.obs;
  final selectedCategory = 0.obs;
  final claimedIds = <String>{}.obs;

  final benefits = const <MerchantBenefitResponse>[
    MerchantBenefitResponse(
      id: 'benefit-001',
      merchantName: '老上海本帮菜(静安店)',
      category: 'food',
      address: '静安区 南京西路1266号恒隆广场5楼',
      distance: '1.2km',
      offers: ['堂食全单9.5折', '周一至周五午市8折'],
      accentColor: 0xFFFF7A1A,
    ),
    MerchantBenefitResponse(
      id: 'benefit-002',
      merchantName: '星巴克(国金中心店)',
      category: 'food',
      address: '浦东新区 世纪大道8号国金中心商场B1层',
      distance: '2.3km',
      offers: ['指定饮品买1送1', '全场饮品9折'],
      accentColor: 0xFF16A6A1,
    ),
    MerchantBenefitResponse(
      id: 'benefit-003',
      merchantName: '言几又书店(来福士店)',
      category: 'shopping',
      address: '黄浦区 西藏中路268号来福士广场5楼',
      distance: '3.1km',
      offers: ['全场图书8.5折', '会员日双倍积分'],
      accentColor: 0xFF7C4DFF,
    ),
    MerchantBenefitResponse(
      id: 'benefit-004',
      merchantName: '超级猩猩健身(陆家嘴店)',
      category: 'service',
      address: '浦东新区 陆家嘴环路1000号汇丰大厦3楼',
      distance: '3.8km',
      offers: ['免费体验3天', '私教课程85折优惠'],
      accentColor: 0xFF0967F2,
    ),
  ];

  List<MerchantBenefitResponse> get filteredBenefits {
    const types = ['', 'food', 'shopping', 'service'];
    final type = types[selectedCategory.value];
    final query = keyword.value.trim().toLowerCase();
    return benefits.where((item) {
      return (type.isEmpty || item.category == type) &&
          (query.isEmpty ||
              item.merchantName.toLowerCase().contains(query) ||
              item.offers.any((offer) => offer.toLowerCase().contains(query)));
    }).toList();
  }

  /// 领取按钮再次点击时保持已领取状态，避免重复领取。
  void claim(String id) => claimedIds.add(id);

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
