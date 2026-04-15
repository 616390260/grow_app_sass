// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TenantInfoModel _$TenantInfoModelFromJson(Map<String, dynamic> json) =>
    TenantInfoModel(
      id: (json['id'] as num?)?.toInt(),
      tenantId: (json['tenantId'] as num?)?.toInt(),
      domain: json['domain'] as String?,
      domainType: json['domainType'] as String?,
      bindMode: json['bindMode'] as String?,
      cfZoneId: json['cfZoneId'] as String?,
      cfRecordId: json['cfRecordId'] as String?,
      cfProxyEnabled: json['cfProxyEnabled'] as String?,
      verifyStatus: json['verifyStatus'] as String?,
      verifyTxt: json['verifyTxt'] as String?,
      sslEnabled: json['sslEnabled'] as String?,
      status: json['status'] as String?,
      createTime: json['createTime'] as String?,
      updateTime: json['updateTime'] as String?,
      tenantName: json['tenantName'] as String?,
    );

Map<String, dynamic> _$TenantInfoModelToJson(TenantInfoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tenantId': instance.tenantId,
      'domain': instance.domain,
      'domainType': instance.domainType,
      'bindMode': instance.bindMode,
      'cfZoneId': instance.cfZoneId,
      'cfRecordId': instance.cfRecordId,
      'cfProxyEnabled': instance.cfProxyEnabled,
      'verifyStatus': instance.verifyStatus,
      'verifyTxt': instance.verifyTxt,
      'sslEnabled': instance.sslEnabled,
      'status': instance.status,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
      'tenantName': instance.tenantName,
    };
