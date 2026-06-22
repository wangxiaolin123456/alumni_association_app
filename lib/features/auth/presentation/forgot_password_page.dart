import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/auth/presentation/forgot_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotPasswordController());
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: context.pop,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Text(l10n.forgotPassword),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 28.h),
        children: [
          Icon(
            Icons.mark_email_read_rounded,
            color: AppColors.primary,
            size: 118.sp,
          ),
          SizedBox(height: 18.h),
          Text(
            l10n.retrievePasswordByEmail,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 10.h),
          Text(
            l10n.retrievePasswordDesc,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14.sp,
              height: 1.45,
            ),
          ),
          SizedBox(height: 28.h),
          _FormCard(
            children: [
              _LabeledField(
                label: l10n.emailAddress,
                controller: controller.emailController,
                hintText: l10n.emailPlaceholder,
                icon: Icons.email_outlined,
              ),
              _CodeField(controller: controller),
              _PasswordField(
                label: l10n.newPassword,
                controller: controller.newPasswordController,
                obscure: controller.obscureNewPassword,
                toggle: controller.toggleNewPasswordVisible,
                hintText: l10n.newPasswordPlaceholder,
              ),
              Padding(
                padding: EdgeInsets.only(top: 7.h, bottom: 16.h),
                child: Text(l10n.passwordRuleHint, style: _hintStyle),
              ),
              _PasswordField(
                label: l10n.confirmNewPassword,
                controller: controller.confirmPasswordController,
                obscure: controller.obscureConfirmPassword,
                toggle: controller.toggleConfirmPasswordVisible,
                hintText: l10n.confirmNewPasswordPlaceholder,
              ),
              SizedBox(height: 16.h),
              _PasswordRuleCard(),
              SizedBox(height: 22.h),
              _SubmitButton(controller: controller),
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
              TextButton(onPressed: context.pop, child: Text(l10n.backToLogin)),
            ],
          ),
        ],
      ),
    );
  }
}

class _FormCard extends StatelessWidget {
  const _FormCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: _cardDecoration,
      child: Column(children: children),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.suffix,
    this.obscureText = false,
  });

  final String label;
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final Widget? suffix;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 9.h),
          TextField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: Icon(icon, color: AppColors.primary),
              suffixIcon: suffix,
            ),
          ),
        ],
      ),
    );
  }
}

class _CodeField extends StatelessWidget {
  const _CodeField({required this.controller});

  final ForgotPasswordController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _LabeledField(
        label: context.l10n.verificationCode,
        controller: controller.codeController,
        hintText: context.l10n.codePlaceholder,
        icon: Icons.verified_user_outlined,
        suffix: TextButton(
          onPressed: controller.secondsRemaining.value == 0
              ? controller.sendCode
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

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.label,
    required this.controller,
    required this.obscure,
    required this.toggle,
    required this.hintText,
  });

  final String label;
  final TextEditingController controller;
  final RxBool obscure;
  final VoidCallback toggle;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _LabeledField(
        label: label,
        controller: controller,
        hintText: hintText,
        icon: Icons.lock_outline_rounded,
        obscureText: obscure.value,
        suffix: IconButton(
          onPressed: toggle,
          icon: Icon(
            obscure.value
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
          ),
        ),
      ),
    );
  }
}

class _PasswordRuleCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF2FF),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.verified_user_outlined, color: AppColors.primary),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(context.l10n.passwordRequirements, style: _hintStyle),
          ),
        ],
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({required this.controller});

  final ForgotPasswordController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: 52.h,
        child: FilledButton(
          onPressed: controller.isSubmitting.value
              ? null
              : () => controller.resetPassword(context),
          child: Text(context.l10n.resetPassword),
        ),
      ),
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

TextStyle get _hintStyle =>
    TextStyle(color: AppColors.textSecondary, fontSize: 13.sp, height: 1.5);
