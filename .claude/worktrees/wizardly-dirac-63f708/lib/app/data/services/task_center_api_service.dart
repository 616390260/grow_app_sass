import '../models/home_info_model.dart';
import '../../core/services/http_service.dart';
import 'package:flutter/foundation.dart';
import '../../core/config/environment_config.dart';

/// 任务中心API服务
class TaskCenterApiService {
  final HttpService _httpService = HttpService.to;

  static const String _getTaskListEndpoint = 'app/taskCenter/getPage';

  /// 获取任务列表（分页）
  Future<TaskListResponse> getTaskList({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'current': page,
        'size': limit,
      };

      if (EnvironmentConfig.instance.enableLogging) {
        debugPrint('请求任务列表API: $_getTaskListEndpoint, 参数: $queryParameters');
      }
      
      final responseData = await _httpService.get<Map<String, dynamic>>(
        _getTaskListEndpoint,
        queryParameters: queryParameters,
      );
      
      if (EnvironmentConfig.instance.enableLogging) {
        debugPrint('获取到任务列表响应: $responseData, 类型: ${responseData.runtimeType}');
      }
      
      // 检查响应数据结构
      
      // 尝试多种解析方式
      try {
        // 方式1: 直接使用responseData作为TaskListResponse（如果API直接返回了分页数据）
        // 检查是否包含分页关键字段
        if (responseData.containsKey('records') || 
            responseData.containsKey('total') || 
            responseData.containsKey('pages')) {
          if (EnvironmentConfig.instance.enableLogging) {
            debugPrint('使用方式1解析: 直接将响应数据作为TaskListResponse');
          }
          return TaskListResponse.fromJson(responseData);
        }
        
        // 方式2: 从data字段获取（标准API响应格式）
        if (responseData.containsKey('data') && responseData['data'] is Map<String, dynamic>) {
          final data = responseData['data'] as Map<String, dynamic>;
          if (EnvironmentConfig.instance.enableLogging) {
            debugPrint('使用方式2解析: 从data字段获取分页数据: $data');
          }
          return TaskListResponse.fromJson(data);
        }
        
        // 方式3: 如果records直接在根级
        if (responseData.containsKey('records') && responseData['records'] is List) {
          if (EnvironmentConfig.instance.enableLogging) {
            debugPrint('使用方式3解析: records直接在根级');
          }
          List<RecommendTaskModel> recordList = [];
          for (var item in responseData['records'] as List) {
            if (item is Map<String, dynamic>) {
              recordList.add(RecommendTaskModel.fromJson(item));
            }
          }
          return TaskListResponse(
            records: recordList,
            total: responseData['total'] as int? ?? 0,
            size: responseData['size'] as int? ?? limit,
            current: responseData['current'] as int? ?? page,
            pages: responseData['pages'] as int? ?? 0,
          );
        }
             
      } catch (e) {
        if (EnvironmentConfig.instance.enableLogging) {
          debugPrint('解析任务列表数据异常: $e');
        }
      }
      
      // 兜底方案：返回空的响应对象
      if (EnvironmentConfig.instance.enableLogging) {
        debugPrint('所有解析方式失败，返回空响应');
      }
      return TaskListResponse(records: [], total: 0, size: limit, current: page, pages: 0);
    } catch (e) {
      if (EnvironmentConfig.instance.enableLogging) {
        debugPrint('获取任务列表异常: $e');
      }
      rethrow;
    }
  }
}
