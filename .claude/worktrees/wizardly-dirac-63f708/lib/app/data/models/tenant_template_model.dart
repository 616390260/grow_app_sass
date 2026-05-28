/// 租户模板与品牌配置模型
/// 对应接口: app/tenant/template
class TenantTemplateModel {
  final Map<String, TemplateInfo> templates;
  final BrandConfig? brand;

  TenantTemplateModel({required this.templates, this.brand});

  factory TenantTemplateModel.fromJson(Map<String, dynamic> json) {
    final templates = <String, TemplateInfo>{};
    final rawTemplates = json['templates'];
    if (rawTemplates is Map) {
      rawTemplates.forEach((key, value) {
        if (value is Map) {
          templates[key.toString()] =
              TemplateInfo.fromJson(Map<String, dynamic>.from(value));
        }
      });
    }
    final rawBrand = json['brand'];
    return TenantTemplateModel(
      templates: templates,
      brand: rawBrand is Map
          ? BrandConfig.fromJson(Map<String, dynamic>.from(rawBrand))
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'templates': templates.map((k, v) => MapEntry(k, v.toJson())),
        'brand': brand?.toJson(),
      };
}

class TemplateInfo {
  final String? configJson;
  final String? templateName;
  final String? templateCode;

  TemplateInfo({this.configJson, this.templateName, this.templateCode});

  factory TemplateInfo.fromJson(Map<String, dynamic> json) => TemplateInfo(
        configJson: json['configJson'] as String?,
        templateName: json['templateName'] as String?,
        templateCode: json['templateCode'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'configJson': configJson,
        'templateName': templateName,
        'templateCode': templateCode,
      };
}

class BrandConfig {
  final String? appName;
  final String? h5Domain;
  final String? brandLogo;
  final String? siteTimeZone;
  final String? activityFunction;

  BrandConfig({
    this.appName,
    this.h5Domain,
    this.brandLogo,
    this.siteTimeZone,
    this.activityFunction,
  });

  factory BrandConfig.fromJson(Map<String, dynamic> json) => BrandConfig(
        appName: json['app_name'] as String?,
        h5Domain: json['h5_domain'] as String?,
        brandLogo: json['brand_logo'] as String?,
        siteTimeZone: json['site_time_zone'] as String?,
        activityFunction: json['activity_function'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'app_name': appName,
        'h5_domain': h5Domain,
        'brand_logo': brandLogo,
        'site_time_zone': siteTimeZone,
        'activity_function': activityFunction,
      };
}
