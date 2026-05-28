import 'package:get/get.dart';

import '../controllers/message_center_controller.dart';

class MessageCenterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MessageCenterController>(
      () => MessageCenterController(),
    );
  }
}
