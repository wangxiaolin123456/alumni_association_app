import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/profile/management/model/profile_management_item.dart';
import 'package:alumni_association_app/features/profile/management/pages/activity_management_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

///活动管理
class ActivityManagementPage extends StatelessWidget {
  const ActivityManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ActivityManagementController());
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: BackButton(onPressed: () => Get.back()),
        title: Text(context.l10n.activityManagement, style: _titleStyle),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: IconButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.l10n.publishActivity)),
              ),
              icon:  Icon(Icons.add_circle_outline_rounded,size: 26.sp,),
              tooltip: context.l10n.publishActivity,
            ),
          ),
        ],
      ),
      body: _ActivityBody(controller: controller),
    );
  }
}

class _ActivityBody extends StatelessWidget {
  const _ActivityBody({required this.controller});
  final ActivityManagementController controller;

  @override
  Widget build(BuildContext context) {
    final tabs = [context.l10n.all, context.l10n.ongoing, context.l10n.offline];
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 16.h),
          child: SizedBox(
            height: 42.h,
            child: TextField(
              controller: controller.searchController,
              onSubmitted: (_) => controller.fetchInitial(),
              textAlignVertical: TextAlignVertical.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF1F2937),
              ),
              decoration: InputDecoration(
                hintText: context.l10n.searchActivityName,
                hintStyle: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF9CA3AF),
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  size: 22.sp,
                  color: const Color(0xFF8A94A6),
                ),
                filled: true,
                fillColor: AppColors.searchBox,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: const BorderSide(
                    color: Color(0xFF4F8CFF),
                    width: 1.2,
                  ),
                ),
              ),
            ),
          ),
        ),
        Obx(
          () => Row(
            children: List.generate(tabs.length, (index) {
              final selected = controller.selectedTab.value == index;
              return Expanded(
                child: InkWell(
                  onTap: () => controller.switchTab(index),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 14.h),
                    child: Column(
                      children: [
                        Text(
                          tabs[index],
                          style: TextStyle(
                            color: selected
                                ? AppColors.primary
                                : AppColors.textPrimary,
                            fontSize: 16.sp,
                            fontWeight: selected
                                ? FontWeight.w800
                                : FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: selected ? 36.w : 0,
                          height: 3.h,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(99.r),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        Expanded(
          child: Obx(
            () => RefreshIndicator(
              onRefresh: controller.fetchInitial,
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification.metrics.pixels >
                      notification.metrics.maxScrollExtent - 80.h) {
                    controller.loadMore();
                  }
                  return false;
                },
                child: ListView.separated(
                  padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 28.h),
                  itemCount:
                      controller.items.length +
                      (controller.hasMore.value ? 1 : 0),
                  separatorBuilder: (_, _) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    if (index >= controller.items.length) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }
                    final item = controller.items[index];
                    return _ActivityManageCard(
                      item: item,
                      onToggle: () => controller.toggleStatus(item),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ActivityManageCard extends StatelessWidget {
  const _ActivityManageCard({required this.item, required this.onToggle});
  final ProfileManagementItem item;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final online = item.status == ProfileManageStatus.online;
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: _cardDecoration,
      child: Column(
        children: [
          Row(
            children: [
              _ActivityImage(item: item),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(item.title, style: _itemTitleStyle),
                        ),
                        _ActivityStatus(online: online),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    _InfoLine(
                      icon: Icons.schedule_rounded,
                      text: item.publishTime,
                    ),
                    _InfoLine(
                      icon: Icons.location_on_rounded,
                      text: item.location ?? '',
                    ),
                    _InfoLine(
                      icon: Icons.groups_rounded,
                      text:
                          '${context.l10n.participantCount}: ${item.participantCount ?? 0}${context.l10n.personUnit}',
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Text(
                '${context.l10n.createTime}:  ${item.publishTime}',
                style: TextStyle(fontSize: 11.sp,color: AppColors.textSecondary),
              ),
              const Spacer(),
              _OutlineAction(label: context.l10n.edit, onTap: () {}),
              SizedBox(width: 10.w),
              _OutlineAction(
                label: online
                    ? context.l10n.offlineAction
                    : context.l10n.relist,
                onTap: onToggle,
                danger: online,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActivityImage extends StatelessWidget {
  const _ActivityImage({required this.item});
  final ProfileManagementItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 116.w,
      height: 96.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        gradient: LinearGradient(
          colors: [item.iconColor, item.iconColor.withValues(alpha: 0.48)],
        ),
      ),
      child: Icon(item.icon, color: Colors.white, size: 42.sp),
    );
  }
}

class _ActivityStatus extends StatelessWidget {
  const _ActivityStatus({required this.online});
  final bool online;

  @override
  Widget build(BuildContext context) {
    final color = online ? AppColors.success : AppColors.textSecondary;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        online ? context.l10n.ongoing : context.l10n.offline,
        style: TextStyle(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5.h),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 17.sp),
          SizedBox(width: 6.w),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _metaStyle,
            ),
          ),
        ],
      ),
    );
  }
}

class _OutlineAction extends StatelessWidget {
  const _OutlineAction({
    required this.label,
    required this.onTap,
    this.danger = false,
  });
  final String label;
  final VoidCallback onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color = danger ? const Color(0xFFFF4B16) : AppColors.primary;
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color.withValues(alpha: 0.65)),
        minimumSize: Size(70.w, 34.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w),
      ),
      child: Text(label),
    );
  }
}

final _titleStyle = TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w900);
final _itemTitleStyle = TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800);
final _metaStyle = TextStyle(color: AppColors.textSecondary, fontSize: 12.sp);
final _cardDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(18.r),
  boxShadow: [
    BoxShadow(
      color: const Color(0xFF1E5AA8).withValues(alpha: 0.06),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ],
);
