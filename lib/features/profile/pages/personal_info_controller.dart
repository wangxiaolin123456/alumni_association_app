import 'package:alumni_association_app/app/api/api_request.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/auth/domain/session_controller.dart';
import 'package:alumni_association_app/features/auth/model/response/user_info_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 个人信息页表单逻辑。
class PersonalInfoController extends GetxController {
  final avatar = ''.obs;
  final nickname = ''.obs;
  final email = ''.obs;
  final phone = ''.obs;
  final createTime = ''.obs;
  final isMerchant = false.obs;
  final isLoading = false.obs;
  final isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    _fillFromUserInfo(SessionController.current.userInfo.value);
    refreshUserInfo();
  }

  /// 调用个人信息接口刷新页面数据，并同步全局登录用户信息。
  Future<void> refreshUserInfo() async {
    final current = SessionController.current.userInfo.value;
    final userId = current?.userId ?? 0;
    if (userId <= 0) return;

    isLoading.value = true;
    try {
      final result = await ApiRequest.userInfo(userId: userId);
      if (result == null) return;
      await SessionController.current.updateLoginInfo(result);
      _fillFromUserInfo(result);
    } finally {
      isLoading.value = false;
    }
  }

  /// 把接口返回字段映射到页面展示状态。
  void _fillFromUserInfo(UserInfoResponse? userInfo) {
    if (userInfo == null) return;
    avatar.value = userInfo.avatar;
    nickname.value = userInfo.displayName;
    email.value = userInfo.email;
    phone.value = userInfo.phone;
    createTime.value = userInfo.createTime;
    isMerchant.value = userInfo.merchant;
  }

  /// 模拟编辑字段：实际项目可替换为底部弹窗或选择器。
  void updateText(RxString target, String value) {
    if (value.trim().isNotEmpty) target.value = value.trim();
  }

  Future<void> save(BuildContext context) async {
    isSaving.value = true;
    try {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.savedSuccessfully)));
    } finally {
      isSaving.value = false;
    }
  }
}
