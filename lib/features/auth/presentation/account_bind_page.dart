import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/auth/domain/session_controller.dart';
import 'package:alumni_association_app/features/auth/model/request/bind_mobile_source.dart';
import 'package:alumni_association_app/features/auth/model/response/login_response.dart';
import 'package:alumni_association_app/features/auth/model/response/user_info_response.dart';
import 'package:alumni_association_app/features/auth/presentation/account_bind_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// 绑定手机号页面。
///
/// 注册成功后进入该页面，用户只需要完成手机号绑定即可进入 App；
/// 第三方登录也复用同一页面，不再展示邮箱绑定和分步骤流程。
class AccountBindPage extends StatelessWidget {
  const AccountBindPage({this.email = '',this.source, super.key});
  final String email;
  final BindMobileSource? source;

  @override
  Widget build(BuildContext context) {
    final controller = _putController();
    controller.syncInitialSource(source);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFD7E9FF), Color(0xFFF8FBFF), Colors.white],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 28.h),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                ),
              ),
              _BrandHeader(),
              SizedBox(height: 32.h),
              _AuthSourceCard(),
              SizedBox(height: 16.h),
              _BindPhoneCard(controller: controller),
              SizedBox(height: 24.h),
              Obx(
                () => SizedBox(
                  height: 54.h,
                  child: FilledButton(
                    onPressed: controller.isSubmitting.value
                        ? null
                        : () => controller.bindPhone(context,email),
                    child: controller.isSubmitting.value
                        ? SizedBox(
                            width: 20.r,
                            height: 20.r,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.w,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            context.l10n.completeBinding,
                            style: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                  ),
                ),
              ),
              Obx(
                () => controller.errorMessage.value == null
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: EdgeInsets.only(top: 10.h),
                        child: Text(
                          controller.errorMessage.value!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.danger,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
              ),
              SizedBox(height: 26.h),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Text(context.l10n.phoneBindTip, style: _hintStyle),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  AccountBindController _putController() {
    if (Get.isRegistered<AccountBindController>()) {
      return Get.find<AccountBindController>();
    }
    return Get.put(
      AccountBindController(
        Get.find<SessionController>(),
        initialSource: source,
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 82.r,
          height: 82.r,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.school_rounded,
            color: AppColors.primary,
            size: 50.sp,
          ),
        ),
        SizedBox(height: 14.h),
        Text(
          context.l10n.appName,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 32.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          context.l10n.heroSubtitle,
          textAlign: TextAlign.center,
          style: TextStyle(color: const Color(0xFF4D7FC5), fontSize: 14.sp),
        ),
      ],
    );
  }
}

class _AuthSourceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: _cardDecoration,
      child: Row(
        children: [
          _IconBox(icon: Icons.verified_user_rounded, color: AppColors.success),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.accountVerified, style: _titleStyle),
                SizedBox(height: 4.h),
                Text(context.l10n.accountVerifiedDesc, style: _hintStyle),
              ],
            ),
          ),
          Text(
            context.l10n.loggedIn,
            style: const TextStyle(color: AppColors.success),
          ),
          SizedBox(width: 8.w),
          const Icon(Icons.check_circle_outline, color: AppColors.success),
        ],
      ),
    );
  }
}

class _BindPhoneCard extends StatelessWidget {
  const _BindPhoneCard({required this.controller});

  final AccountBindController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.bindPhone, style: _titleStyle),
          SizedBox(height: 8.h),
          Text(context.l10n.bindPhoneDesc, style: _hintStyle),
          SizedBox(height: 18.h),
          _Input(
            controller.phoneController,
            context.l10n.phoneHint,
            Icons.phone_android_rounded,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9-]')),
            ],
          ),
        ],
      ),
    );
  }
}

class _Input extends StatelessWidget {
  const _Input(
      this.controller,
      this.hint,
      this.icon, {
        this.keyboardType,
        this.inputFormatters,
      });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.primary),
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  const _IconBox({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52.r,
      height: 52.r,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(icon, color: color),
    );
  }
}

BoxDecoration get _cardDecoration => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(18.r),
  boxShadow: [
    BoxShadow(
      color: const Color(0xFF1E5AA8).withValues(alpha: 0.06),
      blurRadius: 20,
      offset: const Offset(0, 6),
    ),
  ],
);

TextStyle get _titleStyle =>
    TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800);

TextStyle get _hintStyle =>
    TextStyle(color: AppColors.textSecondary, fontSize: 13.sp);
