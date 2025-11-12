import 'package:do_task_project/app/core/exceptions/api_exception.dart';

import '../../core/services/http_service.dart';
import 'package:do_task_project/app/domain/entities/wheel_data.dart';

/// 中奖记录API服务
class WinningApiService {
  final HttpService _httpService = HttpService.to;

  static const String _getWinningListEndpoint = 'app/winning/getList';
  static const String _lotteryEndpoint = 'app/winning/lottery';

  /// 获取中奖记录列表
  Future<WheelData> getWinningList() async {
    try {
      final queryParameters = <String, dynamic>{};

      final responseData = await _httpService.get<Map<String, dynamic>>(
        _getWinningListEndpoint,
        queryParameters: queryParameters,
      );
      
      // 创建WheelData对象，包含奖品列表和积分信息
      return WheelData.fromJson(responseData);
    } catch (e) {
      // 记录错误日志
      
      // 如果是ApiException，直接重新抛出供上层处理
      if (e is ApiException) {
        rethrow;
      }
      
      // 其他异常，包装为ApiException后抛出
      throw ApiException(code: -1, message: '获取中奖记录列表失败');
    }
  }
  
  /// 执行抽奖操作
  Future<String> doLottery(int points) async {
    try {
      final responseData = await _httpService.get<String>(
        _lotteryEndpoint,
        queryParameters: {'points': points}, // 使用queryParameters传递参数（如果需要）
      );
      
      return responseData;
    } catch (e) {
      if (e is ApiException) {
        // 直接重新抛出ApiException，让上层控制器处理
        rethrow;
      }
      throw Exception('抽奖失败: $e');
    }
  }
}
