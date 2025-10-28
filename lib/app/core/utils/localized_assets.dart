import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 多语言资源加载工具类
/// 根据当前语言设置自动加载对应的图片资源
class LocalizedAssets {
  /// 支持的语言代码映射
  static const Map<String, String> _supportedLocales = {
    'zh': 'zh_CN',
    'en': 'en_US', 
    'id': 'id_ID',
    'bn': 'bn_BD',
    'hi': 'hi_IN',
    'es': 'es_ES',
  };

  /// 获取当前语言对应的图片路径
  /// [imageName] 图片文件名（包含扩展名）
  /// 返回完整的资源路径
  static String getImagePath(String imageName) {
    final locale = Get.locale ?? const Locale('zh', 'CN');
    final languageCode = locale.languageCode;
    
    // 获取支持的语言代码，如果不支持则使用默认
    final supportedLocale = _supportedLocales[languageCode] ?? 'default';
    
    return 'assets/images/$supportedLocale/$imageName';
  }

  /// 获取本地化的AssetImage对象
  /// [imageName] 图片文件名（包含扩展名）
  /// 返回AssetImage对象，可直接用于Image widget
  static AssetImage getLocalizedImage(String imageName) {
    return AssetImage(getImagePath(imageName));
  }

  /// 检查指定语言的图片资源是否存在
  /// [imageName] 图片文件名
  /// [languageCode] 语言代码（可选，默认使用当前语言）
  /// 返回资源路径，如果指定语言不存在则返回默认路径
  static String getImagePathWithFallback(String imageName, [String? languageCode]) {
    languageCode ??= Get.locale?.languageCode ?? 'zh';
    final supportedLocale = _supportedLocales[languageCode];
    
    if (supportedLocale != null) {
      return 'assets/images/$supportedLocale/$imageName';
    }
    
    // 如果不支持该语言，使用默认资源
    return 'assets/images/default/$imageName';
  }

  /// 获取所有支持的语言代码列表
  static List<String> getSupportedLanguages() {
    return _supportedLocales.keys.toList();
  }

  /// 获取当前语言的完整locale代码
  static String getCurrentLocaleCode() {
    final locale = Get.locale ?? const Locale('zh', 'CN');
    final languageCode = locale.languageCode;
    return _supportedLocales[languageCode] ?? 'zh_CN';
  }
}

/// 扩展方法，为String添加本地化图片获取功能
extension LocalizedAssetString on String {
  /// 获取本地化图片路径
  String get localizedImagePath => LocalizedAssets.getImagePath(this);
  
  /// 获取本地化AssetImage对象
  AssetImage get localizedImage => LocalizedAssets.getLocalizedImage(this);
}