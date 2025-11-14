import '../models/home_info_model.dart';
import '../../core/services/http_service.dart';

/// 首页相关 API 服务
class HomeApiService {
  final HttpService _httpService = HttpService.to;

  static const String _getHomeInfoEndpoint = 'app/user/getHomeInfo';
  static const String _getApkDownloadUrlEndpoint = 'app/getApkDownloadUrl';

  /// 获取首页信息
  Future<HomeInfoModel> getHomeInfo() async {
    try {
      final responseData = await _httpService.get<Map<String, dynamic>>(
        _getHomeInfoEndpoint,
      );
      
      // 转换数据模型
      return HomeInfoModel.fromJson(responseData);
    } catch (e) {
      // 错误处理
      rethrow;
    }
  }

  /// 获取APK下载链接
  Future<String> getApkDownloadUrl() async {
    try {
      final responseData = await _httpService.get<String>(
        _getApkDownloadUrlEndpoint,
      );
      
      return responseData;
    } catch (e) {
      // 错误处理
      rethrow;
    }
  }
}