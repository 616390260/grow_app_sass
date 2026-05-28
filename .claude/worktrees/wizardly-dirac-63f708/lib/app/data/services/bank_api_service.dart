import 'package:do_task_project/app/core/services/http_service.dart';

import '../../../app/modules/payment_method/controllers/payment_method_controller.dart';

/// 银行相关 API 服务
class BankApiService {
  final HttpService _httpService = HttpService.to;

  static const String _getBankCodeEndpoint = 'app/goldenFlowInfo/getBankCode';

  /// 获取银行列表
  Future<List<BankModel>> getBankList({int? countryId}) async {
    try {
      print('请求银行列表API: $_getBankCodeEndpoint, 参数countryId: $countryId');
      
      final responseData = await _httpService.get<List<dynamic>>(
        _getBankCodeEndpoint,
        queryParameters: {'name': countryId},
      );
      
      print('获取到银行列表响应: $responseData');
      
      // 将响应数据转换为BankModel列表
      return responseData
          .map((item) => BankModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('获取银行列表异常: $e');
      // 发生异常时返回一个空列表
      return <BankModel>[];
    }
  }
}