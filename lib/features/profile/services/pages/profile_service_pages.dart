import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/member/widgets/member_feature_widgets.dart';
import 'package:alumni_association_app/features/profile/services/model/profile_service_item.dart';
import 'package:alumni_association_app/features/profile/services/pages/profile_services_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

enum ProfileServiceListType { opportunities, posts, activities, benefits }

class ProfileServiceListPage extends StatelessWidget {
  const ProfileServiceListPage({required this.type, super.key});
  final ProfileServiceListType type;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileServicesController>();
    final items = switch (type) {
      ProfileServiceListType.opportunities => controller.myOpportunities,
      ProfileServiceListType.posts => controller.myPosts,
      ProfileServiceListType.activities => controller.myActivities,
      ProfileServiceListType.benefits => controller.myBenefits,
    };
    return Scaffold(
      appBar: AppBar(title: Text(_title(context),
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18.sp,
        ),), centerTitle: true),
      body: ListView.separated(
        padding: EdgeInsets.all(14.r),
        itemCount: items.length,
        separatorBuilder: (_, _) => SizedBox(height: 12.h),
        itemBuilder: (_, index) => _ServiceCard(item: items[index]),
      ),
    );
  }

  String _title(BuildContext context) => switch (type) {
    ProfileServiceListType.opportunities => context.l10n.myOpportunities,
    ProfileServiceListType.posts => context.l10n.myPosts,
    ProfileServiceListType.activities => context.l10n.myActivities,
    ProfileServiceListType.benefits => context.l10n.myBenefits,
  };
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.item});
  final ProfileServiceItem item;

  @override
  Widget build(BuildContext context) {
    final color = Color(item.color);
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: memberFeatureCardDecoration,
      child: Row(
        children: [
          CircleAvatar(
            radius: 28.r,
            backgroundColor: color.withValues(alpha: 0.12),
            child: Icon(
              IconData(item.iconCode, fontFamily: 'MaterialIcons'),
              color: color,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  item.subtitle,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                SizedBox(height: 6.h),
                Text(
                  item.meta,
                  style: TextStyle(color: color, fontSize: 10.sp),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}

class ContactServicePage extends StatelessWidget {
  const ContactServicePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.contactService),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(14.r),
        children: [
          _SupportHero(),
          SizedBox(height: 16.h),
          _ContactTile(
            icon: Icons.chat_bubble_outline_rounded,
            title: context.l10n.onlineService,
            subtitle: context.l10n.onlineServiceTime,
          ),
          _ContactTile(
            icon: Icons.phone_outlined,
            title: context.l10n.serviceHotline,
            subtitle: '400-888-2026',
          ),
          _ContactTile(
            icon: Icons.email_outlined,
            title: context.l10n.serviceEmail,
            subtitle: 'service@alumni.example.com',
          ),
        ],
      ),
    );
  }
}

class _SupportHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(28.r),
    decoration: memberFeatureCardDecoration,
    child: Column(
      children: [
        CircleAvatar(
          radius: 42.r,
          backgroundColor: const Color(0xFFEAF2FF),
          child: Icon(
            Icons.support_agent_rounded,
            color: AppColors.primary,
            size: 48.sp,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          context.l10n.howCanWeHelp,
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w800),
        ),
        Text(
          context.l10n.serviceResponseHint,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
      ],
    ),
  );
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.only(bottom: 12.h),
    child: ListTile(
      onTap: () => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.contactRequestSent))),
      leading: CircleAvatar(child: Icon(icon)),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right_rounded),
    ),
  );
}

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileServicesController>();
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.helpCenter), centerTitle: true),
      body: Obx(() {
        final selected = controller.selectedHelpIndex.value;
        return ListView.builder(
          padding: EdgeInsets.all(14.r),
          itemCount: controller.helpQuestionCodes.length,
          itemBuilder: (_, index) => Card(
            margin: EdgeInsets.only(bottom: 10.h),
            child: ExpansionTile(
              key: ValueKey('$selected-$index'),
              initiallyExpanded: selected == index,
              onExpansionChanged: (_) => controller.toggleHelp(index),
              title: Text(
                _helpQuestion(context, controller.helpQuestionCodes[index]),
              ),
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                  child: Text(
                    context.l10n.helpAnswer,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  String _helpQuestion(BuildContext context, String code) => switch (code) {
    'benefits' => context.l10n.helpBenefitsQuestion,
    'activity' => context.l10n.helpActivityQuestion,
    'opportunity' => context.l10n.helpOpportunityQuestion,
    'service' => context.l10n.helpServiceQuestion,
    _ => context.l10n.helpCertificationQuestion,
  };
}

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileServicesController>();
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.feedback), centerTitle: true),
      body: ListView(
        padding: EdgeInsets.all(14.r),
        children: [
          Text(
            context.l10n.feedbackType,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
          ),
          Obx(
            () => Wrap(
              spacing: 8.w,
              children: List.generate(
                3,
                (index) => ChoiceChip(
                  selected: controller.feedbackType.value == index,
                  onSelected: (_) => controller.feedbackType.value = index,
                  label: Text(
                    [
                      context.l10n.featureSuggestion,
                      context.l10n.problemReport,
                      context.l10n.other,
                    ][index],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 18.h),
          TextField(
            controller: controller.feedbackController,
            maxLines: 7,
            decoration: InputDecoration(hintText: context.l10n.feedbackHint),
          ),
          SizedBox(height: 12.h),
          TextField(
            controller: controller.contactController,
            decoration: InputDecoration(
              labelText: context.l10n.contactInformation,
            ),
          ),
          SizedBox(height: 24.h),
          FilledButton(
            onPressed: () async {
              final success = await controller.submitFeedback();
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    success
                        ? context.l10n.feedbackSubmitted
                        : context.l10n.feedbackRequired,
                  ),
                ),
              );
            },
            child: Text(context.l10n.submitFeedback),
          ),
        ],
      ),
    );
  }
}
