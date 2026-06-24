/// 省市区接口返回的地区节点。
///
/// 后端地区接口字段暂未完全固定，这里兼容常见的 `id/name/pid`
/// 以及 `value/label/parentId`，让页面在联调时更稳。
class MerchantRegionItem {
  const MerchantRegionItem({
    required this.id,
    required this.name,
    required this.pid,
  });

  final int id;
  final String name;
  final int pid;

  /// 拉取下一级地区时传给 `/api/merchant/listByPid` 的 pid。
  ///
  /// 有些接口把节点 id 就命名为 pid，因此这里优先使用 id，
  /// 如果 id 缺失再回退到 pid，避免下级列表传 0。
  int get requestPid => id > 0 ? id : pid;

  factory MerchantRegionItem.fromJson(Map<String, dynamic> json) {
    return MerchantRegionItem(
      id: _parseInt(
        json['id'] ??
            json['value'] ??
            json['code'] ??
            json['pid'] ??
            json['areaId'],
      ),
      name:
          (json['name'] ?? json['label'] ?? json['title'] ?? json['areaName'])
              ?.toString() ??
          '',
      pid: _parseInt(json['pid'] ?? json['parentId'] ?? json['parent_id']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'pid': pid};
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }
}
