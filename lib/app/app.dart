import 'package:alumni_association_app/app/router/app_router.dart';
import 'package:alumni_association_app/app/theme/app_theme.dart';
import 'package:alumni_association_app/core/localization/locale_controller.dart';
import 'package:alumni_association_app/l10n/generated/app_localizations.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AlumniAssociationApp extends StatelessWidget {
  const AlumniAssociationApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeController = Get.find<LocaleController>();
    final botToastBuilder = BotToastInit();
    final loadingBuilder = EasyLoading.init();

    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => Obx(
        () => GetMaterialApp(
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          theme: AppTheme.light,

          locale: localeController.activeLocale.value,
          fallbackLocale: const Locale('zh'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          // 设置默认初始路由
          initialRoute:  AppPages.INIT_ROUTER,
          // GetX 的路由表配置
          getPages: AppPages.routes,
          builder: (context, routedChild) {
            Widget current = routedChild ?? const SizedBox.shrink();

            // BotToast
            current = botToastBuilder(context, current);

            // EasyLoading
            current = loadingBuilder(context, current);

            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.noScaling),
              child: current,
            );
          },
        ),
      ),
    );
  }
}
