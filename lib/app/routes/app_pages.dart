import 'package:get/get.dart';
import '../modules/main/bindings/main_binding.dart';
import '../modules/main/views/main_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/promotion/bindings/promotion_binding.dart';
import '../modules/promotion/views/promotion_view.dart';
import '../modules/tasks/bindings/tasks_binding.dart';
import '../modules/tasks/views/tasks_view.dart';
import '../modules/smart/bindings/smart_binding.dart';
import '../modules/smart/views/smart_view.dart';
import '../modules/account/bindings/account_binding.dart';
import '../modules/account/views/account_view.dart';
import '../modules/language_settings/bindings/language_settings_binding.dart';
import '../modules/language_settings/views/language_settings_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/lucky_wheel/bindings/lucky_wheel_binding.dart';
import '../modules/lucky_wheel/views/lucky_wheel_view.dart';
import '../modules/sign_in_calendar/bindings/sign_in_calendar_binding.dart';
import '../modules/sign_in_calendar/views/sign_in_calendar_view.dart';

part 'app_routes.dart';

/// GetX 应用路由配置
class AppPages {
  AppPages._();

  static const INITIAL = Routes.MAIN;

  static final routes = [
    GetPage(
      name: _Paths.MAIN,
      page: () => const MainView(),
      binding: MainBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.PROMOTION,
      page: () => const PromotionView(),
      binding: PromotionBinding(),
    ),
    GetPage(
      name: _Paths.TASKS,
      page: () => const TasksView(),
      binding: TasksBinding(),
    ),
    GetPage(
      name: _Paths.SMART,
      page: () => const SmartView(),
      binding: SmartBinding(),
    ),
    GetPage(
      name: _Paths.ACCOUNT,
      page: () => const AccountView(),
      binding: AccountBinding(),
    ),
    GetPage(
      name: _Paths.LANGUAGE_SETTINGS,
      page: () => const LanguageSettingsView(),
      binding: LanguageSettingsBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.LUCKY_WHEEL,
      page: () => const LuckyWheelView(),
      binding: LuckyWheelBinding(),
    ),
    // 签到日历页
    GetPage(
      name: _Paths.SIGN_IN_CALENDAR,
      page: () => const SignInCalendarView(),
      binding: SignInCalendarBinding(),
    ),
  ];
}