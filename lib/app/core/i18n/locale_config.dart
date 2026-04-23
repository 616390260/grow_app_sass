import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocaleConfig {
  static const List<Locale> supportedLocales = [
    Locale('zh', 'CN'),
    Locale('en', 'US'),
    Locale('id', 'ID'),
    Locale('bn', 'BD'),
    Locale('pt', 'BR'),
    Locale('hi', 'IN'),
    Locale('es', 'MX'),
    Locale('es', 'ES'),
  ];

  static const Locale fallbackLocale = Locale('en', 'US');
  static const Locale defaultLocale = Locale('en', 'US');

  static const String _storageKey = 'app_locale';
  static final GetStorage _box = GetStorage();

  /// 当前应用语言（全局广播），业务 Controller 可通过 `ever` 监听变化并重新请求接口。
  ///
  /// 使用：
  /// ```dart
  /// ever<Locale>(LocaleConfig.currentLocale, (_) => loadData());
  /// ```
  static final Rx<Locale> currentLocale = Rx<Locale>(_readInitialLocale());

  static Locale _readInitialLocale() {
    final saved = _box.read(_storageKey);
    if (saved is String && saved.isNotEmpty) {
      final parts = saved.split('_');
      final languageCode = parts.isNotEmpty ? parts[0] : 'en';
      final countryCode =
          parts.length > 1 && parts[1].isNotEmpty ? parts[1] : null;
      final locale = Locale(languageCode, countryCode);
      if (isSupported(locale)) return locale;
    }
    final device = Get.deviceLocale;
    return device != null && isSupported(device) ? device : defaultLocale;
  }

  static Locale getInitialLocale() => currentLocale.value;

  static Future<void> updateLocale(Locale locale) async {
    if (!isSupported(locale)) return;
    await _box.write(
      _storageKey,
      '${locale.languageCode}_${locale.countryCode ?? ''}',
    );
    Get.updateLocale(locale);
    // 广播语言变更，供业务 Controller 监听重新拉取接口数据。
    currentLocale.value = locale;
  }

  static bool isSupported(Locale locale) {
    return supportedLocales.any((l) => l.languageCode == locale.languageCode && l.countryCode == locale.countryCode);
  }
}