import '../../core/services/http_service.dart';

/// 邀请好友相关 API 服务
class InviteFriendApiService {
  final HttpService _httpService = HttpService.to;

  static const String _getReferralLinkEndpoint = 'app/user/getReferralLink';

  /// 获取推荐链接
  Future<String> getReferralLink() async {
    try {
      final responseData = await _httpService.get<Map<String, dynamic>>(
        _getReferralLinkEndpoint,
      );
      
      // 提取推荐链接
      final link = responseData['link'] as String?;
      if (link == null || link.isEmpty) {
        throw Exception('推荐链接为空');
      }
      
      return link;
    } catch (e) {
      // 错误处理
      rethrow;
    }
  }
}