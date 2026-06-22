import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/profile/presentation/personal_info_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
///个人信息
class PersonalInfoPage extends StatelessWidget {
  const PersonalInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PersonalInfoController());
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: context.pop,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Text(l10n.personalInfo),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(18.w, 20.h, 18.w, 28.h),
        children: [
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF2FF),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.verified_user_rounded,
                  color: AppColors.primary,
                  size: 42.sp,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    l10n.personalInfoTip,
                    style: TextStyle(
                      color: const Color(0xFF25324B),
                      fontSize: 14.sp,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            decoration: _cardDecoration,
            child: Column(
              children: [
                _AvatarRow(),
                Obx(
                  () => _InfoRow(
                    label: l10n.nickname,
                    value: controller.nickname.value,
                    onTap: () =>
                        _edit(context, l10n.nickname, controller.nickname),
                  ),
                ),
                Obx(
                  () => _InfoRow(
                    label: l10n.contactMethod,
                    value: controller.phone.value,
                    onTap: () =>
                        _edit(context, l10n.contactMethod, controller.phone),
                  ),
                ),
                Obx(
                  () => _InfoRow(
                    label: l10n.birthday,
                    value: controller.birthday.value,
                    onTap: () =>
                        _edit(context, l10n.birthday, controller.birthday),
                  ),
                ),
                Obx(
                  () => _InfoRow(
                    label: l10n.region,
                    value: controller.region.value,
                    onTap: () => _edit(context, l10n.region, controller.region),
                    showDivider: false,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 42.h),
          Obx(
            () => Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.w),
              child: SizedBox(
                height: 50.h,
                child: FilledButton(
                  onPressed: controller.isSaving.value
                      ? null
                      : () => controller.save(context),
                  child: Text(l10n.save),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _edit(
    BuildContext context,
    String title,
    RxString target,
  ) async {
    final input = TextEditingController(text: target.value);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(controller: input, autofocus: true),
        actions: [
          TextButton(onPressed: context.pop, child: Text(context.l10n.cancel)),
          FilledButton(
            onPressed: () => context.pop(input.text),
            child: Text(context.l10n.confirm),
          ),
        ],
      ),
    );
    if (result != null) {
      Get.find<PersonalInfoController>().updateText(target, result);
    }
  }
}

class _AvatarRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _InfoShell(
      showDivider: true,
      child: Row(
        children: [
          Text(
            context.l10n.avatar,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
          ),
          const Spacer(),
          CircleAvatar(
            radius: 34.r,
            backgroundColor: const Color(0xFFEAF2FF),
            child: Icon(
              Icons.person_rounded,
              color: AppColors.primary,
              size: 38.sp,
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    required this.onTap,
    this.showDivider = true,
  });

  final String label;
  final String value;
  final VoidCallback onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return _InfoShell(
      showDivider: showDivider,
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
            ),
            const Spacer(),
            Flexible(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16.sp,
                ),
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

class _InfoShell extends StatelessWidget {
  const _InfoShell({required this.child, required this.showDivider});

  final Widget child;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 82.h, child: child),
        if (showDivider) const Divider(height: 1),
      ],
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
