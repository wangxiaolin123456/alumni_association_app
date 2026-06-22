import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// 本地存储工具类（单例）
class InnerStorage {
  InnerStorage._internal();

  static final InnerStorage _instance = InnerStorage._internal();

  factory InnerStorage() => _instance;

  SharedPreferences? _prefs;
  bool _initialized = false;

  bool get isInitialized => _initialized;

  /// 初始化，建议在 main 函数中调用一次。
  Future<void> init() async {
    if (_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    _initialized = true;
  }

  SharedPreferences get _safePrefs {
    assert(_prefs != null, 'InnerStorage not initialized. Call init() first.');
    return _prefs!;
  }

  Future<bool> setString(String key, String value) =>
      _safePrefs.setString(key, value);

  String? getString(String key) => _safePrefs.getString(key);

  Future<bool> setInt(String key, int value) => _safePrefs.setInt(key, value);

  int? getInt(String key) => _safePrefs.getInt(key);

  Future<bool> setBool(String key, bool value) =>
      _safePrefs.setBool(key, value);

  bool? getBool(String key) => _safePrefs.getBool(key);

  Future<bool> setDouble(String key, double value) =>
      _safePrefs.setDouble(key, value);

  double? getDouble(String key) => _safePrefs.getDouble(key);

  Future<bool> setStringList(String key, List<String> value) =>
      _safePrefs.setStringList(key, value);

  List<String>? getStringList(String key) => _safePrefs.getStringList(key);

  Future<bool> setJSON(String key, dynamic jsonValue) =>
      _safePrefs.setString(key, jsonEncode(jsonValue));

  dynamic getJSON(String key) {
    final jsonString = _safePrefs.getString(key);
    return jsonString == null ? null : jsonDecode(jsonString);
  }

  T? getObject<T>(String key, T Function(Map<String, dynamic>) fromMap) {
    final jsonString = _safePrefs.getString(key);
    if (jsonString == null) return null;
    return fromMap(jsonDecode(jsonString) as Map<String, dynamic>);
  }

  Future<bool> remove(String key) => _safePrefs.remove(key);

  Future<bool> clear() => _safePrefs.clear();

  bool containsKey(String key) => _safePrefs.containsKey(key);

  T? get<T>(String key) {
    if (T == String) return getString(key) as T?;
    if (T == int) return getInt(key) as T?;
    if (T == bool) return getBool(key) as T?;
    if (T == double) return getDouble(key) as T?;
    if (T == List<String>) return getStringList(key) as T?;
    return null;
  }
}
