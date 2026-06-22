import 'package:alumni_association_app/features/member/certification/model/response/certification_response.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class CertificationController extends GetxController {
  final nameController = TextEditingController(text: '张三');
  final schoolController = TextEditingController(text: '上海交通大学');
  final collegeController = TextEditingController(text: '计算机科学与工程学院');
  final cohortController = TextEditingController(text: '2016届');
  final majorController = TextEditingController(text: '软件工程');
  final phoneController = TextEditingController(text: '13888885678');
  final uploadedTypes = <String>{}.obs;
  final status = 'draft'.obs;
  final submitted = Rxn<CertificationResponse>();

  bool get canSubmit =>
      nameController.text.trim().isNotEmpty &&
      schoolController.text.trim().isNotEmpty &&
      collegeController.text.trim().isNotEmpty &&
      cohortController.text.trim().isNotEmpty &&
      majorController.text.trim().isNotEmpty &&
      phoneController.text.trim().isNotEmpty &&
      uploadedTypes.isNotEmpty;

  /// 模拟上传证明图片，真实项目中替换为图片选择与上传接口。
  void toggleUpload(String type) {
    uploadedTypes.contains(type)
        ? uploadedTypes.remove(type)
        : uploadedTypes.add(type);
  }

  /// 提交认证后保存当前表单快照，状态进入审核中。
  bool submit() {
    if (!canSubmit) return false;
    submitted.value = CertificationResponse(
      name: nameController.text.trim(),
      school: schoolController.text.trim(),
      college: collegeController.text.trim(),
      cohort: cohortController.text.trim(),
      major: majorController.text.trim(),
      phone: phoneController.text.trim(),
    );
    status.value = 'pending';
    return true;
  }

  void withdraw() => status.value = 'draft';
  void approve() => status.value = 'approved';

  @override
  void onClose() {
    for (final controller in [
      nameController,
      schoolController,
      collegeController,
      cohortController,
      majorController,
      phoneController,
    ]) {
      controller.dispose();
    }
    super.onClose();
  }
}
