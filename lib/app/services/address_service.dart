import 'package:alumni_association_app/app/api/api_request.dart';
import 'package:alumni_association_app/features/profile/pages/merchant_region_item.dart';
import 'package:get/get.dart';

/// 全局地址数据管理。
///
/// 省市区数据属于低频变化的基础数据，统一在这里做内存缓存：
/// - pid = 0 获取省列表；
/// - 选择省后，用省节点的 requestPid 获取市列表；
/// - 选择市后，用市节点的 requestPid 获取区列表。
/// 这样商户入驻、个人资料等页面复用地址时，不需要重复请求大数据接口。
class AddressService extends GetxService {
  final Map<int, List<MerchantRegionItem>> _regionCache = {};
  final Map<int, Future<List<MerchantRegionItem>>> _pendingRequests = {};

  /// 获取指定 pid 的地区列表，已缓存则直接返回。
  Future<List<MerchantRegionItem>> regionsByPid(int pid) {
    final cached = _regionCache[pid];
    if (cached != null) return Future.value(cached);

    final pending = _pendingRequests[pid];
    if (pending != null) return pending;

    final request = ApiRequest.merchantRegionList(pid: pid)
        .then((items) {
          _regionCache[pid] = items;
          _pendingRequests.remove(pid);
          return items;
        })
        .catchError((Object error) {
          _pendingRequests.remove(pid);
          throw error;
        });

    _pendingRequests[pid] = request;
    return request;
  }

  /// 获取省级列表。
  Future<List<MerchantRegionItem>> provinces() => regionsByPid(0);

  /// 获取某个地区节点的下级列表。
  Future<List<MerchantRegionItem>> childrenOf(MerchantRegionItem item) {
    return regionsByPid(item.requestPid);
  }

  /// 清空缓存，预留给后续需要强制刷新地区数据的场景。
  void clearCache() {
    _regionCache.clear();
    _pendingRequests.clear();
  }
}
