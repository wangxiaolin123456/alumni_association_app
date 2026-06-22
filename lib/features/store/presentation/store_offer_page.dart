import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/store/presentation/store_controller.dart';
import 'package:alumni_association_app/features/store/presentation/store_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class StoreOfferPage extends StatelessWidget {
  const StoreOfferPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StoreController>();
    final store = controller.selectedStore;
    final offer = controller.selectedOffer;

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.useBenefit,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18.sp,
        ),), centerTitle: true),
      body: ListView(
        padding: EdgeInsets.fromLTRB(14.w, 8.h, 14.w, 24.h),
        children: [
          StoreSectionCard(
            child: Column(
              children: [
                Row(
                  children: [
                    StoreVisual(store: store, width: 72.r, height: 72.r),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            offer.title,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(store.name, style: storeSecondaryText),
                          Text(
                            '¥${offer.price.toStringAsFixed(0)}',
                            style: TextStyle(
                              color: const Color(0xFFFF5B22),
                              fontSize: 17.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(height: 28.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    context.l10n.instructions,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(height: 8.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(context.l10n.offerInstructions),
                ),
                SizedBox(height: 24.h),
                Obx(
                  () => QrImageView(
                    data:
                        '${store.id}-${offer.id}-${controller.qrRefreshCount.value}',
                    size: 176.r,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(context.l10n.qrRefreshHint, style: storeSecondaryText),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: controller.refreshQrCode,
                    child: Text(context.l10n.refreshQrCode),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),
          StoreSectionCard(
            child: Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.phone_outlined),
                    label: Text(context.l10n.contactMerchant),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.navigation_outlined),
                    label: Text(context.l10n.navigateToStore),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
