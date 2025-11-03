import '../models/home_info_model.dart';
import '../../core/services/http_service.dart';
import 'package:get/get.dart';

/// 任务中心API服务
class TaskCenterApiService {
  final HttpService _httpService = HttpService.to;

  static const String _getTaskListEndpoint = 'app/taskCenter/getPage';

  /// 获取任务列表（分页）
  Future<List<RecommendTaskModel>> getTaskList({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'current': page,
        'size': limit,
      };

      final responseData = await _httpService.get<Map<String, dynamic>>(
        _getTaskListEndpoint,
        queryParameters: queryParameters,
      );
      
      // 解析返回的数据
      if (responseData is Map<String, dynamic> && 
          responseData.containsKey('data') && 
          responseData['data'] is Map<String, dynamic> &&
          responseData['data']['records'] is List) {
        
        final List<dynamic> records = responseData['data']['records'];
        return records
            .map((item) => RecommendTaskModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      
      return <RecommendTaskModel>[];
    } catch (e) {
      rethrow;
    }
  }
}