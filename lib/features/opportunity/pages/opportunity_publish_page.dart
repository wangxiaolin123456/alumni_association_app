import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/opportunity/pages/opportunity_controller.dart';
import 'package:alumni_association_app/features/opportunity/pages/opportunity_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
///发布商机
class OpportunityPublishPage extends StatelessWidget {
  const OpportunityPublishPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OpportunityController>();
    final categoryLabels = [
      context.l10n.cooperationNeeds,
      context.l10n.resourceConnection,
      context.l10n.investmentFinancing,
      context.l10n.franchiseRecruitment,
    ];
    final advantages = [
      context.l10n.capitalAdvantage,
      context.l10n.technicalAdvantage,
      context.l10n.marketAdvantage,
      context.l10n.resourceAdvantage,
      context.l10n.teamAdvantage,
      context.l10n.brandAdvantage,
      context.l10n.channelAdvantage,
      context.l10n.otherAdvantage,
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(context.l10n.publishOpportunity,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(14.w, 6.h, 14.w, 110.h),
        children: [
          _FormSection(
            title: context.l10n.basicInformation,
            children: [
              _FieldLabel(context.l10n.opportunityTitle, required: true),
              TextField(
                controller: controller.titleController,
                maxLength: 30,
                onChanged: (_) => controller.updateForm(),
                decoration: InputDecoration(
                  hintText: context.l10n.opportunityTitleHint,
                ),
              ),
              _FieldLabel(context.l10n.opportunityCategory, required: true),
              Obx(
                () => DropdownButtonFormField<int>(
                  value: controller.selectedPublishCategory.value,
                  items: categoryLabels
                      .asMap()
                      .entries
                      .map(
                        (entry) => DropdownMenuItem(
                          value: entry.key,
                          child: Text(entry.value),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      controller.selectPublishCategory(value ?? 0),
                ),
              ),
              _SelectRow(label: context.l10n.cooperationType),
              _SelectRow(label: context.l10n.industry),
              _SelectRow(label: context.l10n.projectRegion),
              _SelectRow(label: context.l10n.budgetRange),
            ],
          ),
          SizedBox(height: 12.h),
          _FormSection(
            title: context.l10n.opportunityInfo,
            children: [
              _FieldLabel(context.l10n.opportunityDescription, required: true),
              TextField(
                controller: controller.descriptionController,
                minLines: 5,
                maxLines: 7,
                maxLength: 1000,
                onChanged: (_) => controller.updateForm(),
                decoration: InputDecoration(
                  hintText: context.l10n.opportunityDescriptionHint,
                ),
              ),
              _FieldLabel(context.l10n.requirementList),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: categoryLabels
                    .map(
                      (label) =>
                          FilterChip(label: Text(label), onSelected: (_) {}),
                    )
                    .toList(),
              ),
              SizedBox(height: 16.h),
              _FieldLabel(context.l10n.cooperationAdvantages),
              Obx(() {
                final selectedIndexes = controller.selectedAdvantageIndexes
                    .toSet();
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisExtent: 68.h,
                    crossAxisSpacing: 8.w,
                    mainAxisSpacing: 8.h,
                  ),
                  itemCount: advantages.length,
                  itemBuilder: (_, index) => InkWell(
                    onTap: () => controller.toggleAdvantage(index),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selectedIndexes.contains(index)
                            ? const Color(0xFFEDF4FF)
                            : const Color(0xFFF8FAFD),
                        borderRadius: BorderRadius.circular(9.r),
                        border: Border.all(
                          color: selectedIndexes.contains(index)
                              ? AppColors.primary
                              : Colors.transparent,
                        ),
                      ),
                      child: Text(
                        advantages[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 9.sp),
                      ),
                    ),
                  ),
                );
              }),
              SizedBox(height: 16.h),
              _FieldLabel(context.l10n.attachments),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.upload_file_outlined),
                label: Text(context.l10n.uploadDocuments),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _FormSection(
            title: context.l10n.contactInfo,
            children: [
              _ContactField(
                label: context.l10n.contact,
                controller: controller.contactController,
              ),
              _ContactField(
                label: context.l10n.phoneNumber,
                controller: controller.phoneController,
              ),
              _ContactField(
                label: context.l10n.email,
                controller: controller.emailController,
              ),
              _ContactField(
                label: context.l10n.contactAddress,
                controller: controller.addressController,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _FormSection(
            title: context.l10n.otherSettings,
            children: [
              _FieldLabel(context.l10n.validityPeriod, required: true),
              Obx(
                () => Wrap(
                  spacing: 8.w,
                  children: [30, 60, 90].map((days) {
                    return ChoiceChip(
                      label: Text(context.l10n.daysCount(days)),
                      selected: controller.validityDays.value == days,
                      onSelected: (_) => controller.selectValidity(days),
                    );
                  }).toList(),
                ),
              ),
              _FieldLabel(context.l10n.visibility, required: true),
              Obx(
                () => Column(
                  children: [
                    RadioListTile<bool>(
                      value: true,
                      groupValue: controller.publicVisibility.value,
                      onChanged: (value) =>
                          controller.setVisibility(value ?? true),
                      title: Text(context.l10n.publicVisible),
                    ),
                    RadioListTile<bool>(
                      value: false,
                      groupValue: controller.publicVisibility.value,
                      onChanged: (value) =>
                          controller.setVisibility(value ?? false),
                      title: Text(context.l10n.alumniOnlyVisible),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Obx(
            () => CheckboxListTile(
              value: controller.agreementAccepted.value,
              onChanged: controller.toggleAgreement,
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(context.l10n.agreeOpportunityTerms),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(18.w, 8.h, 18.w, 12.h),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: Text(context.l10n.preview),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                flex: 2,
                child: Obx(() {
                  controller.formRevision.value;
                  return FilledButton(
                    onPressed: () {
                      controller.publish();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            controller.published.value
                                ? context.l10n.opportunityPublished
                                : context.l10n.completeRequiredFields,
                          ),
                        ),
                      );
                    },
                    child: Text(context.l10n.publishOpportunity),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormSection extends StatelessWidget {
  const _FormSection({required this.title, required this.children});
  final String title;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => OpportunitySectionCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 12.h),
        ...children.map(
          (child) => Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: child,
          ),
        ),
      ],
    ),
  );
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text, {this.required = false});
  final String text;
  final bool required;
  @override
  Widget build(BuildContext context) => Text(
    '$text${required ? ' *' : ''}',
    style: TextStyle(
      fontWeight: FontWeight.w600,
      color: required ? AppColors.textPrimary : null,
    ),
  );
}

class _SelectRow extends StatelessWidget {
  const _SelectRow({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(label),
    trailing: const Icon(Icons.chevron_right_rounded),
    shape: RoundedRectangleBorder(
      side: const BorderSide(color: Color(0xFFE7EBF2)),
      borderRadius: BorderRadius.circular(10.r),
    ),
  );
}

class _ContactField extends StatelessWidget {
  const _ContactField({required this.label, required this.controller});
  final String label;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    decoration: InputDecoration(labelText: label),
  );
}
