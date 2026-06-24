import 'package:alumni_association_app/features/member/certification/model/response/certification_response.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

/// 校友认证表单控制器。
///
/// 页面只负责渲染和触发事件，表单值、下拉选项、图片上传状态、提交校验都集中在这里，
/// 后续接真实接口时可以直接把 submit / pick 方法替换成 ApiRequest 调用。
class CertificationController extends GetxController {
  /// 基础表单输入项。
  final nameController = TextEditingController();
  final schoolController = TextEditingController();
  final collegeController = TextEditingController();
  final cohortController = TextEditingController();
  final majorController = TextEditingController();
  final phoneController = TextEditingController();

  /// 图片选择器，负责拍照或从相册选择图片。
  final ImagePicker _imagePicker = ImagePicker();

  /// 已上传图片类型集合：student / diploma / alumni。
  final uploadedTypes = <String>{}.obs;

  /// 每一种证明图片对应的本地路径，真实接口里可替换成上传后的 fileId/url。
  final uploadedImagePaths = <String, String>{}.obs;

  /// 证明材料文件名。当前项目没有 file_picker，先模拟 PDF/图片材料选择结果。
  final proofMaterialName = ''.obs;

  /// 认证提交状态。
  final status = 'draft'.obs;

  /// 提交后的表单快照，状态页会读取这份数据。
  final submitted = Rxn<CertificationResponse>();

  /// 下拉选择数据，后续可以由接口返回。
  final schoolOptions = const ['上海交通大学', '复旦大学', '同济大学', '上海财经大学'];
  final collegeOptions = const ['计算机科学与工程学院', '经济管理学院', '设计学院', '医学院'];
  final cohortOptions = const ['2016届', '2017届', '2018届', '2019届', '2020届'];

  /// 选择学校。
  void selectSchool(String value) {
    schoolController.text = value;
  }

  /// 选择学院。
  void selectCollege(String value) {
    collegeController.text = value;
  }

  /// 选择毕业届别。
  void selectCohort(String value) {
    cohortController.text = value;
  }

  /// 模拟选择证明材料。
  ///
  /// UI 中提示支持图片或 PDF；当前依赖只有 image_picker，所以这里先保留可替换的入口。
  void selectProofMaterial() {
    proofMaterialName.value = '校友认证证明材料.pdf';
  }

  /// 选择并“上传”证明图片。
  ///
  /// 当前先保存本地路径并标记已上传；真实项目中在拿到 XFile 后调用上传接口即可。
  Future<bool> pickProofImage({
    required String type,
    required ImageSource source,
  }) async {
    final file = await _imagePicker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1600,
    );
    if (file == null) return false;
    uploadedImagePaths[type] = file.path;
    uploadedTypes.add(type);
    return true;
  }

  /// 移除某一项证明图片。
  void removeProofImage(String type) {
    uploadedImagePaths.remove(type);
    uploadedTypes.remove(type);
  }

  bool get canSubmit =>
      nameController.text.trim().isNotEmpty &&
      schoolController.text.trim().isNotEmpty &&
      collegeController.text.trim().isNotEmpty &&
      cohortController.text.trim().isNotEmpty &&
      majorController.text.trim().isNotEmpty &&
      phoneController.text.trim().isNotEmpty &&
      uploadedTypes.isNotEmpty;

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

  /// 撤回认证，回到草稿状态。
  void withdraw() => status.value = 'draft';

  /// 模拟后台审核通过。
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
