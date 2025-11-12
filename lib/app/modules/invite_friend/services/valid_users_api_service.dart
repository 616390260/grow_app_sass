import 'package:flutter/foundation.dart';
import 'package:do_task_project/app/core/services/http_service.dart';
import 'package:do_task_project/app/modules/invite_friend/models/invite_info_response_model.dart';

/// 有效用户API服务
class ValidUsersApiService {
  final HttpService _httpService = HttpService.to;

  static const String _getInviteInfoEndpoint = 'app/user/getInviteInfo';

  /// 获取邀请信息（包含有效用户列表和统计数据）
  Future<InviteInfoResponseModel> getInviteInfo({int status = 1}) async {
    try {
      final queryParameters = <String, dynamic>{
        'status': status,
      };

      debugPrint('请求邀请信息API: $_getInviteInfoEndpoint, 参数: $queryParameters');
      
      final responseData = await _httpService.get<Map<String, dynamic>>(
        _getInviteInfoEndpoint,
        queryParameters: queryParameters,
      );
      
      debugPrint('获取到邀请信息响应: $responseData');
      
      // 转换数据模型
      return InviteInfoResponseModel.fromJson(responseData);
    } catch (e) {
      debugPrint('获取邀请信息异常: $e');
      rethrow;
    }
  }
}
