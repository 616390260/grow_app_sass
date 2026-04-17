import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/tenant_service.dart';
import '../../routes/app_pages.dart';

/// 租户初始化守卫 —— 确保所有页面访问前租户配置已加载
///
/// Web 端刷新浏览器时 URL 可能是 /login 或 /home，
/// GetX 会直接用 URL 作为初始路由跳过闪屏页。
/// 此中间件拦截未初始化的请求，强制重定向到闪屏页。
class TenantMiddleware extends GetMiddleware {
  @override
  int? get priority => -1;

  @override
  RouteSettings? redirect(String? route) {
    if (!TenantService.to.hasTenant && route != Routes.splash) {
      return const RouteSettings(name: Routes.splash);
    }
    return null;
  }
}
