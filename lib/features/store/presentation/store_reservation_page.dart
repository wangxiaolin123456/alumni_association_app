import 'package:alumni_association_app/app/router/app_router.dart';
import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/store/model/response/store_response.dart';
import 'package:alumni_association_app/features/store/presentation/store_controller.dart';
import 'package:alumni_association_app/features/store/presentation/store_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class StoreReservationPage extends StatelessWidget {
  const StoreReservationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StoreController>();
    final store = controller.selectedStore;
    final offer = controller.selectedOffer;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        title: Text(context.l10n.reservationInfo,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(14.w, 8.h, 14.w, 20.h),
                children: [
                  _StoreInfoCard(store: store),
                  SizedBox(height: 12.h),
                  _SelectedOfferCard(offer: offer),
                  SizedBox(height: 12.h),
                  _DateCard(controller: controller),
                  SizedBox(height: 12.h),
                  _TimeCard(controller: controller),
                  SizedBox(height: 12.h),
                  _ReservationFormCard(controller: controller),
                  SizedBox(height: 14.h),
                  _AgreementRow(controller: controller),
                  SizedBox(height: 18.h),
                  _ConfirmButton(controller: controller),
                  SizedBox(height: 12.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 6.w,
            child: IconButton(
              onPressed: () => context.pop(),
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 22.r,
                color: const Color(0xFF111827),
              ),
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              color: const Color(0xFF111827),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _StoreInfoCard extends StatelessWidget {
  const _StoreInfoCard({required this.store});

  final StoreResponse store;

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      padding: EdgeInsets.all(12.r),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: StoreVisual(
              store: store,
              width: 96.w,
              height: 76.h,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: SizedBox(
              height: 76.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          store.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: const Color(0xFF111827),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      SizedBox(width: 6.w),
                      const _MemberStoreBadge(),
                    ],
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
                          store.address,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: const Color(0xFF6B7280),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            store.distance,
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF4B5563),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectedOfferCard extends StatelessWidget {
  const _SelectedOfferCard({required this.offer});

  final StoreOfferResponse offer;

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      padding: EdgeInsets.fromLTRB(14.w, 16.h, 14.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(text: context.l10n.selectReservationPackage),
          SizedBox(height: 14.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7F0),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Row(
              children: [
                Container(
                  width: 42.r,
                  height: 42.r,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF5B22),
                    borderRadius: BorderRadius.circular(8.r),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF5B22).withOpacity(0.22),
                        blurRadius: 10.r,
                        offset: Offset(0, 4.h),
                      ),
                    ],
                  ),
                  child: Text(
                    '折',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        offer.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: const Color(0xFF111827),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        offer.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: const Color(0xFF6B7280),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      offer.discountLabel,
                      style: TextStyle(
                        color: const Color(0xFFFF5B22),
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '有效期至 2024.06.30',
                      style: TextStyle(
                        color: const Color(0xFF6B7280),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
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
/// 选择日期
class _DateCard extends StatelessWidget {
  const _DateCard({required this.controller});

  final StoreController controller;

  @override
  Widget build(BuildContext context) {
    final weekTexts = ['周一', '周二', '周三', '周四', '周五'];

    return _WhiteCard(
      padding: EdgeInsets.fromLTRB(14.w, 16.h, 14.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(text: context.l10n.selectDate),
          SizedBox(height: 14.h),
          SizedBox(
            height: 82.h,
            child: Obx(() {
              final selectedDate = controller.selectedDateIndex.value;
              final customDate = controller.selectedCustomDate.value;

              return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: controller.reservationDates.length + 1,
                separatorBuilder: (_, _) => SizedBox(width: 9.w),
                itemBuilder: (context, index) {
                  if (index == controller.reservationDates.length) {
                    return _MoreDateBox(
                      selected: customDate != null,
                      dateText: customDate == null
                          ? null
                          : controller.formatCustomDate(customDate),
                      weekText: customDate == null
                          ? null
                          : controller.customWeekday(customDate),
                      onTap: () async {
                        final now = DateTime.now();

                        final picked = await showDatePicker(
                          context: context,
                          initialDate: customDate ?? now,
                          firstDate: now,
                          lastDate: now.add(const Duration(days: 90)),
                          helpText: '选择预约日期',
                          cancelText: '取消',
                          confirmText: '确定',
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: AppColors.primary,
                                  onPrimary: Colors.white,
                                  onSurface: Color(0xFF111827),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );

                        if (picked != null) {
                          controller.selectCustomDate(picked);
                        }
                      },
                    );
                  }

                  final selected = selectedDate == index;
                  final top = index == 0
                      ? context.l10n.today
                      : index == 1
                      ? '明天'
                      : index == 2
                      ? '后天'
                      : weekTexts[index];

                  return _DateBox(
                    selected: selected,
                    top: top,
                    date: controller.reservationDates[index],
                    week: weekTexts[index],
                    onTap: () => controller.selectDate(index),
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

class _TimeCard extends StatelessWidget {
  const _TimeCard({required this.controller});

  final StoreController controller;

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      padding: EdgeInsets.fromLTRB(14.w, 16.h, 14.w, 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(text: context.l10n.selectTime),
          SizedBox(height: 14.h),
          Obx(() {
            final selectedTime = controller.selectedTimeIndex.value;

            return Wrap(
              spacing: 10.w,
              runSpacing: 10.h,
              children: controller.reservationTimes.asMap().entries.map((entry) {
                return _TimeBox(
                  selected: selectedTime == entry.key,
                  time: entry.value,
                  onTap: () => controller.selectTime(entry.key),
                );
              }).toList(),
            );
          }),
          SizedBox(height: 14.h),
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 15.r,
                color: const Color(0xFF8A93A3),
              ),
              SizedBox(width: 5.w),
              Text(
                '预约时间为到店时间，请准时到达',
                style: TextStyle(
                  color: const Color(0xFF8A93A3),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReservationFormCard extends StatelessWidget {
  const _ReservationFormCard({required this.controller});

  final StoreController controller;

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      padding: EdgeInsets.fromLTRB(14.w, 16.h, 14.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(text: context.l10n.fillReservationInfo),
          SizedBox(height: 14.h),
          _FormRow(
            label: context.l10n.contact,
            child: _InputBox(
              controller: controller.contactController,
              hintText: '请输入联系人姓名',
            ),
          ),
          SizedBox(height: 10.h),
          _FormRow(
            label: context.l10n.phoneNumber,
            child: _InputBox(
              controller: controller.phoneController,
              hintText: '请输入手机号',
              keyboardType: TextInputType.phone,
            ),
          ),
          SizedBox(height: 14.h),
          Obx(
                () => _FormRow(
              label: context.l10n.guestCount,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _CountButton(
                    icon: Icons.remove_rounded,
                    onTap: () => controller.changeGuestCount(-1),
                  ),
                  SizedBox(width: 20.w),

                  Text(
                    '${controller.guestCount.value}人',
                    style: TextStyle(
                      color: const Color(0xFF111827),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 20.w),
                  _CountButton(
                    icon: Icons.add_rounded,
                    onTap: () => controller.changeGuestCount(1),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 14.h),
          _FormRow(
            label: context.l10n.notesOptional,
            crossAxisAlignment: CrossAxisAlignment.start,
            child: _NoteInputBox(controller: controller.noteController),
          ),
        ],
      ),
    );
  }
}

class _AgreementRow extends StatelessWidget {
  const _AgreementRow({required this.controller});

  final StoreController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => GestureDetector(
        onTap: () => controller.toggleAgreement(!controller.agreementAccepted.value),
        child: Row(
          children: [
            Container(
              width: 21.r,
              height: 21.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: controller.agreementAccepted.value
                    ? AppColors.primary
                    : Colors.transparent,
                border: Border.all(
                  color: controller.agreementAccepted.value
                      ? AppColors.primary
                      : const Color(0xFFD1D5DB),
                  width: 1.2.w,
                ),
              ),
              child: controller.agreementAccepted.value
                  ? Icon(
                Icons.check_rounded,
                size: 14.r,
                color: Colors.white,
              )
                  : null,
            ),
            SizedBox(width: 8.w),
            Text(
              '我已阅读并同意',
              style: TextStyle(
                color: const Color(0xFF4B5563),
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 4.w),
            Text(
              '《预约服务协议》',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  const _ConfirmButton({required this.controller});

  final StoreController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final enabled = controller.agreementAccepted.value;

      return SizedBox(
        width: double.infinity,
        height: 54.h,
        child: FilledButton(
          onPressed: enabled
              ? () => context.push(Pages.storeReservationConfirm)
              : null,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            disabledBackgroundColor: AppColors.primary.withOpacity(0.45),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(27.r),
            ),
          ),
          child: Text(
            context.l10n.confirmReservation,
            style: TextStyle(
              color: Colors.white,
              fontSize: 17.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      );
    });
  }
}

class _WhiteCard extends StatelessWidget {
  const _WhiteCard({
    required this.child,
    required this.padding,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1F2937).withOpacity(0.035),
            blurRadius: 18.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _MemberStoreBadge extends StatelessWidget {
  const _MemberStoreBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1E8),
        borderRadius: BorderRadius.circular(7.r),
      ),
      child: Text(
        '会员店铺',
        style: TextStyle(
          color: const Color(0xFFFF5B22),
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: const Color(0xFF111827),
        fontSize: 16.sp,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _DateBox extends StatelessWidget {
  const _DateBox({
    required this.selected,
    required this.top,
    required this.date,
    required this.week,
    required this.onTap,
  });

  final bool selected;
  final String top;
  final String date;
  final String week;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textColor = selected ? Colors.white : const Color(0xFF111827);
    final subColor = selected ? Colors.white.withOpacity(0.86) : const Color(0xFF6B7280);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: 58.w,
        height: 82.h,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : const Color(0xFFF5F7FB),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: selected ? AppColors.primary : const Color(0xFFEFF2F7),
          ),
          boxShadow: selected
              ? [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.22),
              blurRadius: 12.r,
              offset: Offset(0, 5.h),
            ),
          ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              top,
              style: TextStyle(
                color: textColor,
                fontSize: 13.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              date,
              style: TextStyle(
                color: textColor,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              week,
              style: TextStyle(
                color: subColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoreDateBox extends StatelessWidget {
  const _MoreDateBox({
    required this.onTap,
    required this.selected,
    this.dateText,
    this.weekText,
  });

  final VoidCallback onTap;
  final bool selected;
  final String? dateText;
  final String? weekText;

  @override
  Widget build(BuildContext context) {
    final textColor = selected ? Colors.white : const Color(0xFF111827);
    final subColor =
    selected ? Colors.white.withOpacity(0.86) : const Color(0xFF6B7280);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: 66.w,
        height: 82.h,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : const Color(0xFFF5F7FB),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: selected ? AppColors.primary : const Color(0xFFEFF2F7),
          ),
          boxShadow: selected
              ? [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.22),
              blurRadius: 12.r,
              offset: Offset(0, 5.h),
            ),
          ]
              : [],
        ),
        child: selected
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '已选',
              style: TextStyle(
                color: textColor,
                fontSize: 13.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              dateText ?? '',
              style: TextStyle(
                color: textColor,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              weekText ?? '',
              style: TextStyle(
                color: subColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_month_outlined,
              size: 25.r,
              color: const Color(0xFF111827),
            ),
            SizedBox(height: 6.h),
            Text(
              '更多日期',
              style: TextStyle(
                color: const Color(0xFF4B5563),
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeBox extends StatelessWidget {
  const _TimeBox({
    required this.selected,
    required this.time,
    required this.onTap,
  });

  final bool selected;
  final String time;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final width = (1.sw - 28.w - 28.w - 30.w) / 4;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: width,
        height: 58.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(9.r),
          border: Border.all(
            color: selected ? AppColors.primary : const Color(0xFFE3E7EF),
          ),
          boxShadow: selected
              ? [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.2),
              blurRadius: 10.r,
              offset: Offset(0, 4.h),
            ),
          ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              time,
              style: TextStyle(
                color: selected ? Colors.white : const Color(0xFF111827),
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              '可预约',
              style: TextStyle(
                color: selected ? Colors.white.withOpacity(0.85) : const Color(0xFF6B7280),
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FormRow extends StatelessWidget {
  const _FormRow({
    required this.label,
    required this.child,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  final String label;
  final Widget child;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        SizedBox(
          width: 84.w,
          child: Text(
            label,
            style: TextStyle(
              color: const Color(0xFF111827),
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}

class _InputBox extends StatelessWidget {
  const _InputBox({
    required this.controller,
    required this.hintText,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44.h,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(
          fontSize: 14.sp,
          color: const Color(0xFF111827),
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: const Color(0xFFB0B7C3),
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 14.w),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: Color(0xFFE3E7EF)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: Color(0xFFE3E7EF)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
        ),
      ),
    );
  }
}

class _NoteInputBox extends StatefulWidget {
  const _NoteInputBox({required this.controller});

  final TextEditingController controller;

  @override
  State<_NoteInputBox> createState() => _NoteInputBoxState();
}

class _NoteInputBoxState extends State<_NoteInputBox> {
  int _textLength = 0;

  @override
  void initState() {
    super.initState();
    _textLength = widget.controller.text.length;
    widget.controller.addListener(_updateTextLength);
  }

  @override
  void didUpdateWidget(covariant _NoteInputBox oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_updateTextLength);
      _textLength = widget.controller.text.length;
      widget.controller.addListener(_updateTextLength);
    }
  }

  void _updateTextLength() {
    if (!mounted) return;

    setState(() {
      _textLength = widget.controller.text.length;
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateTextLength);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 76.h,
      child: TextField(
        controller: widget.controller,
        maxLength: 100,
        maxLines: 3,
        style: TextStyle(
          fontSize: 14.sp,
          color: const Color(0xFF111827),
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: '如有忌口、特殊需求请备注',
          hintStyle: TextStyle(
            color: const Color(0xFFB0B7C3),
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
          ),

          /// 隐藏系统默认计数器
          counterText: '',

          /// 自定义右下角计数
          suffixIcon: Padding(
            padding: EdgeInsets.only(right: 10.w, bottom: 8.h),
            child: Align(
              alignment: Alignment.bottomRight,
              widthFactor: 1,
              heightFactor: 1,
              child: Text(
                '$_textLength/100',
                style: TextStyle(
                  color: const Color(0xFF8A93A3),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          contentPadding: EdgeInsets.fromLTRB(14.w, 11.h, 48.w, 8.h),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: Color(0xFFE3E7EF)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: Color(0xFFE3E7EF)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
        ),
      ),
    );
  }
}

class _CountButton extends StatelessWidget {
  const _CountButton({
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
        width: 31.r,
        height: 31.r,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Color(0xFFF4F6FA),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 18.r,
          color: const Color(0xFF111827),
        ),
      ),
    );
  }
}