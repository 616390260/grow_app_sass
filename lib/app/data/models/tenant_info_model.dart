import 'package:json_annotation/json_annotation.dart';

part 'tenant_info_model.g.dart';

/// 租户信息模型
/// 对应接口 /system/tenant/domain/{domain} 返回的数据
@JsonSerializable()
class TenantInfoModel {
  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'tenantId')
  final int? tenantId;

  @JsonKey(name: 'domain')
  final String? domain;

  @JsonKey(name: 'domainType')
  final String? domainType;

  @JsonKey(name: 'bindMode')
  final String? bindMode;

  @JsonKey(name: 'cfZoneId')
  final String? cfZoneId;

  @JsonKey(name: 'cfRecordId')
  final String? cfRecordId;

  @JsonKey(name: 'cfProxyEnabled')
  final String? cfProxyEnabled;

  @JsonKey(name: 'verifyStatus')
  final String? verifyStatus;

  @JsonKey(name: 'verifyTxt')
  final String? verifyTxt;

  @JsonKey(name: 'sslEnabled')
  final String? sslEnabled;

  @JsonKey(name: 'status')
  final String? status;

  @JsonKey(name: 'createTime')
  final String? createTime;

  @JsonKey(name: 'updateTime')
  final String? updateTime;

  @JsonKey(name: 'tenantName')
  final String? tenantName;

  TenantInfoModel({
    this.id,
    this.tenantId,
    this.domain,
    this.domainType,
    this.bindMode,
    this.cfZoneId,
    this.cfRecordId,
    this.cfProxyEnabled,
    this.verifyStatus,
    this.verifyTxt,
    this.sslEnabled,
    this.status,
    this.createTime,
    this.updateTime,
    this.tenantName,
  });

  factory TenantInfoModel.fromJson(Map<String, dynamic> json) =>
      _$TenantInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$TenantInfoModelToJson(this);
}
