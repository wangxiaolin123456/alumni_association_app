import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/features/opportunity/model/response/opportunity_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

BoxDecoration get opportunityCardDecoration => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(16.r),
  boxShadow: [
    BoxShadow(
      color: const Color(0xFF245CA6).withValues(alpha: 0.05),
      blurRadius: 18,
      offset: const Offset(0, 6),
    ),
  ],
);

IconData opportunityIcon(String category) => switch (category) {
  'cooperation' => Icons.handshake_rounded,
  'resource' => Icons.badge_rounded,
  'investment' => Icons.monetization_on_rounded,
  'franchise' => Icons.storefront_rounded,
  _ => Icons.business_center_rounded,
};

class OpportunityVisual extends StatelessWidget {
  const OpportunityVisual({required this.opportunity, super.key});
  final OpportunityResponse opportunity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58.r,
      height: 58.r,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: opportunity.accentColors.map(Color.new).toList(),
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(
        opportunityIcon(opportunity.category),
        color: Colors.white,
        size: 30.sp,
      ),
    );
  }
}

class OpportunitySectionCard extends StatelessWidget {
  const OpportunitySectionCard({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: opportunityCardDecoration,
      child: child,
    );
  }
}

TextStyle get opportunitySecondaryText =>
    TextStyle(fontSize: 11.sp, color: AppColors.textSecondary);
