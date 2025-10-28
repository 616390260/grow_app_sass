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
}