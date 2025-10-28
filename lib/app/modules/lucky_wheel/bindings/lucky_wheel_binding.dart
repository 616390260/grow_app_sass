import 'package:get/get.dart';
import '../controllers/lucky_wheel_controller.dart';

class LuckyWheelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LuckyWheelController>(
      () => LuckyWheelController(),
    );
  }
}