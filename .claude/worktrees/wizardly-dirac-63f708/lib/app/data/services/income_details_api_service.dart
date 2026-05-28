import 'package:do_task_project/app/core/models/base_list_entity.dart';
import 'package:do_task_project/app/modules/income_details/models/income_details_model.dart';
import '../../core/services/http_service.dart';

/// 收益明细相关 API 服务
class IncomeDetailsApiService {
  final HttpService _httpService = HttpService.to;

  static const String _getIncomeDetailsEndpoint = 'app/userPointsDetails/getPage';

  /// 获取收益明细列表（分页）
  Future<BaseListEntity<IncomeRecord>> getIncomeDetailsList({
    int page = 1,
    int limit = 20,
    String? type,
    String? timeRange,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'current': page,
        'size': limit,
      };
      
      // 添加筛选参数
      if (type != null && type.isNotEmpty) {
        queryParameters['type'] = type;
      }
      
      if (timeRange != null && timeRange.isNotEmpty) {
        queryParameters['timeType'] = timeRange;
      }

      print('请求收益明细API: $_getIncomeDetailsEndpoint, 参数: $queryParameters');
      
      final responseData = await _httpService.get<Map<String, dynamic>>(
        _getIncomeDetailsEndpoint,
        queryParameters: queryParameters,
      );
      
      print('获取到收益明细响应: $responseData');
      
      // 安全地转换数据模型
      return BaseListEntity<IncomeRecord>.fromJsonSafe(
        responseData,
        (json) => IncomeRecord.fromJson(json as Map<String, dynamic>),
      );
    } catch (e) {
      print('获取收益明细异常: $e');
      // 发生异常时返回一个空的BaseListEntity实例
      return BaseListEntity<IncomeRecord>(
        records: <IncomeRecord>[],
        total: 0,
        size: 0,
        current: 1,
        pages: 0,
      );
    }
  }
}