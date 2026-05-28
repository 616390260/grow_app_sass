import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/base/base_view.dart';
import '../../../core/i18n/i18n_keys.dart';
import '../controllers/language_settings_controller.dart';

class LanguageSettingsView extends BaseView<LanguageSettingsController> {
  const LanguageSettingsView({Key? key}) : super(key: key);

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(I18nKeys.languageSettings.tr,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      centerTitle: true,
      leading: const BackButton(),
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
    );
  }

  @override
  Color? get backgroundColor => Colors.white;

  @override
  Widget buildContent(BuildContext context) {
    return ListView.separated(
      itemCount: controller.options.length,
      separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFEDEDED)),
      itemBuilder: (context, index) {
        final opt = controller.options[index];
        return InkWell(
          onTap: () => controller.select(opt.locale),
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    opt.label,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                ),
                // 只在需要响应式更新的图标部分使用Obx
                Obx(() {
                  final selectedLocale = controller.selected.value;
                  final selected = selectedLocale.languageCode == opt.locale.languageCode && 
                                  selectedLocale.countryCode == opt.locale.countryCode;
                  return selected
                      ? const Icon(Icons.check_circle, color: Color(0xFF0B65FF), size: 20)
                      : const SizedBox.shrink();
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}