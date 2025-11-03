import 'package:get/get.dart';
import 'package:do_task_project/app/modules/income_details/controllers/income_details_controller.dart';

class IncomeDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IncomeDetailsController>(
      () => IncomeDetailsController(),
    );
  }
}