import 'package:flutter/foundation.dart';

/// 环境类型枚举
enum EnvironmentType { debug, release }

/// 环境配置类
class EnvironmentConfig {
  static EnvironmentConfig? _instance;
  static EnvironmentConfig get instance => _instance ??= EnvironmentConfig._();

  EnvironmentConfig._();

  /// 当前环境类型
  EnvironmentType get currentEnvironment {
    return kDebugMode ? EnvironmentType.debug : EnvironmentType.release;
  }

  /// 是否为调试模式
  bool get isDebug => currentEnvironment == EnvironmentType.debug;

  /// 是否为发布模式
  bool get isRelease => currentEnvironment == EnvironmentType.release;

  /// 获取基础URL
  String get baseUrl {
    switch (currentEnvironment) {
      case EnvironmentType.debug:
        // return 'http://192.168.3.46:8081/'; // 开发环境API地址
        return 'http://47.243.76.157:8083/'; // 测试环境API地址
      case EnvironmentType.release:
        return 'http://47.243.76.157:8083/'; // 生产环境API地址
    }
  }

  /// 获取连接超时时间（毫秒）
  int get connectTimeout {
    switch (currentEnvironment) {
      case EnvironmentType.debug:
        return 30000; // 调试模式下更长的超时时间
      case EnvironmentType.release:
        return 15000; // 生产环境标准超时时间
    }
  }

  /// 获取接收超时时间（毫秒）
  int get receiveTimeout {
    switch (currentEnvironment) {
      case EnvironmentType.debug:
        return 30000; // 调试模式下更长的超时时间
      case EnvironmentType.release:
        return 15000; // 生产环境标准超时时间
    }
  }

  /// 是否启用日志
  bool get enableLogging {
    switch (currentEnvironment) {
      case EnvironmentType.debug:
        return true; // 调试模式启用详细日志
      case EnvironmentType.release:
        return false; // 生产环境关闭日志
    }
  }

  /// 是否启用网络拦截器日志
  bool get enableNetworkLogging {
    switch (currentEnvironment) {
      case EnvironmentType.debug:
        return true; // 调试模式启用网络请求日志
      case EnvironmentType.release:
        return false; // 生产环境关闭网络日志
    }
  }

  /// 获取应用名称
  String get appName {
    switch (currentEnvironment) {
      case EnvironmentType.debug:
        return 'DoTask (Debug)'; // 调试版本应用名称
      case EnvironmentType.release:
        return 'DoTask'; // 正式版本应用名称
    }
  }

  /// 获取应用版本后缀
  String get versionSuffix {
    switch (currentEnvironment) {
      case EnvironmentType.debug:
        return '-dev'; // 调试版本后缀
      case EnvironmentType.release:
        return ''; // 正式版本无后缀
    }
  }

  /// 是否启用性能监控
  bool get enablePerformanceMonitoring {
    switch (currentEnvironment) {
      case EnvironmentType.debug:
        return true; // 调试模式启用性能监控
      case EnvironmentType.release:
        return false; // 生产环境可选择性启用
    }
  }

  /// 获取缓存过期时间（秒）
  int get cacheExpiration {
    switch (currentEnvironment) {
      case EnvironmentType.debug:
        return 60; // 调试模式短缓存时间，便于测试
      case EnvironmentType.release:
        return 300; // 生产环境较长缓存时间
    }
  }

  /// 获取最大重试次数
  int get maxRetryCount {
    switch (currentEnvironment) {
      case EnvironmentType.debug:
        return 1; // 调试模式减少重试次数，便于调试
      case EnvironmentType.release:
        return 3; // 生产环境增加重试次数，提高稳定性
    }
  }

  /// 打印当前环境信息
  void printEnvironmentInfo() {
    if (enableLogging) {
      print('=== 环境配置信息 ===');
      print('当前环境: ${currentEnvironment.name}');
      print('基础URL: $baseUrl');
      print('应用名称: $appName');
      print('连接超时: ${connectTimeout}ms');
      print('接收超时: ${receiveTimeout}ms');
      print('启用日志: $enableLogging');
      print('启用网络日志: $enableNetworkLogging');
      print('缓存过期时间: ${cacheExpiration}s');
      print('最大重试次数: $maxRetryCount');
      print('==================');
    }
  }
}
