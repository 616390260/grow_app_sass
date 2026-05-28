import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../config/environment_config.dart';
import '../services/http_service.dart';

/// 环境切换工具类
class EnvironmentUtils {
  /// 获取当前环境信息
  static Map<String, dynamic> getCurrentEnvironmentInfo() {
    final config = EnvironmentConfig.instance;
    return {
      'environment': config.currentEnvironment.name,
      'isDebug': config.isDebug,
      'isRelease': config.isRelease,
      'baseUrl': config.baseUrl,
      'appName': config.appName,
      'connectTimeout': config.connectTimeout,
      'receiveTimeout': config.receiveTimeout,
      'enableLogging': config.enableLogging,
      'enableNetworkLogging': config.enableNetworkLogging,
      'cacheExpiration': config.cacheExpiration,
      'maxRetryCount': config.maxRetryCount,
    };
  }

  /// 打印当前环境信息
  static void printCurrentEnvironment() {
    final info = getCurrentEnvironmentInfo();
    if (kDebugMode) {
      print('=== 当前环境信息 ===');
      info.forEach((key, value) {
        print('$key: $value');
      });
      print('==================');
    }
  }

  /// 检查是否为调试模式
  static bool get isDebugMode => kDebugMode;

  /// 检查是否为发布模式
  static bool get isReleaseMode => kReleaseMode;

  /// 检查是否为Profile模式
  static bool get isProfileMode => kProfileMode;

  /// 获取构建模式字符串
  static String get buildMode {
    if (kDebugMode) return 'Debug';
    if (kReleaseMode) return 'Release';
    if (kProfileMode) return 'Profile';
    return 'Unknown';
  }

  /// 重新初始化HTTP服务（当环境配置改变时调用）
  static void reinitializeHttpService() {
    try {
      // 获取当前的HttpService实例
      final httpService = Get.find<HttpService>();
      
      // 重新初始化
      httpService.onInit();
      
      if (kDebugMode) {
        print('✅ HttpService 重新初始化完成');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ HttpService 重新初始化失败: $e');
      }
    }
  }

  /// 验证环境配置
  static bool validateEnvironmentConfig() {
    try {
      final config = EnvironmentConfig.instance;
      
      // 检查基础URL是否有效
      if (config.baseUrl.isEmpty) {
        if (kDebugMode) print('❌ 基础URL为空');
        return false;
      }

      // 检查超时时间是否合理
      if (config.connectTimeout <= 0 || config.receiveTimeout <= 0) {
        if (kDebugMode) print('❌ 超时时间配置无效');
        return false;
      }

      // 检查重试次数是否合理
      if (config.maxRetryCount < 0) {
        if (kDebugMode) print('❌ 重试次数配置无效');
        return false;
      }

      if (kDebugMode) print('✅ 环境配置验证通过');
      return true;
    } catch (e) {
      if (kDebugMode) print('❌ 环境配置验证失败: $e');
      return false;
    }
  }

  /// 获取环境特定的配置
  static T getEnvironmentConfig<T>(T debugValue, T releaseValue) {
    return kDebugMode ? debugValue : releaseValue;
  }

  /// 在调试模式下执行代码
  static void debugOnly(VoidCallback callback) {
    if (kDebugMode) {
      callback();
    }
  }

  /// 在发布模式下执行代码
  static void releaseOnly(VoidCallback callback) {
    if (kReleaseMode) {
      callback();
    }
  }

  /// 获取应用版本信息（包含环境后缀）
  static String getAppVersionWithEnvironment(String baseVersion) {
    final config = EnvironmentConfig.instance;
    return '$baseVersion${config.versionSuffix}';
  }

  /// 检查网络配置是否正确
  static Future<bool> checkNetworkConfiguration() async {
    try {
      final config = EnvironmentConfig.instance;
      
      // 简单的URL格式检查
      final uri = Uri.tryParse(config.baseUrl);
      if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
        if (kDebugMode) print('❌ 基础URL格式无效: ${config.baseUrl}');
        return false;
      }

      if (kDebugMode) print('✅ 网络配置检查通过');
      return true;
    } catch (e) {
      if (kDebugMode) print('❌ 网络配置检查失败: $e');
      return false;
    }
  }

  /// 获取调试信息
  static Map<String, dynamic> getDebugInfo() {
    return {
      'buildMode': buildMode,
      'isDebugMode': isDebugMode,
      'isReleaseMode': isReleaseMode,
      'isProfileMode': isProfileMode,
      'environmentInfo': getCurrentEnvironmentInfo(),
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// 导出环境配置为JSON字符串（调试用）
  static String exportEnvironmentConfig() {
    final info = getCurrentEnvironmentInfo();
    final debugInfo = getDebugInfo();
    
    return '''
{
  "buildInfo": {
    "mode": "${debugInfo['buildMode']}",
    "isDebug": ${debugInfo['isDebugMode']},
    "isRelease": ${debugInfo['isReleaseMode']},
    "timestamp": "${debugInfo['timestamp']}"
  },
  "environment": ${info.toString()}
}
''';
  }
}