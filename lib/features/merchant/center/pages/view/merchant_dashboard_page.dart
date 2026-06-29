import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/store/model/response/store_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/config/app_config.dart';
import '../controller/merchant_dashboard_controller.dart';

/// 我的商户 / 商户工作台首页
class MerchantDashboardPage extends StatelessWidget {
  const MerchantDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MerchantDashboardController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: Get.back,
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 22.sp,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        title: Text(
          context.l10n.merchantDashboard,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value &&
            controller.currentStore.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final store = controller.currentStore.value ?? StoreResponse.empty();

        return RefreshIndicator(
          onRefresh: controller.refreshDashboard,
          color: AppColors.primary,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 100.h),
            children: [
              _MerchantInfoCard(
                store: store,
                onTap: controller.editMerchantInfo,
              ),
              SizedBox(height: 14.h),
              _CommonFunctionCard(controller: controller),
              SizedBox(height: 14.h),
              _OverviewCard(controller: controller),
              SizedBox(height: 14.h),
              _BusinessDataCard(controller: controller),
            ],
          ),
        );
      }),
    );
  }
}

/// 商户信息卡片
class _MerchantInfoCard extends StatelessWidget {
  const _MerchantInfoCard({required this.store, required this.onTap});

  final StoreResponse store;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final statusText = store.shopStatus == 1
        ? l10n.inOperation
        : l10n.pendingReview;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.r),
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: _cardDecoration,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14.r),
              child: _MerchantImage(store: store),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: SizedBox(
                height: 132.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            store.shopName.isEmpty
                                ? l10n.unnamedStore
                                : store.shopName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        _StatusTag(text: statusText),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    _InfoLine(
                      icon: Icons.person_outline_rounded,
                      text:
                          '${l10n.contact}: ${store.names.isEmpty ? l10n.notFilled : store.names}',
                    ),
                    SizedBox(height: 10.h),
                    _InfoLine(
                      icon: Icons.phone_outlined,
                      text: store.phone.isEmpty ? l10n.noPhone : store.phone,
                    ),
                    SizedBox(height: 10.h),
                    _InfoLine(
                      icon: Icons.location_on_outlined,
                      text: store.fullAddress.isEmpty
                          ? l10n.noAddress
                          : store.fullAddress,
                    ),
                  ],
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 34.sp,
              color: const Color(0xFF4B587C),
            ),
          ],
        ),
      ),
    );
  }
}

/// 商户图片
class _MerchantImage extends StatelessWidget {
  const _MerchantImage({required this.store});

  final StoreResponse store;

  @override
  Widget build(BuildContext context) {
    final logo = store.shopLogo.trim();

    if (logo.isEmpty) {
      return Image.asset(
        'assets/default_image.png',
        width: 98.w,
        height: 98.h,
        fit: BoxFit.cover,
      );
    }

    return Image.network(
      _imageUrl(logo),
      width: 98.w,
      height: 98.h,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) {
        return Image.asset(
          'assets/default_image.png',
          width: 98.w,
          height: 98.h,
          fit: BoxFit.cover,
        );
      },
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;

        return Image.asset(
          'assets/default_image.png',
          width: 98.w,
          height: 98.h,
          fit: BoxFit.cover,
        );
      },
    );
  }

  String _imageUrl(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }
    final base = AppConfig.apiBaseUrl;
    final cleanBase = base.endsWith('/')
        ? base.substring(0, base.length - 1)
        : base;
    final cleanPath = path.startsWith('/') ? path : '/$path';
    return '$cleanBase$cleanPath';
  }
}

/// 信息行
class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18.sp, color: const Color(0xFF59627D)),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF4D5872),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

/// 状态标签
class _StatusTag extends StatelessWidget {
  const _StatusTag({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFDFF8E9),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: const Color(0xFF16A05D),
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// 常用功能
class _CommonFunctionCard extends StatelessWidget {
  const _CommonFunctionCard({required this.controller});

  final MerchantDashboardController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 18.h),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.commonFunctions, style: _sectionTitleStyle),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: _FunctionItem(
                  icon: Icons.edit_note_rounded,
                  iconColor: AppColors.primary,
                  title: context.l10n.editMerchantInfo,
                  subtitle: context.l10n.editMerchantInfoDesc,
                  onTap: controller.editMerchantInfo,
                ),
              ),
              _VerticalDivider(),
              Expanded(
                child: _FunctionItem(
                  icon: Icons.assignment_turned_in_rounded,
                  iconColor: AppColors.success,
                  title: context.l10n.entryRecords,
                  subtitle: context.l10n.viewAllEntryRecords,
                  onTap: controller.openEntryRecords,
                ),
              ),
              _VerticalDivider(),
              Expanded(
                child: _FunctionItem(
                  icon: Icons.pie_chart_rounded,
                  iconColor: const Color(0xFF7C4DFF),
                  title: context.l10n.dataStatistics,
                  subtitle: context.l10n.businessDataOverview,
                  onTap: controller.openStatistics,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FunctionItem extends StatelessWidget {
  const _FunctionItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Column(
          children: [
            Icon(icon, size: 38.sp, color: iconColor),
            SizedBox(height: 12.h),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 98.h, color: const Color(0xFFE7ECF5));
  }
}

/// 经营概览
/// 经营概览
class _OverviewCard extends StatelessWidget {
  const _OverviewCard({required this.controller});

  final MerchantDashboardController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 18.h),
      decoration: _cardDecoration,
      child: Obx(() {
        final overview = controller.overview.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(context.l10n.businessOverview, style: _sectionTitleStyle),
                const Spacer(),

                /// 改成一个年月选择按钮
                _MonthPickerButton(controller: controller),
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: _OverviewMetricCard(
                    icon: Icons.assignment_rounded,
                    iconColor: AppColors.primary,
                    title: context.l10n.orderCount,
                    value: '${overview.orderCount}',
                    backgroundColor: const Color(0xFFF6F8FF),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _OverviewMetricCard(
                    icon: Icons.savings_rounded,
                    iconColor: const Color(0xFFFF4F2E),
                    title: context.l10n.receivedAmountYuan,
                    value: _money(overview.receiveAmount),
                    backgroundColor: const Color(0xFFFFF8F3),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _OverviewMetricCard(
                    icon: Icons.local_atm_rounded,
                    iconColor: const Color(0xFF8A4DFF),
                    title: context.l10n.discountAmountYuan,
                    value: _money(overview.discountAmount),
                    backgroundColor: const Color(0xFFF8F6FF),
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}

class _MonthPickerButton extends StatelessWidget {
  const _MonthPickerButton({required this.controller});

  final MerchantDashboardController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InkWell(
        onTap: () => _showMonthPicker(context),
        borderRadius: BorderRadius.circular(999.r),
        child: Container(
          height: 36.h,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F4F9),
            borderRadius: BorderRadius.circular(999.r),
            border: Border.all(color: const Color(0xFFE4EAF3), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.calendar_month_rounded,
                size: 16.sp,
                color: AppColors.primary,
              ),
              SizedBox(width: 6.w),
              Text(
                controller.hasSelectedMonth.value
                    ? _monthLabel(controller.selectedMonth.value)
                    : context.l10n.thisMonth,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(width: 4.w),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 18.sp,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMonthPicker(BuildContext context) {
    Get.bottomSheet<void>(
      Container(
        height: 460.h,
        padding: EdgeInsets.fromLTRB(18.w, 12.h, 18.w, 20.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF7FAFF),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          children: [
            Container(
              width: 42.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFFD5DFEF),
                borderRadius: BorderRadius.circular(999.r),
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Text(
                  context.l10n.selectMonth,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: Get.back,
                  icon: Icon(Icons.close_rounded, size: 22.sp),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: Obx(() {
                final selected = controller.selectedMonth.value;
                final months = controller.selectableMonths;

                return GridView.builder(
                  padding: EdgeInsets.only(top: 8.h),
                  itemCount: months.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisExtent: 46.h,
                    crossAxisSpacing: 10.w,
                    mainAxisSpacing: 10.h,
                  ),
                  itemBuilder: (context, index) {
                    final month = months[index];
                    final isSelected =
                        selected.year == month.year &&
                        selected.month == month.month;

                    final isCurrentMonth =
                        month.year == DateTime.now().year &&
                        month.month == DateTime.now().month;

                    return InkWell(
                      onTap: () {
                        controller.selectMonth(month);
                        Get.back();
                      },
                      borderRadius: BorderRadius.circular(14.r),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : Colors.white,
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : const Color(0xFFE4EAF3),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF1E5AA8,
                              ).withValues(alpha: 0.045),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          isCurrentMonth
                              ? context.l10n.thisMonth
                              : _monthLabel(month),
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w800,
                            color: isSelected
                                ? Colors.white
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}

class _OverviewMetricCard extends StatelessWidget {
  const _OverviewMetricCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.backgroundColor,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30.sp, color: iconColor),
          SizedBox(height: 8.h),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12.sp, color: const Color(0xFF4E5874)),
          ),
          SizedBox(height: 7.h),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

/// 经营数据
class _BusinessDataCard extends StatelessWidget {
  const _BusinessDataCard({required this.controller});

  final MerchantDashboardController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 18.h),
      decoration: _cardDecoration,
      child: Obx(() {
        final data = controller.businessData.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.todayBusinessData, style: _sectionTitleStyle),
            SizedBox(height: 18.h),
            Row(
              children: [
                Expanded(
                  child: _DataTile(
                    title: context.l10n.todayEntryTimes,
                    value: '${data.todayVerifyCount}',
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _DataTile(
                    title: context.l10n.todayConsumeAmountYuan,
                    value: _money(data.todayConsumeAmount),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: _DataTile(
                    title: context.l10n.todayGmvYuan,
                    value: _money(data.monthGmv),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _DataTile(
                    title: context.l10n.todayDiscountAmountYuan,
                    value: _money(data.monthDiscountAmount),
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}

class _DataTile extends StatelessWidget {
  const _DataTile({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 98.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FE),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: const Color(0xFF5E6982),
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.black,
              fontSize: 17.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

/// 金额格式
String _money(double value) {
  final text = value.toStringAsFixed(2);
  final parts = text.split('.');
  final integer = parts.first;
  final decimal = parts.last;

  final buffer = StringBuffer();

  for (int i = 0; i < integer.length; i++) {
    final indexFromEnd = integer.length - i;
    buffer.write(integer[i]);

    if (indexFromEnd > 1 && indexFromEnd % 3 == 1) {
      buffer.write(',');
    }
  }

  return '${buffer.toString()}.$decimal';
}

/// 月份展示文本。
String _monthLabel(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}';
}

/// 卡片样式
BoxDecoration get _cardDecoration => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(18.r),
  border: Border.all(color: const Color(0xFFEAF0F7), width: 1),
  boxShadow: [
    BoxShadow(
      color: const Color(0xFF1E5AA8).withValues(alpha: 0.045),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ],
);

TextStyle get _sectionTitleStyle => TextStyle(
  fontSize: 18.sp,
  fontWeight: FontWeight.w900,
  color: AppColors.textPrimary,
);
