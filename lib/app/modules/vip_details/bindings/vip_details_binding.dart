import 'package:get/get.dart';
import '../controllers/vip_details_controller.dart';

class VipDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VipDetailsController>(() => VipDetailsController());
  }
}