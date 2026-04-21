import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../i18n/i18n_keys.dart';
import '../i18n/locale_config.dart';
import '../theme/app_theme.dart';

/// 语言选项数据。
/// 注意：列表 [kLanguageOptions] 需与 `LanguageSettingsController.options` 保持一致。
class LanguageOption {
  final String label;
  final Locale locale;
  const LanguageOption({required this.label, required this.locale});
}

const List<LanguageOption> kLanguageOptions = <LanguageOption>[
  LanguageOption(label: '简体中文', locale: Locale('zh', 'CN')),
  LanguageOption(label: 'English', locale: Locale('en', 'US')),
  LanguageOption(label: 'Indonesia', locale: Locale('id', 'ID')),
  LanguageOption(label: 'Bangladesh', locale: Locale('bn', 'BD')),
  LanguageOption(label: 'Brazil', locale: Locale('pt', 'BR')),
  LanguageOption(label: 'India', locale: Locale('hi', 'IN')),
  LanguageOption(label: 'Mexico', locale: Locale('es', 'MX')),
  LanguageOption(label: 'Spanish', locale: Locale('es', 'ES')),
];

/// 通用的语言切换胶囊按钮，常用于登录/注册页右上角。
/// 点击后弹出底部抽屉切换语言，整个 App 即时刷新。
class LanguageSwitcherButton extends StatelessWidget {
  const LanguageSwitcherButton({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = Get.locale ?? LocaleConfig.getInitialLocale();
    final currentLabel = kLanguageOptions
        .firstWhere(
          (o) =>
              o.locale.languageCode == currentLocale.languageCode &&
              o.locale.countryCode == currentLocale.countryCode,
          orElse: () => kLanguageOptions.first,
        )
        .label;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => showLanguagePicker(context),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.language, size: 16, color: AppTheme.threeColor),
              const SizedBox(width: 4),
              Text(
                currentLabel,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.threeColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 16,
                color: AppTheme.threeColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 弹出底部语言选择抽屉。
void showLanguagePicker(BuildContext context) {
  final currentLocale = Get.locale ?? LocaleConfig.getInitialLocale();
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      return SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Text(
                I18nKeys.languageSettings.tr,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.threeColor,
                ),
              ),
            ),
            const Divider(height: 1, color: Color(0xFFEDEDED)),
            ...kLanguageOptions.map((opt) {
              final selected =
                  currentLocale.languageCode == opt.locale.languageCode &&
                  currentLocale.countryCode == opt.locale.countryCode;
              return InkWell(
                onTap: () async {
                  Navigator.of(ctx).pop();
                  if (!selected) {
                    await LocaleConfig.updateLocale(opt.locale);
                  }
                },
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          opt.label,
                          style: TextStyle(
                            fontSize: 15,
                            color: selected
                                ? const Color(0xFF0B65FF)
                                : Colors.black87,
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                      if (selected)
                        const Icon(
                          Icons.check_circle,
                          color: Color(0xFF0B65FF),
                          size: 20,
                        ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
}
