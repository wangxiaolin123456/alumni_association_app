import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/core/widgets/pagination_footer.dart';
import 'package:alumni_association_app/features/member/record_center/model/response/member_record_response.dart';
import 'package:alumni_association_app/features/member/record_center/pages/member_record_center_controller.dart';
import 'package:alumni_association_app/features/member/widgets/member_feature_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

enum MemberRecordPageType { registration, favorite, browsing }

class MemberRecordPage extends StatelessWidget {
  const MemberRecordPage({required this.type, super.key});

  final MemberRecordPageType type;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MemberRecordCenterController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(_title(context),
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),),
        centerTitle: true,
        actions: [
          if (type == MemberRecordPageType.browsing)
            TextButton(
              onPressed: controller.clearBrowsing,
              child: Text(context.l10n.clearAll),
            ),
        ],
      ),
      body: Obx(() {
        final records = _records(controller);
        final loading = _loading(controller);
        return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollUpdateNotification &&
                notification.dragDetails != null &&
                notification.metrics.pixels > 0 &&
                notification.metrics.extentAfter < 120) {
              _loadMore(controller);
            }
            return false;
          },
          child: RefreshIndicator(
            onRefresh: () => _refresh(controller),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(14.w, 8.h, 14.w, 24.h),
              children: [
                if (records.isEmpty)
                  SizedBox(
                    height: 520.h,
                    child: Center(child: Text(context.l10n.noRecords)),
                  )
                else
                  ...records.map(
                    (record) => Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: _RecordCard(
                        record: record,
                        type: type,
                        cancelled: controller.cancelledRegistrationIds.contains(
                          record.id,
                        ),
                        onAction: () => _handleAction(controller, record),
                      ),
                    ),
                  ),
                if (records.isNotEmpty)
                  PaginationFooter(
                    loading: loading,
                    hasMore: _hasMore(controller),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  String _title(BuildContext context) => switch (type) {
    MemberRecordPageType.registration => context.l10n.registrationRecords,
    MemberRecordPageType.favorite => context.l10n.favoriteMerchants,
    MemberRecordPageType.browsing => context.l10n.browsingRecords,
  };

  List<MemberRecordResponse> _records(
    MemberRecordCenterController controller,
  ) => switch (type) {
    MemberRecordPageType.registration => controller.visibleRegistrations,
    MemberRecordPageType.favorite => controller.visibleFavorites,
    MemberRecordPageType.browsing => controller.visibleBrowsing,
  };

  bool _loading(MemberRecordCenterController controller) => switch (type) {
    MemberRecordPageType.registration =>
      controller.registrationLoadingMore.value,
    MemberRecordPageType.favorite => controller.favoriteLoadingMore.value,
    MemberRecordPageType.browsing => controller.browsingLoadingMore.value,
  };

  bool _hasMore(MemberRecordCenterController controller) => switch (type) {
    MemberRecordPageType.registration => controller.hasMoreRegistrations,
    MemberRecordPageType.favorite => controller.hasMoreFavorites,
    MemberRecordPageType.browsing => controller.hasMoreBrowsing,
  };

  Future<void> _refresh(MemberRecordCenterController controller) =>
      switch (type) {
        MemberRecordPageType.registration => controller.refreshRegistrations(),
        MemberRecordPageType.favorite => controller.refreshFavorites(),
        MemberRecordPageType.browsing => controller.refreshBrowsing(),
      };

  Future<void> _loadMore(MemberRecordCenterController controller) =>
      switch (type) {
        MemberRecordPageType.registration => controller.loadMoreRegistrations(),
        MemberRecordPageType.favorite => controller.loadMoreFavorites(),
        MemberRecordPageType.browsing => controller.loadMoreBrowsing(),
      };

  void _handleAction(
    MemberRecordCenterController controller,
    MemberRecordResponse record,
  ) {
    switch (type) {
      case MemberRecordPageType.registration:
        controller.cancelRegistration(record.id);
      case MemberRecordPageType.favorite:
        controller.toggleFavorite(record.id);
      case MemberRecordPageType.browsing:
        controller.removeBrowsing(record.id);
    }
  }
}

class _RecordCard extends StatelessWidget {
  const _RecordCard({
    required this.record,
    required this.type,
    required this.cancelled,
    required this.onAction,
  });

  final MemberRecordResponse record;
  final MemberRecordPageType type;
  final bool cancelled;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final colors = record.accentColors.map(Color.new).toList();
    final completed = record.status == 'completed';
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: memberFeatureCardDecoration,
      child: Row(
        children: [
          Container(
            width: 86.w,
            height: 76.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              gradient: LinearGradient(colors: colors),
            ),
            child: Icon(_icon, color: Colors.white, size: 36.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  record.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                SizedBox(height: 7.h),
                Text(
                  record.meta,
                  style: TextStyle(
                    color: colors.first,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 6.w),
          TextButton(
            onPressed: completed || cancelled ? null : onAction,
            child: Text(_actionLabel(context, completed)),
          ),
        ],
      ),
    );
  }

  IconData get _icon => switch (type) {
    MemberRecordPageType.registration => Icons.event_available_rounded,
    MemberRecordPageType.favorite => Icons.storefront_rounded,
    MemberRecordPageType.browsing => Icons.history_rounded,
  };

  String _actionLabel(BuildContext context, bool completed) => switch (type) {
    MemberRecordPageType.registration =>
      completed
          ? context.l10n.completed
          : cancelled
          ? context.l10n.cancelled
          : context.l10n.cancelRegistration,
    MemberRecordPageType.favorite => context.l10n.unfavorite,
    MemberRecordPageType.browsing => context.l10n.remove,
  };
}
