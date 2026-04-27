import '../../core/services/http_service.dart';
import '../models/tenant_info_model.dart';
import '../models/tenant_brand_model.dart';

/// 租户相关 API 服务
class TenantApiService {
  final HttpService _httpService = HttpService.to;

  static const String _tenantByDomainEndpoint = 'system/tenant/domain/';
  static const String _tenantBrandEndpoint = 'app/tenant/template';

  /// 根据域名获取租户信息
  /// [domain] 域名，例如 "app.example.com"
  ///
  /// 静默模式：启动期失败不弹全局错误通知，由 SplashController 统一处理
  Future<TenantInfoModel> getTenantByDomain(String domain) async {
    final responseData = await _httpService.get<Map<String, dynamic>>(
      '$_tenantByDomainEndpoint$domain',
      silent: true,
    );
    return TenantInfoModel.fromJson(responseData);
  }

  /// 获取租户品牌配置（需要先设置 X-Tenant-Id 请求头）
  ///
  /// 静默模式：启动期失败不弹全局错误通知，由 SplashController 统一处理
  Future<TenantBrandModel> getTenantBrand() async {
    final responseData = await _httpService.get<Map<String, dynamic>>(
      _tenantBrandEndpoint,
      silent: true,
    );
    return TenantBrandModel.fromJson(responseData);
  }
}
