import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../promotion/controllers/promotion_controller.dart';
import '../../tasks/controllers/tasks_controller.dart';
import '../../activities/controllers/activities_controller.dart';
import '../../smart/controllers/smart_controller.dart';
import '../../account/controllers/account_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());
    // 注册各模块的控制器，支持在 MainView 中直接作为组件使用
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<PromotionController>(() => PromotionController());
    Get.lazyPut<TasksController>(() => TasksController());
    Get.lazyPut<ActivitiesController>(() => ActivitiesController());
    Get.lazyPut<SmartController>(() => SmartController());
    Get.lazyPut<AccountController>(() => AccountController());
  }
}