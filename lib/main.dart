import 'dart:developer';
import 'package:do_task_project/app/core/i18n/i18n_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app/routes/app_pages.dart';
import 'app/core/theme/app_theme.dart';
import 'app/core/bindings/global_binding.dart';
import 'app/core/i18n/app_translations.dart';
import 'app/core/i18n/locale_config.dart';
import 'app/core/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化 GetStorage（默认与命名box）
  await GetStorage.init();
  await GetStorage.init('sign_in_calendar');
  
  // 初始化全局依赖
  GlobalBinding().dependencies();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 从URL参数获取并保存邀请码（在决定路由之前）
    _saveInviteCodeFromUrl();
    
    // 根据认证状态确定初始路由
    final authService = Get.find<AuthService>();
    final initialRoute = authService.needLogin ? Routes.login : AppPages.initial;
    
    return GetMaterialApp(
      title: 'Taskgo8',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: initialRoute,
      getPages: AppPages.routes,
      translations: AppTranslations(),
      locale: LocaleConfig.getInitialLocale(),
      fallbackLocale: LocaleConfig.fallbackLocale,
      supportedLocales: LocaleConfig.supportedLocales,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
    );
  }
  
  /// 从URL参数获取邀请码并保存
  void _saveInviteCodeFromUrl() {
    try {
      // 从Get参数中获取邀请码（适用于所有平台）
      final inviteCode = Get.parameters['i'] ?? Get.parameters['invite_code'] ?? Get.parameters['referral'];
      if (inviteCode != null && inviteCode.isNotEmpty) {
        // 直接使用GetStorage保存邀请码，避免GetX依赖注入的时序问题
        final storage = GetStorage();
        storage.write('pending_invite_code', inviteCode);
        debugPrint('成功保存URL邀请码: $inviteCode');
      }
    } catch (e) {
      // 捕获可能的错误，避免影响应用启动
      debugPrint('保存URL邀请码失败: $e');
    }
  }
}
