import 'package:alumni_association_app/app/router/app_router.dart';
import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/consumption/model/response/consumption_entry_response.dart';
import 'package:alumni_association_app/features/consumption/presentation/consumption_entry_controller.dart';
import 'package:alumni_association_app/features/consumption/presentation/consumption_entry_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


import '../widget/consumption_category_sheet.dart';

///会员 消费入单
class ConsumptionMerchantPage extends StatelessWidget {
  const ConsumptionMerchantPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ConsumptionEntryController>();
    return Scaffold(
      ///标题
      appBar: AppBar(
        title: Text(
          context.l10n.consumptionEntry,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(14.w, 4.h, 14.w, 105.h),
        children: [
          ///步骤1-4
          const ConsumptionStepIndicator(currentStep: 1),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 44.h,
                  child: TextField(
                    controller: controller.searchController,
                    onChanged: controller.search,
                    style: TextStyle(fontSize: 13.sp),
                    decoration: InputDecoration(
                      hintText: context.l10n.consumptionMerchantSearchHint,
                      hintStyle: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        size: 20.sp,
                        color: AppColors.textSecondary,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 0,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: const BorderSide(
                          color: Color(0xFFE0E5EE),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide(
                          color: AppColors.primary,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(width: 12.w),

              InkWell(
                borderRadius: BorderRadius.circular(10.r),
                onTap: () {

                  showConsumptionCategorySheet(
                    context: context,
                    categories: controller.merchantCategories,
                    selectedCategory: controller.selectedCategory.value,
                    onSelected: controller.selectCategory,

                  );

                },
                child: Container(
                  height: 44.h,
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: const Color(0xFFE0E5EE),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        controller.selectedCategory.value=="all"?
                        context.l10n.allCategories:controller.selectedCategory.value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 18.sp,
                        color: AppColors.textPrimary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Obx(() {
            final merchants = controller.filteredMerchants;
            final selectedIndex = controller.selectedMerchantIndex.value;
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: merchants.length,
              separatorBuilder: (_, _) => SizedBox(height: 10.h),
              itemBuilder: (_, index) {
                final merchant = merchants[index];
                final selected =
                    controller.merchants.indexOf(merchant) == selectedIndex;
                return _MerchantItem(
                  merchant: merchant,
                  selected: selected,
                  onTap: () => controller.selectMerchant(merchant),
                );
              },
            );
          }),
          SizedBox(height: 12.h),
          Center(
            child: TextButton.icon(
              onPressed: () {},
              label: Text(context.l10n.manualEntry),
              icon: const Icon(Icons.chevron_right_rounded),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(14.w, 8.h, 14.w, 12.h),
          child: FilledButton(
            onPressed: () {
              controller.goToStep(2);
              Get.toNamed(Pages.consumptionCoupon);
            },
            child: Text(context.l10n.nextSelectCoupon),
          ),
        ),
      ),
    );
  }
}

class _MerchantItem extends StatelessWidget {
  const _MerchantItem({
    required this.merchant,
    required this.selected,
    required this.onTap,
  });

  final ConsumptionMerchantResponse merchant;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: selected ? AppColors.primary : const Color(0xFFEAF0F7),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            ConsumptionMerchantVisual(
              merchant: merchant,
              width: 92.w,
              height: 78.h,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    merchant.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 7.h),
                  Text(merchant.category, style: consumptionSecondaryText),
                  SizedBox(height: 7.h),
                  Text(
                    '★ ${merchant.rating}    ${merchant.distance}',
                    style: TextStyle(fontSize: 11.sp, color: AppColors.warning),
                  ),
                ],
              ),
            ),
            Icon(
              selected
                  ? Icons.check_circle_rounded
                  : Icons.chevron_right_rounded,
              color: selected ? AppColors.primary : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
