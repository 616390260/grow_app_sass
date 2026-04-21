import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/i18n/locale_config.dart';

class LanguageOption {
  final String label;
  final Locale locale;
  const LanguageOption({required this.label, required this.locale});
}

class LanguageSettingsController extends BaseController {
  final Rx<Locale> selected =
      (Get.locale ?? LocaleConfig.getInitialLocale()).obs;

  final List<LanguageOption> options = const [
    LanguageOption(label: '简体中文', locale: Locale('zh', 'CN')),
    LanguageOption(label: 'English', locale: Locale('en', 'US')),
    LanguageOption(label: 'Indonesia', locale: Locale('id', 'ID')),
    LanguageOption(label: 'Bangladesh', locale: Locale('bn', 'BD')),
    LanguageOption(label: 'Brazil', locale: Locale('pt', 'BR')),
    LanguageOption(label: 'India', locale: Locale('hi', 'IN')),
    LanguageOption(label: 'Mexico', locale: Locale('es', 'MX')),
    LanguageOption(label: 'Spanish', locale: Locale('es', 'ES')),
  ];

  bool isSelected(Locale locale) {
    final s = selected.value;
    return s.languageCode == locale.languageCode &&
        s.countryCode == locale.countryCode;
  }

  Future<void> select(Locale locale) async {
    if (isSelected(locale)) return;
    await LocaleConfig.updateLocale(locale);
    selected.value = locale;
  }
}
