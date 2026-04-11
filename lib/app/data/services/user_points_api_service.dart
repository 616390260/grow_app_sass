import 'package:do_task_project/app/core/models/base_list_entity.dart';
import 'package:do_task_project/app/modules/user_points_details/models/user_points_model.dart';

import '../../core/services/http_service.dart';

/// 用户积分相关 API 服务
class UserPointsApiService {
  final HttpService _httpService = HttpService.to;

  static const String _getUserPointsEndpoint = 'app/userPointsDetails/getPage';

  /// 获取用户积分详情列表（分页）
  Future<BaseListEntity<PointsRecord>> getUserPointsList({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'current': page,
        'size': limit,
      };

      print('请求用户积分详情API: $_getUserPointsEndpoint, 参数: $queryParameters');
      
      final responseData = await _httpService.get<Map<String, dynamic>>(
        _getUserPointsEndpoint,
        queryParameters: queryParameters,
      );
      
      print('获取到用户积分详情响应: $responseData');
      
      // 安全地转换数据模型
      return BaseListEntity<PointsRecord>.fromJsonSafe(
        responseData,
        (json) => PointsRecord.fromJson(json as Map<String, dynamic>),
      );
    } catch (e) {
      print('获取用户积分详情异常: $e');
      // 发生异常时返回一个空的BaseListEntity实例
      return BaseListEntity<PointsRecord>(
        records: <PointsRecord>[],
        total: 0,
        size: 0,
        current: 1,
        pages: 0,
      );
    }
  }
}