part of 'app_pages.dart';

/// 应用路由定义
abstract class Routes {
  Routes._();
  static const MAIN = _Paths.MAIN;
  static const HOME = _Paths.HOME;
  static const PROMOTION = _Paths.PROMOTION;
  static const TASKS = _Paths.TASKS;
  static const SMART = _Paths.SMART;
  static const ACCOUNT = _Paths.ACCOUNT;
  static const LANGUAGE_SETTINGS = _Paths.LANGUAGE_SETTINGS;
  static const REGISTER = _Paths.REGISTER;
  static const LOGIN = _Paths.LOGIN;
  static const LUCKY_WHEEL = _Paths.LUCKY_WHEEL;
  static const SIGN_IN_CALENDAR = _Paths.SIGN_IN_CALENDAR;
  static const CHANGE_PASSWORD = _Paths.CHANGE_PASSWORD;
  static const VIP_DETAILS = _Paths.VIP_DETAILS;
  static const INVITE_FRIEND = _Paths.INVITE_FRIEND;
  static const WHATSAPP_TASK = _Paths.WHATSAPP_TASK;
  static const ACCOUNT_WITHDRAWAL = _Paths.ACCOUNT_WITHDRAWAL;
  static const PAYMENT_METHOD = _Paths.PAYMENT_METHOD;
  static const WITHDRAWAL_ORDERS = _Paths.WITHDRAWAL_ORDERS;
}

/// 路由路径定义
abstract class _Paths {
  _Paths._();
  static const MAIN = '/main';
  static const HOME = '/home';
  static const PROMOTION = '/promotion';
  static const TASKS = '/tasks';
  static const SMART = '/smart';
  static const ACCOUNT = '/account';
  static const LANGUAGE_SETTINGS = '/language-settings';
  static const REGISTER = '/register';
  static const LOGIN = '/login';
  static const LUCKY_WHEEL = '/lucky-wheel';
  static const SIGN_IN_CALENDAR = '/sign-in-calendar';
  static const CHANGE_PASSWORD = '/change-password';
  static const VIP_DETAILS = '/vip-details';
  static const INVITE_FRIEND = '/invite_friend';
  static const WHATSAPP_TASK = '/whatsapp_task';
  static const ACCOUNT_WITHDRAWAL = '/account-withdrawal';
  static const PAYMENT_METHOD = '/payment-method';
  static const WITHDRAWAL_ORDERS = '/withdrawal-orders';
}