import '../models/tenant_template_model.dart';
import '../../core/services/http_service.dart';

/// 租户模板/品牌配置 API 服务
class TenantApiService {
  final HttpService _httpService = HttpService.to;

  static const String _getTemplateEndpoint = 'app/tenant/template';

  /// 获取租户模板与品牌配置
  Future<TenantTemplateModel> getTemplate() async {
    final responseData = await _httpService.get<Map<String, dynamic>>(
      _getTemplateEndpoint,
    );
    return TenantTemplateModel.fromJson(responseData);
  }
}
