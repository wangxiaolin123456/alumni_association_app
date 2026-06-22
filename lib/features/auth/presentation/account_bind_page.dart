import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/auth/presentation/account_bind_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class AccountBindPage extends StatelessWidget {
  const AccountBindPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AccountBindController());
    final l10n = context.l10n;

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
                  onPressed: context.pop,
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                ),
              ),
              Icon(Icons.school_rounded, color: AppColors.primary, size: 76.sp),
              SizedBox(height: 8.h),
              Text(
                l10n.appName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                l10n.heroSubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 28.h),
              _StepBar(controller: controller),
              SizedBox(height: 28.h),
              _WechatAuthCard(),
              SizedBox(height: 14.h),
              Obx(
                () => controller.currentStep.value == 1
                    ? _SetPasswordCard(controller: controller)
                    : _BindEmailCard(controller: controller),
              ),
              SizedBox(height: 26.h),
              Obx(
                () => SizedBox(
                  height: 54.h,
                  child: FilledButton(
                    onPressed: controller.isSubmitting.value
                        ? null
                        : () => controller.next(context),
                    child: Text(
                      controller.currentStep.value == 2
                          ? l10n.finishBinding
                          : l10n.nextStep,
                      style: TextStyle(fontSize: 17.sp),
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
              SizedBox(height: 28.h),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Text(l10n.otherLoginMethods, style: _hintStyle),
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
}

class _StepBar extends StatelessWidget {
  const _StepBar({required this.controller});

  final AccountBindController controller;

  @override
  Widget build(BuildContext context) {
    final labels = [
      context.l10n.bindEmail,
      context.l10n.setPassword,
      context.l10n.completeBinding,
    ];
    return Obx(
      () => Row(
        children: List.generate(labels.length, (index) {
          final active = controller.currentStep.value >= index;
          return Expanded(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 18.r,
                  backgroundColor: active
                      ? AppColors.primary
                      : const Color(0xFFEAF2FF),
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: active ? Colors.white : AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  labels[index],
                  style: TextStyle(
                    color: active ? AppColors.primary : AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _WechatAuthCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: _cardDecoration,
      child: Row(
        children: [
          _IconBox(icon: Icons.wechat, color: AppColors.success),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.wechatLogin, style: _titleStyle),
                SizedBox(height: 4.h),
                Text(context.l10n.authorizedLogin, style: _hintStyle),
              ],
            ),
          ),
          Text(
            context.l10n.loggedIn,
            style: TextStyle(color: AppColors.success),
          ),
          SizedBox(width: 8.w),
          Icon(Icons.check_circle_outline, color: AppColors.success),
        ],
      ),
    );
  }
}

class _BindEmailCard extends StatelessWidget {
  const _BindEmailCard({required this.controller});

  final AccountBindController controller;

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      title: context.l10n.bindEmail,
      subtitle: context.l10n.bindEmailDesc,
      children: [
        _Input(
          controller.emailController,
          context.l10n.emailPlaceholder,
          Icons.email_outlined,
        ),
        SizedBox(height: 12.h),
        Obx(
          () => _Input(
            controller.codeController,
            context.l10n.emailCodePlaceholder,
            Icons.lock_outline_rounded,
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
        ),
      ],
    );
  }
}

class _SetPasswordCard extends StatelessWidget {
  const _SetPasswordCard({required this.controller});

  final AccountBindController controller;

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      title: context.l10n.setPassword,
      subtitle: context.l10n.setPasswordDesc,
      children: [
        Obx(
          () => _Input(
            controller.passwordController,
            context.l10n.setPasswordPlaceholder,
            Icons.lock_outline_rounded,
            obscureText: controller.obscurePassword.value,
            suffix: IconButton(
              onPressed: controller.togglePasswordVisible,
              icon: Icon(
                controller.obscurePassword.value
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _WhiteCard extends StatelessWidget {
  const _WhiteCard({
    required this.title,
    required this.subtitle,
    required this.children,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: _titleStyle),
          SizedBox(height: 8.h),
          Text(subtitle, style: _hintStyle),
          SizedBox(height: 18.h),
          ...children,
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
    this.suffix,
    this.obscureText = false,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final Widget? suffix;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.primary),
        suffixIcon: suffix,
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
