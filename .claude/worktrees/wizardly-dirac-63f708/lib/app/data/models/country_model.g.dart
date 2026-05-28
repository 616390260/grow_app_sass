// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CountryModel _$CountryModelFromJson(Map<String, dynamic> json) => CountryModel(
  id: (json['id'] as num).toInt(),
  payName: json['payName'] as String,
  status: json['status'] as String,
  merchantNo: json['merchantNo'] as String,
  minAmount: (json['minAmount'] as num?)?.toDouble(),
  fee: (json['fee'] as num?)?.toDouble(),
  exchangeRate: (json['exchangeRate'] as num?)?.toDouble(),
  delFlag: json['delFlag'] as String,
  className: json['className'] as String?,
  classNameLang: json['classNameLang'] as String?,
  bankData: json['bankData'] as String?,
  bankInfo: json['bankInfo'] as String?,
  singleAmount: json['singleAmount'] as String?,
  code: json['code'] as String?,
  recommend: json['recommend'] as String,
  createBy: json['createBy'] as String?,
  createTime: json['createTime'] as String?,
  updateBy: json['updateBy'] as String?,
  updateTime: json['updateTime'] as String?,
  remark: json['remark'] as String?,
  appid: json['appid'] as String?,
  appcode: json['appcode'] as String?,
  merchantKey: json['merchantKey'] as String?,
);

Map<String, dynamic> _$CountryModelToJson(CountryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'payName': instance.payName,
      'status': instance.status,
      'merchantNo': instance.merchantNo,
      'minAmount': instance.minAmount,
      'fee': instance.fee,
      'exchangeRate': instance.exchangeRate,
      'delFlag': instance.delFlag,
      'className': instance.className,
      'classNameLang': instance.classNameLang,
      'bankData': instance.bankData,
      'bankInfo': instance.bankInfo,
      'singleAmount': instance.singleAmount,
      'code': instance.code,
      'recommend': instance.recommend,
      'createBy': instance.createBy,
      'createTime': instance.createTime,
      'updateBy': instance.updateBy,
      'updateTime': instance.updateTime,
      'remark': instance.remark,
      'appid': instance.appid,
      'appcode': instance.appcode,
      'merchantKey': instance.merchantKey,
    };
