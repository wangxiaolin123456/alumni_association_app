import 'package:alumni_association_app/app/router/app_router.dart';
import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/config/app_config.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/merchant/center/pages/controller/my_merchant_controller.dart';
import 'package:alumni_association_app/features/store/model/response/store_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// 我的商户页面。
class MyMerchantPage extends StatelessWidget {
  const MyMerchantPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyMerchantController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: Get.back,
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18.sp,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        title: Text(
          context.l10n.myMerchant,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: InkWell(
              onTap: () => Get.toNamed(Pages.merchantOnboardingPage),
              borderRadius: BorderRadius.circular(18.r),
              child: Container(
                width: 36.w,
                height: 36.w,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.merchants.isEmpty) {
          return const SizedBox.shrink();
        }
        if (controller.merchants.isEmpty) {
          return _EmptyMerchant(onRefresh: controller.fetchMyMerchants);
        }

        return RefreshIndicator(
          onRefresh: controller.fetchMyMerchants,
          child: ListView.separated(
            padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 28.h),
            itemCount: controller.merchants.length,
            separatorBuilder: (_, _) => SizedBox(height: 14.h),
            itemBuilder: (context, index) {
              return _MerchantCard(store: controller.merchants[index]);
            },
          ),
        );
      }),
    );
  }
}

class _MerchantCard extends StatelessWidget {
  const _MerchantCard({required this.store});

  final StoreResponse store;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(
        Pages.merchantDashboard,
        arguments: {'shopId': store.shopId},
      ),
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFEAF0F7)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1D5CA8).withValues(alpha: 0.06),
              blurRadius: 22,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: _MerchantLogo(store: store),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          store.shopName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      _StatusTag(status: store.shopStatus),
                    ],
                  ),
                  SizedBox(height: 14.h),
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline_rounded,
                        size: 14.sp,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: 4.w),
                      Flexible(
                        child: Text(
                          '${context.l10n.contact}: ${store.names}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: _metaStyle,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Icon(
                        Icons.phone_outlined,
                        size: 14.sp,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: 4.w),
                      Text(_maskPhone(store.phone), style: _metaStyle),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 15.sp,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          store.fullAddress.replaceAll(' · ', ''),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: _metaStyle,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 6.w),
            Icon(
              Icons.chevron_right_rounded,
              size: 26.sp,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _MerchantLogo extends StatelessWidget {
  const _MerchantLogo({required this.store});

  final StoreResponse store;

  @override
  Widget build(BuildContext context) {
    final logo = store.shopLogo.trim();
    if (logo.isEmpty) return _LogoFallback();

    return Image.network(
      _imageUrl(logo),
      width: 94.w,
      height: 94.w,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => _LogoFallback(),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _LogoFallback();
      },
    );
  }
}

class _LogoFallback extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 94.w,
      height: 94.w,
      color: const Color(0xFFEAF2FF),
      child: Icon(
        Icons.storefront_rounded,
        color: AppColors.primary,
        size: 34.sp,
      ),
    );
  }
}

class _StatusTag extends StatelessWidget {
  const _StatusTag({required this.status});

  final int status;

  @override
  Widget build(BuildContext context) {
    final active = status == 1;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFE8FAF1) : const Color(0xFFFFF3E1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        active ? context.l10n.inOperation : context.l10n.pendingReview,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w800,
          color: active ? AppColors.success : AppColors.warning,
        ),
      ),
    );
  }
}

class _EmptyMerchant extends StatelessWidget {
  const _EmptyMerchant({required this.onRefresh});

  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        children: [
          SizedBox(height: 160.h),
          Icon(
            Icons.storefront_rounded,
            size: 68.sp,
            color: AppColors.primary.withValues(alpha: 0.35),
          ),
          SizedBox(height: 18.h),
          Text(
            context.l10n.noMerchantYet,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            context.l10n.noMerchantYetDesc,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              height: 1.45,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

TextStyle get _metaStyle => TextStyle(
  fontSize: 12.sp,
  color: AppColors.textSecondary,
  fontWeight: FontWeight.w500,
);

String _maskPhone(String phone) {
  final value = phone.trim();
  if (value.length < 7) return value;
  return '${value.substring(0, 3)}****${value.substring(value.length - 4)}';
}

String _imageUrl(String path) {
  if (path.startsWith('http://') || path.startsWith('https://')) return path;
  if (path.startsWith('/')) return '${AppConfig.apiBaseUrl}$path';
  return '${AppConfig.apiBaseUrl}/$path';
}
