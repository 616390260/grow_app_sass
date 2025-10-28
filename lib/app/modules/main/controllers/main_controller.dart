import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';

class MainController extends BaseController {
  final currentTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    setSuccess();
  }

  void onTabChanged(int index) {
    currentTabIndex.value = index;
  }

  @override
  void refreshData() {}
}