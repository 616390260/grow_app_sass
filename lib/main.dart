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
    // 根据认证状态确定初始路由
    final authService = Get.find<AuthService>();
    final initialRoute = authService.needLogin ? Routes.login : AppPages.initial;
    
    return GetMaterialApp(
      title: 'app_title'.tr,
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
}
