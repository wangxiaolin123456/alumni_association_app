import 'package:alumni_association_app/app/router/app_router.dart';
import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/config/app_config.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/consumption/pages/consumption_entry_controller.dart';
import 'package:alumni_association_app/features/profile/pages/merchant_type_item.dart';
import 'package:alumni_association_app/features/store/model/response/store_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../store/pages/store_controller.dart';

/// 会员消费入单 - 选择商户
class ConsumptionMerchantPage extends StatelessWidget {
  const ConsumptionMerchantPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ConsumptionEntryController>();

    return Scaffold(
      backgroundColor: AppColors.background,
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
      body: RefreshIndicator(
        onRefresh: controller.refreshMerchants,
        color: AppColors.primary,
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification.metrics.pixels >
                notification.metrics.maxScrollExtent - 100.h &&
                controller.hasMore.value &&
                !controller.isLoading.value) {
              controller.loadMore();
            }
            return false;
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(14.w, 4.h, 14.w, 105.h),
            children: [
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 42.h,
                      child: TextField(
                        controller: controller.searchController,
                        onChanged: controller.search,
                        style: TextStyle(fontSize: 13.sp),
                        decoration: InputDecoration(
                          hintText: context.l10n.storeSearchHint,
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
                  Obx(
                        () => _CategoryButton(
                      text: controller.selectedCategoryName(context),
                      onTap: () => _showCategorySheet(
                        context: context,
                        controller: controller,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.h),
              Obx(() {
                final isLoading = controller.isLoading.value;
                final merchants = controller.merchants;
                final hasMore = controller.hasMore.value;
                final selectedIndex = controller.selectedMerchantIndex.value;

                if (isLoading && merchants.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.only(top: 120.h),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (merchants.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.only(top: 120.h),
                    child: Center(
                      child: Text(
                        context.l10n.noAvailableStores,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: merchants.length + (hasMore ? 1 : 0),
                  separatorBuilder: (_, _) => SizedBox(height: 10.h),
                  itemBuilder: (_, index) {
                    if (index >= merchants.length) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      );
                    }

                    final merchant = merchants[index];
                    final selected = index == selectedIndex;

                    return _MerchantItem(
                      merchant: merchant,
                      selected: selected,
                      onTap: () => controller.selectMerchant(merchant),
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(14.w, 8.h, 14.w, 12.h),
          child: Obx(
                () => FilledButton(
              onPressed: controller.canContinueFromMerchant
                  ? () {
                Get.find<StoreController>().selectStore(controller.selectedMerchant);
                Get.toNamed(Pages.storeDetail);
              }
                  : null,
              child: Text(context.l10n.nextStep),
            ),
          ),
        ),
      ),
    );
  }

  void _showCategorySheet({
    required BuildContext context,
    required ConsumptionEntryController controller,
  }) {
    Get.bottomSheet<void>(
      _ConsumptionCategorySheet(
        controller: controller,
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}

class _CategoryButton extends StatelessWidget {
  const _CategoryButton({
    required this.text,
    required this.onTap,
  });

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10.r),
      onTap: onTap,
      child: Container(
        height: 42.h,
        constraints: BoxConstraints(maxWidth: 118.w),
        padding: EdgeInsets.symmetric(horizontal: 12.w),
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
            Flexible(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
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
    );
  }
}

class _ConsumptionCategorySheet extends StatelessWidget {
  const _ConsumptionCategorySheet({
    required this.controller,
  });

  final ConsumptionEntryController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 430.h,
      padding: EdgeInsets.fromLTRB(18.w, 12.h, 18.w, 20.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFF),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24.r),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 42.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: const Color(0xFFD5DFEF),
              borderRadius: BorderRadius.circular(999.r),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Text(
                context.l10n.allCategories,
                style: TextStyle(
                  fontSize: 18.sp,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: Get.back,
                icon: Icon(
                  Icons.close_rounded,
                  size: 22.sp,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Expanded(
            child: Obx(() {
              final types = controller.merchantTypes;
              final selectedIndex = controller.selectedCategoryIndex.value;

              if (types.isEmpty) {
                return Center(
                  child: Text(
                    context.l10n.noAvailableStores,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                );
              }

              return GridView.builder(
                padding: EdgeInsets.only(top: 8.h),
                itemCount: types.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 46.h,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 10.h,
                ),
                itemBuilder: (context, index) {
                  final type = types[index];
                  final selected = index == selectedIndex;

                  return _CategorySheetItem(
                    item: type,
                    selected: selected,
                    onTap: () {
                      controller.selectCategoryByIndex(index);
                      Get.back();
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _CategorySheetItem extends StatelessWidget {
  const _CategorySheetItem({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final MerchantTypeItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final title = item.id == 0 ? context.l10n.allCategories : item.typeName;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(13.r),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(13.r),
          border: Border.all(
            color: selected ? AppColors.primary : const Color(0xFFE0E5EE),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1E5AA8).withValues(alpha: 0.045),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.textPrimary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
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

  final StoreResponse merchant;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final name = merchant.shopName.trim().isEmpty
        ? context.l10n.unnamedStore
        : merchant.shopName;

    final typeName = merchant.typeName.trim().isEmpty
        ? context.l10n.allCategories
        : merchant.typeName;

    final address = merchant.fullAddress.trim().isEmpty
        ? context.l10n.noAddress
        : merchant.fullAddress;

    final timeText = _businessHoursText(merchant);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEAF2FF) : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: selected ? AppColors.primary : const Color(0xFFEAF0F7),
            width: selected ? 1.6 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: selected
                  ? AppColors.primary.withValues(alpha: 0.16)
                  : const Color(0xFF1E5AA8).withValues(alpha: 0.045),
              blurRadius: selected ? 20 : 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            _MerchantVisual(
              merchant: merchant,
              width: 78.w,
              height: 78.h,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: SizedBox(
                // height: 78.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                     address,
                      style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
                    ),

                    if (timeText.isNotEmpty) ...[
                      SizedBox(height: 5.h),
                      Text(
                        "营业时间：$timeText",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],

                    SizedBox(height: 5.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF2E9),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        typeName,
                        style: TextStyle(
                          fontSize: 8.sp,
                          color: const Color(0xFFFF5B22),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8.w),
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

  String _businessHoursText(StoreResponse store) {
    final start = store.businessStartTime.trim();
    final end = store.businessEndTime.trim();

    if (start.isEmpty && end.isEmpty) return '';
    if (start.isNotEmpty && end.isNotEmpty) return '$start - $end';
    if (start.isNotEmpty) return start;
    return end;
  }
}

class _MerchantVisual extends StatelessWidget {
  const _MerchantVisual({
    required this.merchant,
    required this.width,
    required this.height,
  });

  final StoreResponse merchant;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final imageUrl = merchant.imageUrls.isEmpty ? '' : AppConfig.apiBaseUrl+merchant.imageUrls.first;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: SizedBox(
        width: width,
        height: height,
        child: imageUrl.trim().isEmpty
            ? Image.asset(
          'assets/default_image.png',
          width: width,
          height: height,
          fit: BoxFit.cover,
        )
            : Image.network(
          _networkImageUrl(imageUrl),
          width: width,
          height: height,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) {
            return Image.asset(
              'assets/default_image.png',
              width: width,
              height: height,
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }

  String _networkImageUrl(String path) {
    final value = path.trim();

    if (value.startsWith('http://') || value.startsWith('https://')) {
      return value;
    }

    const base = String.fromEnvironment('API_BASE_URL');

    if (base.isEmpty) {
      return value;
    }

    final cleanBase = base.endsWith('/')
        ? base.substring(0, base.length - 1)
        : base;

    final cleanPath = value.startsWith('/') ? value : '/$value';

    return '$cleanBase$cleanPath';
  }
}

TextStyle get _secondaryText => TextStyle(
  fontSize: 12.sp,
  color: AppColors.textSecondary,
  fontWeight: FontWeight.w500,
);