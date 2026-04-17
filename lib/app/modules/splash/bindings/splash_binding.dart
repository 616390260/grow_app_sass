import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

/// 闪屏页依赖绑定
class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(
      () => SplashController(),
    );
  }
}
