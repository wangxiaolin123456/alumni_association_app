import 'dart:math' as math;

import 'package:alumni_association_app/app/router/app_router.dart';
import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'merchant_statistics_controller.dart';

/// 商户数据统计页面。
class MerchantStatisticsPage extends StatelessWidget {
  const MerchantStatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MerchantStatisticsController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: Get.back,
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20.sp),
        ),
        centerTitle: true,
        title: Text(
          context.l10n.dataStatistics,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => _showMonthPicker(context, controller),
            icon: Icon(
              Icons.calendar_month_outlined,
              size: 18.sp,
              color: const Color(0xFF526079),
            ),
            label: Text(
              context.l10n.selectDate,
              style: TextStyle(
                color: const Color(0xFF526079),
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 110.h),
        children: [
          _MonthSwitcher(controller: controller),
          SizedBox(height: 16.h),
          _CoreOverviewCard(controller: controller),
          SizedBox(height: 14.h),
          _TrendCard(controller: controller),
          SizedBox(height: 14.h),
          _DetailCard(controller: controller),
          SizedBox(height: 14.h),
          _ChannelCard(controller: controller),
        ],
      ),
      bottomNavigationBar: const _MerchantBottomNav(),
    );
  }

  /// 底部月份选择器，先做本地月份切换，后续可在确认时请求接口。
  void _showMonthPicker(
    BuildContext context,
    MerchantStatisticsController controller,
  ) {
    Get.bottomSheet<void>(
      Container(
        padding: EdgeInsets.fromLTRB(18.w, 12.h, 18.w, 20.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 42.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFFD7DEEA),
                borderRadius: BorderRadius.circular(99.r),
              ),
            ),
            SizedBox(height: 18.h),
            Text(
              context.l10n.selectMonth,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w900),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      controller.previousMonth();
                      Get.back();
                    },
                    child: Text(context.l10n.previousMonth),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      controller.nextMonth();
                      Get.back();
                    },
                    child: Text(context.l10n.nextMonth),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }
}

class _MonthSwitcher extends StatelessWidget {
  const _MonthSwitcher({required this.controller});

  final MerchantStatisticsController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: controller.previousMonth,
          icon: Icon(
            Icons.chevron_left_rounded,
            size: 34.sp,
            color: const Color(0xFF657089),
          ),
        ),
        SizedBox(width: 18.w),
        Text(
          _monthText(context, controller.selectedMonth.value),
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
          ),
        ),
        Icon(Icons.keyboard_arrow_down_rounded, size: 24.sp),
        SizedBox(width: 18.w),
        IconButton(
          onPressed: controller.nextMonth,
          icon: Icon(
            Icons.chevron_right_rounded,
            size: 34.sp,
            color: const Color(0xFF657089),
          ),
        ),
      ],
    );
  }
}

class _CoreOverviewCard extends StatelessWidget {
  const _CoreOverviewCard({required this.controller});

  final MerchantStatisticsController controller;

  @override
  Widget build(BuildContext context) {
    final metrics = controller.metrics;

    return Container(
      padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 20.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1976FF), Color(0xFF0055F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1167FF).withValues(alpha: 0.22),
            blurRadius: 24,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                context.l10n.coreDataOverview,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Spacer(),
              Text(
                context.l10n.compareLastMonth,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.white,
                size: 18.sp,
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Row(
            children: metrics
                .map((item) => Expanded(child: _CoreMetricItem(metric: item)))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _CoreMetricItem extends StatelessWidget {
  const _CoreMetricItem({required this.metric});

  final MerchantStatisticMetric metric;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          IconData(metric.iconCodePoint, fontFamily: 'MaterialIcons'),
          color: Colors.white,
          size: 24.sp,
        ),
        SizedBox(height: 12.h),
        Text(
          _metricTitle(context, metric.titleKey),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.white, fontSize: 12.sp),
        ),
        SizedBox(height: 10.h),
        Text(
          metric.value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          '${metric.changeText} ${metric.increased ? '↗' : '↘'}',
          style: TextStyle(
            color: metric.increased
                ? const Color(0xFFFFA1A1)
                : const Color(0xFF63E09A),
            fontSize: 12.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _TrendCard extends StatelessWidget {
  const _TrendCard({required this.controller});

  final MerchantStatisticsController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 18.h),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(context.l10n.businessTrend, style: _sectionTitleStyle),
              const Spacer(),
              _SegmentTabs(
                controller: controller,
                labels: [
                  context.l10n.orderCount,
                  context.l10n.receivedAmountYuan,
                  context.l10n.memberCount,
                ],
              ),
            ],
          ),
          SizedBox(height: 24.h),
          SizedBox(
            height: 220.h,
            child: CustomPaint(
              painter: _TrendChartPainter(
                points: controller.trendPoints,
                color: AppColors.primary,
              ),
              child: const SizedBox.expand(),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            context.l10n.statisticsMonthlyTip,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13.sp),
          ),
        ],
      ),
    );
  }
}

class _SegmentTabs extends StatelessWidget {
  const _SegmentTabs({required this.controller, required this.labels});

  final MerchantStatisticsController controller;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4FA),
        borderRadius: BorderRadius.circular(99.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(labels.length, (index) {
          final selected = controller.trendTabIndex.value == index;
          return GestureDetector(
            onTap: () => controller.selectTrendTab(index),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
              decoration: BoxDecoration(
                color: selected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(99.r),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: Offset(0, 3.h),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                labels[index],
                style: TextStyle(
                  color: selected ? AppColors.primary : AppColors.textSecondary,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.controller});

  final MerchantStatisticsController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 8.h),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.dataDetail, style: _sectionTitleStyle),
          SizedBox(height: 18.h),
          ...controller.metrics.map((item) => _DetailRow(metric: item)),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.metric});

  final MerchantStatisticMetric metric;

  @override
  Widget build(BuildContext context) {
    final bgColors = {
      MerchantStatisticMetricKey.orderCount: const Color(0xFFEAF2FF),
      MerchantStatisticMetricKey.receivedAmount: const Color(0xFFFFF0EB),
      MerchantStatisticMetricKey.memberCount: const Color(0xFFEAF8F1),
      MerchantStatisticMetricKey.discountAmount: const Color(0xFFF1ECFF),
    };
    final iconColors = {
      MerchantStatisticMetricKey.orderCount: AppColors.primary,
      MerchantStatisticMetricKey.receivedAmount: const Color(0xFFFF5B22),
      MerchantStatisticMetricKey.memberCount: const Color(0xFF21C774),
      MerchantStatisticMetricKey.discountAmount: const Color(0xFF7C4DFF),
    };

    return Container(
      padding: EdgeInsets.symmetric(vertical: 13.h),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE8EDF5))),
      ),
      child: Row(
        children: [
          Container(
            width: 44.r,
            height: 44.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: bgColors[metric.titleKey],
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              IconData(metric.iconCodePoint, fontFamily: 'MaterialIcons'),
              color: iconColors[metric.titleKey],
              size: 24.sp,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _metricTitle(context, metric.titleKey),
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  metric.increased
                      ? context.l10n.increaseComparedLastMonth
                      : context.l10n.decreaseComparedLastMonth,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                metric.value,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                '${metric.changeText} ${metric.increased ? '↗' : '↘'}',
                style: TextStyle(
                  color: metric.increased
                      ? const Color(0xFFFF2F3A)
                      : const Color(0xFF18BF63),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          SizedBox(width: 10.w),
          Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}

class _ChannelCard extends StatelessWidget {
  const _ChannelCard({required this.controller});

  final MerchantStatisticsController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 20.h),
      decoration: _cardDecoration,
      child: Column(
        children: [
          Row(
            children: [
              Text(context.l10n.channelRatio, style: _sectionTitleStyle),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F6FB),
                  borderRadius: BorderRadius.circular(99.r),
                ),
                child: Row(
                  children: [
                    Text(
                      context.l10n.receivedAmountYuan,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_down_rounded, size: 18.sp),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 18.h),
          ...controller.channels.map((item) => _ChannelProgress(item: item)),
        ],
      ),
    );
  }
}

class _ChannelProgress extends StatelessWidget {
  const _ChannelProgress({required this.item});

  final MerchantChannelRatio item;

  @override
  Widget build(BuildContext context) {
    final ratio = (item.value / 100).clamp(0.0, 1.0);

    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                _channelTitle(context, item.nameKey),
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                '${item.value.toStringAsFixed(0)}%',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(99.r),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 8.h,
              backgroundColor: const Color(0xFFEAF0F8),
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _MerchantBottomNav extends StatelessWidget {
  const _MerchantBottomNav();

  @override
  Widget build(BuildContext context) {
    final items = [
      _BottomNavItem(
        icon: Icons.home_outlined,
        label: context.l10n.merchantHome,
        onTap: () => Get.offNamed(Pages.merchantDashboard),
      ),
      _BottomNavItem(
        icon: Icons.receipt_long_outlined,
        label: context.l10n.entryRecords,
        onTap: () => Get.toNamed(Pages.entryRecordsPage),
      ),
      _BottomNavItem(
        icon: Icons.bar_chart_rounded,
        label: context.l10n.dataStatistics,
        selected: true,
        onTap: () {},
      ),
      _BottomNavItem(
        icon: Icons.settings_outlined,
        label: context.l10n.merchantSettings,
        onTap: () {},
      ),
    ];

    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: Offset(0, -8.h),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: items.map((item) => Expanded(child: item)).toList(),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : const Color(0xFF667085);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 26.sp),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12.sp,
                fontWeight: selected ? FontWeight.w900 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrendChartPainter extends CustomPainter {
  _TrendChartPainter({required this.points, required this.color});

  final List<MerchantTrendPoint> points;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final chartLeft = 42.w;
    final chartRight = size.width - 12.w;
    final chartTop = 12.h;
    final chartBottom = size.height - 36.h;
    final chartWidth = chartRight - chartLeft;
    final chartHeight = chartBottom - chartTop;
    final maxValue = math.max(
      80.0,
      points.map((e) => e.value).reduce(math.max),
    );

    final gridPaint = Paint()
      ..color = const Color(0xFFE8EDF5)
      ..strokeWidth = 1;
    final axisPaint = Paint()
      ..color = const Color(0xFFDCE3EF)
      ..strokeWidth = 1.1;

    for (final value in [0, 20, 40, 60, 80]) {
      final y = chartBottom - chartHeight * (value / 80);
      canvas.drawLine(Offset(chartLeft, y), Offset(chartRight, y), gridPaint);
      _drawText(
        canvas,
        value.toString(),
        Offset(8.w, y - 8.h),
        const Color(0xFF7B8497),
        12.sp,
      );
    }

    canvas.drawLine(
      Offset(chartLeft, chartTop),
      Offset(chartLeft, chartBottom),
      axisPaint,
    );
    canvas.drawLine(
      Offset(chartLeft, chartBottom),
      Offset(chartRight, chartBottom),
      axisPaint,
    );

    final path = Path();
    final fillPath = Path();
    final spots = <Offset>[];

    for (int i = 0; i < points.length; i++) {
      final x = chartLeft + chartWidth * (i / (points.length - 1));
      final y = chartBottom - chartHeight * (points[i].value / maxValue);
      final spot = Offset(x, y);
      spots.add(spot);
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, chartBottom);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }
    fillPath.lineTo(spots.last.dx, chartBottom);
    fillPath.close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          colors: [
            color.withValues(alpha: 0.16),
            color.withValues(alpha: 0.015),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromLTWH(0, chartTop, size.width, chartHeight)),
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    for (int i = 0; i < spots.length; i++) {
      final spot = spots[i];
      canvas.drawCircle(spot, 5.r, Paint()..color = Colors.white);
      canvas.drawCircle(
        spot,
        5.r,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      );
      _drawText(
        canvas,
        points[i].value.toStringAsFixed(0),
        Offset(spot.dx - 10.w, spot.dy - 27.h),
        const Color(0xFF6B7280),
        12.sp,
      );
      _drawText(
        canvas,
        points[i].label,
        Offset(spot.dx - 12.w, chartBottom + 14.h),
        i == points.length - 1 ? color : const Color(0xFF7B8497),
        12.sp,
        weight: i == points.length - 1 ? FontWeight.w900 : FontWeight.w500,
      );
    }

    final last = spots.last;
    final labelRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(last.dx - 20.w, last.dy - 48.h, 42.w, 30.h),
      Radius.circular(6.r),
    );
    canvas.drawRRect(labelRect, Paint()..color = color);
    _drawText(
      canvas,
      points.last.value.toStringAsFixed(0),
      Offset(last.dx - 9.w, last.dy - 42.h),
      Colors.white,
      13.sp,
      weight: FontWeight.w800,
    );
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset offset,
    Color color,
    double size, {
    FontWeight weight = FontWeight.w500,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: color, fontSize: size, fontWeight: weight),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _TrendChartPainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.color != color;
  }
}

String _metricTitle(BuildContext context, MerchantStatisticMetricKey key) {
  switch (key) {
    case MerchantStatisticMetricKey.orderCount:
      return context.l10n.monthOrderCount;
    case MerchantStatisticMetricKey.receivedAmount:
      return context.l10n.monthReceivedAmount;
    case MerchantStatisticMetricKey.memberCount:
      return context.l10n.memberCount;
    case MerchantStatisticMetricKey.discountAmount:
      return context.l10n.discountAmountYuan;
  }
}

String _channelTitle(BuildContext context, MerchantStatisticsChannelKey key) {
  switch (key) {
    case MerchantStatisticsChannelKey.storeVerification:
      return context.l10n.storeVerificationChannel;
    case MerchantStatisticsChannelKey.memberReservation:
      return context.l10n.memberReservationChannel;
    case MerchantStatisticsChannelKey.activityConversion:
      return context.l10n.activityConversionChannel;
  }
}

String _monthText(BuildContext context, DateTime date) {
  final month = date.month.toString().padLeft(2, '0');

  switch (Localizations.localeOf(context).languageCode) {
    case 'en':
      return '${date.year}/$month';
    case 'ja':
      return '${date.year}年$month月';
    default:
      return '${date.year}年$month月';
  }
}

BoxDecoration get _cardDecoration => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(18.r),
  boxShadow: [
    BoxShadow(
      color: const Color(0xFF1E5AA8).withValues(alpha: 0.045),
      blurRadius: 24,
      offset: Offset(0, 8.h),
    ),
  ],
);

TextStyle get _sectionTitleStyle => TextStyle(
  color: AppColors.textPrimary,
  fontSize: 18.sp,
  fontWeight: FontWeight.w900,
);
