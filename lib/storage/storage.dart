import '../features/auth/model/response/login_response.dart';
import 'inner_storage.dart';

/// 全局Key
class _StorageKeys {
  /// token
  static String token = "access_token";

  ///整体用户信息
  static String loginInfo = "login_info";

  /// 更新对话框显示版本
  static String updateDialogShownVersion = "update_dialog_shown_version";
}

/// 全局管理器
class Storage {
  /// 保存登录之后返回得信息 包括用户信息
  static Future<void> setLoginInfo(LoginResponse loginInfo) async {
    await InnerStorage().setJSON(_StorageKeys.loginInfo, loginInfo.toJson());
  }

  /// 获取登录信息
  static LoginResponse? get loginInfo {
    final data = InnerStorage().getJSON(_StorageKeys.loginInfo);
    if (data == null) return null;
    return LoginResponse.fromJson(data);
  }

  /// 设置token
  static Future<void> setAccessToken({String? token}) async {
    if (token == null) {
      await InnerStorage().remove(_StorageKeys.token);
    } else {
      await InnerStorage().setString(_StorageKeys.token, token);
    }
  }

  /// 获取token
  static String? get accessToken {
    final storage = InnerStorage();
    if (!storage.isInitialized) return null;
    return storage.getString(_StorageKeys.token);
  }

  /// 清除登录信息（token + 用户信息）
  static Future<void> clearLoginInfo() async {
    await InnerStorage().remove(_StorageKeys.token);
    await InnerStorage().remove(_StorageKeys.loginInfo);
  }

  /// 设置更新对话框显示版本
  static Future<void> setUpdateDialogShownVersion(String version) async {
    await InnerStorage().setString(
      _StorageKeys.updateDialogShownVersion,
      version,
    );
  }

  /// 获取更新对话框显示版本
  static String? get updateDialogShownVersion =>
      InnerStorage().getString(_StorageKeys.updateDialogShownVersion);

  /// 清除更新对话框显示版本记录
  static Future<void> clearUpdateDialogShownVersion() async {
    await InnerStorage().remove(_StorageKeys.updateDialogShownVersion);
  }
}
