import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/store/presentation/store_controller.dart';
import 'package:alumni_association_app/features/store/presentation/store_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class StoreReservationConfirmPage extends StatelessWidget {
  const StoreReservationConfirmPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StoreController>();
    final store = controller.selectedStore;
    final offer = controller.selectedOffer;
    final amount = offer.price - 29;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.reservationConfirmation,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(14.w, 6.h, 14.w, 120.h),
        children: [
          StoreSectionCard(
            child: Row(
              children: [
                StoreVisual(store: store, width: 86.w, height: 72.h),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        store.name,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        store.address,
                        maxLines: 1,
                        style: storeSecondaryText,
                      ),
                    ],
                  ),
                ),
                Text(store.distance),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          _InfoCard(
            title: context.l10n.reservationPackage,
            children: [
              Text(
                offer.title,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              Text(offer.subtitle, style: storeSecondaryText),
              Text(
                '¥${offer.price.toStringAsFixed(0)}',
                style: TextStyle(
                  color: const Color(0xFFFF5B22),
                  fontSize: 18.sp,
                ),
              ),
            ],
          ),
          _InfoCard(
            title: context.l10n.reservationTime,
            children: [
              Text(
                '2026-${controller.reservationDates[controller.selectedDateIndex.value]}',
              ),
              Text(
                controller.reservationTimes[controller.selectedTimeIndex.value],
              ),
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
          _InfoCard(
            title: context.l10n.benefitInfo,
            children: [
              _KeyValue(context.l10n.memberDiscount, '- ¥29'),
              Divider(height: 24.h),
              _KeyValue(
                context.l10n.discountedAmount,
                '¥${amount.toStringAsFixed(0)}',
                valueColor: const Color(0xFFFF5B22),
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
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${context.l10n.amountDue}\n¥${amount.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: const Color(0xFFFF5B22),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Expanded(
                child: FilledButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(context.l10n.reservationSubmitted)),
                  ),
                  child: Text(context.l10n.confirmReservation),
                ),
              ),
            ],
          ),
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
