import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

/// 闪屏页依赖绑定
///
/// 使用 permanent 单例：避免页面被重新 push 时 controller 被销毁重建，
/// 防止"重试期间日志/动画/路由不停刷新"的问题。
class SplashBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<SplashController>()) {
      Get.put<SplashController>(SplashController(), permanent: true);
    }
  }
}
