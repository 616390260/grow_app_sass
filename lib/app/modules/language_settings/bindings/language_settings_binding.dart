import 'package:get/get.dart';
import '../controllers/language_settings_controller.dart';

class LanguageSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LanguageSettingsController>(
      () => LanguageSettingsController(),
    );
  }
}