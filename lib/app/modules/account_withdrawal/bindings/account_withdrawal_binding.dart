import 'package:get/get.dart';
import '../controllers/account_withdrawal_controller.dart';

class AccountWithdrawalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountWithdrawalController>(
      () => AccountWithdrawalController(),
    );
  }
}