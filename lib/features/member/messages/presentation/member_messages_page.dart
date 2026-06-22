import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/member/messages/presentation/member_messages_controller.dart';
import 'package:alumni_association_app/features/member/widgets/member_feature_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
///我的消息
class MemberMessagesPage extends StatelessWidget {
  const MemberMessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MemberMessagesController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.myMessages,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: controller.markAllRead,
            child: Text(context.l10n.markAllRead),
          ),
        ],
      ),
      body: Obx(() {
        final selectedTab = controller.selectedTab.value;
        final messages = controller.filteredMessages;
        final readIds = controller.readIds.toSet();
        return ListView(
          padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 24.h),
          children: [
            MemberFeatureTabs(
              labels: [
                context.l10n.all,
                context.l10n.systemNotification,
                context.l10n.activityNotification,
                context.l10n.merchantNotification,
              ],
              selectedIndex: selectedTab,
              onSelected: (index) => controller.selectedTab.value = index,
            ),
            SizedBox(height: 16.h),
            ...messages.map(
              (message) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: InkWell(
                  onTap: () => controller.markRead(message.id),
                  borderRadius: BorderRadius.circular(16.r),
                  child: Container(
                    padding: EdgeInsets.all(16.r),
                    decoration: memberFeatureCardDecoration,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25.r,
                          backgroundColor: const Color(0xFFEAF2FF),
                          child: Icon(
                            controller.iconFor(message),
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message.title,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                message.content,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                _typeLabel(context, message.type),
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Column(
                          children: [
                            Text(
                              message.time,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 10.sp,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            if (!readIds.contains(message.id))
                              CircleAvatar(
                                radius: 4.r,
                                backgroundColor: AppColors.primary,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  String _typeLabel(BuildContext context, String type) => switch (type) {
    'activity' => context.l10n.activityNotification,
    'merchant' => context.l10n.merchantNotification,
    _ => context.l10n.systemNotification,
  };
}
