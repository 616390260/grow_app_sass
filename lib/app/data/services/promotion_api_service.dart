import 'package:do_task_project/app/domain/entities/promotion_data.dart';
import '../../core/services/http_service.dart';

/// 推广数据相关 API 服务
class PromotionApiService {
  final HttpService _httpService = HttpService.to;

  static const String _getInviteHomeEndpoint = 'app/user/getInviteHome';
  static const String _receiveRewardEndpoint = 'app/user/receiveTwoStarReward';

  /// 获取推广首页信息
  Future<PromotionData> getInviteHome() async {
    try {
      final responseData = await _httpService.get<Map<String, dynamic>>(
        _getInviteHomeEndpoint,
      );

      // 转换数据模型，确保能处理null值
      return PromotionData.fromJson(responseData);
    } catch (e) {
      // 错误处理
      rethrow;
    }
  }

  /// 领取奖励
  Future<void> receiveReward({
    required int reachTwoStarUsers,
    required int twoStarRewardPoints,
  }) async {
    try {
      await _httpService.get(
        _receiveRewardEndpoint,
        queryParameters: {
          'reachTwoStarUsers': reachTwoStarUsers,
          'twoStarRewardPoints': twoStarRewardPoints,
        },
      );
    } catch (e) {
      // 错误处理
      rethrow;
    }
  }
}
