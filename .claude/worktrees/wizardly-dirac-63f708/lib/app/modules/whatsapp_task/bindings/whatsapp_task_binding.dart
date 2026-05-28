import 'package:get/get.dart';
import '../controllers/whatsapp_task_controller.dart';

class WhatsappTaskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WhatsappTaskController>(
      () => WhatsappTaskController(),
    );
  }
}