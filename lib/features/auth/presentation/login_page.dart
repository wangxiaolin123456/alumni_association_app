import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/app/router/app_router.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/auth/presentation/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
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
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(30.w, 38.h, 30.w, 28.h),
                child: Column(
                  children: [
                    SizedBox(height: 4.h),
                    _BrandHeader(),
                    SizedBox(height: 36.h),
                    _LoginModeSelector(),
                    SizedBox(height: 14.h),
                    _EmailField(),
                    SizedBox(height: 12.h),
                    Obx(
                      () => controller.isRegisterMode.value
                          ? _RegisterFields()
                          : _PasswordField(
                              hintText: context.l10n.passwordPlaceholder,
                            ),
                    ),
                    SizedBox(height: 20.h),
                    _LoginButton(),
                    Obx(
                      () => controller.isRegisterMode.value
                          ? SizedBox(height: 12.h)
                          : Align(
                              alignment: Alignment.center,
                              child: TextButton(
                                onPressed: () =>
                                    context.push(Pages.forgotPassword),
                                child: Text(context.l10n.forgotPassword),
                              ),
                            ),
                    ),
                    _AgreementRow(),
                    SizedBox(height: 30.h),
                    _ThirdPartyDivider(),
                    SizedBox(height: 20.h),
                    _ThirdPartyLogin(),
                    SizedBox(height: 22.h),
                    Obx(
                      () => Text(
                        controller.isRegisterMode.value
                            ? context.l10n.registerEmailHint
                            : context.l10n.emailPasswordLoginHint,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 0.w,
                top: 0.h,
                child: IconButton(
                  tooltip: context.l10n.backHome,
                  onPressed: () => controller.backHome(context),
                  icon: Icon(Icons.arrow_back_ios_new_rounded, size: 22.sp),
                ),
              ),
            ],
          ),
        ),
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
          width: 78.r,
          height: 78.r,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.school_rounded,
            color: AppColors.primary,
            size: 48.sp,
          ),
        ),
        SizedBox(height: 14.h),
        Text(
          context.l10n.appName,
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 28.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          context.l10n.heroSubtitle,
          style: TextStyle(color: const Color(0xFF4D7FC5), fontSize: 13.sp),
        ),
      ],
    );
  }
}

class _LoginModeSelector extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: EdgeInsets.all(4.r),
        decoration: BoxDecoration(
          color: const Color(0xFFEAF2FF),
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Row(
          children: [
            _ModeButton(
              title: context.l10n.emailPasswordLogin,
              selected: !controller.isRegisterMode.value,
              onTap: () => controller.switchMode(false),
            ),
            _ModeButton(
              title: context.l10n.emailCodeRegister,
              selected: controller.isRegisterMode.value,
              onTap: () => controller.switchMode(true),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(15.r),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(vertical: 11.h),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? AppColors.primary : AppColors.textSecondary,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailField extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return _LoginField(
      controller: controller.emailController,
      icon: Icons.email_outlined,
      hintText: context.l10n.emailPlaceholder,
      keyboardType: TextInputType.emailAddress,
    );
  }
}

class _PasswordField extends GetView<LoginController> {
  const _PasswordField({required this.hintText});

  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _LoginField(
        controller: controller.passwordController,
        icon: Icons.lock_outline_rounded,
        hintText: hintText,
        keyboardType: TextInputType.visiblePassword,
        obscureText: controller.obscurePassword.value,
        suffix: IconButton(
          onPressed: controller.togglePasswordVisible,
          icon: Icon(
            controller.obscurePassword.value
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _RegisterFields extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _CodeField(),
        SizedBox(height: 12.h),
        _PasswordField(hintText: context.l10n.setPasswordPlaceholder),
      ],
    );
  }
}

class _CodeField extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _LoginField(
        controller: controller.codeController,
        icon: Icons.lock_outline_rounded,
        hintText: context.l10n.emailCodePlaceholder,
        keyboardType: TextInputType.number,
        suffix: TextButton(
          onPressed: controller.secondsRemaining.value == 0
              ? controller.sendEmailCode
              : null,
          child: Text(
            controller.secondsRemaining.value == 0
                ? context.l10n.getVerificationCode
                : '${controller.secondsRemaining.value}s',
          ),
        ),
      ),
    );
  }
}

class _LoginField extends StatelessWidget {
  const _LoginField({
    required this.controller,
    required this.icon,
    required this.hintText,
    required this.keyboardType,
    this.suffix,
    this.obscureText = false,
  });

  final TextEditingController controller;
  final IconData icon;
  final String hintText;
  final TextInputType keyboardType;
  final Widget? suffix;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: const Color(0xFF547DB8)),
        suffixIcon: suffix,
        contentPadding: EdgeInsets.symmetric(vertical: 17.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _LoginButton extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 54.h,
          child: FilledButton(
            onPressed: () => controller.login(context),
            child: Obx(
              () => controller.isSubmitting.value
                  ? SizedBox(
                      width: 20.r,
                      height: 20.r,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      controller.isRegisterMode.value
                          ? context.l10n.registerButton
                          : context.l10n.loginButton,
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ),
        Obx(
          () => controller.errorMessage.value == null
              ? const SizedBox.shrink()
              : Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: Text(
                    controller.errorMessage.value!,
                    style: TextStyle(color: AppColors.danger, fontSize: 12.sp),
                  ),
                ),
        ),
      ],
    );
  }
}

class _AgreementRow extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          Checkbox(
            value: controller.agreedToTerms.value,
            onChanged: controller.toggleAgreement,
            visualDensity: VisualDensity.compact,
          ),
          Expanded(
            child: Text.rich(
              TextSpan(
                text: context.l10n.agreementPrefix,
                children: [
                  TextSpan(
                    text: context.l10n.userAgreement,
                    style: TextStyle(color: AppColors.primary),
                  ),
                  TextSpan(text: context.l10n.and),
                  TextSpan(
                    text: context.l10n.privacyPolicy,
                    style: TextStyle(color: AppColors.primary),
                  ),
                ],
              ),
              style: TextStyle(color: AppColors.textSecondary, fontSize: 11.sp),
            ),
          ),
        ],
      ),
    );
  }
}

class _ThirdPartyDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            context.l10n.thirdPartyLogin,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12.sp),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}

class _ThirdPartyLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ThirdPartyButton(
          icon: Icons.wechat,
          label: context.l10n.wechat,
          onTap: () => context.push(Pages.accountBind),
        ),
        SizedBox(width: 52.w),
        _ThirdPartyButton(
          icon: Icons.chat_bubble_outline_rounded,
          label: 'LINE',
          onTap: () => context.push(Pages.accountBind),
        ),
      ],
    );
  }
}

class _ThirdPartyButton extends StatelessWidget {
  const _ThirdPartyButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Container(
            width: 48.r,
            height: 48.r,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFD8E2F0)),
            ),
            child: Icon(icon, color: AppColors.success),
          ),
        ),
        SizedBox(height: 7.h),
        Text(
          label,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 12.sp),
        ),
      ],
    );
  }
}
