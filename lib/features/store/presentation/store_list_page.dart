import 'package:alumni_association_app/app/router/app_router.dart';
import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/config/app_config.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/core/widgets/pagination_footer.dart';
import 'package:alumni_association_app/features/store/model/response/store_response.dart';
import 'package:alumni_association_app/features/store/presentation/store_controller.dart';
import 'package:alumni_association_app/features/store/presentation/store_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

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

    return ColoredBox(
      color: AppColors.background,
      child: NotificationListener<ScrollNotification>(
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
              /// 顶部搜索
              SizedBox(
                height: 42.h,
                child: TextField(
                  controller: controller.searchController,
                  onChanged: controller.search,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14.sp,
                  ),
                  decoration: InputDecoration(
                    hintText: context.l10n.storeSearchHint,
                    hintStyle: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF9CA3AF),
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      size: 20.sp,
                      color: const Color(0xFF7E8DA3),
                    ),
                    filled: true,
                    fillColor: AppColors.searchBox,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.w,
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

              SizedBox(height: 15.h),

              /// 顶部商户类型 Tab
              SizedBox(
                height: 32.h,
                child: Obx(() {
                  final types = controller.merchantTypes;
                  final selectedIndex = controller.selectedCategory.value;

                  if (types.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: types.length,
                    separatorBuilder: (_, _) => SizedBox(width: 16.w),
                    itemBuilder: (context, index) {
                      final type = types[index];
                      final selected = selectedIndex == index;

                      return InkWell(
                        onTap: () => controller.selectCategory(index),
                        borderRadius: BorderRadius.circular(8.r),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              type.typeName,
                              style: TextStyle(
                                color: selected
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (selected)
                              Container(
                                width: 20.w,
                                height: 2.h,
                                margin: EdgeInsets.only(top: 6.h),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),

              SizedBox(height: 8.h),

              /// 商家列表
              Obx(() {
                final stores = controller.visibleStores;
                final isLoading = controller.isLoading.value;
                final isLoadingMore = controller.isLoadingMore.value;

                if (stores.isEmpty && isLoading) {
                  return Padding(
                    padding: EdgeInsets.only(top: 100.h),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (stores.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.only(top: 100.h),
                    child: Center(
                      child: Text(
                        '暂无商家',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  );
                }

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
                            Get.toNamed(Pages.storeDetail);
                          },
                        );
                      },
                    ),
                    PaginationFooter(
                      loading: isLoadingMore,
                      hasMore: controller.hasMoreStores,
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _StoreListItem extends StatelessWidget {
  const _StoreListItem({
    required this.store,
    required this.onTap,
  });

  final StoreResponse store;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final typeName = store.typeName.trim().isEmpty
        ? context.l10n.memberStore
        : store.typeName;

    final businessTime = _businessTimeText(store);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(10.r),
        decoration: storeCardDecoration,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: _storeImage(store),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: SizedBox(
                height: 78.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      store.shopName,
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
                      store.fullAddress,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: storeSecondaryText,
                    ),
                    if (businessTime.isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      Text(
                        businessTime,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: storeSecondaryText,
                      ),
                    ],
                    const Spacer(),
                    Row(
                      children: [
                        _Tag(text: typeName),
                        SizedBox(width: 5.w),
                        _Tag(text: context.l10n.memberDiscount),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  String _businessTimeText(StoreResponse store) {
    final start = store.businessStartTime.trim();
    final end = store.businessEndTime.trim();

    if (start.isEmpty && end.isEmpty) return '';
    if (start.isNotEmpty && end.isNotEmpty) {
      return '营业时间 $start-$end';
    }
    if (start.isNotEmpty) return '营业开始 $start';
    return '营业结束 $end';
  }
}

///商店logo图
Widget _storeImage(StoreResponse store) {
  final logo = store.shopLogo.trim();

  if (logo.isEmpty) {
    return Image.asset(
      "assets/default_image.png",
      width: 78.w,
      height: 78.h,
      fit: BoxFit.cover,
    );
  }

  return Image.network(
    AppConfig.apiBaseUrl + logo,
    width: 78.w,
    height: 78.h,
    fit: BoxFit.cover,

    // 加载失败显示默认图
    errorBuilder: (context, error, stackTrace) {
      return Image.asset(
        "assets/default_image.png",
        width: 78.w,
        height: 78.h,
        fit: BoxFit.cover,
      );
    },

    // 加载中显示默认图或者 loading
    loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) {
        return child;
      }

      return Image.asset(
        "assets/default_image.png",
        width: 78.w,
        height: 78.h,
        fit: BoxFit.cover,
      );
    },
  );
}

class _Tag extends StatelessWidget {
  const _Tag({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    if (text.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF2E9),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 8.sp,
          color: const Color(0xFFFF5B22),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}