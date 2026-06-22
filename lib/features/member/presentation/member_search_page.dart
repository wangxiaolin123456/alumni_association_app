import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/localization_extensions.dart';
import 'package:alumni_association_app/features/member/presentation/member_home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
/// 首页搜索
class MemberSearchPage extends StatelessWidget {
  const MemberSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MemberHomeController>();

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.search,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18.sp,
        ),), centerTitle: true),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(18.w, 10.h, 18.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SearchBar(controller: controller),
              SizedBox(height: 30.h),
              Expanded(
                child: Obx(
                  () => controller.keyword.value.isEmpty
                      ? _SearchSuggestions(controller: controller)
                      : _SearchResults(controller: controller),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller});

  final MemberHomeController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller.searchController,
            autofocus: true,
            textInputAction: TextInputAction.search,
            onSubmitted: controller.search,
            decoration: InputDecoration(
              hintText: context.l10n.searchHint,
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: IconButton(
                onPressed: controller.clearSearch,
                icon: const Icon(Icons.close_rounded),
              ),
            ),
          ),
        ),
        TextButton(
          onPressed: controller.clearSearch,
          child: Text(context.l10n.cancel),
        ),
      ],
    );
  }
}

class _SearchSuggestions extends StatelessWidget {
  const _SearchSuggestions({required this.controller});

  final MemberHomeController controller;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _SearchTitle(title: context.l10n.hotSearch),
        SizedBox(height: 10.h),
        Wrap(
          spacing: 9.w,
          runSpacing: 9.h,
          children: controller.hotSearches
              .map(
                (term) => ActionChip(
                  label: Text(term),
                  onPressed: () => controller.useSearchTerm(term),
                  backgroundColor: Colors.white,
                  side: BorderSide.none,
                ),
              )
              .toList(),
        ),
        SizedBox(height: 34.h),
        _SearchTitle(title: context.l10n.searchHistory),
        SizedBox(height: 8.h),
        Obx(
          () => Column(
            children: controller.searchHistory
                .map(
                  (term) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.history_rounded,
                      color: AppColors.textSecondary,
                      size: 20.sp,
                    ),
                    title: Text(term),
                    trailing: IconButton(
                      onPressed: () => controller.removeHistory(term),
                      icon: const Icon(Icons.close_rounded),
                    ),
                    onTap: () => controller.useSearchTerm(term),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults({required this.controller});

  final MemberHomeController controller;

  @override
  Widget build(BuildContext context) {
    final results = controller.filteredMerchants;
    if (results.isEmpty) {
      return Center(child: Text(context.l10n.noSearchResults));
    }

    return ListView.separated(
      itemCount: results.length,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final merchant = results[index];
        return Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Row(
            children: [
              Container(
                width: 66.r,
                height: 66.r,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: merchant.gradientColors.map(Color.new).toList(),
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.storefront_rounded,
                  color: Colors.white,
                  size: 30.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      merchant.name,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(merchant.location, style: _resultSecondary),
                    Text(
                      '${merchant.category} · ${merchant.distance}',
                      style: _resultSecondary,
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
            ],
          ),
        );
      },
    );
  }
}

class _SearchTitle extends StatelessWidget {
  const _SearchTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w700),
    );
  }
}

TextStyle get _resultSecondary =>
    TextStyle(fontSize: 12.sp, color: AppColors.textSecondary);
