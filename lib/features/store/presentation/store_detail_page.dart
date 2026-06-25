import 'package:alumni_association_app/app/router/app_router.dart';
import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/config/app_config.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/store/model/response/store_response.dart';
import 'package:alumni_association_app/features/store/presentation/store_controller.dart';
import 'package:alumni_association_app/features/store/presentation/store_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

///商家详情
class StoreDetailPage extends StatelessWidget {
  const StoreDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StoreController>();
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      body: Obx(() {
        final store = controller.selectedStore;
        return Stack(
          children: [
            ListView(
              padding: EdgeInsets.fromLTRB(16.w, 70.h, 16.w, 128.h),
              children: [
                _HeroInfoCard(store: store),
                SizedBox(height: 14.h),
                ///会员优惠
                if (store.coupons.isNotEmpty) ...[
                  _BenefitCard(
                    store: store,
                    onUseOffer: (index) {
                      controller.selectOffer(index);
                      Get.toNamed(Pages.storeOffer);
                    },
                  ),
                  SizedBox(height: 14.h),
                ],
                const _IntroCard(),
              ],
            ),
            ///头布局
            _FloatingTopBar(controller: controller),
          ],
        );
      }),
      bottomNavigationBar: const _BottomBar(),
    );
  }
}

class _FloatingTopBar extends StatelessWidget {
  const _FloatingTopBar({required this.controller});

  final StoreController controller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(14.w, 0.h, 16.w, 8.h),
        child: Row(
          children: [
            _CircleIconButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: () => Get.back(),
            ),
            const Spacer(),
            Obx(
                  () => GestureDetector(
                onTap: controller.toggleFavorite,
                child: Container(
                  height: 38.h,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: _softShadow,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        controller.isFavorite.value
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        size: 22.r,
                        color: controller.isFavorite.value
                            ? const Color(0xFFFF6A1A)
                            : const Color(0xFF111827),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        context.l10n.favorite,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFF111827),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroInfoCard extends StatelessWidget {
  const _HeroInfoCard({required this.store});

  final StoreResponse store;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26.r),
        boxShadow: _softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StoreImage(store: store),
          Padding(
            padding: EdgeInsets.fromLTRB(10.w, 16.h, 10.w, 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StoreTitleRow(store: store),
                SizedBox(height: 13.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: [
                    _CategoryChip(text: store.typeName),
                  ],
                ),
                SizedBox(height: 12.h),
                _InfoLine(
                  icon: Icons.schedule_rounded,
                  text:
                      '${context.l10n.businessHoursRequired.replaceAll(' *', '')}: ${_businessHoursText(store)}',
                ),
                SizedBox(height: 11.h),
                Row(
                  children: [
                    Expanded(
                      child: _InfoLine(
                        icon: Icons.location_on_outlined,
                        text: store.fullAddress,
                      ),
                    ),

                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StoreImage extends StatefulWidget {
  const _StoreImage({required this.store});

  final StoreResponse store;

  @override
  State<_StoreImage> createState() => _StoreImageState();
}

class _StoreImageState extends State<_StoreImage> {
  late final PageController _pageController;
  int _currentIndex = 0;

  List<String> get _images => widget.store.imageUrls;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void didUpdateWidget(covariant _StoreImage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.store.shopId != widget.store.shopId) {
      _currentIndex = 0;
      if (_pageController.hasClients) {
        _pageController.jumpToPage(0);
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = _images;

    return ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: SizedBox(
        height: 192.h,
        width: double.infinity,
        child: Stack(
          children: [
            if (images.isEmpty)
              Image.asset(
               "assets/default_image.png",
                width: double.infinity,
                height: 192.h,
              )
            else
              PageView.builder(
                controller: _pageController,
                itemCount: images.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Image.network(
                    _networkImageUrl(images[index]),
                    width: double.infinity,
                    height: 192.h,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;

                      return Container(
                        alignment: Alignment.center,
                        // decoration: BoxDecoration(
                          // gradient: LinearGradient(
                          //   begin: Alignment.topLeft,
                          //   end: Alignment.bottomRight,
                            // colors: widget.store.accentColors
                            //     .map((color) => Color(color))
                            //     .toList(),
                          // ),
                        // ),
                        child: SizedBox(
                          width: 22.r,
                          height: 22.r,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return  Image.asset(
                        "assets/default_image.png",
                        width: double.infinity,
                        height: 192.h,
                      );
                    },
                  );
                },
              ),

            /// 图片上轻微渐变，文字点位更清楚
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.02),
                        Colors.black.withOpacity(0.16),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            /// 底部轮播点
            if (images.length > 1)
              Positioned(
                left: 0,
                right: 0,
                bottom: 12.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    images.length,
                        (index) => _BannerDot(
                      selected: index == _currentIndex,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// 详情页营业时间文案，避免接口字段为空时出现孤立连接符。
String _businessHoursText(StoreResponse store) {
  final start = store.businessStartTime.trim();
  final end = store.businessEndTime.trim();

  if (start.isNotEmpty && end.isNotEmpty) return '$start–$end';
  if (start.isNotEmpty) return start;
  if (end.isNotEmpty) return end;
  return '--';
}

/// 后端图片字段通常返回相对路径，详情页统一拼成完整图片地址。
String _networkImageUrl(String path) {
  final value = path.trim();
  if (value.startsWith('http://') || value.startsWith('https://')) {
    return value;
  }
  if (value.startsWith('/')) return '${AppConfig.apiBaseUrl}$value';
  return '${AppConfig.apiBaseUrl}/$value';
}

class _StoreTitleRow extends StatelessWidget {
  const _StoreTitleRow({required this.store});

  final StoreResponse store;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            store.shopName.trim().isEmpty ? store.names : store.shopName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 20.sp,
              height: 1.15,
              color: const Color(0xFF111827),
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        const _MemberBadge(),
      ],
    );
  }
}


///会员优惠
class _BenefitCard extends StatelessWidget {
  const _BenefitCard({
    required this.store,
    required this.onUseOffer,
  });

  final StoreResponse store;
  final ValueChanged<int> onUseOffer;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(14.w, 18.h, 14.w, 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: _softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(title: context.l10n.memberBenefitsTitle),
          SizedBox(height: 14.h),
          ...store.coupons.asMap().entries.map(
                (entry) => _CouponItem(
              coupon: entry.value,
              selected: entry.key == 0,
              onTap: () => onUseOffer(entry.key),
            ),
          ),
        ],
      ),
    );
  }
}

class _CouponItem extends StatelessWidget {
  const _CouponItem({
    required this.coupon,
    required this.selected,
    required this.onTap,
  });

  final StoreCouponResponse coupon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor =
    selected ? const Color(0xFFFFB088) : Colors.transparent;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 13.h),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF7F0),
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: borderColor, width: 1.w),
        ),
        child: Row(
          children: [
            _RadioCircle(selected: selected),
            SizedBox(width: 13.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coupon.displayTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: const Color(0xFFFF5B22),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    coupon.displayDescription,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: const Color(0xFF596273),
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              coupon.displayValue,
              style: TextStyle(
                color: const Color(0xFFFF5B22),
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: _softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(title: context.l10n.storeIntroduction),
          SizedBox(height: 14.h),
          Text(
            context.l10n.storeIntroductionText,
            style: TextStyle(
              fontSize: 14.sp,
              height: 1.75,
              color: const Color(0xFF4B5563),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 16.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.98),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF111827).withOpacity(0.08),
            blurRadius: 22.r,
            offset: Offset(0, -8.h),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 52.h,
                child: OutlinedButton(
                  onPressed: () => Get.toNamed(Pages.storeReservation),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFFEAF2FF),
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: Text(
                    context.l10n.reserveNow,
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: SizedBox(
                height: 52.h,
                child: FilledButton(
                  onPressed: () => Get.toNamed(Pages.storeOffer),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: Text(
                    context.l10n.useNow,
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38.r,
        height: 38.r,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.92),
          shape: BoxShape.circle,
          boxShadow: _softShadow,
        ),
        child: Icon(
          icon,
          size: 19.r,
          color: const Color(0xFF111827),
        ),
      ),
    );
  }
}

class _BannerDot extends StatelessWidget {
  const _BannerDot({this.selected = false});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: selected ? 16.w : 7.w,
      height: 7.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(99.r),
      ),
    );
  }
}

class _MemberBadge extends StatelessWidget {
  const _MemberBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1E8),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.workspace_premium_rounded,
            size: 13.r,
            color: const Color(0xFFFF5B22),
          ),
          SizedBox(width: 4.w),
          Text(
            context.l10n.memberDiscount,
            style: TextStyle(
              color: const Color(0xFFFF5B22),
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.w,
      height: 13.h,
      margin: EdgeInsets.symmetric(horizontal: 11.w),
      color: const Color(0xFFE2E6EF),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F5F9),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: const Color(0xFF4B5563),
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 19.r,
          color: const Color(0xFF6B7280),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: _normalText,
          ),
        ),
      ],
    );
  }
}

class _RadioCircle extends StatelessWidget {
  const _RadioCircle({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 23.r,
      height: 23.r,
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? const Color(0xFFFF6A1A) : const Color(0xFF9CA3AF),
          width: 1.4.w,
        ),
        color: Colors.white,
      ),
      child: selected
          ? Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFFF6A1A),
        ),
      )
          : null,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        color: const Color(0xFF111827),
        fontWeight: FontWeight.w800,
        letterSpacing: -0.2,
      ),
    );
  }
}

TextStyle get _normalText => TextStyle(
  color: const Color(0xFF4B5563),
  fontSize: 14.sp,
  fontWeight: FontWeight.w500,
);

List<BoxShadow> get _softShadow => [
  BoxShadow(
    color: const Color(0xFF1F2937).withOpacity(0.045),
    blurRadius: 22.r,
    offset: Offset(0, 10.h),
  ),
];
