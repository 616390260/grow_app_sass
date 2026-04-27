import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../data/models/tenant_info_model.dart';
import '../../data/models/tenant_brand_model.dart';
import '../../data/services/tenant_api_service.dart';
import '../config/environment_config.dart';
import '../utils/web_utils.dart';

/// 租户服务 —— 管理多租户信息与品牌配置
///
/// 启动流程：
///   1. Web 端通过 `Uri.base.host` 获取浏览器域名；
///      非 Web 端从 baseUrl 中提取域名
///   2. 调用 `/system/tenant/domain/{domain}` 获取 tenantId
///   3. 后续请求自动携带 `X-Tenant-Id` 请求头
///   4. 调用 `/app/tenant/template` 获取租户配置
class TenantService extends GetxService {
  static TenantService get to => Get.find();

  final Rxn<TenantInfoModel> tenantInfo = Rxn<TenantInfoModel>();
  final Rxn<TenantBrandModel> brandInfo = Rxn<TenantBrandModel>();

  /// 租户 ID（便捷访问，转为 String 用于请求头）
  String? get tenantId {
    final id = tenantInfo.value?.tenantId;
    return id?.toString();
  }

  /// 应用名称（优先接口 → 编译期注入 → 硬编码默认值）
  String get appName =>
      brandInfo.value?.brand?.appName ??
      EnvironmentConfig.compileAppName.ifEmpty(() => 'Taskgo');

  /// 品牌 Logo 完整 URL（相对路径自动拼接 baseUrl）
  String? get brandLogo {
    final raw = brandInfo.value?.brand?.brandLogo;
    if (raw == null || raw.isEmpty) return null;
    if (raw.startsWith('http://') || raw.startsWith('https://')) return raw;
    final base = EnvironmentConfig.instance.baseUrl.replaceAll(RegExp(r'/+$'), '');
    return '$base$raw';
  }

  /// 各模板默认色
  static const Color _classicBlue = Color(0xFF03318C);
  static const Color _minimalGreen = Color(0xFF097A45);
  static const Color _darkGoldAccent = Color(0xFFE8C779);

  /// 品牌主题色（接口有 brand_color 时返回对应 Color，无则 null）
  Color? get brandColor {
    final hex = brandInfo.value?.brand?.brandColor;
    if (hex == null || hex.isEmpty) return null;
    final cleaned = hex.replaceAll('#', '').replaceAll('0x', '');
    final value = int.tryParse(cleaned, radix: 16);
    if (value == null) return null;
    return Color(cleaned.length <= 6 ? (0xFF000000 | value) : value);
  }

  /// 有效主题色：优先取 brandColor，无配置时根据登录模板回退
  /// - login_classic_blue → 深蓝 #03318C
  /// - login_dark_gold   → 金色 #E8C779
  /// - 其他返回 null（AppTheme 保持默认色）
  Color? get effectiveBrandColor {
    final color = brandColor;
    if (color != null) return color;
    switch (loginTemplateCode) {
      case 'login_classic_blue':
        return _classicBlue;
      case 'login_minimal_green':
        return _minimalGreen;
      case 'login_dark_gold':
        return _darkGoldAccent;
      default:
        return null;
    }
  }

  /// 是否启用活动功能（默认启用）
  bool get activityEnabled {
    final val = brandInfo.value?.brand?.activityFunction;
    if (val == null) return true;
    if (val is bool) return val;
    final str = val.toString().trim().toLowerCase();
    return str == '1' || str == 'true';
  }

  /// 是否启用 VIP 功能（默认启用）
  bool get vipEnabled {
    final val = brandInfo.value?.brand?.vipFun;
    if (val == null) return true;
    if (val is bool) return val;
    final str = val.toString().trim().toLowerCase();
    return str == '1' || str == 'true';
  }

  /// 站点时区（来自 `/app/tenant/template` → `brand.site_time_zone`）
  ///
  /// 取值示例：`Asia/Tokyo`、`Etc/UTC`、`UTC+4`、`UTC+5:30`；
  /// 用于活动倒计时等需要按站点时区显示的场景。无配置时返回空串。
  String get siteTimeZone =>
      brandInfo.value?.brand?.siteTimeZone?.trim() ?? '';

  /// 登录页模板编码
  String? get loginTemplateCode =>
      brandInfo.value?.templates?.login?.templateCode;

  /// 首页模板编码
  String? get homeTemplateCode =>
      brandInfo.value?.templates?.home?.templateCode;

  /// 是否已成功加载租户信息
  bool get hasTenant => tenantInfo.value != null;

  /// 是否已成功加载品牌配置
  bool get hasBrand => brandInfo.value != null;

  /// 启动期日志只打印一次（避免重试刷屏）
  bool _bootLogPrinted = false;
  bool _fetchTenantLogPrinted = false;
  bool _fetchBrandLogPrinted = false;

  /// 初始化租户信息
  ///
  /// - Web 端：从浏览器地址栏获取域名 → 查接口获取 tenantId → 拉品牌配置
  /// - APK 端：从编译期常量 [EnvironmentConfig.compileTenantId] 获取 tenantId
  ///           → 设置 tenantInfo → 拉品牌配置
  Future<TenantService> init() async {
    if (kIsWeb) {
      final domain = Uri.base.host;
      if (!_bootLogPrinted) {
        debugPrint('[TenantService] Web端域名: $domain');
        _bootLogPrinted = true;
      }
      if (domain.isNotEmpty) {
        await fetchTenant(domain);
      }
    } else {
      final tid = EnvironmentConfig.compileTenantId;
      if (tid.isNotEmpty) {
        if (!_bootLogPrinted) {
          debugPrint('[TenantService] APK端编译期tenantId: $tid');
          _bootLogPrinted = true;
        }
        tenantInfo.value = TenantInfoModel(tenantId: int.tryParse(tid));
        if (tenantInfo.value?.tenantId != null) {
          await fetchBrand();
        }
      }
    }
    return this;
  }

  /// 根据域名拉取租户信息，成功后自动获取品牌配置
  Future<void> fetchTenant(String domain) async {
    try {
      if (!_fetchTenantLogPrinted) {
        debugPrint('[TenantService] 正在获取租户信息, domain=$domain');
        _fetchTenantLogPrinted = true;
      }
      final api = TenantApiService();
      final info = await api.getTenantByDomain(domain);
      tenantInfo.value = info;
      debugPrint('[TenantService] 租户信息获取成功: tenantId=${info.tenantId}');

      // tenantId 已写入，后续请求会自动携带 X-Tenant-Id，继续获取品牌配置
      if (info.tenantId != null) {
        await fetchBrand();
      }
    } catch (e) {
      // 静默：由 SplashController 统一聚合一次性日志，避免刷屏
    }
  }

  /// 获取租户品牌配置（依赖 X-Tenant-Id 请求头）
  Future<void> fetchBrand() async {
    try {
      if (!_fetchBrandLogPrinted) {
        debugPrint('[TenantService] 正在获取租户品牌配置...');
        _fetchBrandLogPrinted = true;
      }
      final api = TenantApiService();
      final brand = await api.getTenantBrand();
      brandInfo.value = brand;
      debugPrint('[TenantService] 品牌配置获取成功: appName=${brand.brand?.appName}, loginTemplate=${brand.templates?.login?.templateCode}, homeTemplate=${brand.templates?.home?.templateCode}');

      // Web 端同步更新浏览器标签标题和 favicon
      if (kIsWeb) {
        updateDocumentTitle(appName);
        final logo = brandLogo;
        if (logo != null) updateFavicon(logo);
      }
    } catch (e) {
      // 静默：由 SplashController 统一聚合一次性日志，避免刷屏
    }
  }
}
