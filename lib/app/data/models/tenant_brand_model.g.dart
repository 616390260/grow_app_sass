// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant_brand_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TenantBrandModel _$TenantBrandModelFromJson(Map<String, dynamic> json) =>
    TenantBrandModel(
      templates: json['templates'] == null
          ? null
          : TenantTemplates.fromJson(json['templates'] as Map<String, dynamic>),
      brand: json['brand'] == null
          ? null
          : TenantBrand.fromJson(json['brand'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TenantBrandModelToJson(TenantBrandModel instance) =>
    <String, dynamic>{'templates': instance.templates, 'brand': instance.brand};

TenantTemplates _$TenantTemplatesFromJson(Map<String, dynamic> json) =>
    TenantTemplates(
      login: json['login'] == null
          ? null
          : TenantTemplate.fromJson(json['login'] as Map<String, dynamic>),
      home: json['home'] == null
          ? null
          : TenantTemplate.fromJson(json['home'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TenantTemplatesToJson(TenantTemplates instance) =>
    <String, dynamic>{'login': instance.login, 'home': instance.home};

TenantTemplate _$TenantTemplateFromJson(Map<String, dynamic> json) =>
    TenantTemplate(
      configJson: json['configJson'] as String?,
      templateName: json['templateName'] as String?,
      templateCode: json['templateCode'] as String?,
    );

Map<String, dynamic> _$TenantTemplateToJson(TenantTemplate instance) =>
    <String, dynamic>{
      'configJson': instance.configJson,
      'templateName': instance.templateName,
      'templateCode': instance.templateCode,
    };

TenantBrand _$TenantBrandFromJson(Map<String, dynamic> json) => TenantBrand(
  appName: json['app_name'] as String?,
  brandLogo: json['brand_logo'] as String?,
  brandColor: json['brand_color'] as String?,
  activityFunction: json['activity_function'],
  vipFun: json['vip_fun'],
);

Map<String, dynamic> _$TenantBrandToJson(TenantBrand instance) =>
    <String, dynamic>{
      'app_name': instance.appName,
      'brand_logo': instance.brandLogo,
      'brand_color': instance.brandColor,
      'activity_function': instance.activityFunction,
      'vip_fun': instance.vipFun,
    };
