import 'package:alumni_association_app/features/auth/domain/user_role.dart';
import 'package:get/get.dart';

import '../../../storage/storage.dart';
import '../model/response/login_response.dart';
import '../model/response/user_info_response.dart';

class SessionController extends GetxController {
  /// 全局快捷访问
  static SessionController get current => Get.find<SessionController>();

  /// 是否已经登录
  final isAuthenticated = false.obs;

  /// 当前用户角色：会员 / 商家
  final role = UserRole.member.obs;

  /// 当前登录用户信息
  final userInfo = Rxn<UserInfoResponse>();

  /// 是否已登录
  bool get isLogin => isAuthenticated.value;

  /// 是否是会员
  bool get isMember => role.value == UserRole.member;

  /// 是否是商家
  bool get isMerchant => role.value == UserRole.merchant;

  /// 是否是管理员
  bool get isAdmin => false;

  @override
  void onInit() {
    super.onInit();
    restoreFromStorage();
  }

  /// App 启动时从本地缓存恢复登录态
  void restoreFromStorage() {
    final cached = Storage.userInfo;
    final token = Storage.accessToken;

    if (cached == null || token == null || token.isEmpty) return;

    userInfo.value = cached;
    role.value = _roleFromResponse(cached);
    isAuthenticated.value = true;
  }

  /// 按指定角色进入 App
  Future<void> signInAs(UserInfoResponse userInfoResponse) async{
    role.value = _roleFromResponse(userInfoResponse);
    isAuthenticated.value = true;
  }

  /// 登录成功后保存登录状态
  Future<void> signIn(UserInfoResponse response) async {
    await updateLoginInfo(response);
  }

  /// 更新当前登录用户信息
  ///
  /// 适合登录成功、修改个人资料成功、刷新用户信息后调用。
  Future<void> updateLoginInfo(UserInfoResponse response) async {
    userInfo.value = response;
    role.value = _roleFromResponse(response);

    await Storage.setLoginInfo(response);
  }

  /// 退出登录
  Future<void> signOut() async {
    isAuthenticated.value = false;
    role.value = UserRole.member;
    userInfo.value = null;

    await Storage.clearUserInfo();
  }

  /// 根据接口返回的 role 转换为 App 内部角色
  UserRole _roleFromResponse(UserInfoResponse response) {
    if (response.isMerchant == 1) {
      return UserRole.merchant;
    }

    return UserRole.member;
  }
}
