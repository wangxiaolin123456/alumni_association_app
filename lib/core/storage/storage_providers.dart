import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Centralizes sensitive token storage and non-sensitive app preferences.
class StorageService extends GetxService {
  final secure = const FlutterSecureStorage();
  late final SharedPreferences preferences;

  Future<StorageService> init() async {
    preferences = await SharedPreferences.getInstance();
    return this;
  }
}
