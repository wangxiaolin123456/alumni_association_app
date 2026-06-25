import 'package:alumni_association_app/app/api/api_request.dart';
import 'package:alumni_association_app/features/store/model/response/store_response.dart';
import 'package:alumni_association_app/util/loading_util.dart';
import 'package:get/get.dart';

/// 我的商户列表逻辑。
class MyMerchantController extends GetxController {
  /// 商户列表数据，接口不分页，进入页面时拉取一次。
  final merchants = <StoreResponse>[].obs;

  /// 页面加载状态，用于展示首屏 loading/空态。
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyMerchants();
  }

  /// 获取我的商户列表。
  Future<void> fetchMyMerchants() async {
    if (isLoading.value) return;
    isLoading.value = true;
    LoadingUtil.showSafe();
    try {
      final result = await ApiRequest.myMerchantList();
      merchants.assignAll(result);
    } finally {
      isLoading.value = false;
      LoadingUtil.dismissSafe();
    }
  }
}
