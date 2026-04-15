import 'package:json_annotation/json_annotation.dart';

part 'tenant_brand_model.g.dart';

/// 租户模板配置顶层模型
/// 对应接口 /app/tenant/template 返回的 data 字段
@JsonSerializable()
class TenantBrandModel {
  /// 页面模板集合（login / home 等）
  @JsonKey(name: 'templates')
  final TenantTemplates? templates;

  /// 品牌信息
  @JsonKey(name: 'brand')
  final TenantBrand? brand;

  TenantBrandModel({this.templates, this.brand});

  factory TenantBrandModel.fromJson(Map<String, dynamic> json) =>
      _$TenantBrandModelFromJson(json);

  Map<String, dynamic> toJson() => _$TenantBrandModelToJson(this);
}

/// 模板集合
@JsonSerializable()
class TenantTemplates {
  /// 登录页模板
  @JsonKey(name: 'login')
  final TenantTemplate? login;

  /// 首页模板
  @JsonKey(name: 'home')
  final TenantTemplate? home;

  TenantTemplates({this.login, this.home});

  factory TenantTemplates.fromJson(Map<String, dynamic> json) =>
      _$TenantTemplatesFromJson(json);

  Map<String, dynamic> toJson() => _$TenantTemplatesToJson(this);
}

/// 单个模板配置
@JsonSerializable()
class TenantTemplate {
  /// 模板自定义配置 JSON
  @JsonKey(name: 'configJson')
  final String? configJson;

  /// 模板显示名称
  @JsonKey(name: 'templateName')
  final String? templateName;

  /// 模板编码：login_classic_blue / login_minimal_green / login_dark_gold
  @JsonKey(name: 'templateCode')
  final String? templateCode;

  TenantTemplate({this.configJson, this.templateName, this.templateCode});

  factory TenantTemplate.fromJson(Map<String, dynamic> json) =>
      _$TenantTemplateFromJson(json);

  Map<String, dynamic> toJson() => _$TenantTemplateToJson(this);
}

/// 品牌信息
@JsonSerializable()
class TenantBrand {
  /// 应用名称
  @JsonKey(name: 'app_name')
  final String? appName;

  /// 品牌 Logo URL（可能是相对路径）
  @JsonKey(name: 'brand_logo')
  final String? brandLogo;

  /// 品牌主题色（十六进制，如 "#097A45"）
  @JsonKey(name: 'brand_color')
  final String? brandColor;

  /// 是否启用活动功能（"1" 或 true 表示启用）
  @JsonKey(name: 'activity_function')
  final dynamic activityFunction;

  /// 是否启用 VIP 功能（"1" 或 true 表示启用）
  @JsonKey(name: 'vip_fun')
  final dynamic vipFun;

  TenantBrand({this.appName, this.brandLogo, this.brandColor, this.activityFunction, this.vipFun});

  factory TenantBrand.fromJson(Map<String, dynamic> json) =>
      _$TenantBrandFromJson(json);

  Map<String, dynamic> toJson() => _$TenantBrandToJson(this);
}
