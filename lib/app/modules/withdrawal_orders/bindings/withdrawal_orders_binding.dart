import 'package:get/get.dart';
import '../controllers/withdrawal_orders_controller.dart';

class WithdrawalOrdersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WithdrawalOrdersController>(
      () => WithdrawalOrdersController(),
    );
  }
}