import '../../core/services/http_service.dart';
import 'package:flutter/foundation.dart';
import 'package:do_task_project/app/domain/entities/online_number.dart';

/// WhatsApp API服务类
class WhatsappApiService {
  final HttpService _httpService = HttpService.to;

  /// API端点
  static const String _getLoginCodeEndpoint = 'app/wsNumber/getLoginCode';
  static const String _getOnlineNumbersEndpoint = 'app/wsNumber/online';
  static const String _getTaskInfoEndpoint = 'app/wsNumber/getTaskInfo';

  /// 获取登录验证码
  Future<String> getLoginCode(String phoneNumber) async {
    try {
      final data = await _httpService.get<String>(
        _getLoginCodeEndpoint,
        queryParameters: {
          'phone': phoneNumber,
        },
      );
      
      return data;
    } catch (e) {
      rethrow;
    }
  }

  /// 获取在线号码列表
  Future<List<OnlineNumber>> getOnlineNumbers() async {
    try {
      // 使用dynamic类型获取原始响应数据，避免HttpService的自动处理
      final response = await _httpService.get<dynamic>(
        _getOnlineNumbersEndpoint,
      );
      
      
      // 处理API响应
      if (response != null) {
        List<dynamic> dataList;
        
        // 检查响应结构
        if (response is Map<String, dynamic>) {
          // 如果是标准API格式，从data字段获取
          if (response['data'] != null && response['data'] is List) {
            dataList = response['data'] as List;
          } else {
            debugPrint('No data field found in Map response');
            return [];
          }
        } else if (response is List) {
          // 如果响应本身就是列表
          dataList = response;
        } else {
          debugPrint('Unexpected response format: ${response.runtimeType}');
          return [];
        }
        
        debugPrint('Data list length: ${dataList.length}');
        
        if (dataList.isNotEmpty) {
          debugPrint('First item sample: ${dataList[0]}');
          debugPrint('First item type: ${dataList[0].runtimeType}');
        }
        
        try {
          final result = dataList
              .map((item) {
                debugPrint('Processing item: $item');
                return OnlineNumber.fromJson(item as Map<String, dynamic>);
              })
              .toList();
          debugPrint('Parsed ${result.length} OnlineNumber objects');
          return result;
        } catch (e, stackTrace) {
          debugPrint('Error parsing OnlineNumber objects: $e');
          debugPrint('Stack trace: $stackTrace');
          return [];
        }
      }
      
      debugPrint('Response is null');
      return [];
    } catch (e, stackTrace) {
      // 发生异常时返回空列表
      debugPrint('Error fetching online numbers: $e');
      debugPrint('Stack trace: $stackTrace');
      return [];
    }
  }

  /// 获取任务信息
  Future<Map<String, dynamic>> getTaskInfo() async {
    try {
      final data = await _httpService.get<Map<String, dynamic>>(
        _getTaskInfoEndpoint,
      );
      
      return data;
    } catch (e) {
      debugPrint('Error fetching task info: $e');
      // 发生异常时返回默认值
      return {
        'todayPoints': 0,
        'todaySendNum': 0,
        'videoUrl': '',
        'wsDownloadUrl': '',
        'yesterdayPoints': 0
      };
    }
  }
}
