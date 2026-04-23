import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../i18n/locale_config.dart';

/// 语言切换组件：胶囊按钮 + 底部弹窗选择
///
/// - 点击按钮弹出 bottom sheet，展示所有支持的语言
/// - 点击某项语言立即切换 App locale 并关闭弹窗
/// - 按钮样式可通过 [foreground] / [background] 自定义，适配深浅背景
class LanguageSwitcher extends StatelessWidget {
  /// 按钮前景色（文字、图标、边框），默认白色（适合深色/渐变背景）
  final Color foreground;

  /// 按钮背景色（半透明胶囊），默认浅白色遮罩
  final Color background;

  /// 是否显示当前语言的文字标签；为 false 时只展示地球图标（更紧凑）
  final bool showLabel;

  const LanguageSwitcher({
    super.key,
    this.foreground = Colors.white,
    this.background = const Color(0x33FFFFFF),
    this.showLabel = true,
  });

  /// 当前语言对应的选项，找不到时回退到英文
  /// 优先从 [Localizations.localeOf] 读取（与 MaterialApp 的实际 locale 同步），
  /// 其次回退到 [Get.locale] 或存储的初始 locale。
  _LangOption _currentOption(BuildContext context) {
    Locale l;
    try {
      l = Localizations.localeOf(context);
    } catch (_) {
      l = Get.locale ?? LocaleConfig.getInitialLocale();
    }
    return _languages.firstWhere(
      (e) =>
          e.locale.languageCode == l.languageCode &&
          e.locale.countryCode == l.countryCode,
      orElse: () => _languages.firstWhere(
        (e) =>
            e.locale.languageCode == l.languageCode &&
            e.locale.countryCode == null,
        orElse: () => _languages.firstWhere(
          (e) => e.locale.languageCode == 'en',
          orElse: () => _languages.first,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cur = _currentOption(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _showSheet(context),
        child: Container(
          height: 34,
          padding: EdgeInsets.symmetric(horizontal: showLabel ? 12 : 8),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: foreground.withValues(alpha: 0.35),
              width: 0.8,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.language_rounded, size: 16, color: foreground),
              if (showLabel) ...[
                const SizedBox(width: 6),
                Text(
                  cur.short,
                  style: TextStyle(
                    color: foreground,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 16,
                  color: foreground,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// 弹出底部语言选择表
  void _showSheet(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    // 通过 Builder 新建 context，从 MaterialApp 当前的 Localizations 里实时读取 locale，
    // 避免 Get.locale 与 UI 实际 locale 不同步导致选中项未高亮
    Get.bottomSheet(
      Builder(
        builder: (sheetCtx) {
          Locale current;
          try {
            current = Localizations.localeOf(sheetCtx);
          } catch (_) {
            current = Get.locale ?? LocaleConfig.getInitialLocale();
          }
          return ConstrainedBox(
            constraints: BoxConstraints(maxHeight: screenH * 0.7),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 4),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5E7EB),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.language_rounded,
                            size: 20,
                            color: Color(0xFF111827),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Language · 语言',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF111827),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: Color(0xFFEDEDED)),
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(bottom: 8),
                        physics: const BouncingScrollPhysics(),
                        itemCount: _languages.length,
                        separatorBuilder: (_, __) =>
                            const Divider(height: 1, color: Color(0xFFF4F4F5)),
                        itemBuilder: (_, i) {
                          final opt = _languages[i];
                          final selected =
                              current.languageCode == opt.locale.languageCode &&
                              current.countryCode == opt.locale.countryCode;
                          return InkWell(
                            onTap: () async {
                              if (!selected) {
                                await LocaleConfig.updateLocale(opt.locale);
                              }
                              if (Get.isBottomSheetOpen ?? false) Get.back();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: selected
                                          ? const Color(0xFFECFDF5)
                                          : const Color(0xFFF3F4F6),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      opt.short,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: selected
                                            ? const Color(0xFF059669)
                                            : const Color(0xFF374151),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Text(
                                      opt.label,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Color(0xFF111827),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  if (selected)
                                    const Icon(
                                      Icons.check_circle,
                                      color: Color(0xFF10B981),
                                      size: 20,
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }
}

/// 单个语言选项
class _LangOption {
  /// 弹窗中显示的完整名称
  final String label;

  /// 按钮和语言图标上显示的简短代码
  final String short;

  /// 对应的 [Locale]
  final Locale locale;

  const _LangOption({
    required this.label,
    required this.short,
    required this.locale,
  });
}

/// 支持的语言清单（与 [LocaleConfig.supportedLocales] 保持一致）
const List<_LangOption> _languages = [
  _LangOption(label: '简体中文', short: '中', locale: Locale('zh', 'CN')),
  _LangOption(label: 'English', short: 'EN', locale: Locale('en', 'US')),
  _LangOption(label: 'Indonesia', short: 'ID', locale: Locale('id', 'ID')),
  _LangOption(label: 'Bangladesh', short: 'BN', locale: Locale('bn', 'BD')),
  _LangOption(label: 'Brasil', short: 'PT', locale: Locale('pt', 'BR')),
  _LangOption(label: 'हिन्दी', short: 'HI', locale: Locale('hi', 'IN')),
  _LangOption(label: 'México', short: 'MX', locale: Locale('es', 'MX')),
  _LangOption(label: 'Spanish', short: 'ES', locale: Locale('es', 'ES')),
];
