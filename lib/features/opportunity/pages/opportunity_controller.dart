import 'package:alumni_association_app/features/opportunity/model/response/opportunity_response.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../app/api/api_request.dart';
import '../../../http/model/page_response.dart';

/// Owns opportunity browsing, detail interactions and publishing-form state.
class OpportunityController extends GetxController {
  /// Text inputs are kept in the controller to match the app's GetX lifecycle.
  final searchController = TextEditingController();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final contactController = TextEditingController(text: '张三');
  final phoneController = TextEditingController(text: '138 **** 5678');
  final emailController = TextEditingController(text: 'zhangsan@example.com');
  final addressController = TextEditingController(text: '上海市浦东新区张江高科技园区88号');

  /// Reactive list, detail and publishing state.
  final keyword = ''.obs;
  final selectedCategory = 0.obs;
  final selectedOpportunityIndex = 0.obs;
  final isFavorite = false.obs;
  final isDescriptionExpanded = false.obs;
  final cooperationRequested = false.obs;
  final selectedPublishCategory = 0.obs;
  final selectedAdvantageIndexes = <int>{0, 2}.obs;
  final validityDays = 30.obs;
  final publicVisibility = true.obs;
  final agreementAccepted = false.obs;
  final draftSaved = false.obs;
  final published = false.obs;
  final formRevision = 0.obs;
  final opportunityList = <OpportunityResponse>[].obs;
  final isLoading = false.obs;
  final isRefreshing = false.obs;
  final isLoadingMore = false.obs;
  final hasMore = true.obs;
  int pageNum = 1;
  final int pageSize = 3;

  final categoryCodes = const [
    'all',
    'cooperation',
    'resource',
    'investment',
    'franchise',
  ];

  /// Mock API responses used until opportunity endpoints are connected.
  final opportunities = const <OpportunityResponse>[
    OpportunityResponse(
      id: 'opportunity-001',
      title: '寻找餐饮供应链合作伙伴',
      summary: '我们是一家连锁餐饮品牌，寻找优质食材供应商，长期稳定合作。',
      category: 'cooperation',
      industry: '餐饮行业',
      region: '上海',
      budget: '50万-100万',
      publishedAt: '2026-06-14',
      expiresAt: '2026-07-14',
      views: 1280,
      favorites: 86,
      status: 'ongoing',
      accentColors: [0xFF1687E8, 0xFF315DF5],
      requirements: ['肉类食材', '蔬菜水果', '调味品', '粮油干货'],
    ),
    OpportunityResponse(
      id: 'opportunity-002',
      title: '寻人力资源服务公司合作',
      summary: '公司业务扩张，需要专业的人力资源服务支持，包含招聘、培训等。',
      category: 'resource',
      industry: '企业服务',
      region: '上海',
      budget: '20万-50万',
      publishedAt: '2026-06-12',
      expiresAt: '2026-08-12',
      views: 760,
      favorites: 42,
      status: 'ongoing',
      accentColors: [0xFF7155EA, 0xFFA072F2],
      requirements: ['招聘服务', '培训服务'],
    ),
    OpportunityResponse(
      id: 'opportunity-003',
      title: '智能教育项目寻求天使投资',
      summary: '专注于K12智能学习平台开发，已有产品原型，寻求天使轮投资。',
      category: 'investment',
      industry: '教育培训',
      region: '上海',
      budget: '100万-300万',
      publishedAt: '2026-06-11',
      expiresAt: '2026-09-11',
      views: 920,
      favorites: 63,
      status: 'ongoing',
      accentColors: [0xFFFF7B12, 0xFFFFAE29],
      requirements: ['天使投资', '行业资源'],
    ),
    OpportunityResponse(
      id: 'opportunity-004',
      title: '健康轻食连锁品牌全国招商',
      summary: '品牌已有10家直营店，现开放全国城市合伙人加盟。',
      category: 'franchise',
      industry: '餐饮行业',
      region: '全国',
      budget: '30万-80万',
      publishedAt: '2026-06-10',
      expiresAt: '2026-10-10',
      views: 1560,
      favorites: 105,
      status: 'ongoing',
      accentColors: [0xFF17B966, 0xFF4BD58A],
      requirements: ['城市合伙人', '门店资源'],
    ),
    OpportunityResponse(
      id: 'opportunity-005',
      title: '寻找软件开发外包团队',
      summary: '我们有多个企业数字化项目，寻找长期技术外包合作伙伴。',
      category: 'cooperation',
      industry: '互联网',
      region: '上海',
      budget: '50万-200万',
      publishedAt: '2026-06-09',
      expiresAt: '2026-08-09',
      views: 680,
      favorites: 38,
      status: 'ongoing',
      accentColors: [0xFF3265D8, 0xFF67A0F5],
      requirements: ['技术合作', '长期合作'],
    ),
  ];

  OpportunityResponse get selectedOpportunity =>
      opportunities[selectedOpportunityIndex.value];

  List<OpportunityResponse> get filteredOpportunities {
    final category = categoryCodes[selectedCategory.value];
    final query = keyword.value.trim().toLowerCase();
    return opportunities.where((opportunity) {
      final matchesCategory =
          category == 'all' || opportunity.category == category;
      final matchesQuery =
          query.isEmpty ||
          opportunity.title.toLowerCase().contains(query) ||
          opportunity.summary.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchInitial();
  }

  Future<void> search(String value) async {
    keyword.value = value.trim();
    await fetchInitial();
  }

  Future<void> selectCategory(int index) async {
    selectedCategory.value = index;
    await fetchInitial();
  }

  List<OpportunityResponse> get visibleOpportunities => opportunityList;
  bool get hasMoreOpportunities => hasMore.value;

  /// 重置分页并重新请求第一页。
  Future<void> fetchInitial() async {
    pageNum = 1;
    hasMore.value = true;
    await fetchOpportunityList(isRefresh: true);
  }

  Future<void> refreshOpportunities() => fetchInitial();

  Future<void> loadMoreOpportunities() => fetchOpportunityList();

  /// 模拟请求商机分页接口；刷新替换列表，加载更多追加列表。
  Future<void> fetchOpportunityList({bool isRefresh = false}) async {
    if (isLoading.value || (!isRefresh && !hasMore.value)) return;
    isLoading.value = true;
    isRefreshing.value = isRefresh;
    isLoadingMore.value = !isRefresh;
    try {
      // final result =
      //     await ApiRequest.opportunityList(
      //       pageNum: pageNum,
      //       pageSize: pageSize,
      //     ) ??
          _mockPage(filteredOpportunities);
      // isRefresh
      //     ? opportunityList.assignAll(result.rows)
      //     : opportunityList.addAll(result.rows);
      // hasMore.value = result.hasMore;
      // if (result.hasMore) pageNum++;
    } finally {
      isLoading.value = false;
      isRefreshing.value = false;
      isLoadingMore.value = false;
    }
  }

  /// 接口暂未接通时，由 Controller 使用本地数据模拟当前分页结果。
  PageResponse<OpportunityResponse> _mockPage(List<OpportunityResponse> rows) {
    final start = ((pageNum - 1) * pageSize).clamp(0, rows.length);
    final end = (start + pageSize).clamp(0, rows.length);
    return PageResponse(
      rows: rows.sublist(start, end),
      total: rows.length,
      pageNum: pageNum,
      pageSize: pageSize,
    );
  }

  /// Selects one opportunity before navigation and resets page-only state.
  void selectOpportunity(OpportunityResponse opportunity) {
    selectedOpportunityIndex.value = opportunities.indexWhere(
      (item) => item.id == opportunity.id,
    );
    isDescriptionExpanded.value = false;
    cooperationRequested.value = false;
  }

  void toggleFavorite() => isFavorite.toggle();
  void toggleDescription() => isDescriptionExpanded.toggle();
  void requestCooperation() => cooperationRequested.value = true;
  void selectPublishCategory(int index) =>
      selectedPublishCategory.value = index;
  void selectValidity(int days) => validityDays.value = days;
  void setVisibility(bool value) => publicVisibility.value = value;
  void toggleAgreement(bool? value) => agreementAccepted.value = value ?? false;
  void saveDraft() => draftSaved.value = true;
  void updateForm() => formRevision.value++;
  void publish() {
    if (canPublish) published.value = true;
  }

  /// Adds or removes one selectable cooperation advantage.
  void toggleAdvantage(int index) {
    if (selectedAdvantageIndexes.contains(index)) {
      selectedAdvantageIndexes.remove(index);
    } else {
      selectedAdvantageIndexes.add(index);
    }
  }

  bool get canPublish =>
      titleController.text.trim().isNotEmpty &&
      descriptionController.text.trim().isNotEmpty &&
      agreementAccepted.value;

  @override
  void onClose() {
    searchController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    contactController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
