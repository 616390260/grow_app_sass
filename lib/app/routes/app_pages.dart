import 'package:flutter/material.dart';
import '../modules/change_password/views/change_password_view.dart';
import '../modules/vip_details/bindings/vip_details_binding.dart';
import '../modules/vip_details/views/vip_details_view.dart';
import '../modules/invite_friend/bindings/invite_friend_binding.dart';
import '../modules/invite_friend/views/invite_friend_view.dart';
import '../modules/whatsapp_task/views/whatsapp_task_view.dart';
import '../modules/whatsapp_task/bindings/whatsapp_task_binding.dart';
import '../modules/account_withdrawal/bindings/account_withdrawal_binding.dart';
import '../modules/account_withdrawal/views/account_withdrawal_view.dart';
import '../modules/payment_method/bindings/payment_method_binding.dart';
import '../modules/payment_method/views/payment_method_view.dart';
import '../modules/withdrawal_orders/bindings/withdrawal_orders_binding.dart';
import '../modules/withdrawal_orders/views/withdrawal_orders_view.dart';
import 'package:get/get.dart';
import '../modules/main/bindings/main_binding.dart';
import '../modules/main/views/main_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/home/views/workgo_home_view.dart';
import '../modules/home/views/darkgold_home_view.dart';
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
import '../modules/login/views/taskgo_gold_login_view.dart';
import '../modules/login/views/taskgo_login_view.dart';
import '../modules/login/views/taskgo_replicate_login_view.dart';
import '../../app/core/services/tenant_service.dart';
import '../modules/lucky_wheel/bindings/lucky_wheel_binding.dart';
import '../modules/lucky_wheel/views/lucky_wheel_view.dart';
import '../modules/sign_in_calendar/bindings/sign_in_calendar_binding.dart';
import '../modules/sign_in_calendar/views/sign_in_calendar_view.dart';
import '../modules/change_password/bindings/change_password_binding.dart';
import '../modules/income_details/bindings/income_details_binding.dart';
import '../modules/income_details/views/income_details_view.dart';
import '../modules/invite_friend/views/valid_users_view.dart';
import '../modules/invite_friend/controllers/valid_users_controller.dart';
import '../modules/message_center/bindings/message_center_binding.dart';
import '../modules/message_center/views/message_center_view.dart';

import '../modules/activities/bindings/activities_binding.dart';
import '../modules/activities/views/activities_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../core/middleware/tenant_middleware.dart';

part 'app_routes.dart';

/// 根据租户配置的 templateCode 返回对应首页
Widget _buildHomeView() {
  try {
    final code = TenantService.to.homeTemplateCode;
    switch (code) {
      case 'home_classic_blue':
        return const WorkgoHomeView();
      case 'home_dark_gold':
        return const DarkGoldHomeView();
      case 'home_minimal_green':
      default:
        return const HomeView();
    }
  } catch (_) {
    return const HomeView();
  }
}

/// 根据租户配置的 templateCode 返回对应登录页
Widget _buildLoginView() {
  try {
    final code = TenantService.to.loginTemplateCode;
    switch (code) {
      case 'login_classic_blue':
        return const TaskgoLoginView();
      case 'login_minimal_green':
        return const TaskgoReplicateLoginView();
      case 'login_dark_gold':
        return const TaskgoGoldLoginView();
      default:
        return const TaskgoLoginView();
    }
  } catch (_) {
    return const TaskgoLoginView();
  }
}

/// GetX 应用路由配置
class AppPages {
  AppPages._();

  static const initial = Routes.splash;

  static final routes = [
    // 闪屏页（启动入口）
    GetPage(
      name: _Paths.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.root,
      page: () => const MainView(),
      binding: MainBinding(),
      customTransition: _SplashExitTransition(),
      transitionDuration: const Duration(milliseconds: 600),
      middlewares: [TenantMiddleware()],
    ),
    // GetPage(
    //   name: _Paths.main,
    //   page: () => const MainView(),
    //   binding: MainBinding(),
    // ),
    // 有效用户页面
    GetPage(
      name: Routes.validUsers,
      page: () => const ValidUsersView(),
      binding: BindingsBuilder(() {
        Get.put(ValidUsersController());
      }),
      middlewares: [TenantMiddleware()],
    ),
    GetPage(
      name: _Paths.home,
      page: () => _buildHomeView(),
      binding: HomeBinding(),
      middlewares: [TenantMiddleware()],
    ),
    GetPage(
      name: _Paths.promotion,
      page: () => const PromotionView(),
      binding: PromotionBinding(),
      middlewares: [TenantMiddleware()],
    ),
    GetPage(
      name: _Paths.tasks,
      page: () => TasksView(),
      binding: TasksBinding(),
      middlewares: [TenantMiddleware()],
    ),
    GetPage(
      name: _Paths.smart,
      page: () => const SmartView(),
      binding: SmartBinding(),
      middlewares: [TenantMiddleware()],
    ),
    GetPage(
      name: _Paths.account,
      page: () => const AccountView(),
      binding: AccountBinding(),
      middlewares: [TenantMiddleware()],
    ),
    GetPage(
      name: _Paths.languageSettings,
      page: () => const LanguageSettingsView(),
      binding: LanguageSettingsBinding(),
      middlewares: [TenantMiddleware()],
    ),
    GetPage(
      name: _Paths.register,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
      middlewares: [TenantMiddleware()],
    ),
    GetPage(
      name: _Paths.login,
      page: () => _buildLoginView(),
      binding: LoginBinding(),
      customTransition: _SplashExitTransition(),
      transitionDuration: const Duration(milliseconds: 600),
      middlewares: [TenantMiddleware()],
    ),
    GetPage(
      name: _Paths.luckyWheel,
      page: () => const LuckyWheelView(),
      binding: LuckyWheelBinding(),
      middlewares: [TenantMiddleware()],
    ),
    // 签到日历页
    GetPage(
      name: _Paths.signInCalendar,
      page: () => const SignInCalendarView(),
      binding: SignInCalendarBinding(),
      middlewares: [TenantMiddleware()],
    ),
    // 修改密码页
    GetPage(
      name: Routes.changePassword,
      page: () => const ChangePasswordView(),
      binding: ChangePasswordBinding(),
      middlewares: [TenantMiddleware()],
    ),
    // VIP详情页
    GetPage(
      name: Routes.vipDetails,
      page: () => const VipDetailsView(),
      binding: VipDetailsBinding(),
      middlewares: [TenantMiddleware()],
    ),
    // invite friend
    GetPage(
      name: Routes.inviteFriend,
      page: () => const InviteFriendView(),
      binding: InviteFriendBinding(),
      middlewares: [TenantMiddleware()],
    ),
    // whatsapp task
    GetPage(
      name: Routes.whatsappTask,
      page: () => const WhatsappTaskView(),
      binding: WhatsappTaskBinding(),
      middlewares: [TenantMiddleware()],
    ),
    // 账号提现页
    GetPage(
      name: Routes.accountWithdrawal,
      page: () => const AccountWithdrawalView(),
      binding: AccountWithdrawalBinding(),
      middlewares: [TenantMiddleware()],
    ),
    // 收款方式页
    GetPage(
      name: Routes.paymentMethod,
      page: () => const PaymentMethodView(),
      binding: PaymentMethodBinding(),
      middlewares: [TenantMiddleware()],
    ),
    // 提现订单页
    GetPage(
      name: Routes.withdrawalOrders,
      page: () => const WithdrawalOrdersView(),
      binding: WithdrawalOrdersBinding(),
      middlewares: [TenantMiddleware()],
    ),
    // 收益明细页
    GetPage(
      name: Routes.incomeDetails,
      page: () => IncomeDetailsPage(),
      binding: IncomeDetailsBinding(),
      middlewares: [TenantMiddleware()],
    ),
    GetPage(
      name: _Paths.messageCenter,
      page: () => const MessageCenterView(),
      binding: MessageCenterBinding(),
      middlewares: [TenantMiddleware()],
    ),
    GetPage(
      name: _Paths.activities,
      page: () => const ActivitiesView(),
      binding: ActivitiesBinding(),
      middlewares: [TenantMiddleware()],
    ),
  ];
}

/// 从闪屏页跳转时的自定义过渡：淡入 + 轻微上滑 + 缩放，有层次感
class _SplashExitTransition extends CustomTransition {
  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final c = curve ?? Curves.easeOutCubic;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final t = c.transform(animation.value);

        return Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - t)),
            child: Transform.scale(
              scale: 0.96 + 0.04 * t,
              child: child,
            ),
          ),
        );
      },
    );
  }
}
