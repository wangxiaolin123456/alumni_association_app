import 'package:alumni_association_app/core/localization/locale_controller.dart';
import 'package:alumni_association_app/core/network/core/http_manager.dart';
import 'package:alumni_association_app/core/storage/storage_providers.dart';
import 'package:alumni_association_app/features/activity/presentation/activity_controller.dart';
import 'package:alumni_association_app/features/auth/domain/session_controller.dart';
import 'package:alumni_association_app/features/auth/presentation/login_controller.dart';
import 'package:alumni_association_app/features/consumption/presentation/consumption_entry_controller.dart';
import 'package:alumni_association_app/features/member/benefits/presentation/merchant_benefits_controller.dart';
import 'package:alumni_association_app/features/member/certification/presentation/certification_controller.dart';
import 'package:alumni_association_app/features/member/consumption_records/presentation/consumption_records_controller.dart';
import 'package:alumni_association_app/features/member/member_card/presentation/member_card_controller.dart';
import 'package:alumni_association_app/features/member/messages/presentation/member_messages_controller.dart';
import 'package:alumni_association_app/features/member/presentation/member_home_controller.dart';
import 'package:alumni_association_app/features/member/record_center/presentation/member_record_center_controller.dart';
import 'package:alumni_association_app/features/opportunity/presentation/opportunity_controller.dart';
import 'package:alumni_association_app/features/store/presentation/store_controller.dart';
import 'package:alumni_association_app/features/profile/services/presentation/profile_services_controller.dart';
import 'package:alumni_association_app/storage/inner_storage.dart';
import 'package:get/get.dart';

class AppBinding {
  static Future<void> init() async {
    // HttpManager 会从 InnerStorage 读取 token，必须在业务 Controller 请求前初始化。
    await InnerStorage().init();
    await Get.putAsync(() => StorageService().init(), permanent: true);

    // 网络服务需要先于业务 Controller 注册，方便 Controller 初始化时请求接口。
    Get.put(HttpManager(), permanent: true);
    final session = Get.put(SessionController(), permanent: true);
    Get.put(LocaleController(), permanent: true);
    Get.put(LoginController(session), permanent: true);
    Get.put(MemberHomeController(), permanent: true);
    Get.put(StoreController(), permanent: true);
    Get.put(ActivityController(), permanent: true);
    Get.put(OpportunityController(), permanent: true);
    Get.put(ConsumptionEntryController(), permanent: true);
    Get.put(ConsumptionRecordsController(), permanent: true);
    Get.put(MemberMessagesController(), permanent: true);
    Get.put(MerchantBenefitsController(), permanent: true);
    Get.put(CertificationController(), permanent: true);
    Get.put(MemberCardController(), permanent: true);
    Get.put(MemberRecordCenterController(), permanent: true);
    Get.put(ProfileServicesController(), permanent: true);
  }
}
