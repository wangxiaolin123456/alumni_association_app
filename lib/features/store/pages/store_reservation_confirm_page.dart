import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/store/pages/store_controller.dart';
import 'package:alumni_association_app/features/store/pages/store_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/config/app_config.dart';
import '../model/response/store_response.dart';

class StoreReservationConfirmPage extends StatelessWidget {
  const StoreReservationConfirmPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StoreController>();
    final store = controller.selectedStore;
    final offer = controller.selectedCoupon;
    // final amount = controller.reservationActualTotal;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.reservationConfirmation,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(14.w, 6.h, 14.w, 120.h),
        children: [
          _ConfirmStoreCard(store: store),
          SizedBox(height: 12.h),
          _InfoCard(
            title: context.l10n.reservationPackage,
            children: [
              Text(
                offer!.name,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              Text(offer.description, style: storeSecondaryText),

            ],
          ),
          _InfoCard(
            title: context.l10n.reservationTime,
            children: [
              Text(controller.reservationDateParam),
              Text(controller.reservationAppointmentTime.split(' ').last),
            ],
          ),
          _InfoCard(
            title: context.l10n.guestCount,
            children: [Text('${controller.guestCount.value}')],
          ),
          _InfoCard(
            title: context.l10n.contactInfo,
            children: [
              _KeyValue(
                context.l10n.contact,
                controller.contactController.text,
              ),
              _KeyValue(
                context.l10n.phoneNumber,
                controller.phoneController.text,
              ),
            ],
          ),
          _InfoCard(
            title: context.l10n.notes,
            children: [
              Text(
                controller.noteController.text.isEmpty
                    ? context.l10n.noNotes
                    : controller.noteController.text,
              ),
            ],
          ),

          Container(
            margin: EdgeInsets.only(top: 10.h),
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF5FF),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(context.l10n.reservationWarmTip),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(18.w, 10.h, 18.w, 12.h),
          color: Colors.white,
          child: Obx(
                () => SizedBox(
              width: double.infinity,
              height: 50.h,
              child: FilledButton(
                onPressed: controller.isReservationSubmitting.value
                    ? null
                    : () async {
                  final success = await controller.submitReservationOrder();
                  if (!context.mounted || !success) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.l10n.reservationSubmitted),
                    ),
                  );
                  Get.back();
                },
                child: controller.isReservationSubmitting.value
                    ? SizedBox(
                  width: 18.r,
                  height: 18.r,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : Text(context.l10n.confirmReservation),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ConfirmStoreCard extends StatelessWidget {
  const _ConfirmStoreCard({required this.store});

  final StoreResponse store;

  @override
  Widget build(BuildContext context) {
    final businessTime = _businessTimeText(context, store);
    final address = '${store.province}${store.city}${store.area}${store.address}';

    return StoreSectionCard(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: _storeImage(store),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: SizedBox(
              height: 96.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store.names.trim().isEmpty
                        ? context.l10n.unnamedStore
                        : store.names,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: const Color(0xFF111827),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16.r,
                        color: const Color(0xFF8A93A3),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          address,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: storeSecondaryText,
                        ),
                      ),
                    ],
                  ),
                  if (businessTime.isNotEmpty) ...[
                    SizedBox(height: 4.h),
                    Text(
                      businessTime,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                  const Spacer(),
                  _Tag(
                    text: store.typeName.trim().isEmpty
                        ? context.l10n.memberStore
                        : store.typeName,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _businessTimeText(BuildContext context, StoreResponse store) {
  final start = store.businessStartTime.trim();
  final end = store.businessEndTime.trim();

  if (start.isEmpty && end.isEmpty) return '';
  if (start.isNotEmpty && end.isNotEmpty) {
    return '${context.l10n.businessHours} $start-$end';
  }
  if (start.isNotEmpty) return '${context.l10n.businessStartTime} $start';
  return '${context.l10n.businessEndTime} $end';
}

Widget _storeImage(StoreResponse store) {
  final logo = store.shopLogo.trim();

  if (logo.isEmpty) {
    return Image.asset(
      'assets/default_image.png',
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
    errorBuilder: (_, _, _) => Image.asset(
      'assets/default_image.png',
      width: 78.w,
      height: 78.h,
      fit: BoxFit.cover,
    ),
    loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) return child;
      return Image.asset(
        'assets/default_image.png',
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
    if (text.trim().isEmpty) return const SizedBox.shrink();

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

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: StoreSectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 10.h),
            ...children.map(
              (child) => Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KeyValue extends StatelessWidget {
  const _KeyValue(this.label, this.value, {this.valueColor});
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
