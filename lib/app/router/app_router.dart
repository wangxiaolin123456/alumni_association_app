import 'package:alumni_association_app/features/auth/presentation/login_page.dart';
import 'package:alumni_association_app/features/auth/presentation/forgot_password_page.dart';
import 'package:alumni_association_app/features/auth/presentation/account_bind_page.dart';
import 'package:alumni_association_app/features/activity/presentation/activity_detail_page.dart';
import 'package:alumni_association_app/features/consumption/presentation/consumption_amount_page.dart';
import 'package:alumni_association_app/features/consumption/presentation/consumption_coupon_page.dart';
import 'package:alumni_association_app/features/consumption/presentation/consumption_merchant_page.dart';
import 'package:alumni_association_app/features/consumption/presentation/consumption_success_page.dart';
import 'package:alumni_association_app/features/home/presentation/role_home_page.dart';
import 'package:alumni_association_app/features/member/benefits/presentation/merchant_benefits_page.dart';
import 'package:alumni_association_app/features/member/certification/presentation/certification_form_page.dart';
import 'package:alumni_association_app/features/member/certification/presentation/certification_status_page.dart';
import 'package:alumni_association_app/features/member/certification/presentation/certification_success_page.dart';
import 'package:alumni_association_app/features/member/consumption_records/presentation/consumption_records_page.dart';
import 'package:alumni_association_app/features/member/member_card/presentation/member_card_page.dart';
import 'package:alumni_association_app/features/member/member_card/presentation/member_qr_page.dart';
import 'package:alumni_association_app/features/member/messages/presentation/member_messages_page.dart';
import 'package:alumni_association_app/features/member/record_center/presentation/member_record_pages.dart';
import 'package:alumni_association_app/features/member/presentation/member_search_page.dart';
import 'package:alumni_association_app/features/opportunity/presentation/opportunity_detail_page.dart';
import 'package:alumni_association_app/features/opportunity/presentation/opportunity_publish_page.dart';
import 'package:alumni_association_app/features/profile/presentation/language_page.dart';
import 'package:alumni_association_app/features/profile/presentation/merchant_onboarding_page.dart';
import 'package:alumni_association_app/features/profile/presentation/personal_info_page.dart';
import 'package:alumni_association_app/features/profile/presentation/settings_page.dart';
import 'package:alumni_association_app/features/profile/management/presentation/activity_management_page.dart';
import 'package:alumni_association_app/features/profile/management/presentation/opportunity_management_page.dart';
import 'package:alumni_association_app/features/profile/orders/model/profile_order_item.dart';
import 'package:alumni_association_app/features/profile/orders/presentation/my_orders_page.dart';
import 'package:alumni_association_app/features/profile/orders/presentation/order_detail_page.dart';
import 'package:alumni_association_app/features/profile/records/presentation/entry_records_page.dart';
import 'package:alumni_association_app/features/profile/services/presentation/profile_service_pages.dart';
import 'package:alumni_association_app/features/store/presentation/store_detail_page.dart';
import 'package:alumni_association_app/features/store/presentation/store_offer_page.dart';
import 'package:alumni_association_app/features/store/presentation/store_reservation_confirm_page.dart';
import 'package:alumni_association_app/features/store/presentation/store_reservation_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Pages {
  static String login = '/login';
  static String forgotPassword = '/auth/forgot-password';
  static String accountBind = '/auth/account-bind';
  static String settings = '/settings';
  static String settingsLanguage = '/settings/language';
  static String personalInfo = '/profile/personal-info';
  static String merchantOnboardingPage = '/profile/merchant-onboarding';
  static String memberSearch = '/member/search';
  static String storeDetail = '/member/stores/detail';
  static String storeOffer = '/member/stores/offer';
  static String storeReservation = '/member/stores/reservation';
  static String storeReservationConfirm = '/member/stores/reservation/confirm';
  static String activityDetail = '/member/activities/detail';
  static String opportunityDetail = '/member/opportunities/detail';
  static String opportunityPublish = '/member/opportunities/publish';
  static String consumptionMerchant = '/member/consumption/merchant';
  static String consumptionCoupon = '/member/consumption/coupon';
  static String consumptionAmount = '/member/consumption/amount';
  static String consumptionSuccess = '/member/consumption/success';
  static String memberRecords = '/member/records';
  static String memberMessages = '/member/messages';
  static String memberCertification = '/member/certification';
  static String memberCertificationStatus = '/member/certification/status';
  static String memberCertificationSuccess = '/member/certification/success';
  static String memberCard = '/member/card';
  static String memberQr = '/member/card/qr';
  static String memberBenefits = '/member/benefits';
  static String memberRegistrationRecords = '/member/profile/registrations';
  static String memberFavoriteMerchants = '/member/profile/favorites';
  static String memberBrowsingRecords = '/member/profile/browsing';
  static String myOpportunities = '/member/profile/my-opportunities';
  static String myPosts = '/member/profile/my-posts';
  static String myActivities = '/member/profile/my-activities';
  static String myBenefits = '/member/profile/my-benefits';
  static String myOrdersPage = '/profile/orders';
  static String orderDetail = '/profile/orders/detail';
  static String entryRecordsPage = '/profile/entry-records';
  static String opportunityManagementPage = '/profile/opportunity-management';
  static String activityManagementPage = '/profile/activity-management';
  static String contactService = '/member/profile/contact-service';
  static String helpCenter = '/member/profile/help-center';
  static String feedback = '/member/profile/feedback';
}

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const _SessionGate()),
    GoRoute(path: Pages.login, builder: (context, state) => const LoginPage()),
    GoRoute(
      path: Pages.forgotPassword,
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    GoRoute(
      path: Pages.accountBind,
      builder: (context, state) => const AccountBindPage(),
    ),
    GoRoute(
      path: Pages.settings,
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: Pages.settingsLanguage,
      builder: (context, state) => const LanguagePage(),
    ),
    GoRoute(
      path: Pages.personalInfo,
      builder: (context, state) => const PersonalInfoPage(),
    ),
    GoRoute(
      path: Pages.merchantOnboardingPage,
      builder: (context, state) => const MerchantOnboardingPage(),
    ),
    GoRoute(
      path: Pages.memberSearch,
      builder: (context, state) => const MemberSearchPage(),
    ),
    GoRoute(
      path: Pages.storeDetail,
      builder: (context, state) => const StoreDetailPage(),
    ),
    GoRoute(
      path: Pages.storeOffer,
      builder: (context, state) => const StoreOfferPage(),
    ),
    GoRoute(
      path: Pages.storeReservation,
      builder: (context, state) => const StoreReservationPage(),
    ),
    GoRoute(
      path: Pages.storeReservationConfirm,
      builder: (context, state) => const StoreReservationConfirmPage(),
    ),
    GoRoute(
      path: Pages.activityDetail,
      builder: (context, state) => const ActivityDetailPage(),
    ),
    GoRoute(
      path: Pages.opportunityDetail,
      builder: (context, state) => const OpportunityDetailPage(),
    ),
    GoRoute(
      path: Pages.opportunityPublish,
      builder: (context, state) => const OpportunityPublishPage(),
    ),
    GoRoute(
      path: Pages.consumptionMerchant,
      builder: (context, state) => const ConsumptionMerchantPage(),
    ),
    GoRoute(
      path: Pages.consumptionCoupon,
      builder: (context, state) => const ConsumptionCouponPage(),
    ),
    GoRoute(
      path: Pages.consumptionAmount,
      builder: (context, state) => const ConsumptionAmountPage(),
    ),
    GoRoute(
      path: Pages.consumptionSuccess,
      builder: (context, state) => const ConsumptionSuccessPage(),
    ),
    GoRoute(
      path: Pages.memberRecords,
      builder: (context, state) => const ConsumptionRecordsPage(),
    ),
    GoRoute(
      path: Pages.memberMessages,
      builder: (context, state) => const MemberMessagesPage(),
    ),
    GoRoute(
      path: Pages.memberCertification,
      builder: (context, state) => const CertificationFormPage(),
    ),
    GoRoute(
      path: Pages.memberCertificationStatus,
      builder: (context, state) => const CertificationStatusPage(),
    ),
    GoRoute(
      path: Pages.memberCertificationSuccess,
      builder: (context, state) => const CertificationSuccessPage(),
    ),
    GoRoute(
      path: Pages.memberCard,
      builder: (context, state) => const MemberCardPage(),
    ),
    GoRoute(
      path: Pages.memberQr,
      builder: (context, state) => const MemberQrPage(),
    ),
    GoRoute(
      path: Pages.memberBenefits,
      builder: (context, state) => const MerchantBenefitsPage(),
    ),
    GoRoute(
      path: Pages.memberRegistrationRecords,
      builder: (context, state) =>
          const MemberRecordPage(type: MemberRecordPageType.registration),
    ),
    GoRoute(
      path: Pages.memberFavoriteMerchants,
      builder: (context, state) =>
          const MemberRecordPage(type: MemberRecordPageType.favorite),
    ),
    GoRoute(
      path: Pages.memberBrowsingRecords,
      builder: (context, state) =>
          const MemberRecordPage(type: MemberRecordPageType.browsing),
    ),
    GoRoute(
      path: Pages.myOpportunities,
      builder: (_, _) => const ProfileServiceListPage(
        type: ProfileServiceListType.opportunities,
      ),
    ),
    GoRoute(
      path: Pages.myPosts,
      builder: (_, _) =>
          const ProfileServiceListPage(type: ProfileServiceListType.posts),
    ),
    GoRoute(
      path: Pages.myActivities,
      builder: (_, _) =>
          const ProfileServiceListPage(type: ProfileServiceListType.activities),
    ),
    GoRoute(
      path: Pages.myBenefits,
      builder: (_, _) =>
          const ProfileServiceListPage(type: ProfileServiceListType.benefits),
    ),
    GoRoute(path: Pages.myOrdersPage, builder: (_, _) => const MyOrdersPage()),
    GoRoute(
      path: Pages.orderDetail,
      builder: (_, state) => OrderDetailPage(
        order: state.extra is ProfileOrderItem
            ? state.extra! as ProfileOrderItem
            : null,
      ),
    ),
    GoRoute(
      path: Pages.entryRecordsPage,
      builder: (_, _) => const EntryRecordsPage(),
    ),
    GoRoute(
      path: Pages.opportunityManagementPage,
      builder: (_, _) => const OpportunityManagementPage(),
    ),
    GoRoute(
      path: Pages.activityManagementPage,
      builder: (_, _) => const ActivityManagementPage(),
    ),
    GoRoute(
      path: Pages.contactService,
      builder: (_, _) => const ContactServicePage(),
    ),
    GoRoute(path: Pages.helpCenter, builder: (_, _) => const HelpCenterPage()),
    GoRoute(path: Pages.feedback, builder: (_, _) => const FeedbackPage()),
  ],
);

/// 启动页结束后先进入首页。
///
/// 具体功能入口自行判断登录态，未登录时再跳转登录页。
class _SessionGate extends StatelessWidget {
  const _SessionGate();

  @override
  Widget build(BuildContext context) {
    return const RoleHomePage();
  }
}
