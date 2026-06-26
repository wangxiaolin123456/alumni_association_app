import 'package:alumni_association_app/features/auth/pages/login_page.dart';
import 'package:alumni_association_app/features/auth/pages/forgot_password_page.dart';
import 'package:alumni_association_app/features/auth/pages/account_bind_page.dart';
import 'package:alumni_association_app/features/activity/pages/activity_detail_page.dart';
import 'package:alumni_association_app/features/consumption/pages/consumption_amount_page.dart';
import 'package:alumni_association_app/features/consumption/pages/consumption_coupon_page.dart';
import 'package:alumni_association_app/features/consumption/pages/consumption_merchant_page.dart';
import 'package:alumni_association_app/features/consumption/pages/consumption_success_page.dart';
import 'package:alumni_association_app/features/home/pages/role_home_page.dart';
import 'package:alumni_association_app/features/member/benefits/pages/merchant_benefits_page.dart';
import 'package:alumni_association_app/features/member/certification/pages/certification_form_page.dart';
import 'package:alumni_association_app/features/member/certification/pages/certification_status_page.dart';
import 'package:alumni_association_app/features/member/certification/pages/certification_success_page.dart';
import 'package:alumni_association_app/features/member/consumption_records/pages/consumption_records_page.dart';
import 'package:alumni_association_app/features/member/member_card/pages/member_card_page.dart';
import 'package:alumni_association_app/features/member/member_card/pages/member_qr_page.dart';
import 'package:alumni_association_app/features/member/messages/pages/member_messages_page.dart';
import 'package:alumni_association_app/features/member/record_center/pages/member_record_pages.dart';
import 'package:alumni_association_app/features/member/pages/member_search_page.dart';
import 'package:alumni_association_app/features/merchant/center/pages/view/my_merchant_page.dart';
import 'package:alumni_association_app/features/opportunity/pages/opportunity_detail_page.dart';
import 'package:alumni_association_app/features/opportunity/pages/opportunity_publish_page.dart';
import 'package:alumni_association_app/features/profile/pages/language_page.dart';
import 'package:alumni_association_app/features/profile/pages/merchant_onboarding_page.dart';
import 'package:alumni_association_app/features/profile/pages/personal_info_page.dart';
import 'package:alumni_association_app/features/profile/pages/settings_page.dart';
import 'package:alumni_association_app/features/profile/management/pages/activity_management_page.dart';
import 'package:alumni_association_app/features/profile/management/pages/opportunity_management_page.dart';
import 'package:alumni_association_app/features/profile/orders/model/profile_order_item.dart';
import 'package:alumni_association_app/features/profile/orders/pages/my_orders_page.dart';
import 'package:alumni_association_app/features/profile/orders/pages/order_detail_page.dart';
import 'package:alumni_association_app/features/profile/records/pages/entry_records_page.dart';
import 'package:alumni_association_app/features/profile/services/pages/profile_service_pages.dart';
import 'package:alumni_association_app/features/store/pages/store_detail_page.dart';
import 'package:alumni_association_app/features/store/pages/store_offer_page.dart';
import 'package:alumni_association_app/features/store/pages/store_reservation_confirm_page.dart';
import 'package:alumni_association_app/features/store/pages/store_reservation_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../features/merchant/coupon/pages/view/publish_coupon_page.dart';
import '../../features/merchant/center/pages/view/merchant_dashboard_page.dart';

class Pages {
  static const String home = '/';

  static const String login = '/login';
  static const String forgotPassword = '/auth/forgot-password';
  static const String accountBind = '/auth/account-bind';

  static const String settings = '/settings';
  static const String settingsLanguage = '/settings/language';
  static const String personalInfo = '/profile/personal-info';
  static const String merchantOnboardingPage = '/profile/merchant-onboarding';
  static const String myMerchantPage = '/merchant/my';
  static const merchantDashboard = '/merchant-dashboard';

  static const String memberSearch = '/member/search';
  static const String storeDetail = '/member/stores/detail';
  static const String storeOffer = '/member/stores/offer';
  static const String storeReservation = '/member/stores/reservation';
  static const String storeReservationConfirm =
      '/member/stores/reservation/confirm';

  static const String activityDetail = '/member/activities/detail';

  static const String opportunityDetail = '/member/opportunities/detail';
  static const String opportunityPublish = '/member/opportunities/publish';

  static const String consumptionMerchant = '/member/consumption/merchant';
  static const String consumptionCoupon = '/member/consumption/coupon';
  static const String consumptionAmount = '/member/consumption/amount';
  static const String consumptionSuccess = '/member/consumption/success';

  static const String memberRecords = '/member/records';
  static const String memberMessages = '/member/messages';
  static const String memberCertification = '/member/certification';
  static const String memberCertificationStatus =
      '/member/certification/status';
  static const String memberCertificationSuccess =
      '/member/certification/success';
  static const String memberCard = '/member/card';
  static const String memberQr = '/member/card/qr';
  static const String memberBenefits = '/member/benefits';

  static const String memberRegistrationRecords =
      '/member/profile/registrations';
  static const String memberFavoriteMerchants = '/member/profile/favorites';
  static const String memberBrowsingRecords = '/member/profile/browsing';

  static const String myOpportunities = '/member/profile/my-opportunities';
  static const String myPosts = '/member/profile/my-posts';
  static const String myActivities = '/member/profile/my-activities';
  static const String myBenefits = '/member/profile/my-benefits';

  static const String myOrdersPage = '/profile/orders';
  static const String orderDetail = '/profile/orders/detail';
  static const String entryRecordsPage = '/profile/entry-records';

  static const String opportunityManagementPage =
      '/profile/opportunity-management';
  static const String activityManagementPage = '/profile/activity-management';

  static const String contactService = '/member/profile/contact-service';
  static const String helpCenter = '/member/profile/help-center';
  static const String feedback = '/member/profile/feedback';

  static const publishCoupon = '/publish/coupon';
}

class AppPages {
  // ignore: constant_identifier_names
  static const String INIT_ROUTER = Pages.home;
  static final List<GetPage> routes = [
    GetPage(name: Pages.home, page: () => const _SessionGate()),

    GetPage(name: Pages.login, page: () => const LoginPage()),

    GetPage(name: Pages.forgotPassword, page: () => const ForgotPasswordPage()),

    GetPage(
      name: Pages.accountBind,
      page: () {
        final args = Get.arguments;
        return AccountBindPage(
          email: args['email']?.toString() ?? '',
          source: args['source'],
        );
      },
    ),

    GetPage(name: Pages.settings, page: () => const SettingsPage()),

    GetPage(name: Pages.settingsLanguage, page: () => const LanguagePage()),

    GetPage(name: Pages.personalInfo, page: () => const PersonalInfoPage()),

    GetPage(
      name: Pages.merchantOnboardingPage,
      page: () => const MerchantOnboardingPage(),
    ),

    GetPage(name: Pages.myMerchantPage, page: () => const MyMerchantPage()),

    GetPage(
      name: Pages.merchantDashboard,
      page: () => const MerchantDashboardPage(),
    ),

    GetPage(name: Pages.memberSearch, page: () => const MemberSearchPage()),

    GetPage(name: Pages.storeDetail, page: () => const StoreDetailPage()),

    GetPage(name: Pages.storeOffer, page: () => const StoreOfferPage()),

    GetPage(
      name: Pages.storeReservation,
      page: () => const StoreReservationPage(),
    ),

    GetPage(
      name: Pages.storeReservationConfirm,
      page: () => const StoreReservationConfirmPage(),
    ),

    GetPage(name: Pages.activityDetail, page: () => const ActivityDetailPage()),

    GetPage(
      name: Pages.opportunityDetail,
      page: () => const OpportunityDetailPage(),
    ),

    GetPage(
      name: Pages.opportunityPublish,
      page: () => const OpportunityPublishPage(),
    ),

    GetPage(
      name: Pages.consumptionMerchant,
      page: () => const ConsumptionMerchantPage(),
    ),

    GetPage(
      name: Pages.consumptionCoupon,
      page: () => const ConsumptionCouponPage(),
    ),

    GetPage(
      name: Pages.consumptionAmount,
      page: () => const ConsumptionAmountPage(),
    ),

    GetPage(
      name: Pages.consumptionSuccess,
      page: () => const ConsumptionSuccessPage(),
    ),

    GetPage(
      name: Pages.memberRecords,
      page: () => const ConsumptionRecordsPage(),
    ),

    GetPage(name: Pages.memberMessages, page: () => const MemberMessagesPage()),

    GetPage(
      name: Pages.memberCertification,
      page: () => const CertificationFormPage(),
    ),

    GetPage(
      name: Pages.memberCertificationStatus,
      page: () => const CertificationStatusPage(),
    ),

    GetPage(
      name: Pages.memberCertificationSuccess,
      page: () => const CertificationSuccessPage(),
    ),

    GetPage(name: Pages.memberCard, page: () => const MemberCardPage()),

    GetPage(name: Pages.memberQr, page: () => const MemberQrPage()),

    GetPage(
      name: Pages.memberBenefits,
      page: () => const MerchantBenefitsPage(),
    ),

    GetPage(
      name: Pages.memberRegistrationRecords,
      page: () =>
          const MemberRecordPage(type: MemberRecordPageType.registration),
    ),

    GetPage(
      name: Pages.memberFavoriteMerchants,
      page: () => const MemberRecordPage(type: MemberRecordPageType.favorite),
    ),

    GetPage(
      name: Pages.memberBrowsingRecords,
      page: () => const MemberRecordPage(type: MemberRecordPageType.browsing),
    ),

    GetPage(
      name: Pages.myOpportunities,
      page: () => const ProfileServiceListPage(
        type: ProfileServiceListType.opportunities,
      ),
    ),

    GetPage(
      name: Pages.myPosts,
      page: () =>
          const ProfileServiceListPage(type: ProfileServiceListType.posts),
    ),

    GetPage(
      name: Pages.myActivities,
      page: () =>
          const ProfileServiceListPage(type: ProfileServiceListType.activities),
    ),

    GetPage(
      name: Pages.myBenefits,
      page: () =>
          const ProfileServiceListPage(type: ProfileServiceListType.benefits),
    ),

    GetPage(name: Pages.myOrdersPage, page: () => const MyOrdersPage()),

    GetPage(
      name: Pages.orderDetail,
      page: () {
        final args = Get.arguments;
        return OrderDetailPage(order: args is ProfileOrderItem ? args : null);
      },
    ),

    GetPage(name: Pages.entryRecordsPage, page: () => const EntryRecordsPage()),

    GetPage(
      name: Pages.opportunityManagementPage,
      page: () => const OpportunityManagementPage(),
    ),

    GetPage(
      name: Pages.activityManagementPage,
      page: () => const ActivityManagementPage(),
    ),

    GetPage(name: Pages.contactService, page: () => const ContactServicePage()),

    GetPage(name: Pages.helpCenter, page: () => const HelpCenterPage()),

    GetPage(name: Pages.feedback, page: () => const FeedbackPage()),

    GetPage(
      name: Pages.publishCoupon,
      page: () => const PublishCouponPage(),
    ),
  ];
}

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
