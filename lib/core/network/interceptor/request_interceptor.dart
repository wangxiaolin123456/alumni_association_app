import 'package:alumni_association_app/core/localization/locale_controller.dart';
import 'package:alumni_association_app/core/storage/storage_providers.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

/// Adds app-wide authentication and locale headers before each request.
class AppRequestInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (Get.isRegistered<StorageService>()) {
      final token = await Get.find<StorageService>().secure.read(
        key: 'access_token',
      );
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    if (Get.isRegistered<LocaleController>()) {
      options.headers['Accept-Language'] =
          Get.find<LocaleController>().activeLocale.value.languageCode;
    }
    handler.next(options);
  }
}
