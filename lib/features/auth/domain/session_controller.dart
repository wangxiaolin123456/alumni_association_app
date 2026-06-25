import 'package:alumni_association_app/features/auth/domain/user_role.dart';
import 'package:get/get.dart';

import '../../../app/api/api_request.dart';
import '../../../storage/storage.dart';
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

  /// 是否正在刷新用户信息
  final isRefreshingUserInfo = false.obs;

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
  Future<void> signInAs(UserInfoResponse userInfoResponse) async {
    role.value = _roleFromResponse(userInfoResponse);
    userInfo.value = userInfoResponse;
    isAuthenticated.value = true;

    await Storage.setLoginInfo(userInfoResponse);
  }

  /// 登录成功后保存登录状态
  Future<void> signIn(UserInfoResponse response) async {
    isAuthenticated.value = true;
    await updateLoginInfo(response);
  }

  /// 更新当前登录用户信息
  ///
  /// 适合登录成功、修改个人资料成功、刷新用户信息后调用。
  Future<void> updateLoginInfo(UserInfoResponse response) async {
    userInfo.value = response;
    role.value = _roleFromResponse(response);
    isAuthenticated.value = true;

    await Storage.setLoginInfo(response);
  }

  /// 调接口刷新当前登录用户信息
  ///
  /// 使用场景：
  /// 1. 我的页面下拉刷新
  /// 2. 修改个人资料成功后刷新
  /// 3. 商户入驻成功后刷新用户身份
  Future<UserInfoResponse?> refreshUserInfo() async {
    if (!isAuthenticated.value) return null;

    final currentUser = userInfo.value;
    if (currentUser == null) return null;

    if (isRefreshingUserInfo.value) return currentUser;

    isRefreshingUserInfo.value = true;

    try {
      final latest = await ApiRequest.userInfo(userId: currentUser.id);

      if (latest != null) {
        await updateLoginInfo(latest);
        return latest;
      }

      return null;
    } finally {
      isRefreshingUserInfo.value = false;
    }
  }

  /// 退出登录
  Future<void> signOut() async {
    isAuthenticated.value = false;
    role.value = UserRole.member;
    userInfo.value = null;
    isRefreshingUserInfo.value = false;

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