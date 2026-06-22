import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/features/store/model/response/store_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

BoxDecoration get storeCardDecoration => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(16.r),
  boxShadow: [
    BoxShadow(
      color: const Color(0xFF245CA6).withValues(alpha: 0.06),
      blurRadius: 18,
      offset: const Offset(0, 6),
    ),
  ],
);

List<Color> storeGradient(StoreResponse store) =>
    store.accentColors.map(Color.new).toList();

IconData storeIcon(String category) => switch (category) {
  'food' => Icons.restaurant_rounded,
  'hotel' => Icons.apartment_rounded,
  'travel' => Icons.landscape_rounded,
  'education' => Icons.school_rounded,
  'medical' => Icons.medical_services_rounded,
  _ => Icons.storefront_rounded,
};

class StoreVisual extends StatelessWidget {
  const StoreVisual({
    required this.store,
    this.width,
    this.height,
    this.borderRadius,
    super.key,
  });

  final StoreResponse store;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: storeGradient(store)),
        borderRadius: borderRadius ?? BorderRadius.circular(12.r),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -8.w,
            bottom: -8.h,
            child: Icon(
              Icons.apartment_rounded,
              color: Colors.white24,
              size: 76.sp,
            ),
          ),
          Center(
            child: Icon(
              storeIcon(store.category),
              color: Colors.white,
              size: 38.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class StoreSectionCard extends StatelessWidget {
  const StoreSectionCard({required this.child, this.padding, super.key});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsets.all(16.r),
      decoration: storeCardDecoration,
      child: child,
    );
  }
}

TextStyle get storeSecondaryText =>
    TextStyle(fontSize: 11.sp, color: AppColors.textSecondary);
