import '../models/activity_model.dart';
import '../../core/services/http_service.dart';

/// 活动相关 API 服务
class ActivityApiService {
  final HttpService _httpService = HttpService.to;

  static const String _getAllEndpoint = 'app/activity/all';
  static const String _claimEndpoint = 'app/activity/claim';

  /// 获取全部活动数据（任务/佣金/下属）
  Future<ActivityAllData> getAll() async {
    final data = await _httpService.get<Map<String, dynamic>>(_getAllEndpoint);
    return ActivityAllData.fromJson(data);
  }

  /// 领取活动奖励，返回本次领取的积分数
  Future<int> claim(int activityId) async {
    final data = await _httpService.get<dynamic>(
      _claimEndpoint,
      queryParameters: {'activityId': activityId},
    );
    return (data as num).toInt();
  }
}
