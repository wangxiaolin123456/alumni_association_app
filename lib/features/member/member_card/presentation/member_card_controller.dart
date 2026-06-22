import 'package:get/get.dart';

class MemberCardController extends GetxController {
  final refreshCount = 0.obs;

  String get qrPayload =>
      'alumni-member:XYH20240001:${refreshCount.value}:20260612';

  /// 每次刷新都会生成新的二维码载荷，模拟动态会员码。
  void refreshQr() => refreshCount.value++;
}
