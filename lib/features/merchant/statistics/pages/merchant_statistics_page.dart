import 'dart:math' as math;

import 'package:alumni_association_app/app/router/app_router.dart';
import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'merchant_statistics_controller.dart';

/// 商户数据统计页面。
///
/// 页面数据来自 `/api/order/orderSum`，后端返回月度数组：
/// 订单数、实收金额、优惠金额及对应环比。
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
        title: Text(context.l10n.dataStatistics, style: _titleStyle),
      ),
      body: Obx(
        () => RefreshIndicator(
          onRefresh: controller.loadStatistics,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 110.h),
            children: [
              _MonthSwitcher(controller: controller),
              SizedBox(height: 16.h),
              if (controller.isLoading.value && controller.summaries.isEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 160.h),
                  child: const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                )
              else ...[
                _CoreOverviewCard(controller: controller),
                SizedBox(height: 14.h),
                _TrendCard(controller: controller),
                SizedBox(height: 14.h),
                _DetailCard(controller: controller),
              ],
            ],
          ),
        ),
      ),
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
          IconData(metric.icon, fontFamily: 'MaterialIcons'),
          color: Colors.white,
          size: 24.sp,
        ),
        SizedBox(height: 12.h),
        Text(
          _metricTitle(context, metric.key),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.white, fontSize: 12.sp),
        ),
        SizedBox(height: 10.h),
        Text(
          metric.displayValue,
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
          _growthText(metric),
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
                  context.l10n.discountAmountYuan,
                ],
              ),
            ],
          ),
          SizedBox(height: 24.h),
          SizedBox(
            height: 220.h,
            child:Obx(() =>  CustomPaint(
              painter: _TrendChartPainter(
                points: controller.trendPoints,
                color: AppColors.primary,
              ),
              child: const SizedBox.expand(),
            )),
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
    return Obx(() => Container(
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
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
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
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          );
        }),
      ),
    ));
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
    final bgColor = switch (metric.key) {
      MerchantStatisticMetricKey.orderCount => const Color(0xFFEAF2FF),
      MerchantStatisticMetricKey.receivedAmount => const Color(0xFFFFF0EB),
      MerchantStatisticMetricKey.discountAmount => const Color(0xFFF1ECFF),
    };
    final iconColor = switch (metric.key) {
      MerchantStatisticMetricKey.orderCount => AppColors.primary,
      MerchantStatisticMetricKey.receivedAmount => const Color(0xFFFF5B22),
      MerchantStatisticMetricKey.discountAmount => const Color(0xFF7C4DFF),
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
              color: bgColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              IconData(metric.icon, fontFamily: 'MaterialIcons'),
              color: iconColor,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _metricTitle(context, metric.key),
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
                metric.displayValue,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                _growthText(metric),
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
        ],
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
    final maxPointValue = points.map((e) => e.value).reduce(math.max);
    final maxValue = math.max(1.0, maxPointValue);
    final gridMax = _niceGridMax(maxValue);

    final gridPaint = Paint()
      ..color = const Color(0xFFE8EDF5)
      ..strokeWidth = 1;
    final axisPaint = Paint()
      ..color = const Color(0xFFDCE3EF)
      ..strokeWidth = 1.1;

    for (int i = 0; i <= 4; i++) {
      final value = gridMax * i / 4;
      final y = chartBottom - chartHeight * (value / gridMax);
      canvas.drawLine(Offset(chartLeft, y), Offset(chartRight, y), gridPaint);
      _drawText(
        canvas,
        value.toStringAsFixed(0),
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

    final spots = <Offset>[];
    final path = Path();
    final fillPath = Path();

    for (int i = 0; i < points.length; i++) {
      final denominator = math.max(1, points.length - 1);
      final x = chartLeft + chartWidth * (i / denominator);
      final y = chartBottom - chartHeight * (points[i].value / gridMax);
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
        _formatChartValue(points[i].value),
        Offset(spot.dx - 12.w, spot.dy - 27.h),
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
    final labelText = _formatChartValue(points.last.value);
    final labelWidth = math.max(42.w, labelText.length * 8.w);
    final labelRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(last.dx - labelWidth / 2, last.dy - 48.h, labelWidth, 30.h),
      Radius.circular(6.r),
    );
    canvas.drawRRect(labelRect, Paint()..color = color);
    _drawText(
      canvas,
      labelText,
      Offset(last.dx - labelWidth / 2 + 8.w, last.dy - 42.h),
      Colors.white,
      13.sp,
      weight: FontWeight.w800,
    );
  }

  double _niceGridMax(double value) {
    if (value <= 10) return 10;
    final exponent = math.pow(10, value.toStringAsFixed(0).length - 1);
    final normalized = value / exponent;
    final rounded = normalized <= 2
        ? 2
        : normalized <= 5
        ? 5
        : 10;
    return rounded * exponent.toDouble();
  }

  String _formatChartValue(double value) {
    if (value >= 10000) return '${(value / 10000).toStringAsFixed(1)}w';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}k';
    return value.toStringAsFixed(0);
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
  return switch (key) {
    MerchantStatisticMetricKey.orderCount => context.l10n.monthOrderCount,
    MerchantStatisticMetricKey.receivedAmount =>
      context.l10n.monthReceivedAmount,
    MerchantStatisticMetricKey.discountAmount =>
      context.l10n.discountAmountYuan,
  };
}

String _growthText(MerchantStatisticMetric metric) {
  final text = metric.normalizedGrowthDesc;
  if (text == '-') return text;
  return '$text ${metric.increased ? '↗' : '↘'}';
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

final _titleStyle = TextStyle(
  fontSize: 18.sp,
  fontWeight: FontWeight.w900,
  color: AppColors.textPrimary,
);

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
