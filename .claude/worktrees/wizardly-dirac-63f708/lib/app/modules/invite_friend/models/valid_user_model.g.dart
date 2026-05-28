// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'valid_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ValidUserModel _$ValidUserModelFromJson(Map<String, dynamic> json) =>
    ValidUserModel(
      phone: json['phone'] as String?,
      account: json['account'] as String?,
      points: (json['points'] as num?)?.toInt(),
      createTime: json['createTime'] as String?,
      sendCount: (json['sendCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ValidUserModelToJson(ValidUserModel instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'account': instance.account,
      'points': instance.points,
      'createTime': instance.createTime,
      'sendCount': instance.sendCount,
    };
