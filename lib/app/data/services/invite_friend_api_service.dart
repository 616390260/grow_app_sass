
import '../../core/services/http_service.dart';
import '../../modules/invite_friend/models/box_product_model.dart';

/// 邀请好友相关 API 服务
class InviteFriendApiService {
  final HttpService _httpService = HttpService.to;

  static const String _getReferralLinkEndpoint = 'app/user/getInviteFriends';
  static const String _getBoxProductListEndpoint = 'app/user/getBoxProductList';
  static const String _receiveBoxEndpoint = 'app/user/receiveBox';

  /// 获取推荐链接
  Future<String> getReferralLink() async {
    try {
      final responseData = await _httpService.get<String>(
        _getReferralLinkEndpoint,
      );
      
      // 提取推荐链接
      if (responseData.isEmpty) {
        throw Exception('推荐链接为空');
      }
      
      return responseData;
    } catch (e) {
      // 错误处理
      rethrow;
    }
  }

  /// 获取宝箱产品列表
  Future<List<BoxProductModel>> getBoxProductList() async {
    try {
      final responseData = await _httpService.get<List<dynamic>>(
        _getBoxProductListEndpoint,
      );
      
      // 解析数据并创建模型列表，兼容null值
      final List<BoxProductModel> boxProducts = [];
      for (var item in responseData) {
        if (item != null && item is Map<String, dynamic>) {
          boxProducts.add(BoxProductModel.fromJson(item));
        } else {
          // 如果数据格式不正确，创建默认模型
          boxProducts.add(BoxProductModel());
        }
      }
      
      return boxProducts;
    } catch (e) {
      // 错误处理
      rethrow;
    }
  }

  /// 领取宝箱
  /// [boxId] 宝箱ID
  Future<Map<String, dynamic>> receiveBox(int boxId) async {
    try {
      final responseData = await _httpService.get<Map<String, dynamic>>(
        _receiveBoxEndpoint,
        queryParameters: {'boxId': boxId},
      );
      
      return responseData;
    } catch (e) {
      // 错误处理
      rethrow;
    }
  }
}