import 'package:get/get.dart';
import '../services/http_service.dart';
import '../config/environment_config.dart';

/// 全局依赖绑定
/// 注册应用程序启动时需要的核心服务
class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    // 注册环境配置（单例，应用启动时立即创建）
    Get.put<EnvironmentConfig>(EnvironmentConfig.instance, permanent: true);
    
    // 注册HTTP服务（单例，应用启动时立即创建）
    Get.put<HttpService>(HttpService(), permanent: true);
  }
}