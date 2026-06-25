import 'package:alumni_association_app/app/router/app_router.dart';
import 'package:alumni_association_app/features/store/model/response/store_response.dart';
import 'package:get/get.dart';

/// 商户工作台 Controller
class MerchantDashboardController extends GetxController {
  /// 当前商户
  final currentStore = Rxn<StoreResponse>();

  /// 是否加载中
  final isLoading = false.obs;

  /// 当前底部 Tab
  final currentTabIndex = 0.obs;

  /// 当前选择的统计月份
  final selectedMonth = DateTime.now().obs;

  /// 是否选择过月份
  final hasSelectedMonth = false.obs;

  /// 顶部按钮显示文字
  String get selectedMonthText {
    if (!hasSelectedMonth.value) {
      return '本月';
    }

    final date = selectedMonth.value;
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, '0');

    return '$year年$month月';
  }

  /// 可选月份列表
  ///
  /// 当前月往前推 24 个月
  List<DateTime> get selectableMonths {
    final now = DateTime.now();

    return List.generate(24, (index) {
      return DateTime(now.year, now.month - index, 1);
    });
  }

  /// 选择月份
  void selectMonth(DateTime date) {
    selectedMonth.value = DateTime(date.year, date.month, 1);
    hasSelectedMonth.value = true;

    loadOverviewByMonth();
  }

  /// 重新请求经营概览
  Future<void> loadOverviewByMonth() async {
    final date = selectedMonth.value;

    /// TODO: 后续这里换成真实接口
    /// 参数一般传：
    /// year: date.year
    /// month: date.month
    ///
    /// await ApiRequest.merchantOverview(
    ///   shopId: currentStore.value?.shopId ?? 0,
    ///   year: date.year,
    ///   month: date.month,
    /// );

    overview.value = MerchantOverviewData(
      orderCount: date.month == DateTime.now().month ? 56 : 38,
      receiveAmount: date.month == DateTime.now().month ? 12345.67 : 8960.20,
      discountAmount: date.month == DateTime.now().month ? 5678.90 : 3200.00,
    );
  }

  /// 经营概览数据
  final overview = MerchantOverviewData.empty().obs;

  /// 经营数据
  final businessData = MerchantBusinessData.empty().obs;



  @override
  void onInit() {
    super.onInit();
    loadDashboard();
  }

  /// 加载商户工作台数据
  Future<void> loadDashboard() async {
    isLoading.value = true;

    try {
      /// TODO: 后续这里替换成真实接口
      /// 例如：
      /// final store = await ApiRequest.myMerchantDetail();
      /// final stats = await ApiRequest.merchantStatistics(...);

      await Future.delayed(const Duration(milliseconds: 300));

      currentStore.value = const StoreResponse(
        shopId: 1,
        userId: 1,
        shopName: '创享餐饮商会',
        typeId: 1,
        typeName: '餐饮美食',
        names: '张经理',
        phone: '138****5678',
        postalCode: '100000',
        province: '上海市',
        city: '上海市',
        area: '静安区',
        address: '南京西路123号',
        businessStartTime: '09:00',
        businessEndTime: '22:00',
        shopLogo: '',
        shopImgs: '',
        licenseImages: '',
        shopStatus: 1,
        createTime: '',
        updateTime: '',
        isDeleted: 0,
      );

      overview.value = const MerchantOverviewData(
        orderCount: 56,
        receiveAmount: 12345.67,
        discountAmount: 5678.90,
      );

      businessData.value = const MerchantBusinessData(
        todayVerifyCount: 56,
        todayConsumeAmount: 12345.67,
        monthGmv: 234567.89,
        monthDiscountAmount: 5678.90,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// 下拉刷新
  Future<void> refreshDashboard() async {
    await loadDashboard();
  }


  /// 新增商户
  void addMerchant() {
    Get.toNamed(Pages.merchantOnboardingPage);
  }

  /// 修改商户信息
  void editMerchantInfo() {
    /// TODO: 换成你的商户信息编辑页
    Get.toNamed(Pages.merchantOnboardingPage);
  }

  /// 入单记录
  void openEntryRecords() {
    /// TODO: 换成你的入单记录页面路由
    // Get.toNamed(Pages.merchantEntryRecords);
  }

  /// 数据统计
  void openStatistics() {
    /// TODO: 换成你的数据统计页面路由
    // Get.toNamed(Pages.merchantStatistics);
  }

  /// 优惠券管理
  void openCouponManagement() {
    Get.toNamed(Pages.publishCoupon);
  }

  /// 商户设置
  void openMerchantSettings() {
    /// TODO: 换成你的商户设置页面路由
    // Get.toNamed(Pages.merchantSettings);
  }

  /// 点击底部 Tab
  void selectBottomTab(int index) {
    currentTabIndex.value = index;

    switch (index) {
      case 0:
        break;
      case 1:
        openEntryRecords();
        break;
      case 2:
        openStatistics();
        break;
      case 3:
        openMerchantSettings();
        break;
    }
  }
}


/// 经营概览
class MerchantOverviewData {
  const MerchantOverviewData({
    required this.orderCount,
    required this.receiveAmount,
    required this.discountAmount,
  });

  /// 订单数
  final int orderCount;

  /// 实收金额
  final double receiveAmount;

  /// 优惠金额
  final double discountAmount;

  factory MerchantOverviewData.empty() {
    return const MerchantOverviewData(
      orderCount: 0,
      receiveAmount: 0,
      discountAmount: 0,
    );
  }
}

/// 经营数据
class MerchantBusinessData {
  const MerchantBusinessData({
    required this.todayVerifyCount,
    required this.todayConsumeAmount,
    required this.monthGmv,
    required this.monthDiscountAmount,
  });

  /// 今日核销次数
  final int todayVerifyCount;

  /// 今日消费金额
  final double todayConsumeAmount;

  /// 本月 GMV
  final double monthGmv;

  /// 本月优惠金额
  final double monthDiscountAmount;

  factory MerchantBusinessData.empty() {
    return const MerchantBusinessData(
      todayVerifyCount: 0,
      todayConsumeAmount: 0,
      monthGmv: 0,
      monthDiscountAmount: 0,
    );
  }
}