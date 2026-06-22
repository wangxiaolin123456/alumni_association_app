import 'package:alumni_association_app/app/router/app_router.dart';
import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/profile/management/model/profile_management_item.dart';
import 'package:alumni_association_app/features/profile/management/presentation/opportunity_management_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
///商机管理
class OpportunityManagementPage extends StatelessWidget {
  const OpportunityManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OpportunityManagementController());
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: Text(context.l10n.opportunityManagement, style: _titleStyle),
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
      body: _ManagementBody(
        controller: controller,
        searchHint: context.l10n.searchOpportunityTitle,
        tabs: [context.l10n.all, context.l10n.listed, context.l10n.offline],
        itemBuilder: (item) => _OpportunityManageCard(
          item: item,
          onToggle: () => controller.toggleStatus(item),
          onDelete: () => controller.deleteItem(item),
        ),
      ),
    );
  }
}

class _ManagementBody<T extends GetxController> extends StatelessWidget {
  const _ManagementBody({
    required this.controller,
    required this.searchHint,
    required this.tabs,
    required this.itemBuilder,
  });

  final dynamic controller;
  final String searchHint;
  final List<String> tabs;
  final Widget Function(ProfileManagementItem item) itemBuilder;

  @override
  Widget build(BuildContext context) {
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
                hintText: searchHint,
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
                    return itemBuilder(controller.items[index]);
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

class _OpportunityManageCard extends StatelessWidget {
  const _OpportunityManageCard({
    required this.item,
    required this.onToggle,
    required this.onDelete,
  });

  final ProfileManagementItem item;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final online = item.status == ProfileManageStatus.online;
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: _cardDecoration,
      child: Column(
        children: [
          Row(
            children: [
              _IconBox(item: item),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title, style: _itemTitleStyle),
                    SizedBox(height: 7.h),
                    _CategoryTag(label: item.category),
                    SizedBox(height: 8.h),
                    Text(
                      '${context.l10n.publishTime}:  ${item.publishTime}',
                      style: _metaStyle,
                    ),
                  ],
                ),
              ),
              _StatusPill(online: online),
              Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
            ],
          ),
          Divider(height: 28.h),
          Row(
            children: [
              _SmallMeta(
                icon: Icons.visibility_outlined,
                text: '${context.l10n.viewsCount} ${item.views}',
              ),
              // SizedBox(width: 12.w),
              // _SmallMeta(
              //   icon: Icons.chat_bubble_outline_rounded,
              //   text: '${context.l10n.inquiriesCount} ${item.inquiries}',
              // ),
              const Spacer(),
              _OutlineAction(label: context.l10n.edit, onTap: () {}),
              SizedBox(width: 8.w),
              if (online)
                _OutlineAction(
                  label: context.l10n.offlineAction,
                  onTap: onToggle,
                  danger: true,
                )
              else ...[
                _OutlineAction(label: context.l10n.relist, onTap: onToggle),
                SizedBox(width: 8.w),
                _OutlineAction(
                  label: context.l10n.delete,
                  onTap: onDelete,
                  danger: true,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  const _IconBox({required this.item});
  final ProfileManagementItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58.w,
      height: 58.w,
      decoration: BoxDecoration(
        color: item.iconColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Icon(item.icon, color: item.iconColor, size: 34.sp),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.online});
  final bool online;

  @override
  Widget build(BuildContext context) {
    final color = online ? AppColors.success : AppColors.textSecondary;
    return Row(
      children: [
        Container(
          width: 7.w,
          height: 7.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 5.w),
        Text(
          online ? context.l10n.listed : context.l10n.offline,
          style: TextStyle(color: color, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _CategoryTag extends StatelessWidget {
  const _CategoryTag({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF2FF),
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Text(
        label,
        style: TextStyle(color: AppColors.primary, fontSize: 12.sp),
      ),
    );
  }
}

class _SmallMeta extends StatelessWidget {
  const _SmallMeta({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 18.sp, color: AppColors.textSecondary),
      SizedBox(width: 5.w),
      Text(text, style: _metaStyle),
    ],
  );
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
        minimumSize: Size(58.w, 34.h),
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
