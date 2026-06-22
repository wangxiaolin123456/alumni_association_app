import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Stores and applies the app language independently from the login session.
///
/// [activeLocale] is always a supported locale. When following the system, it
/// contains a normalized version of the device locale so the whole route stack
/// can rebuild consistently instead of relying on a nullable locale.
class LocaleController extends GetxController with WidgetsBindingObserver {
  static const _localeKey = 'selected_locale';
  static const _systemValue = 'system';
  static const supportedLanguageCodes = {'zh', 'en', 'ja'};

  final activeLocale = _normalizedSystemLocale.obs;
  final followsSystem = true.obs;
  final isReady = false.obs;

  static Locale get _normalizedSystemLocale {
    final systemLocale = ui.PlatformDispatcher.instance.locale;
    return supportedLanguageCodes.contains(systemLocale.languageCode)
        ? Locale(systemLocale.languageCode)
        : const Locale('zh');
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    restore();
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    if (followsSystem.value) _applyLocale(_normalizedSystemLocale);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  Future<void> restore() async {
    final preferences = await SharedPreferences.getInstance();
    final saved = preferences.getString(_localeKey);

    if (saved == null || saved == _systemValue) {
      followsSystem.value = true;
      _applyLocale(_normalizedSystemLocale);
    } else {
      followsSystem.value = false;
      _applyLocale(_normalize(Locale(saved)));
    }
    isReady.value = true;
  }

  /// Enables automatic device-language selection.
  Future<void> followSystem() async {
    followsSystem.value = true;
    _applyLocale(_normalizedSystemLocale);

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_localeKey, _systemValue);
  }

  /// Disables system following while keeping the currently visible language.
  Future<void> stopFollowingSystem() async {
    followsSystem.value = false;

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_localeKey, activeLocale.value.languageCode);
  }

  Future<void> select(Locale selectedLocale) async {
    followsSystem.value = false;
    final normalizedLocale = _normalize(selectedLocale);
    _applyLocale(normalizedLocale);

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_localeKey, normalizedLocale.languageCode);
  }

  void _applyLocale(Locale locale) {
    activeLocale.value = locale;
  }

  Locale _normalize(Locale locale) {
    return supportedLanguageCodes.contains(locale.languageCode)
        ? Locale(locale.languageCode)
        : const Locale('zh');
  }
}
