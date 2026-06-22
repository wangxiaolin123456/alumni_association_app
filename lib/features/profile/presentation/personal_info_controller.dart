import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 个人信息页表单逻辑。
class PersonalInfoController extends GetxController {
  final nickname = '张小明'.obs;
  final phone = '138 0000 0000'.obs;
  final birthday = '1995-08-20'.obs;
  final region = '山东省 济南市 历下区'.obs;
  final isSaving = false.obs;

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
