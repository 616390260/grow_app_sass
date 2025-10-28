import 'package:get/get.dart';
import '../controllers/smart_controller.dart';

class SmartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SmartController>(
      () => SmartController(),
    );
  }
}