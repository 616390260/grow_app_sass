import '../models/vip_model.dart';
import '../../core/services/http_service.dart';

/// VIP相关 API 服务
class VipApiService {
  final HttpService _httpService = HttpService.to;

  static const String _getVipInfoEndpoint = 'app/vipReward/getInfo';
  static const String _getRewardEndpoint = 'app/vipReward/getReward';

  /// 获取VIP详情信息
  Future<VipDetailsModel> getVipInfo() async {
    try {
      final responseData = await _httpService.get<Map<String, dynamic>>(
        _getVipInfoEndpoint,
      );
      
      // 转换数据模型
      return VipDetailsModel.fromJson(responseData);
    } catch (e) {
      // 可以在这里添加错误处理逻辑
      rethrow;
    }
  }
  
  /// 领取VIP奖励
  Future<Map<String, dynamic>> getReward(int vipLevel) async {
    try {
      final responseData = await _httpService.get<Map<String, dynamic>>(
        _getRewardEndpoint,
        queryParameters: {'id': vipLevel},
      );
      
      return responseData;
    } catch (e) {
      rethrow;
    }
  }
}