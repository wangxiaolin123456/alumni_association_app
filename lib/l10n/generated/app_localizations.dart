import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('zh'),
  ];

  /// No description provided for @appName.
  ///
  /// In zh, this message translates to:
  /// **'校友会'**
  String get appName;

  /// No description provided for @home.
  ///
  /// In zh, this message translates to:
  /// **'首页'**
  String get home;

  /// No description provided for @merchants.
  ///
  /// In zh, this message translates to:
  /// **'商家'**
  String get merchants;

  /// No description provided for @activities.
  ///
  /// In zh, this message translates to:
  /// **'活动'**
  String get activities;

  /// No description provided for @activityOpportunity.
  ///
  /// In zh, this message translates to:
  /// **'活动商机'**
  String get activityOpportunity;

  /// No description provided for @memberCard.
  ///
  /// In zh, this message translates to:
  /// **'会员卡'**
  String get memberCard;

  /// No description provided for @mine.
  ///
  /// In zh, this message translates to:
  /// **'我的'**
  String get mine;

  /// No description provided for @scan.
  ///
  /// In zh, this message translates to:
  /// **'扫码'**
  String get scan;

  /// No description provided for @verificationRecords.
  ///
  /// In zh, this message translates to:
  /// **'核销记录'**
  String get verificationRecords;

  /// No description provided for @store.
  ///
  /// In zh, this message translates to:
  /// **'门店'**
  String get store;

  /// No description provided for @profileName.
  ///
  /// In zh, this message translates to:
  /// **'张三'**
  String get profileName;

  /// No description provided for @alumniMember.
  ///
  /// In zh, this message translates to:
  /// **'校友会员'**
  String get alumniMember;

  /// No description provided for @memberNumber.
  ///
  /// In zh, this message translates to:
  /// **'会员编号：XYH20240001'**
  String get memberNumber;

  /// No description provided for @verified.
  ///
  /// In zh, this message translates to:
  /// **'已认证'**
  String get verified;

  /// No description provided for @electronicMemberCard.
  ///
  /// In zh, this message translates to:
  /// **'电子会员卡'**
  String get electronicMemberCard;

  /// No description provided for @exclusiveBenefits.
  ///
  /// In zh, this message translates to:
  /// **'校友身份 · 专属权益'**
  String get exclusiveBenefits;

  /// No description provided for @viewMemberCode.
  ///
  /// In zh, this message translates to:
  /// **'查看会员码'**
  String get viewMemberCode;

  /// No description provided for @myOrdersRecords.
  ///
  /// In zh, this message translates to:
  /// **'我的订单/记录'**
  String get myOrdersRecords;

  /// No description provided for @consumptionRecords.
  ///
  /// In zh, this message translates to:
  /// **'消费记录'**
  String get consumptionRecords;

  /// No description provided for @registrationRecords.
  ///
  /// In zh, this message translates to:
  /// **'报名记录'**
  String get registrationRecords;

  /// No description provided for @favoriteMerchants.
  ///
  /// In zh, this message translates to:
  /// **'收藏商家'**
  String get favoriteMerchants;

  /// No description provided for @browsingRecords.
  ///
  /// In zh, this message translates to:
  /// **'浏览记录'**
  String get browsingRecords;

  /// No description provided for @myServices.
  ///
  /// In zh, this message translates to:
  /// **'我的服务'**
  String get myServices;

  /// No description provided for @myOpportunities.
  ///
  /// In zh, this message translates to:
  /// **'我的商机'**
  String get myOpportunities;

  /// No description provided for @myPosts.
  ///
  /// In zh, this message translates to:
  /// **'我的发布'**
  String get myPosts;

  /// No description provided for @myActivities.
  ///
  /// In zh, this message translates to:
  /// **'我的活动'**
  String get myActivities;

  /// No description provided for @myBenefits.
  ///
  /// In zh, this message translates to:
  /// **'我的优惠'**
  String get myBenefits;

  /// No description provided for @merchantOnboarding.
  ///
  /// In zh, this message translates to:
  /// **'商户入驻'**
  String get merchantOnboarding;

  /// No description provided for @contactService.
  ///
  /// In zh, this message translates to:
  /// **'联系客服'**
  String get contactService;

  /// No description provided for @helpCenter.
  ///
  /// In zh, this message translates to:
  /// **'帮助中心'**
  String get helpCenter;

  /// No description provided for @feedback.
  ///
  /// In zh, this message translates to:
  /// **'意见反馈'**
  String get feedback;

  /// No description provided for @recommendedServices.
  ///
  /// In zh, this message translates to:
  /// **'推荐服务'**
  String get recommendedServices;

  /// No description provided for @inviteAlumni.
  ///
  /// In zh, this message translates to:
  /// **'邀请校友加入'**
  String get inviteAlumni;

  /// No description provided for @connectResources.
  ///
  /// In zh, this message translates to:
  /// **'一起连接资源，共创价值'**
  String get connectResources;

  /// No description provided for @invite.
  ///
  /// In zh, this message translates to:
  /// **'去邀请'**
  String get invite;

  /// No description provided for @settings.
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get settings;

  /// No description provided for @accountSecurity.
  ///
  /// In zh, this message translates to:
  /// **'账号与安全'**
  String get accountSecurity;

  /// No description provided for @accountSecurityDesc.
  ///
  /// In zh, this message translates to:
  /// **'手机号、密码、登录方式'**
  String get accountSecurityDesc;

  /// No description provided for @notifications.
  ///
  /// In zh, this message translates to:
  /// **'消息通知'**
  String get notifications;

  /// No description provided for @notificationsDesc.
  ///
  /// In zh, this message translates to:
  /// **'系统通知、活动通知、商户通知'**
  String get notificationsDesc;

  /// No description provided for @languageSwitch.
  ///
  /// In zh, this message translates to:
  /// **'语言切换'**
  String get languageSwitch;

  /// No description provided for @languageSwitchDesc.
  ///
  /// In zh, this message translates to:
  /// **'中文、English、日本語'**
  String get languageSwitchDesc;

  /// No description provided for @privacySettings.
  ///
  /// In zh, this message translates to:
  /// **'隐私设置'**
  String get privacySettings;

  /// No description provided for @privacySettingsDesc.
  ///
  /// In zh, this message translates to:
  /// **'资料展示与权限管理'**
  String get privacySettingsDesc;

  /// No description provided for @clearCache.
  ///
  /// In zh, this message translates to:
  /// **'清除缓存'**
  String get clearCache;

  /// No description provided for @currentCache.
  ///
  /// In zh, this message translates to:
  /// **'当前缓存 28.6MB'**
  String get currentCache;

  /// No description provided for @aboutPlatform.
  ///
  /// In zh, this message translates to:
  /// **'关于平台'**
  String get aboutPlatform;

  /// No description provided for @aboutPlatformDesc.
  ///
  /// In zh, this message translates to:
  /// **'版本信息、服务协议'**
  String get aboutPlatformDesc;

  /// No description provided for @checkUpdates.
  ///
  /// In zh, this message translates to:
  /// **'检查更新'**
  String get checkUpdates;

  /// No description provided for @currentVersion.
  ///
  /// In zh, this message translates to:
  /// **'当前版本 1.0.0'**
  String get currentVersion;

  /// No description provided for @signOut.
  ///
  /// In zh, this message translates to:
  /// **'退出登录'**
  String get signOut;

  /// No description provided for @followSystemLanguage.
  ///
  /// In zh, this message translates to:
  /// **'跟随系统语言'**
  String get followSystemLanguage;

  /// No description provided for @followSystemLanguageDesc.
  ///
  /// In zh, this message translates to:
  /// **'根据手机系统语言自动切换'**
  String get followSystemLanguageDesc;

  /// No description provided for @chooseLanguage.
  ///
  /// In zh, this message translates to:
  /// **'选择语言'**
  String get chooseLanguage;

  /// No description provided for @chinese.
  ///
  /// In zh, this message translates to:
  /// **'中文'**
  String get chinese;

  /// No description provided for @simplifiedChinese.
  ///
  /// In zh, this message translates to:
  /// **'简体中文'**
  String get simplifiedChinese;

  /// No description provided for @english.
  ///
  /// In zh, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @japanese.
  ///
  /// In zh, this message translates to:
  /// **'日本語'**
  String get japanese;

  /// No description provided for @languageUpdateHint.
  ///
  /// In zh, this message translates to:
  /// **'切换语言后，App 内文字将立即更新。'**
  String get languageUpdateHint;

  /// No description provided for @memberHome.
  ///
  /// In zh, this message translates to:
  /// **'会员首页'**
  String get memberHome;

  /// No description provided for @certifiedMember.
  ///
  /// In zh, this message translates to:
  /// **'已认证会员'**
  String get certifiedMember;

  /// No description provided for @searchHint.
  ///
  /// In zh, this message translates to:
  /// **'搜索企业 / 商户 / 活动 / 商机'**
  String get searchHint;

  /// No description provided for @heroTitle.
  ///
  /// In zh, this message translates to:
  /// **'连接校友资源\n共创价值生态'**
  String get heroTitle;

  /// No description provided for @heroSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'整合校友企业、商家和优惠资源'**
  String get heroSubtitle;

  /// No description provided for @consumptionEntry.
  ///
  /// In zh, this message translates to:
  /// **'消费入单'**
  String get consumptionEntry;

  /// No description provided for @consumptionEntryDesc.
  ///
  /// In zh, this message translates to:
  /// **'谁付款 谁入单'**
  String get consumptionEntryDesc;

  /// No description provided for @myQrCode.
  ///
  /// In zh, this message translates to:
  /// **'我的二维码'**
  String get myQrCode;

  /// No description provided for @myQrCodeDesc.
  ///
  /// In zh, this message translates to:
  /// **'出示给商家扫码'**
  String get myQrCodeDesc;

  /// No description provided for @consumptionRecordsDesc.
  ///
  /// In zh, this message translates to:
  /// **'查看我的消费'**
  String get consumptionRecordsDesc;

  /// No description provided for @discountMerchants.
  ///
  /// In zh, this message translates to:
  /// **'优惠商家'**
  String get discountMerchants;

  /// No description provided for @discountMerchantsDesc.
  ///
  /// In zh, this message translates to:
  /// **'发现优惠好店'**
  String get discountMerchantsDesc;

  /// No description provided for @memberBenefits.
  ///
  /// In zh, this message translates to:
  /// **'享受会员权益'**
  String get memberBenefits;

  /// No description provided for @alumniCertification.
  ///
  /// In zh, this message translates to:
  /// **'校友认证'**
  String get alumniCertification;

  /// No description provided for @identityVerification.
  ///
  /// In zh, this message translates to:
  /// **'身份认证'**
  String get identityVerification;

  /// No description provided for @opportunityHall.
  ///
  /// In zh, this message translates to:
  /// **'商机大厅'**
  String get opportunityHall;

  /// No description provided for @resourceOpportunity.
  ///
  /// In zh, this message translates to:
  /// **'资源合作机会'**
  String get resourceOpportunity;

  /// No description provided for @activityRegistration.
  ///
  /// In zh, this message translates to:
  /// **'活动报名'**
  String get activityRegistration;

  /// No description provided for @joinAlumniActivities.
  ///
  /// In zh, this message translates to:
  /// **'参与校友活动'**
  String get joinAlumniActivities;

  /// No description provided for @recommendedMerchants.
  ///
  /// In zh, this message translates to:
  /// **'推荐商家'**
  String get recommendedMerchants;

  /// No description provided for @viewMore.
  ///
  /// In zh, this message translates to:
  /// **'查看更多'**
  String get viewMore;

  /// No description provided for @popularActivities.
  ///
  /// In zh, this message translates to:
  /// **'热门活动'**
  String get popularActivities;

  /// No description provided for @registering.
  ///
  /// In zh, this message translates to:
  /// **'报名中'**
  String get registering;

  /// No description provided for @registerNow.
  ///
  /// In zh, this message translates to:
  /// **'立即报名'**
  String get registerNow;

  /// No description provided for @registeredPeople.
  ///
  /// In zh, this message translates to:
  /// **'{count} 人已报名'**
  String registeredPeople(int count);

  /// No description provided for @search.
  ///
  /// In zh, this message translates to:
  /// **'搜索'**
  String get search;

  /// No description provided for @cancel.
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get cancel;

  /// No description provided for @hotSearch.
  ///
  /// In zh, this message translates to:
  /// **'热门搜索'**
  String get hotSearch;

  /// No description provided for @searchHistory.
  ///
  /// In zh, this message translates to:
  /// **'搜索历史'**
  String get searchHistory;

  /// No description provided for @noSearchResults.
  ///
  /// In zh, this message translates to:
  /// **'暂未找到相关商家'**
  String get noSearchResults;

  /// No description provided for @all.
  ///
  /// In zh, this message translates to:
  /// **'全部'**
  String get all;

  /// No description provided for @food.
  ///
  /// In zh, this message translates to:
  /// **'餐饮美食'**
  String get food;

  /// No description provided for @hotel.
  ///
  /// In zh, this message translates to:
  /// **'酒店住宿'**
  String get hotel;

  /// No description provided for @travel.
  ///
  /// In zh, this message translates to:
  /// **'旅游出行'**
  String get travel;

  /// No description provided for @education.
  ///
  /// In zh, this message translates to:
  /// **'教育培训'**
  String get education;

  /// No description provided for @medical.
  ///
  /// In zh, this message translates to:
  /// **'医疗健康'**
  String get medical;

  /// No description provided for @retail.
  ///
  /// In zh, this message translates to:
  /// **'零售百货'**
  String get retail;

  /// No description provided for @storeSearchHint.
  ///
  /// In zh, this message translates to:
  /// **'搜索商家、商品、服务'**
  String get storeSearchHint;

  /// No description provided for @allRegions.
  ///
  /// In zh, this message translates to:
  /// **'全部区域'**
  String get allRegions;

  /// No description provided for @sortBy.
  ///
  /// In zh, this message translates to:
  /// **'综合排序'**
  String get sortBy;

  /// No description provided for @filter.
  ///
  /// In zh, this message translates to:
  /// **'筛选'**
  String get filter;

  /// No description provided for @memberStore.
  ///
  /// In zh, this message translates to:
  /// **'会员店铺'**
  String get memberStore;

  /// No description provided for @memberDiscount.
  ///
  /// In zh, this message translates to:
  /// **'会员优惠'**
  String get memberDiscount;

  /// No description provided for @monthlySales.
  ///
  /// In zh, this message translates to:
  /// **'月售 {count}+'**
  String monthlySales(int count);

  /// No description provided for @phone.
  ///
  /// In zh, this message translates to:
  /// **'电话'**
  String get phone;

  /// No description provided for @navigation.
  ///
  /// In zh, this message translates to:
  /// **'导航'**
  String get navigation;

  /// No description provided for @memberBenefitsTitle.
  ///
  /// In zh, this message translates to:
  /// **'会员优惠'**
  String get memberBenefitsTitle;

  /// No description provided for @storeIntroduction.
  ///
  /// In zh, this message translates to:
  /// **'商家简介'**
  String get storeIntroduction;

  /// No description provided for @storeIntroductionText.
  ///
  /// In zh, this message translates to:
  /// **'专注于提供优质服务与美好体验，精选食材，匠心烹饪，致力于为校友会员打造专属的品质空间。'**
  String get storeIntroductionText;

  /// No description provided for @favorite.
  ///
  /// In zh, this message translates to:
  /// **'收藏'**
  String get favorite;

  /// No description provided for @share.
  ///
  /// In zh, this message translates to:
  /// **'分享'**
  String get share;

  /// No description provided for @contactMerchant.
  ///
  /// In zh, this message translates to:
  /// **'联系商家'**
  String get contactMerchant;

  /// No description provided for @reserveNow.
  ///
  /// In zh, this message translates to:
  /// **'立即预约'**
  String get reserveNow;

  /// No description provided for @useNow.
  ///
  /// In zh, this message translates to:
  /// **'立即使用'**
  String get useNow;

  /// No description provided for @useBenefit.
  ///
  /// In zh, this message translates to:
  /// **'使用优惠'**
  String get useBenefit;

  /// No description provided for @instructions.
  ///
  /// In zh, this message translates to:
  /// **'使用说明'**
  String get instructions;

  /// No description provided for @offerInstructions.
  ///
  /// In zh, this message translates to:
  /// **'1. 到店出示会员二维码\n2. 商家扫描二维码核销\n3. 享受会员专属优惠价格'**
  String get offerInstructions;

  /// No description provided for @qrRefreshHint.
  ///
  /// In zh, this message translates to:
  /// **'会员二维码每分钟自动刷新'**
  String get qrRefreshHint;

  /// No description provided for @refreshQrCode.
  ///
  /// In zh, this message translates to:
  /// **'刷新二维码'**
  String get refreshQrCode;

  /// No description provided for @navigateToStore.
  ///
  /// In zh, this message translates to:
  /// **'导航到店'**
  String get navigateToStore;

  /// No description provided for @reservationInfo.
  ///
  /// In zh, this message translates to:
  /// **'预约信息'**
  String get reservationInfo;

  /// No description provided for @selectReservationPackage.
  ///
  /// In zh, this message translates to:
  /// **'选择预约套餐'**
  String get selectReservationPackage;

  /// No description provided for @selectDate.
  ///
  /// In zh, this message translates to:
  /// **'选择日期'**
  String get selectDate;

  /// No description provided for @selectTime.
  ///
  /// In zh, this message translates to:
  /// **'选择时间'**
  String get selectTime;

  /// No description provided for @today.
  ///
  /// In zh, this message translates to:
  /// **'今天'**
  String get today;

  /// No description provided for @weekday.
  ///
  /// In zh, this message translates to:
  /// **'周{day}'**
  String weekday(int day);

  /// No description provided for @available.
  ///
  /// In zh, this message translates to:
  /// **'可预约'**
  String get available;

  /// No description provided for @fillReservationInfo.
  ///
  /// In zh, this message translates to:
  /// **'填写预约信息'**
  String get fillReservationInfo;

  /// No description provided for @contact.
  ///
  /// In zh, this message translates to:
  /// **'联系人'**
  String get contact;

  /// No description provided for @phoneNumber.
  ///
  /// In zh, this message translates to:
  /// **'手机号码'**
  String get phoneNumber;

  /// No description provided for @guestCount.
  ///
  /// In zh, this message translates to:
  /// **'预约人数'**
  String get guestCount;

  /// No description provided for @notesOptional.
  ///
  /// In zh, this message translates to:
  /// **'备注（选填）'**
  String get notesOptional;

  /// No description provided for @agreeReservationTerms.
  ///
  /// In zh, this message translates to:
  /// **'我已阅读并同意《预约服务协议》'**
  String get agreeReservationTerms;

  /// No description provided for @confirmReservation.
  ///
  /// In zh, this message translates to:
  /// **'确认预约'**
  String get confirmReservation;

  /// No description provided for @reservationConfirmation.
  ///
  /// In zh, this message translates to:
  /// **'预约信息确认'**
  String get reservationConfirmation;

  /// No description provided for @reservationPackage.
  ///
  /// In zh, this message translates to:
  /// **'预约套餐'**
  String get reservationPackage;

  /// No description provided for @reservationTime.
  ///
  /// In zh, this message translates to:
  /// **'预约时间'**
  String get reservationTime;

  /// No description provided for @contactInfo.
  ///
  /// In zh, this message translates to:
  /// **'联系人信息'**
  String get contactInfo;

  /// No description provided for @notes.
  ///
  /// In zh, this message translates to:
  /// **'备注信息'**
  String get notes;

  /// No description provided for @noNotes.
  ///
  /// In zh, this message translates to:
  /// **'暂无备注'**
  String get noNotes;

  /// No description provided for @benefitInfo.
  ///
  /// In zh, this message translates to:
  /// **'优惠信息'**
  String get benefitInfo;

  /// No description provided for @discountedAmount.
  ///
  /// In zh, this message translates to:
  /// **'优惠后金额'**
  String get discountedAmount;

  /// No description provided for @reservationWarmTip.
  ///
  /// In zh, this message translates to:
  /// **'温馨提示：商家将在24小时内确认您的预约，请留意短信或消息通知。'**
  String get reservationWarmTip;

  /// No description provided for @amountDue.
  ///
  /// In zh, this message translates to:
  /// **'需支付金额'**
  String get amountDue;

  /// No description provided for @reservationSubmitted.
  ///
  /// In zh, this message translates to:
  /// **'预约已提交'**
  String get reservationSubmitted;

  /// No description provided for @allActivities.
  ///
  /// In zh, this message translates to:
  /// **'全部活动'**
  String get allActivities;

  /// No description provided for @alumniActivities.
  ///
  /// In zh, this message translates to:
  /// **'校友活动'**
  String get alumniActivities;

  /// No description provided for @industryForums.
  ///
  /// In zh, this message translates to:
  /// **'行业论坛'**
  String get industryForums;

  /// No description provided for @trainingLectures.
  ///
  /// In zh, this message translates to:
  /// **'培训讲座'**
  String get trainingLectures;

  /// No description provided for @sportsEntertainment.
  ///
  /// In zh, this message translates to:
  /// **'体育文娱'**
  String get sportsEntertainment;

  /// No description provided for @upcomingActivities.
  ///
  /// In zh, this message translates to:
  /// **'近期活动'**
  String get upcomingActivities;

  /// No description provided for @activityDetails.
  ///
  /// In zh, this message translates to:
  /// **'活动详情'**
  String get activityDetails;

  /// No description provided for @shareReady.
  ///
  /// In zh, this message translates to:
  /// **'分享内容已准备'**
  String get shareReady;

  /// No description provided for @activityTime.
  ///
  /// In zh, this message translates to:
  /// **'活动时间'**
  String get activityTime;

  /// No description provided for @activityLocation.
  ///
  /// In zh, this message translates to:
  /// **'活动地点'**
  String get activityLocation;

  /// No description provided for @activityScale.
  ///
  /// In zh, this message translates to:
  /// **'活动规模'**
  String get activityScale;

  /// No description provided for @activityFee.
  ///
  /// In zh, this message translates to:
  /// **'活动费用'**
  String get activityFee;

  /// No description provided for @limitedPeople.
  ///
  /// In zh, this message translates to:
  /// **'{count}人（限额）'**
  String limitedPeople(int count);

  /// No description provided for @free.
  ///
  /// In zh, this message translates to:
  /// **'免费'**
  String get free;

  /// No description provided for @paid.
  ///
  /// In zh, this message translates to:
  /// **'实付'**
  String get paid;

  /// No description provided for @activityIntroduction.
  ///
  /// In zh, this message translates to:
  /// **'活动介绍'**
  String get activityIntroduction;

  /// No description provided for @activityIntroductionText.
  ///
  /// In zh, this message translates to:
  /// **'全球校友联谊会旨在搭建校友交流合作平台，汇聚全球校友力量，共话未来发展，寻找合作机遇，共创价值生态。活动将邀请各行业杰出校友、企业家、投资人等共同参与，分享经验，拓展人脉，促进合作。'**
  String get activityIntroductionText;

  /// No description provided for @expandAll.
  ///
  /// In zh, this message translates to:
  /// **'展开全部'**
  String get expandAll;

  /// No description provided for @collapse.
  ///
  /// In zh, this message translates to:
  /// **'收起'**
  String get collapse;

  /// No description provided for @activityHighlights.
  ///
  /// In zh, this message translates to:
  /// **'活动亮点'**
  String get activityHighlights;

  /// No description provided for @topicSharing.
  ///
  /// In zh, this message translates to:
  /// **'主题分享'**
  String get topicSharing;

  /// No description provided for @resourceMatching.
  ///
  /// In zh, this message translates to:
  /// **'资源对接'**
  String get resourceMatching;

  /// No description provided for @alumniNetworking.
  ///
  /// In zh, this message translates to:
  /// **'校友交流'**
  String get alumniNetworking;

  /// No description provided for @specialGifts.
  ///
  /// In zh, this message translates to:
  /// **'精美礼品'**
  String get specialGifts;

  /// No description provided for @registrationNotice.
  ///
  /// In zh, this message translates to:
  /// **'报名须知'**
  String get registrationNotice;

  /// No description provided for @registrationNoticeText.
  ///
  /// In zh, this message translates to:
  /// **'• 本次活动仅限校友及在校师生报名参加。\n• 报名成功后，请凭签到二维码入场。\n• 如需取消报名，请至少提前24小时操作。\n• 活动最终解释权归主办方所有。'**
  String get registrationNoticeText;

  /// No description provided for @organizer.
  ///
  /// In zh, this message translates to:
  /// **'校友会'**
  String get organizer;

  /// No description provided for @cancelRegistration.
  ///
  /// In zh, this message translates to:
  /// **'取消报名'**
  String get cancelRegistration;

  /// No description provided for @allOpportunities.
  ///
  /// In zh, this message translates to:
  /// **'全部商机'**
  String get allOpportunities;

  /// No description provided for @cooperationNeeds.
  ///
  /// In zh, this message translates to:
  /// **'合作需求'**
  String get cooperationNeeds;

  /// No description provided for @resourceConnection.
  ///
  /// In zh, this message translates to:
  /// **'资源对接'**
  String get resourceConnection;

  /// No description provided for @investmentFinancing.
  ///
  /// In zh, this message translates to:
  /// **'投融资'**
  String get investmentFinancing;

  /// No description provided for @franchiseRecruitment.
  ///
  /// In zh, this message translates to:
  /// **'招商加盟'**
  String get franchiseRecruitment;

  /// No description provided for @opportunitySearchHint.
  ///
  /// In zh, this message translates to:
  /// **'搜索商机 / 需求 / 资源'**
  String get opportunitySearchHint;

  /// No description provided for @allCategories.
  ///
  /// In zh, this message translates to:
  /// **'全部分类'**
  String get allCategories;

  /// No description provided for @hoursAgo.
  ///
  /// In zh, this message translates to:
  /// **'{count}小时前'**
  String hoursAgo(int count);

  /// No description provided for @publishOpportunity.
  ///
  /// In zh, this message translates to:
  /// **'发布商机'**
  String get publishOpportunity;

  /// No description provided for @opportunityDetails.
  ///
  /// In zh, this message translates to:
  /// **'商机详情'**
  String get opportunityDetails;

  /// No description provided for @inProgress.
  ///
  /// In zh, this message translates to:
  /// **'进行中'**
  String get inProgress;

  /// No description provided for @publishDate.
  ///
  /// In zh, this message translates to:
  /// **'发布时间'**
  String get publishDate;

  /// No description provided for @validUntil.
  ///
  /// In zh, this message translates to:
  /// **'有效期至'**
  String get validUntil;

  /// No description provided for @views.
  ///
  /// In zh, this message translates to:
  /// **'浏览量'**
  String get views;

  /// No description provided for @favorites.
  ///
  /// In zh, this message translates to:
  /// **'收藏量'**
  String get favorites;

  /// No description provided for @opportunityInfo.
  ///
  /// In zh, this message translates to:
  /// **'商机详情'**
  String get opportunityInfo;

  /// No description provided for @industry.
  ///
  /// In zh, this message translates to:
  /// **'所属行业'**
  String get industry;

  /// No description provided for @cooperationType.
  ///
  /// In zh, this message translates to:
  /// **'合作类型'**
  String get cooperationType;

  /// No description provided for @supplyChainCooperation.
  ///
  /// In zh, this message translates to:
  /// **'供应链合作'**
  String get supplyChainCooperation;

  /// No description provided for @projectRegion.
  ///
  /// In zh, this message translates to:
  /// **'项目地区'**
  String get projectRegion;

  /// No description provided for @budgetRange.
  ///
  /// In zh, this message translates to:
  /// **'预算范围'**
  String get budgetRange;

  /// No description provided for @cooperationMethod.
  ///
  /// In zh, this message translates to:
  /// **'合作方式'**
  String get cooperationMethod;

  /// No description provided for @longTermCooperation.
  ///
  /// In zh, this message translates to:
  /// **'长期合作'**
  String get longTermCooperation;

  /// No description provided for @publisher.
  ///
  /// In zh, this message translates to:
  /// **'发布会员'**
  String get publisher;

  /// No description provided for @opportunityDescription.
  ///
  /// In zh, this message translates to:
  /// **'商机描述'**
  String get opportunityDescription;

  /// No description provided for @opportunityDescriptionText.
  ///
  /// In zh, this message translates to:
  /// **'我们是一家连锁餐饮品牌，目前在上海及周边地区拥有20+门店，计划在未来一年内拓展至60家门店。现寻找优质食材供应商，要求食品品质优良，符合国家食品安全标准，具备稳定的供应能力和物流配送能力，价格合理并具有长期合作诚意。'**
  String get opportunityDescriptionText;

  /// No description provided for @requirementList.
  ///
  /// In zh, this message translates to:
  /// **'需求清单'**
  String get requirementList;

  /// No description provided for @cooperationAdvantages.
  ///
  /// In zh, this message translates to:
  /// **'合作优势'**
  String get cooperationAdvantages;

  /// No description provided for @stableCooperation.
  ///
  /// In zh, this message translates to:
  /// **'长期稳定合作'**
  String get stableCooperation;

  /// No description provided for @brandResources.
  ///
  /// In zh, this message translates to:
  /// **'品牌资源支持'**
  String get brandResources;

  /// No description provided for @marketExpansion.
  ///
  /// In zh, this message translates to:
  /// **'共同市场拓展'**
  String get marketExpansion;

  /// No description provided for @flexibleModel.
  ///
  /// In zh, this message translates to:
  /// **'灵活合作模式'**
  String get flexibleModel;

  /// No description provided for @email.
  ///
  /// In zh, this message translates to:
  /// **'联系邮箱'**
  String get email;

  /// No description provided for @contactAddress.
  ///
  /// In zh, this message translates to:
  /// **'联系地址'**
  String get contactAddress;

  /// No description provided for @opportunitySafetyTip.
  ///
  /// In zh, this message translates to:
  /// **'温馨提示：请在沟通合作前充分了解对方信息，谨防诈骗。如遇异常情况，请及时联系客服。'**
  String get opportunitySafetyTip;

  /// No description provided for @contactPublisher.
  ///
  /// In zh, this message translates to:
  /// **'联系发布者'**
  String get contactPublisher;

  /// No description provided for @interestedInCooperation.
  ///
  /// In zh, this message translates to:
  /// **'有意向合作'**
  String get interestedInCooperation;

  /// No description provided for @intentSubmitted.
  ///
  /// In zh, this message translates to:
  /// **'合作意向已提交'**
  String get intentSubmitted;

  /// No description provided for @saveDraft.
  ///
  /// In zh, this message translates to:
  /// **'保存草稿'**
  String get saveDraft;

  /// No description provided for @draftSaved.
  ///
  /// In zh, this message translates to:
  /// **'草稿已保存'**
  String get draftSaved;

  /// No description provided for @basicInformation.
  ///
  /// In zh, this message translates to:
  /// **'基本信息'**
  String get basicInformation;

  /// No description provided for @opportunityTitle.
  ///
  /// In zh, this message translates to:
  /// **'商机标题'**
  String get opportunityTitle;

  /// No description provided for @opportunityTitleHint.
  ///
  /// In zh, this message translates to:
  /// **'请输入商机标题，简明扼要概括您的需求'**
  String get opportunityTitleHint;

  /// No description provided for @opportunityCategory.
  ///
  /// In zh, this message translates to:
  /// **'商机分类'**
  String get opportunityCategory;

  /// No description provided for @opportunityDescriptionHint.
  ///
  /// In zh, this message translates to:
  /// **'请详细描述您的需求、项目背景、合作目标、对合作方的要求等信息'**
  String get opportunityDescriptionHint;

  /// No description provided for @capitalAdvantage.
  ///
  /// In zh, this message translates to:
  /// **'资金优势'**
  String get capitalAdvantage;

  /// No description provided for @technicalAdvantage.
  ///
  /// In zh, this message translates to:
  /// **'技术优势'**
  String get technicalAdvantage;

  /// No description provided for @marketAdvantage.
  ///
  /// In zh, this message translates to:
  /// **'市场优势'**
  String get marketAdvantage;

  /// No description provided for @resourceAdvantage.
  ///
  /// In zh, this message translates to:
  /// **'资源优势'**
  String get resourceAdvantage;

  /// No description provided for @teamAdvantage.
  ///
  /// In zh, this message translates to:
  /// **'团队优势'**
  String get teamAdvantage;

  /// No description provided for @brandAdvantage.
  ///
  /// In zh, this message translates to:
  /// **'品牌优势'**
  String get brandAdvantage;

  /// No description provided for @channelAdvantage.
  ///
  /// In zh, this message translates to:
  /// **'渠道优势'**
  String get channelAdvantage;

  /// No description provided for @otherAdvantage.
  ///
  /// In zh, this message translates to:
  /// **'其他优势'**
  String get otherAdvantage;

  /// No description provided for @attachments.
  ///
  /// In zh, this message translates to:
  /// **'附件资料'**
  String get attachments;

  /// No description provided for @uploadDocuments.
  ///
  /// In zh, this message translates to:
  /// **'上传资料'**
  String get uploadDocuments;

  /// No description provided for @otherSettings.
  ///
  /// In zh, this message translates to:
  /// **'其他设置'**
  String get otherSettings;

  /// No description provided for @validityPeriod.
  ///
  /// In zh, this message translates to:
  /// **'有效期'**
  String get validityPeriod;

  /// No description provided for @daysCount.
  ///
  /// In zh, this message translates to:
  /// **'{count}天'**
  String daysCount(int count);

  /// No description provided for @visibility.
  ///
  /// In zh, this message translates to:
  /// **'是否公开'**
  String get visibility;

  /// No description provided for @publicVisible.
  ///
  /// In zh, this message translates to:
  /// **'公开（所有人可见）'**
  String get publicVisible;

  /// No description provided for @alumniOnlyVisible.
  ///
  /// In zh, this message translates to:
  /// **'仅校友可见'**
  String get alumniOnlyVisible;

  /// No description provided for @agreeOpportunityTerms.
  ///
  /// In zh, this message translates to:
  /// **'我已阅读并同意《商机发布协议》'**
  String get agreeOpportunityTerms;

  /// No description provided for @preview.
  ///
  /// In zh, this message translates to:
  /// **'预览'**
  String get preview;

  /// No description provided for @opportunityPublished.
  ///
  /// In zh, this message translates to:
  /// **'商机发布成功'**
  String get opportunityPublished;

  /// No description provided for @completeRequiredFields.
  ///
  /// In zh, this message translates to:
  /// **'请填写标题、描述并同意发布协议'**
  String get completeRequiredFields;

  /// No description provided for @selectMerchant.
  ///
  /// In zh, this message translates to:
  /// **'选择商家'**
  String get selectMerchant;

  /// No description provided for @selectCoupon.
  ///
  /// In zh, this message translates to:
  /// **'选择优惠券'**
  String get selectCoupon;

  /// No description provided for @enterAmount.
  ///
  /// In zh, this message translates to:
  /// **'填写金额'**
  String get enterAmount;

  /// No description provided for @confirmSubmit.
  ///
  /// In zh, this message translates to:
  /// **'确认提交'**
  String get confirmSubmit;

  /// No description provided for @consumptionMerchantSearchHint.
  ///
  /// In zh, this message translates to:
  /// **'搜索商家名称、品类'**
  String get consumptionMerchantSearchHint;

  /// No description provided for @manualEntry.
  ///
  /// In zh, this message translates to:
  /// **'没有找到商家？手动输入'**
  String get manualEntry;

  /// No description provided for @nextSelectCoupon.
  ///
  /// In zh, this message translates to:
  /// **'下一步：选择优惠券'**
  String get nextSelectCoupon;

  /// No description provided for @reselect.
  ///
  /// In zh, this message translates to:
  /// **'重新选择'**
  String get reselect;

  /// No description provided for @couponInstructions.
  ///
  /// In zh, this message translates to:
  /// **'优惠使用说明'**
  String get couponInstructions;

  /// No description provided for @singleCouponHint.
  ///
  /// In zh, this message translates to:
  /// **'优惠券仅可使用1张，不可叠加使用'**
  String get singleCouponHint;

  /// No description provided for @doNotUseCoupon.
  ///
  /// In zh, this message translates to:
  /// **'不使用优惠券'**
  String get doNotUseCoupon;

  /// No description provided for @calculateOriginalPrice.
  ///
  /// In zh, this message translates to:
  /// **'不使用任何优惠，按原价计算'**
  String get calculateOriginalPrice;

  /// No description provided for @nextEnterAmount.
  ///
  /// In zh, this message translates to:
  /// **'下一步：填写金额'**
  String get nextEnterAmount;

  /// No description provided for @fillConsumptionAmount.
  ///
  /// In zh, this message translates to:
  /// **'填写消费金额'**
  String get fillConsumptionAmount;

  /// No description provided for @originalAmount.
  ///
  /// In zh, this message translates to:
  /// **'消费原价'**
  String get originalAmount;

  /// No description provided for @currencyYuan.
  ///
  /// In zh, this message translates to:
  /// **'元'**
  String get currencyYuan;

  /// No description provided for @enterAmountHint.
  ///
  /// In zh, this message translates to:
  /// **'请输入金额'**
  String get enterAmountHint;

  /// No description provided for @originalAmountHint.
  ///
  /// In zh, this message translates to:
  /// **'请输入不享受优惠的原价金额'**
  String get originalAmountHint;

  /// No description provided for @selectedCoupon.
  ///
  /// In zh, this message translates to:
  /// **'已选择优惠券'**
  String get selectedCoupon;

  /// No description provided for @changeCoupon.
  ///
  /// In zh, this message translates to:
  /// **'更换优惠券'**
  String get changeCoupon;

  /// No description provided for @discountAmount.
  ///
  /// In zh, this message translates to:
  /// **'优惠金额'**
  String get discountAmount;

  /// No description provided for @payableAmount.
  ///
  /// In zh, this message translates to:
  /// **'实付金额'**
  String get payableAmount;

  /// No description provided for @consumptionNoteHint.
  ///
  /// In zh, this message translates to:
  /// **'请输入备注信息（如：桌号、特殊要求等）'**
  String get consumptionNoteHint;

  /// No description provided for @nextConfirmSubmit.
  ///
  /// In zh, this message translates to:
  /// **'下一步：确认提交'**
  String get nextConfirmSubmit;

  /// No description provided for @submissionSuccessful.
  ///
  /// In zh, this message translates to:
  /// **'提交成功！'**
  String get submissionSuccessful;

  /// No description provided for @submissionSuccessHint.
  ///
  /// In zh, this message translates to:
  /// **'您的消费入单已成功提交\n请等待商家核销确认'**
  String get submissionSuccessHint;

  /// No description provided for @orderNumber.
  ///
  /// In zh, this message translates to:
  /// **'订单号'**
  String get orderNumber;

  /// No description provided for @merchantName.
  ///
  /// In zh, this message translates to:
  /// **'商家名称'**
  String get merchantName;

  /// No description provided for @submissionTime.
  ///
  /// In zh, this message translates to:
  /// **'提交时间'**
  String get submissionTime;

  /// No description provided for @usedCoupon.
  ///
  /// In zh, this message translates to:
  /// **'使用优惠券'**
  String get usedCoupon;

  /// No description provided for @viewOrder.
  ///
  /// In zh, this message translates to:
  /// **'查看订单'**
  String get viewOrder;

  /// No description provided for @returnHome.
  ///
  /// In zh, this message translates to:
  /// **'返回首页'**
  String get returnHome;

  /// No description provided for @orderDetailsComingSoon.
  ///
  /// In zh, this message translates to:
  /// **'订单详情功能即将开放'**
  String get orderDetailsComingSoon;

  /// No description provided for @thisMonth.
  ///
  /// In zh, this message translates to:
  /// **'本月'**
  String get thisMonth;

  /// No description provided for @pendingVerification.
  ///
  /// In zh, this message translates to:
  /// **'待确认'**
  String get pendingVerification;

  /// No description provided for @noRecords.
  ///
  /// In zh, this message translates to:
  /// **'暂无记录'**
  String get noRecords;

  /// No description provided for @monthlyConsumption.
  ///
  /// In zh, this message translates to:
  /// **'本月消费金额'**
  String get monthlyConsumption;

  /// No description provided for @paidAmount.
  ///
  /// In zh, this message translates to:
  /// **'实付金额'**
  String get paidAmount;

  /// No description provided for @myMessages.
  ///
  /// In zh, this message translates to:
  /// **'我的消息'**
  String get myMessages;

  /// No description provided for @markAllRead.
  ///
  /// In zh, this message translates to:
  /// **'全部已读'**
  String get markAllRead;

  /// No description provided for @systemNotification.
  ///
  /// In zh, this message translates to:
  /// **'系统通知'**
  String get systemNotification;

  /// No description provided for @activityNotification.
  ///
  /// In zh, this message translates to:
  /// **'活动通知'**
  String get activityNotification;

  /// No description provided for @merchantNotification.
  ///
  /// In zh, this message translates to:
  /// **'商户通知'**
  String get merchantNotification;

  /// No description provided for @merchantBenefits.
  ///
  /// In zh, this message translates to:
  /// **'商家优惠'**
  String get merchantBenefits;

  /// No description provided for @benefitSearchHint.
  ///
  /// In zh, this message translates to:
  /// **'搜索商家 / 优惠 / 品类'**
  String get benefitSearchHint;

  /// No description provided for @shopping.
  ///
  /// In zh, this message translates to:
  /// **'购物休闲'**
  String get shopping;

  /// No description provided for @lifeServices.
  ///
  /// In zh, this message translates to:
  /// **'生活服务'**
  String get lifeServices;

  /// No description provided for @memberExclusiveBenefits.
  ///
  /// In zh, this message translates to:
  /// **'会员专享 · 商家优惠'**
  String get memberExclusiveBenefits;

  /// No description provided for @benefitsNeverStop.
  ///
  /// In zh, this message translates to:
  /// **'超值优惠享不停'**
  String get benefitsNeverStop;

  /// No description provided for @claimed.
  ///
  /// In zh, this message translates to:
  /// **'已领取'**
  String get claimed;

  /// No description provided for @claimNow.
  ///
  /// In zh, this message translates to:
  /// **'立即领取'**
  String get claimNow;

  /// No description provided for @certificationInstructions.
  ///
  /// In zh, this message translates to:
  /// **'认证说明'**
  String get certificationInstructions;

  /// No description provided for @certificationInformation.
  ///
  /// In zh, this message translates to:
  /// **'认证信息'**
  String get certificationInformation;

  /// No description provided for @certificationFormHint.
  ///
  /// In zh, this message translates to:
  /// **'请填写真实信息，提交后将由工作人员审核'**
  String get certificationFormHint;

  /// No description provided for @name.
  ///
  /// In zh, this message translates to:
  /// **'姓名'**
  String get name;

  /// No description provided for @school.
  ///
  /// In zh, this message translates to:
  /// **'学校'**
  String get school;

  /// No description provided for @college.
  ///
  /// In zh, this message translates to:
  /// **'学院'**
  String get college;

  /// No description provided for @cohort.
  ///
  /// In zh, this message translates to:
  /// **'届别'**
  String get cohort;

  /// No description provided for @major.
  ///
  /// In zh, this message translates to:
  /// **'专业'**
  String get major;

  /// No description provided for @uploadImages.
  ///
  /// In zh, this message translates to:
  /// **'上传图片（至少上传一项）'**
  String get uploadImages;

  /// No description provided for @studentCard.
  ///
  /// In zh, this message translates to:
  /// **'学生证'**
  String get studentCard;

  /// No description provided for @diploma.
  ///
  /// In zh, this message translates to:
  /// **'毕业证'**
  String get diploma;

  /// No description provided for @alumniProof.
  ///
  /// In zh, this message translates to:
  /// **'校友证明'**
  String get alumniProof;

  /// No description provided for @certificationWarmTip.
  ///
  /// In zh, this message translates to:
  /// **'请确保填写信息真实有效，上传的证明材料清晰可见。'**
  String get certificationWarmTip;

  /// No description provided for @certificationBenefitsHint.
  ///
  /// In zh, this message translates to:
  /// **'尊享会员权益与商户专属优惠'**
  String get certificationBenefitsHint;

  /// No description provided for @completeCertificationForm.
  ///
  /// In zh, this message translates to:
  /// **'请填写完整信息并至少上传一项证明'**
  String get completeCertificationForm;

  /// No description provided for @submitCertification.
  ///
  /// In zh, this message translates to:
  /// **'提交认证'**
  String get submitCertification;

  /// No description provided for @confirm.
  ///
  /// In zh, this message translates to:
  /// **'确定'**
  String get confirm;

  /// No description provided for @certificationStatus.
  ///
  /// In zh, this message translates to:
  /// **'认证状态'**
  String get certificationStatus;

  /// No description provided for @certificationPending.
  ///
  /// In zh, this message translates to:
  /// **'认证审核中'**
  String get certificationPending;

  /// No description provided for @certificationPendingHint.
  ///
  /// In zh, this message translates to:
  /// **'资料已提交，请等待管理员审核，预计1-3个工作日完成'**
  String get certificationPendingHint;

  /// No description provided for @submittedInformation.
  ///
  /// In zh, this message translates to:
  /// **'提交资料'**
  String get submittedInformation;

  /// No description provided for @certificationReviewTips.
  ///
  /// In zh, this message translates to:
  /// **'温馨提示\n1. 审核通过后将自动生成电子会员卡。\n2. 若资料有误，可撤回后重新提交。\n3. 审核结果将通过消息通知提醒。'**
  String get certificationReviewTips;

  /// No description provided for @withdrawAndEdit.
  ///
  /// In zh, this message translates to:
  /// **'撤回修改'**
  String get withdrawAndEdit;

  /// No description provided for @viewReviewResult.
  ///
  /// In zh, this message translates to:
  /// **'查看审核结果'**
  String get viewReviewResult;

  /// No description provided for @certificationSuccess.
  ///
  /// In zh, this message translates to:
  /// **'认证成功'**
  String get certificationSuccess;

  /// No description provided for @identityMark.
  ///
  /// In zh, this message translates to:
  /// **'身份标识'**
  String get identityMark;

  /// No description provided for @activityPriority.
  ///
  /// In zh, this message translates to:
  /// **'活动优先'**
  String get activityPriority;

  /// No description provided for @certificationPassed.
  ///
  /// In zh, this message translates to:
  /// **'校友认证已通过'**
  String get certificationPassed;

  /// No description provided for @certifiedAlumniMember.
  ///
  /// In zh, this message translates to:
  /// **'你已成为认证校友会员'**
  String get certifiedAlumniMember;

  /// No description provided for @certificationRights.
  ///
  /// In zh, this message translates to:
  /// **'认证权益'**
  String get certificationRights;

  /// No description provided for @memberIdLabel.
  ///
  /// In zh, this message translates to:
  /// **'会员编号'**
  String get memberIdLabel;

  /// No description provided for @memberIdentity.
  ///
  /// In zh, this message translates to:
  /// **'会员身份'**
  String get memberIdentity;

  /// No description provided for @certificationTime.
  ///
  /// In zh, this message translates to:
  /// **'认证时间'**
  String get certificationTime;

  /// No description provided for @viewMemberCard.
  ///
  /// In zh, this message translates to:
  /// **'查看会员卡'**
  String get viewMemberCard;

  /// No description provided for @memberBarcode.
  ///
  /// In zh, this message translates to:
  /// **'会员条形码'**
  String get memberBarcode;

  /// No description provided for @tapBarcodeToRefresh.
  ///
  /// In zh, this message translates to:
  /// **'点击条形码可刷新'**
  String get tapBarcodeToRefresh;

  /// No description provided for @memberLevel.
  ///
  /// In zh, this message translates to:
  /// **'会员等级'**
  String get memberLevel;

  /// No description provided for @serviceSupport.
  ///
  /// In zh, this message translates to:
  /// **'专属服务支持'**
  String get serviceSupport;

  /// No description provided for @memberCardRules.
  ///
  /// In zh, this message translates to:
  /// **'使用规则\n1. 此卡仅限本人使用，不可转借他人。\n2. 会员权益仅限在合作商家及指定场景使用。\n3. 请在有效期内使用，过期后自动失效。'**
  String get memberCardRules;

  /// No description provided for @showMemberQr.
  ///
  /// In zh, this message translates to:
  /// **'出示会员二维码'**
  String get showMemberQr;

  /// No description provided for @alumniElectronicCard.
  ///
  /// In zh, this message translates to:
  /// **'校友会电子会员卡'**
  String get alumniElectronicCard;

  /// No description provided for @memberQrCode.
  ///
  /// In zh, this message translates to:
  /// **'会员二维码'**
  String get memberQrCode;

  /// No description provided for @qrAutoRefreshHint.
  ///
  /// In zh, this message translates to:
  /// **'会员二维码每分钟自动刷新'**
  String get qrAutoRefreshHint;

  /// No description provided for @refreshQr.
  ///
  /// In zh, this message translates to:
  /// **'刷新二维码'**
  String get refreshQr;

  /// No description provided for @showQrToMerchant.
  ///
  /// In zh, this message translates to:
  /// **'到店消费时向商户出示此二维码\n商户扫码后可确认会员身份并完成优惠核销'**
  String get showQrToMerchant;

  /// No description provided for @bannerBenefitsTitle.
  ///
  /// In zh, this message translates to:
  /// **'校友专享权益\n品质生活触手可及'**
  String get bannerBenefitsTitle;

  /// No description provided for @bannerBenefitsSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'精选合作商家与会员专属优惠'**
  String get bannerBenefitsSubtitle;

  /// No description provided for @bannerActivitiesTitle.
  ///
  /// In zh, this message translates to:
  /// **'精彩校友活动\n拓展人脉与视野'**
  String get bannerActivitiesTitle;

  /// No description provided for @bannerActivitiesSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'汇聚行业交流、论坛与学习活动'**
  String get bannerActivitiesSubtitle;

  /// No description provided for @bannerOpportunitiesTitle.
  ///
  /// In zh, this message translates to:
  /// **'发现合作商机\n链接优质校友资源'**
  String get bannerOpportunitiesTitle;

  /// No description provided for @bannerOpportunitiesSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'让需求与资源高效精准匹配'**
  String get bannerOpportunitiesSubtitle;

  /// No description provided for @pullUpToLoadMore.
  ///
  /// In zh, this message translates to:
  /// **'上拉加载更多'**
  String get pullUpToLoadMore;

  /// No description provided for @noMoreData.
  ///
  /// In zh, this message translates to:
  /// **'没有更多数据了'**
  String get noMoreData;

  /// No description provided for @clearAll.
  ///
  /// In zh, this message translates to:
  /// **'清空'**
  String get clearAll;

  /// No description provided for @completed.
  ///
  /// In zh, this message translates to:
  /// **'已完成'**
  String get completed;

  /// No description provided for @cancelled.
  ///
  /// In zh, this message translates to:
  /// **'已取消'**
  String get cancelled;

  /// No description provided for @unfavorite.
  ///
  /// In zh, this message translates to:
  /// **'取消收藏'**
  String get unfavorite;

  /// No description provided for @remove.
  ///
  /// In zh, this message translates to:
  /// **'移除'**
  String get remove;

  /// No description provided for @onlineService.
  ///
  /// In zh, this message translates to:
  /// **'在线客服'**
  String get onlineService;

  /// No description provided for @onlineServiceTime.
  ///
  /// In zh, this message translates to:
  /// **'服务时间：09:00-21:00'**
  String get onlineServiceTime;

  /// No description provided for @serviceHotline.
  ///
  /// In zh, this message translates to:
  /// **'客服热线'**
  String get serviceHotline;

  /// No description provided for @serviceEmail.
  ///
  /// In zh, this message translates to:
  /// **'客服邮箱'**
  String get serviceEmail;

  /// No description provided for @howCanWeHelp.
  ///
  /// In zh, this message translates to:
  /// **'您好，有什么可以帮您？'**
  String get howCanWeHelp;

  /// No description provided for @serviceResponseHint.
  ///
  /// In zh, this message translates to:
  /// **'专业客服团队将及时为您处理问题'**
  String get serviceResponseHint;

  /// No description provided for @contactRequestSent.
  ///
  /// In zh, this message translates to:
  /// **'客服请求已发起'**
  String get contactRequestSent;

  /// No description provided for @helpAnswer.
  ///
  /// In zh, this message translates to:
  /// **'进入对应功能页面，根据页面提示完成操作。如仍有疑问，请联系在线客服获取帮助。'**
  String get helpAnswer;

  /// No description provided for @feedbackType.
  ///
  /// In zh, this message translates to:
  /// **'反馈类型'**
  String get feedbackType;

  /// No description provided for @featureSuggestion.
  ///
  /// In zh, this message translates to:
  /// **'功能建议'**
  String get featureSuggestion;

  /// No description provided for @problemReport.
  ///
  /// In zh, this message translates to:
  /// **'问题反馈'**
  String get problemReport;

  /// No description provided for @other.
  ///
  /// In zh, this message translates to:
  /// **'其他'**
  String get other;

  /// No description provided for @feedbackHint.
  ///
  /// In zh, this message translates to:
  /// **'请详细描述您的建议或遇到的问题'**
  String get feedbackHint;

  /// No description provided for @contactInformation.
  ///
  /// In zh, this message translates to:
  /// **'联系方式'**
  String get contactInformation;

  /// No description provided for @submitFeedback.
  ///
  /// In zh, this message translates to:
  /// **'提交反馈'**
  String get submitFeedback;

  /// No description provided for @feedbackSubmitted.
  ///
  /// In zh, this message translates to:
  /// **'反馈提交成功，感谢您的建议'**
  String get feedbackSubmitted;

  /// No description provided for @feedbackRequired.
  ///
  /// In zh, this message translates to:
  /// **'请填写反馈内容'**
  String get feedbackRequired;

  /// No description provided for @helpCertificationQuestion.
  ///
  /// In zh, this message translates to:
  /// **'如何完成校友认证？'**
  String get helpCertificationQuestion;

  /// No description provided for @helpBenefitsQuestion.
  ///
  /// In zh, this message translates to:
  /// **'如何使用会员优惠？'**
  String get helpBenefitsQuestion;

  /// No description provided for @helpActivityQuestion.
  ///
  /// In zh, this message translates to:
  /// **'活动报名后如何取消？'**
  String get helpActivityQuestion;

  /// No description provided for @helpOpportunityQuestion.
  ///
  /// In zh, this message translates to:
  /// **'如何发布和管理商机？'**
  String get helpOpportunityQuestion;

  /// No description provided for @helpServiceQuestion.
  ///
  /// In zh, this message translates to:
  /// **'如何联系平台客服？'**
  String get helpServiceQuestion;

  /// No description provided for @emailPasswordLogin.
  ///
  /// In zh, this message translates to:
  /// **'密码登录'**
  String get emailPasswordLogin;

  /// No description provided for @emailCodeRegister.
  ///
  /// In zh, this message translates to:
  /// **'验证码注册'**
  String get emailCodeRegister;

  /// No description provided for @emailPlaceholder.
  ///
  /// In zh, this message translates to:
  /// **'请输入邮件地址'**
  String get emailPlaceholder;

  /// No description provided for @passwordPlaceholder.
  ///
  /// In zh, this message translates to:
  /// **'请输入登录密码'**
  String get passwordPlaceholder;

  /// No description provided for @setPasswordPlaceholder.
  ///
  /// In zh, this message translates to:
  /// **'请设置登录密码'**
  String get setPasswordPlaceholder;

  /// No description provided for @emailCodePlaceholder.
  ///
  /// In zh, this message translates to:
  /// **'请输入邮件验证码'**
  String get emailCodePlaceholder;

  /// No description provided for @getVerificationCode.
  ///
  /// In zh, this message translates to:
  /// **'获取验证码'**
  String get getVerificationCode;

  /// No description provided for @loginButton.
  ///
  /// In zh, this message translates to:
  /// **'登录'**
  String get loginButton;

  /// No description provided for @registerButton.
  ///
  /// In zh, this message translates to:
  /// **'注册'**
  String get registerButton;

  /// No description provided for @registerEmailHint.
  ///
  /// In zh, this message translates to:
  /// **'注册使用邮箱验证码完成验证'**
  String get registerEmailHint;

  /// No description provided for @emailPasswordLoginHint.
  ///
  /// In zh, this message translates to:
  /// **'使用邮箱和密码登录账号'**
  String get emailPasswordLoginHint;

  /// No description provided for @agreementPrefix.
  ///
  /// In zh, this message translates to:
  /// **'我已阅读并同意 '**
  String get agreementPrefix;

  /// No description provided for @userAgreement.
  ///
  /// In zh, this message translates to:
  /// **'《用户协议》'**
  String get userAgreement;

  /// No description provided for @and.
  ///
  /// In zh, this message translates to:
  /// **' 和 '**
  String get and;

  /// No description provided for @privacyPolicy.
  ///
  /// In zh, this message translates to:
  /// **'《隐私政策》'**
  String get privacyPolicy;

  /// No description provided for @thirdPartyLogin.
  ///
  /// In zh, this message translates to:
  /// **'或使用第三方登录'**
  String get thirdPartyLogin;

  /// No description provided for @wechat.
  ///
  /// In zh, this message translates to:
  /// **'微信'**
  String get wechat;

  /// No description provided for @backHome.
  ///
  /// In zh, this message translates to:
  /// **'返回首页'**
  String get backHome;

  /// No description provided for @invalidEmailMessage.
  ///
  /// In zh, this message translates to:
  /// **'请输入有效的邮件地址'**
  String get invalidEmailMessage;

  /// No description provided for @passwordRequiredMessage.
  ///
  /// In zh, this message translates to:
  /// **'请输入至少 6 位密码'**
  String get passwordRequiredMessage;

  /// No description provided for @codeRequiredMessage.
  ///
  /// In zh, this message translates to:
  /// **'请输入邮件验证码'**
  String get codeRequiredMessage;

  /// No description provided for @agreementRequiredMessage.
  ///
  /// In zh, this message translates to:
  /// **'请先阅读并同意用户协议和隐私政策'**
  String get agreementRequiredMessage;

  /// No description provided for @invalidLoginMessage.
  ///
  /// In zh, this message translates to:
  /// **'邮箱或密码不正确'**
  String get invalidLoginMessage;

  /// No description provided for @notLoggedIn.
  ///
  /// In zh, this message translates to:
  /// **'未登录'**
  String get notLoggedIn;

  /// No description provided for @loginToViewProfileHint.
  ///
  /// In zh, this message translates to:
  /// **'登录后可查看会员卡、消费记录、收藏商家和专属权益。'**
  String get loginToViewProfileHint;

  /// No description provided for @goLoginRegister.
  ///
  /// In zh, this message translates to:
  /// **'登录 / 注册'**
  String get goLoginRegister;

  /// No description provided for @afterLoginAvailable.
  ///
  /// In zh, this message translates to:
  /// **'登录后可使用'**
  String get afterLoginAvailable;

  /// No description provided for @merchantProfileName.
  ///
  /// In zh, this message translates to:
  /// **'华创科技有限公司'**
  String get merchantProfileName;

  /// No description provided for @verifiedMerchant.
  ///
  /// In zh, this message translates to:
  /// **'已认证商家'**
  String get verifiedMerchant;

  /// No description provided for @merchantMemberCard.
  ///
  /// In zh, this message translates to:
  /// **'商家会员卡'**
  String get merchantMemberCard;

  /// No description provided for @merchantExclusiveBenefits.
  ///
  /// In zh, this message translates to:
  /// **'校友商家身份 · 尊享专属权益'**
  String get merchantExclusiveBenefits;

  /// No description provided for @viewBenefits.
  ///
  /// In zh, this message translates to:
  /// **'查看权益'**
  String get viewBenefits;

  /// No description provided for @revenueRecords.
  ///
  /// In zh, this message translates to:
  /// **'收益记录'**
  String get revenueRecords;

  /// No description provided for @publishRecords.
  ///
  /// In zh, this message translates to:
  /// **'发布记录'**
  String get publishRecords;

  /// No description provided for @merchantInfo.
  ///
  /// In zh, this message translates to:
  /// **'商家资料'**
  String get merchantInfo;

  /// No description provided for @productServiceManagement.
  ///
  /// In zh, this message translates to:
  /// **'商品/服务管理'**
  String get productServiceManagement;

  /// No description provided for @orderManagement.
  ///
  /// In zh, this message translates to:
  /// **'订单管理'**
  String get orderManagement;

  /// No description provided for @couponManage.
  ///
  /// In zh, this message translates to:
  /// **'优惠券管理'**
  String get couponManage;

  /// No description provided for @opportunityManagement.
  ///
  /// In zh, this message translates to:
  /// **'商机管理'**
  String get opportunityManagement;

  /// No description provided for @dataStatistics.
  ///
  /// In zh, this message translates to:
  /// **'数据统计'**
  String get dataStatistics;

  /// No description provided for @businessOverview.
  ///
  /// In zh, this message translates to:
  /// **'经营概览'**
  String get businessOverview;

  /// No description provided for @todayVerificationCount.
  ///
  /// In zh, this message translates to:
  /// **'今日核销次数'**
  String get todayVerificationCount;

  /// No description provided for @todayConsumptionAmount.
  ///
  /// In zh, this message translates to:
  /// **'今日消费金额(元)'**
  String get todayConsumptionAmount;

  /// No description provided for @monthlyGmv.
  ///
  /// In zh, this message translates to:
  /// **'本月GMV(元)'**
  String get monthlyGmv;

  /// No description provided for @monthlyDiscountAmount.
  ///
  /// In zh, this message translates to:
  /// **'本月优惠金额(元)'**
  String get monthlyDiscountAmount;

  /// No description provided for @pendingItems.
  ///
  /// In zh, this message translates to:
  /// **'待处理事项'**
  String get pendingItems;

  /// No description provided for @pendingVerificationConfirm.
  ///
  /// In zh, this message translates to:
  /// **'待确认核销'**
  String get pendingVerificationConfirm;

  /// No description provided for @abnormalVerification.
  ///
  /// In zh, this message translates to:
  /// **'异常核销'**
  String get abnormalVerification;

  /// No description provided for @couponReview.
  ///
  /// In zh, this message translates to:
  /// **'优惠审核'**
  String get couponReview;

  /// No description provided for @unreadMessages.
  ///
  /// In zh, this message translates to:
  /// **'未读消息'**
  String get unreadMessages;

  /// No description provided for @selectCategory.
  ///
  /// In zh, this message translates to:
  /// **'选择分类'**
  String get selectCategory;

  /// No description provided for @forgotPassword.
  ///
  /// In zh, this message translates to:
  /// **'忘记密码'**
  String get forgotPassword;

  /// No description provided for @retrievePasswordByEmail.
  ///
  /// In zh, this message translates to:
  /// **'通过邮箱找回密码'**
  String get retrievePasswordByEmail;

  /// No description provided for @retrievePasswordDesc.
  ///
  /// In zh, this message translates to:
  /// **'请输入您的邮箱地址，我们将发送验证码到该邮箱，验证通过后您可以重置密码。'**
  String get retrievePasswordDesc;

  /// No description provided for @emailAddress.
  ///
  /// In zh, this message translates to:
  /// **'邮箱地址'**
  String get emailAddress;

  /// No description provided for @verificationCode.
  ///
  /// In zh, this message translates to:
  /// **'验证码'**
  String get verificationCode;

  /// No description provided for @codePlaceholder.
  ///
  /// In zh, this message translates to:
  /// **'请输入验证码'**
  String get codePlaceholder;

  /// No description provided for @newPassword.
  ///
  /// In zh, this message translates to:
  /// **'新密码'**
  String get newPassword;

  /// No description provided for @newPasswordPlaceholder.
  ///
  /// In zh, this message translates to:
  /// **'请输入新密码'**
  String get newPasswordPlaceholder;

  /// No description provided for @confirmNewPassword.
  ///
  /// In zh, this message translates to:
  /// **'确认新密码'**
  String get confirmNewPassword;

  /// No description provided for @confirmNewPasswordPlaceholder.
  ///
  /// In zh, this message translates to:
  /// **'请再次输入新密码'**
  String get confirmNewPasswordPlaceholder;

  /// No description provided for @passwordRuleHint.
  ///
  /// In zh, this message translates to:
  /// **'密码必须是 8-18 位，且同时包含数字、字母'**
  String get passwordRuleHint;

  /// No description provided for @passwordRequirements.
  ///
  /// In zh, this message translates to:
  /// **'密码要求\n• 8-18 位字符\n• 同时包含数字、字母\n• 区分大小写'**
  String get passwordRequirements;

  /// No description provided for @passwordRuleMessage.
  ///
  /// In zh, this message translates to:
  /// **'请输入 8-18 位且包含数字、字母的密码'**
  String get passwordRuleMessage;

  /// No description provided for @passwordNotMatch.
  ///
  /// In zh, this message translates to:
  /// **'两次输入的密码不一致'**
  String get passwordNotMatch;

  /// No description provided for @passwordResetSuccess.
  ///
  /// In zh, this message translates to:
  /// **'密码重置成功'**
  String get passwordResetSuccess;

  /// No description provided for @resetPassword.
  ///
  /// In zh, this message translates to:
  /// **'重置密码'**
  String get resetPassword;

  /// No description provided for @backToLogin.
  ///
  /// In zh, this message translates to:
  /// **'返回登录'**
  String get backToLogin;

  /// No description provided for @bindEmail.
  ///
  /// In zh, this message translates to:
  /// **'绑定邮箱'**
  String get bindEmail;

  /// No description provided for @setPassword.
  ///
  /// In zh, this message translates to:
  /// **'设置密码'**
  String get setPassword;

  /// No description provided for @completeBinding.
  ///
  /// In zh, this message translates to:
  /// **'完成绑定'**
  String get completeBinding;

  /// No description provided for @wechatLogin.
  ///
  /// In zh, this message translates to:
  /// **'微信登录'**
  String get wechatLogin;

  /// No description provided for @authorizedLogin.
  ///
  /// In zh, this message translates to:
  /// **'已授权登录'**
  String get authorizedLogin;

  /// No description provided for @loggedIn.
  ///
  /// In zh, this message translates to:
  /// **'已登录'**
  String get loggedIn;

  /// No description provided for @bindEmailDesc.
  ///
  /// In zh, this message translates to:
  /// **'绑定邮箱可用于找回密码、接收重要通知等'**
  String get bindEmailDesc;

  /// No description provided for @setPasswordDesc.
  ///
  /// In zh, this message translates to:
  /// **'请设置登录密码，后续可直接使用邮箱密码登录'**
  String get setPasswordDesc;

  /// No description provided for @finishBinding.
  ///
  /// In zh, this message translates to:
  /// **'完成绑定'**
  String get finishBinding;

  /// No description provided for @nextStep.
  ///
  /// In zh, this message translates to:
  /// **'下一步'**
  String get nextStep;

  /// No description provided for @otherLoginMethods.
  ///
  /// In zh, this message translates to:
  /// **'或使用其他方式登录'**
  String get otherLoginMethods;

  /// No description provided for @accountBindSuccess.
  ///
  /// In zh, this message translates to:
  /// **'账号绑定成功'**
  String get accountBindSuccess;

  /// No description provided for @changePassword.
  ///
  /// In zh, this message translates to:
  /// **'修改密码'**
  String get changePassword;

  /// No description provided for @changePasswordDesc.
  ///
  /// In zh, this message translates to:
  /// **'定期修改密码，保护账号安全'**
  String get changePasswordDesc;

  /// No description provided for @aboutUs.
  ///
  /// In zh, this message translates to:
  /// **'关于我们'**
  String get aboutUs;

  /// No description provided for @aboutUsDesc.
  ///
  /// In zh, this message translates to:
  /// **'了解平台信息与联系方式'**
  String get aboutUsDesc;

  /// No description provided for @relatedAgreements.
  ///
  /// In zh, this message translates to:
  /// **'相关协议'**
  String get relatedAgreements;

  /// No description provided for @relatedAgreementsDesc.
  ///
  /// In zh, this message translates to:
  /// **'用户协议与隐私政策'**
  String get relatedAgreementsDesc;

  /// No description provided for @personalInfo.
  ///
  /// In zh, this message translates to:
  /// **'个人信息'**
  String get personalInfo;

  /// No description provided for @personalInfoTip.
  ///
  /// In zh, this message translates to:
  /// **'完善个人信息有助于校友之间的联系和交流\n真实的信息将获得更好的服务体验'**
  String get personalInfoTip;

  /// No description provided for @avatar.
  ///
  /// In zh, this message translates to:
  /// **'头像'**
  String get avatar;

  /// No description provided for @nickname.
  ///
  /// In zh, this message translates to:
  /// **'昵称'**
  String get nickname;

  /// No description provided for @contactMethod.
  ///
  /// In zh, this message translates to:
  /// **'联系方式'**
  String get contactMethod;

  /// No description provided for @birthday.
  ///
  /// In zh, this message translates to:
  /// **'生日'**
  String get birthday;

  /// No description provided for @region.
  ///
  /// In zh, this message translates to:
  /// **'所在地区'**
  String get region;

  /// No description provided for @registerTime.
  ///
  /// In zh, this message translates to:
  /// **'注册时间'**
  String get registerTime;

  /// No description provided for @accountRole.
  ///
  /// In zh, this message translates to:
  /// **'账号身份'**
  String get accountRole;

  /// No description provided for @save.
  ///
  /// In zh, this message translates to:
  /// **'保存'**
  String get save;

  /// No description provided for @savedSuccessfully.
  ///
  /// In zh, this message translates to:
  /// **'保存成功'**
  String get savedSuccessfully;

  /// No description provided for @campus.
  ///
  /// In zh, this message translates to:
  /// **'校园'**
  String get campus;

  /// No description provided for @merchant.
  ///
  /// In zh, this message translates to:
  /// **'商家'**
  String get merchant;

  /// No description provided for @myOrders.
  ///
  /// In zh, this message translates to:
  /// **'我的订单'**
  String get myOrders;

  /// No description provided for @activityManagement.
  ///
  /// In zh, this message translates to:
  /// **'活动管理'**
  String get activityManagement;

  /// No description provided for @myCoupons.
  ///
  /// In zh, this message translates to:
  /// **'我的优惠券'**
  String get myCoupons;

  /// No description provided for @myMerchant.
  ///
  /// In zh, this message translates to:
  /// **'我的商户'**
  String get myMerchant;

  /// No description provided for @myMerchantDesc.
  ///
  /// In zh, this message translates to:
  /// **'管理我的所有商户信息与经营数据'**
  String get myMerchantDesc;

  /// No description provided for @viewMerchant.
  ///
  /// In zh, this message translates to:
  /// **'查看商户'**
  String get viewMerchant;

  /// No description provided for @entryRecords.
  ///
  /// In zh, this message translates to:
  /// **'入单记录'**
  String get entryRecords;

  /// No description provided for @onboardingGuide.
  ///
  /// In zh, this message translates to:
  /// **'入驻指南'**
  String get onboardingGuide;

  /// No description provided for @fillStoreInfo.
  ///
  /// In zh, this message translates to:
  /// **'请填写店铺信息'**
  String get fillStoreInfo;

  /// No description provided for @fillStoreInfoDesc.
  ///
  /// In zh, this message translates to:
  /// **'请如实填写以下信息，提交后将由平台进行审核'**
  String get fillStoreInfoDesc;

  /// No description provided for @informationSecurity.
  ///
  /// In zh, this message translates to:
  /// **'信息安全保障'**
  String get informationSecurity;

  /// No description provided for @storeInformation.
  ///
  /// In zh, this message translates to:
  /// **'店铺信息'**
  String get storeInformation;

  /// No description provided for @storeNameRequired.
  ///
  /// In zh, this message translates to:
  /// **'店铺名称 *'**
  String get storeNameRequired;

  /// No description provided for @storeNameHint.
  ///
  /// In zh, this message translates to:
  /// **'请输入与营业执照一致的店铺名称'**
  String get storeNameHint;

  /// No description provided for @industryRequired.
  ///
  /// In zh, this message translates to:
  /// **'所属行业 *'**
  String get industryRequired;

  /// No description provided for @chooseIndustry.
  ///
  /// In zh, this message translates to:
  /// **'请选择所属行业'**
  String get chooseIndustry;

  /// No description provided for @chooseProvince.
  ///
  /// In zh, this message translates to:
  /// **'请选择省'**
  String get chooseProvince;

  /// No description provided for @chooseCity.
  ///
  /// In zh, this message translates to:
  /// **'请选择市'**
  String get chooseCity;

  /// No description provided for @chooseDistrict.
  ///
  /// In zh, this message translates to:
  /// **'请选择区'**
  String get chooseDistrict;

  /// No description provided for @selectRegion.
  ///
  /// In zh, this message translates to:
  /// **'选择省市区'**
  String get selectRegion;

  /// No description provided for @detailAddressRequired.
  ///
  /// In zh, this message translates to:
  /// **'详细地址 *'**
  String get detailAddressRequired;

  /// No description provided for @detailAddressHint.
  ///
  /// In zh, this message translates to:
  /// **'请输入门牌号、楼层、房间号等详细信息'**
  String get detailAddressHint;

  /// No description provided for @postalCode.
  ///
  /// In zh, this message translates to:
  /// **'邮政编码'**
  String get postalCode;

  /// No description provided for @postalCodeRequired.
  ///
  /// In zh, this message translates to:
  /// **'邮政编码 *'**
  String get postalCodeRequired;

  /// No description provided for @postalCodeHint.
  ///
  /// In zh, this message translates to:
  /// **'请输入邮政编码'**
  String get postalCodeHint;

  /// No description provided for @businessStartTime.
  ///
  /// In zh, this message translates to:
  /// **'营业开始时间'**
  String get businessStartTime;

  /// No description provided for @businessEndTime.
  ///
  /// In zh, this message translates to:
  /// **'营业结束时间'**
  String get businessEndTime;

  /// No description provided for @businessHoursRequired.
  ///
  /// In zh, this message translates to:
  /// **'营业时间 *'**
  String get businessHoursRequired;

  /// No description provided for @startTime.
  ///
  /// In zh, this message translates to:
  /// **'开始时间'**
  String get startTime;

  /// No description provided for @endTime.
  ///
  /// In zh, this message translates to:
  /// **'结束时间'**
  String get endTime;

  /// No description provided for @to.
  ///
  /// In zh, this message translates to:
  /// **'至'**
  String get to;

  /// No description provided for @operationAddressRequired.
  ///
  /// In zh, this message translates to:
  /// **'经营地址 *'**
  String get operationAddressRequired;

  /// No description provided for @merchantSecurityGuarantee.
  ///
  /// In zh, this message translates to:
  /// **'保障商户信息安全'**
  String get merchantSecurityGuarantee;

  /// No description provided for @merchantPhotosRequired.
  ///
  /// In zh, this message translates to:
  /// **'商户照片 *'**
  String get merchantPhotosRequired;

  /// No description provided for @storefrontPhoto.
  ///
  /// In zh, this message translates to:
  /// **'门店门头照'**
  String get storefrontPhoto;

  /// No description provided for @uploadStorefrontPhoto.
  ///
  /// In zh, this message translates to:
  /// **'上传门店门头照'**
  String get uploadStorefrontPhoto;

  /// No description provided for @storeInteriorPhoto.
  ///
  /// In zh, this message translates to:
  /// **'店内环境照'**
  String get storeInteriorPhoto;

  /// No description provided for @storeInteriorPhotos.
  ///
  /// In zh, this message translates to:
  /// **'店内环境照'**
  String get storeInteriorPhotos;

  /// No description provided for @addInteriorPhoto.
  ///
  /// In zh, this message translates to:
  /// **'添加图片'**
  String get addInteriorPhoto;

  /// No description provided for @businessScenePhoto.
  ///
  /// In zh, this message translates to:
  /// **'经营场所照'**
  String get businessScenePhoto;

  /// No description provided for @otherSupplementPhoto.
  ///
  /// In zh, this message translates to:
  /// **'其他补充照'**
  String get otherSupplementPhoto;

  /// No description provided for @photoUploadHint.
  ///
  /// In zh, this message translates to:
  /// **'请上传真实清晰的照片，最多6张，支持JPG/PNG，大小不超过10MB'**
  String get photoUploadHint;

  /// No description provided for @interiorPhotoUploadHint.
  ///
  /// In zh, this message translates to:
  /// **'门店门头照需上传1张，店内环境照最多9张，支持JPG/PNG，大小不超过10MB'**
  String get interiorPhotoUploadHint;

  /// No description provided for @uploaded.
  ///
  /// In zh, this message translates to:
  /// **'已上传'**
  String get uploaded;

  /// No description provided for @example.
  ///
  /// In zh, this message translates to:
  /// **'示例'**
  String get example;

  /// No description provided for @contactRequired.
  ///
  /// In zh, this message translates to:
  /// **'联系人 *'**
  String get contactRequired;

  /// No description provided for @contactNameHint.
  ///
  /// In zh, this message translates to:
  /// **'请输入联系人姓名'**
  String get contactNameHint;

  /// No description provided for @phoneRequired.
  ///
  /// In zh, this message translates to:
  /// **'手机号码 *'**
  String get phoneRequired;

  /// No description provided for @phoneHint.
  ///
  /// In zh, this message translates to:
  /// **'请输入手机号码'**
  String get phoneHint;

  /// No description provided for @businessQualifications.
  ///
  /// In zh, this message translates to:
  /// **'营业资质'**
  String get businessQualifications;

  /// No description provided for @optional.
  ///
  /// In zh, this message translates to:
  /// **'非必填'**
  String get optional;

  /// No description provided for @businessLicenseLabel.
  ///
  /// In zh, this message translates to:
  /// **'营业执照'**
  String get businessLicenseLabel;

  /// No description provided for @businessLicense.
  ///
  /// In zh, this message translates to:
  /// **'上传营业执照'**
  String get businessLicense;

  /// No description provided for @otherQualificationLabel.
  ///
  /// In zh, this message translates to:
  /// **'其他资质\n（非必填）'**
  String get otherQualificationLabel;

  /// No description provided for @otherQualification.
  ///
  /// In zh, this message translates to:
  /// **'上传其他资质（如食品经营许可证等）'**
  String get otherQualification;

  /// No description provided for @qualificationSupplementTip.
  ///
  /// In zh, this message translates to:
  /// **'  如暂未准备好，可先提交，后续在店铺管理中补充'**
  String get qualificationSupplementTip;

  /// No description provided for @uploadFormatHint.
  ///
  /// In zh, this message translates to:
  /// **'支持JPG/PNG格式，大小不超过10MB'**
  String get uploadFormatHint;

  /// No description provided for @merchantOnboardingAgreement.
  ///
  /// In zh, this message translates to:
  /// **'《商户入驻协议》'**
  String get merchantOnboardingAgreement;

  /// No description provided for @agreementPreviewContent.
  ///
  /// In zh, this message translates to:
  /// **'当前为协议预览内容，正式协议页面接入后可在这里打开完整内容。'**
  String get agreementPreviewContent;

  /// No description provided for @completeMerchantOnboardingForm.
  ///
  /// In zh, this message translates to:
  /// **'请填写完整的必填信息'**
  String get completeMerchantOnboardingForm;

  /// No description provided for @uploadMerchantPhotoRequired.
  ///
  /// In zh, this message translates to:
  /// **'请至少上传一张商户照片'**
  String get uploadMerchantPhotoRequired;

  /// No description provided for @merchantOnboardingSubmitted.
  ///
  /// In zh, this message translates to:
  /// **'商户入驻资料已提交'**
  String get merchantOnboardingSubmitted;

  /// No description provided for @allOrders.
  ///
  /// In zh, this message translates to:
  /// **'全部订单'**
  String get allOrders;

  /// No description provided for @pendingUse.
  ///
  /// In zh, this message translates to:
  /// **'待使用'**
  String get pendingUse;

  /// No description provided for @used.
  ///
  /// In zh, this message translates to:
  /// **'已使用'**
  String get used;

  /// No description provided for @orderNo.
  ///
  /// In zh, this message translates to:
  /// **'订单号'**
  String get orderNo;

  /// No description provided for @useDate.
  ///
  /// In zh, this message translates to:
  /// **'使用日期'**
  String get useDate;

  /// No description provided for @memberOffer.
  ///
  /// In zh, this message translates to:
  /// **'会员优惠'**
  String get memberOffer;

  /// No description provided for @totalCountPrefix.
  ///
  /// In zh, this message translates to:
  /// **'共'**
  String get totalCountPrefix;

  /// No description provided for @portion.
  ///
  /// In zh, this message translates to:
  /// **'份'**
  String get portion;

  /// No description provided for @cancelReservation.
  ///
  /// In zh, this message translates to:
  /// **'取消预约'**
  String get cancelReservation;

  /// No description provided for @viewDetail.
  ///
  /// In zh, this message translates to:
  /// **'查看详情'**
  String get viewDetail;

  /// No description provided for @orderDetail.
  ///
  /// In zh, this message translates to:
  /// **'订单详情'**
  String get orderDetail;

  /// No description provided for @copy.
  ///
  /// In zh, this message translates to:
  /// **'复制'**
  String get copy;

  /// No description provided for @orderInfo.
  ///
  /// In zh, this message translates to:
  /// **'订单信息'**
  String get orderInfo;

  /// No description provided for @orderStatus.
  ///
  /// In zh, this message translates to:
  /// **'订单状态'**
  String get orderStatus;

  /// No description provided for @orderCreateTime.
  ///
  /// In zh, this message translates to:
  /// **'下单时间'**
  String get orderCreateTime;

  /// No description provided for @packageName.
  ///
  /// In zh, this message translates to:
  /// **'套餐名称'**
  String get packageName;

  /// No description provided for @packageContent.
  ///
  /// In zh, this message translates to:
  /// **'套餐内容'**
  String get packageContent;

  /// No description provided for @quantity.
  ///
  /// In zh, this message translates to:
  /// **'数量'**
  String get quantity;

  /// No description provided for @paymentMethod.
  ///
  /// In zh, this message translates to:
  /// **'支付方式'**
  String get paymentMethod;

  /// No description provided for @useInfo.
  ///
  /// In zh, this message translates to:
  /// **'使用信息'**
  String get useInfo;

  /// No description provided for @useTime.
  ///
  /// In zh, this message translates to:
  /// **'使用时间'**
  String get useTime;

  /// No description provided for @useStore.
  ///
  /// In zh, this message translates to:
  /// **'使用门店'**
  String get useStore;

  /// No description provided for @useAddress.
  ///
  /// In zh, this message translates to:
  /// **'使用地址'**
  String get useAddress;

  /// No description provided for @user.
  ///
  /// In zh, this message translates to:
  /// **'使用人'**
  String get user;

  /// No description provided for @contactPhone.
  ///
  /// In zh, this message translates to:
  /// **'联系电话'**
  String get contactPhone;

  /// No description provided for @orderAmountDetail.
  ///
  /// In zh, this message translates to:
  /// **'订单金额明细'**
  String get orderAmountDetail;

  /// No description provided for @productAmount.
  ///
  /// In zh, this message translates to:
  /// **'商品金额'**
  String get productAmount;

  /// No description provided for @memberDiscountAmount.
  ///
  /// In zh, this message translates to:
  /// **'会员优惠'**
  String get memberDiscountAmount;

  /// No description provided for @orderReservedHint.
  ///
  /// In zh, this message translates to:
  /// **'订单已预约成功，请按时使用'**
  String get orderReservedHint;

  /// No description provided for @orderCancelSuccess.
  ///
  /// In zh, this message translates to:
  /// **'预约已取消'**
  String get orderCancelSuccess;

  /// No description provided for @entryRecordSearchHint.
  ///
  /// In zh, this message translates to:
  /// **'搜索会员姓名、手机号、订单号'**
  String get entryRecordSearchHint;

  /// No description provided for @receivable.
  ///
  /// In zh, this message translates to:
  /// **'应收'**
  String get receivable;

  /// No description provided for @todayEntryCount.
  ///
  /// In zh, this message translates to:
  /// **'今日入单'**
  String get todayEntryCount;

  /// No description provided for @receivableTotal.
  ///
  /// In zh, this message translates to:
  /// **'应收合计'**
  String get receivableTotal;

  /// No description provided for @paidTotal.
  ///
  /// In zh, this message translates to:
  /// **'实付合计'**
  String get paidTotal;

  /// No description provided for @recordUnit.
  ///
  /// In zh, this message translates to:
  /// **'笔'**
  String get recordUnit;

  /// No description provided for @searchOpportunityTitle.
  ///
  /// In zh, this message translates to:
  /// **'搜索商机标题'**
  String get searchOpportunityTitle;

  /// No description provided for @listed.
  ///
  /// In zh, this message translates to:
  /// **'上架中'**
  String get listed;

  /// No description provided for @offline.
  ///
  /// In zh, this message translates to:
  /// **'已下架'**
  String get offline;

  /// No description provided for @offlineAction.
  ///
  /// In zh, this message translates to:
  /// **'下架'**
  String get offlineAction;

  /// No description provided for @relist.
  ///
  /// In zh, this message translates to:
  /// **'重新上架'**
  String get relist;

  /// No description provided for @delete.
  ///
  /// In zh, this message translates to:
  /// **'删除'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In zh, this message translates to:
  /// **'编辑'**
  String get edit;

  /// No description provided for @publishTime.
  ///
  /// In zh, this message translates to:
  /// **'发布时间'**
  String get publishTime;

  /// No description provided for @viewsCount.
  ///
  /// In zh, this message translates to:
  /// **'浏览'**
  String get viewsCount;

  /// No description provided for @inquiriesCount.
  ///
  /// In zh, this message translates to:
  /// **'咨询'**
  String get inquiriesCount;

  /// No description provided for @publishActivity.
  ///
  /// In zh, this message translates to:
  /// **'发布活动'**
  String get publishActivity;

  /// No description provided for @searchActivityName.
  ///
  /// In zh, this message translates to:
  /// **'搜索活动名称'**
  String get searchActivityName;

  /// No description provided for @ongoing.
  ///
  /// In zh, this message translates to:
  /// **'进行中'**
  String get ongoing;

  /// No description provided for @createTime.
  ///
  /// In zh, this message translates to:
  /// **'创建时间'**
  String get createTime;

  /// No description provided for @participantCount.
  ///
  /// In zh, this message translates to:
  /// **'报名人数'**
  String get participantCount;

  /// No description provided for @personUnit.
  ///
  /// In zh, this message translates to:
  /// **'人'**
  String get personUnit;

  /// No description provided for @exclusiveIdentity.
  ///
  /// In zh, this message translates to:
  /// **'专属身份'**
  String get exclusiveIdentity;

  /// No description provided for @exclusiveRights.
  ///
  /// In zh, this message translates to:
  /// **'专属权益'**
  String get exclusiveRights;

  /// No description provided for @exclusiveService.
  ///
  /// In zh, this message translates to:
  /// **'专属服务'**
  String get exclusiveService;

  /// No description provided for @realNameHint.
  ///
  /// In zh, this message translates to:
  /// **'请输入真实姓名'**
  String get realNameHint;

  /// No description provided for @chooseGraduatedSchool.
  ///
  /// In zh, this message translates to:
  /// **'请选择毕业院校'**
  String get chooseGraduatedSchool;

  /// No description provided for @chooseCollege.
  ///
  /// In zh, this message translates to:
  /// **'请选择所在学院'**
  String get chooseCollege;

  /// No description provided for @chooseCohort.
  ///
  /// In zh, this message translates to:
  /// **'请选择毕业届别'**
  String get chooseCohort;

  /// No description provided for @majorHint.
  ///
  /// In zh, this message translates to:
  /// **'请输入专业名称'**
  String get majorHint;

  /// No description provided for @proofMaterial.
  ///
  /// In zh, this message translates to:
  /// **'证明材料'**
  String get proofMaterial;

  /// No description provided for @proofMaterialHint.
  ///
  /// In zh, this message translates to:
  /// **'上传学生证 / 毕业证 / 校友证明等（支持图片或PDF）'**
  String get proofMaterialHint;

  /// No description provided for @uploadImagesTitle.
  ///
  /// In zh, this message translates to:
  /// **'上传图片'**
  String get uploadImagesTitle;

  /// No description provided for @uploadAtLeastOne.
  ///
  /// In zh, this message translates to:
  /// **'至少上传一项'**
  String get uploadAtLeastOne;

  /// No description provided for @exampleImage.
  ///
  /// In zh, this message translates to:
  /// **'示例图'**
  String get exampleImage;

  /// No description provided for @warmTip.
  ///
  /// In zh, this message translates to:
  /// **'温馨提示'**
  String get warmTip;

  /// No description provided for @submitCertificationAgreementPrefix.
  ///
  /// In zh, this message translates to:
  /// **'提交即表示同意 '**
  String get submitCertificationAgreementPrefix;

  /// No description provided for @alumniCertificationAgreement.
  ///
  /// In zh, this message translates to:
  /// **'《校友认证服务协议》'**
  String get alumniCertificationAgreement;

  /// No description provided for @certificationInstructionDetail.
  ///
  /// In zh, this message translates to:
  /// **'请填写真实有效的校友信息，并上传清晰可见的学生证、毕业证或校友证明。提交后工作人员会在 1-3 个工作日内完成审核。'**
  String get certificationInstructionDetail;

  /// No description provided for @takePhoto.
  ///
  /// In zh, this message translates to:
  /// **'拍照上传'**
  String get takePhoto;

  /// No description provided for @chooseFromAlbum.
  ///
  /// In zh, this message translates to:
  /// **'从相册选择'**
  String get chooseFromAlbum;

  /// No description provided for @removeUploadedImage.
  ///
  /// In zh, this message translates to:
  /// **'删除已上传图片'**
  String get removeUploadedImage;

  /// No description provided for @sendCodeFailed.
  ///
  /// In zh, this message translates to:
  /// **'验证码发送失败，请稍后再试'**
  String get sendCodeFailed;

  /// No description provided for @bindPhone.
  ///
  /// In zh, this message translates to:
  /// **'绑定手机号'**
  String get bindPhone;

  /// No description provided for @bindPhoneDesc.
  ///
  /// In zh, this message translates to:
  /// **'绑定手机号用于接收重要通知、找回账号和保障账号安全'**
  String get bindPhoneDesc;

  /// No description provided for @phoneCodePlaceholder.
  ///
  /// In zh, this message translates to:
  /// **'请输入手机验证码'**
  String get phoneCodePlaceholder;

  /// No description provided for @invalidPhoneMessage.
  ///
  /// In zh, this message translates to:
  /// **'请输入有效的手机号'**
  String get invalidPhoneMessage;

  /// No description provided for @phoneCodeRequiredMessage.
  ///
  /// In zh, this message translates to:
  /// **'请输入手机验证码'**
  String get phoneCodeRequiredMessage;

  /// No description provided for @phoneBindSuccess.
  ///
  /// In zh, this message translates to:
  /// **'手机号绑定成功'**
  String get phoneBindSuccess;

  /// No description provided for @phoneBindTip.
  ///
  /// In zh, this message translates to:
  /// **'绑定后可直接进入 App'**
  String get phoneBindTip;

  /// No description provided for @accountVerified.
  ///
  /// In zh, this message translates to:
  /// **'账号验证已完成'**
  String get accountVerified;

  /// No description provided for @accountVerifiedDesc.
  ///
  /// In zh, this message translates to:
  /// **'请继续绑定手机号，完善账号安全信息'**
  String get accountVerifiedDesc;

  /// No description provided for @sendCodeSuccess.
  ///
  /// In zh, this message translates to:
  /// **'验证码已发送，请查收邮件'**
  String get sendCodeSuccess;

  /// No description provided for @registerSuccess.
  ///
  /// In zh, this message translates to:
  /// **'注册成功，请使用邮箱和密码登录'**
  String get registerSuccess;

  /// No description provided for @registerFailed.
  ///
  /// In zh, this message translates to:
  /// **'注册失败，请检查验证码或稍后再试'**
  String get registerFailed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
