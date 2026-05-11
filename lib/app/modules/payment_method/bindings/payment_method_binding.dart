import 'package:get/get.dart';
import '../controllers/payment_method_controller.dart';

class PaymentMethodBinding extends Bindings {
  @override
  void dependencies() {
    /// fenix: true 确保每次导航都重新创建控制器，防止复用旧参数
    Get.lazyPut<PaymentMethodController>(
      () => PaymentMethodController(),
      fenix: true,
    );
  }
}