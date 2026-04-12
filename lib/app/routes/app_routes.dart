part of 'app_pages.dart';

/// 应用路由定义
abstract class Routes {
  Routes._();
  static const root = _Paths.root;
  static const home = _Paths.home;
  // static const main = _Paths.main;
  static const promotion = _Paths.promotion;
  static const tasks = _Paths.tasks;
  static const smart = _Paths.smart;
  static const account = _Paths.account;
  static const languageSettings = _Paths.languageSettings;
  static const register = _Paths.register;
  static const login = _Paths.login;
  static const luckyWheel = _Paths.luckyWheel;
  static const signInCalendar = _Paths.signInCalendar;
  static const changePassword = _Paths.changePassword;
  static const vipDetails = _Paths.vipDetails;
  static const inviteFriend = _Paths.inviteFriend;
  static const whatsappTask = _Paths.whatsappTask;
  static const accountWithdrawal = _Paths.accountWithdrawal;
  static const paymentMethod = _Paths.paymentMethod;
  static const withdrawalOrders = _Paths.withdrawalOrders;
  static const incomeDetails = _Paths.incomeDetails;
  static const validUsers = _Paths.validUsers;
  static const messageCenter = _Paths.messageCenter;
  static const activities = _Paths.activities;
}

/// 路由路径定义
abstract class _Paths {
  _Paths._();
  // 根路径默认跳转到main页面
  static const root = '/';
  // static const main = '/main';
  static const home = '/home';
  static const promotion = '/promotion';
  static const tasks = '/tasks';
  static const smart = '/smart';
  static const account = '/account';
  static const languageSettings = '/language-settings';
  static const register = '/register';
  static const login = '/login';
  static const luckyWheel = '/lucky-wheel';
  static const signInCalendar = '/sign-in-calendar';
  static const changePassword = '/change-password';
  static const vipDetails = '/vip-details';
  static const inviteFriend = '/invite_friend';
  static const whatsappTask = '/whatsapp_task';
  static const accountWithdrawal = '/account-withdrawal';
  static const paymentMethod = '/payment-method';
  static const withdrawalOrders = '/withdrawal-orders';
  static const incomeDetails = '/income-details';
  static const validUsers = '/valid-users';
  static const messageCenter = '/message-center';
  static const activities = '/activities';
  // customerServiceList路径暂未使用，保留定义供后续使用
  // static const customerServiceList = '/customer-service-list';
}