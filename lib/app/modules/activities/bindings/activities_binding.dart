import 'package:get/get.dart';
import '../controllers/activities_controller.dart';

/// 活动页面依赖绑定
class ActivitiesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ActivitiesController>(
      () => ActivitiesController(),
    );
  }
}
