import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/member/member_card/presentation/member_card_controller.dart';
import 'package:alumni_association_app/features/member/widgets/member_feature_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
///会员二维码
class MemberQrPage extends StatelessWidget {
  const MemberQrPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MemberCardController>();
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.memberQrCode,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18.sp,
        ),), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 24.h),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(24.r),
          decoration: memberFeatureCardDecoration,
          child: Obx(() {
            final payload = controller.qrPayload;
            return Column(
              children: [
                CircleAvatar(
                  radius: 42.r,
                  backgroundColor: const Color(0xFFEAF2FF),
                  child: Icon(
                    Icons.person_rounded,
                    color: AppColors.primary,
                    size: 48.sp,
                  ),
                ),
                SizedBox(height: 14.h),
                Text(
                  '张三',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  '${context.l10n.memberIdLabel}: XYH20240001',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                SizedBox(height: 26.h),
                QrImageView(data: payload, size: 220.r),
                SizedBox(height: 16.h),
                Text(
                  context.l10n.qrAutoRefreshHint,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: controller.refreshQr,
                    child: Text(context.l10n.refreshQr),
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  context.l10n.showQrToMerchant,
                  textAlign: TextAlign.center,
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
