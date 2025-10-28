import 'package:get/get.dart';
import '../controllers/sign_in_calendar_controller.dart';

class SignInCalendarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignInCalendarController>(() => SignInCalendarController());
  }
}