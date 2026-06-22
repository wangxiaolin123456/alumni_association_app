import 'package:alumni_association_app/app/router/app_router.dart';
import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/core/widgets/pagination_footer.dart';
import 'package:alumni_association_app/features/store/model/response/store_response.dart';
import 'package:alumni_association_app/features/store/presentation/store_controller.dart';
import 'package:alumni_association_app/features/store/presentation/store_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

/// 底部商家首页
class StoreListPage extends StatefulWidget {
  const StoreListPage({super.key});

  @override
  State<StoreListPage> createState() => _StoreListPageState();
}

class _StoreListPageState extends State<StoreListPage> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StoreController>();
    final categories = [
      context.l10n.all,
      context.l10n.food,
      context.l10n.hotel,
      context.l10n.travel,
      context.l10n.education,
      context.l10n.medical,
      context.l10n.retail,
    ];

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification &&
            notification.dragDetails != null &&
            notification.metrics.pixels > 0 &&
            notification.metrics.extentAfter < 120) {
          controller.loadMoreStores();
        }
        return false;
      },
      child: RefreshIndicator(
        onRefresh: controller.refreshStores,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(14.w, 18.h, 14.w, 24.h),
          children: [
            TextField(
              controller: controller.searchController,
              onChanged: controller.search,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),
              decoration: InputDecoration(
                hintText: context.l10n.storeSearchHint,
                prefixIcon: const Icon(Icons.search_rounded),
                // suffixIcon: const Icon(Icons.grid_view_rounded),
              ),
            ),
            SizedBox(height: 10.h),
            SizedBox(
              height: 32.h,
              child: Obx(() {
                final selectedCategory = controller.selectedCategory.value;
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, _) => SizedBox(width: 16.w),
                  itemBuilder: (context, index) => InkWell(
                    onTap: () => controller.selectCategory(index),
                    child: Column(
                      children: [
                        Text(
                          categories[index],
                          style: TextStyle(
                            color: selectedCategory == index
                                ? AppColors.primary
                                : AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (selectedCategory == index)
                          Container(
                            width: 20.w,
                            height: 2.h,
                            margin: EdgeInsets.only(top: 6.h),
                            color: AppColors.primary,
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 8.h),
            Obx(() {
              final stores = controller.visibleStores;
              final loading = controller.isLoadingMore.value;
              return Column(
                children: [
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: stores.length,
                    separatorBuilder: (_, _) => SizedBox(height: 10.h),
                    itemBuilder: (context, index) {
                      final store = stores[index];
                      return _StoreListItem(
                        store: store,
                        onTap: () {
                          controller.selectStore(store);
                          context.push(Pages.storeDetail);
                        },
                      );
                    },
                  ),
                  PaginationFooter(
                    loading: loading,
                    hasMore: controller.hasMoreStores,
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _StoreListItem extends StatelessWidget {
  const _StoreListItem({required this.store, required this.onTap});

  final StoreResponse store;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(10.r),
        decoration: storeCardDecoration,
        child: Row(
          children: [
            StoreVisual(store: store, width: 104.w, height: 78.h),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store.name,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(store.address, maxLines: 1, style: storeSecondaryText),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      _Tag(text: context.l10n.memberStore),
                      SizedBox(width: 5.w),
                      _Tag(text: context.l10n.memberDiscount),
                      const Spacer(),
                      Text(store.distance, style: storeSecondaryText),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF2E9),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 8.sp, color: const Color(0xFFFF5B22)),
      ),
    );
  }
}
