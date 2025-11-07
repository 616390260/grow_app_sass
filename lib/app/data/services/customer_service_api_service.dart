import 'package:do_task_project/domain/entities/customer_service.dart';
import '../../core/services/http_service.dart';

/// 客服列表相关 API 服务
class CustomerServiceApiService {
  final HttpService _httpService = HttpService.to;

  static const String _getCustomerServiceListEndpoint = 'app/customerService/getList';

  /// 获取客服列表
  Future<List<CustomerService>> getCustomerServiceList() async {
    try {
      print('请求客服列表API: $_getCustomerServiceListEndpoint');
      
      final responseData = await _httpService.get<List<dynamic>>(
        _getCustomerServiceListEndpoint,
      );
      
      print('获取到客服列表响应: $responseData');
      
      // 直接处理返回的数组
      return responseData.map((item) => CustomerService.fromJson(item as Map<String, dynamic>)).toList();
          
      // 如果不是数组，返回空列表
    } catch (e) {
      print('获取客服列表异常: $e');
      // 发生异常时返回一个空列表
      return <CustomerService>[];
    }
  }
}