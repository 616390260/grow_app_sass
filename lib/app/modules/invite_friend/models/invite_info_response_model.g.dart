// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite_info_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InviteInfoResponseModel _$InviteInfoResponseModelFromJson(
  Map<String, dynamic> json,
) => InviteInfoResponseModel(
  growth: (json['growth'] as num?)?.toInt(),
  registerDays: (json['registerDays'] as num?)?.toInt(),
  sendCount: (json['sendCount'] as num?)?.toInt(),
  user: json['user'] == null
      ? null
      : UserPaginationModel.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$InviteInfoResponseModelToJson(
  InviteInfoResponseModel instance,
) => <String, dynamic>{
  'growth': instance.growth,
  'registerDays': instance.registerDays,
  'sendCount': instance.sendCount,
  'user': instance.user,
};

UserPaginationModel _$UserPaginationModelFromJson(Map<String, dynamic> json) =>
    UserPaginationModel(
      records: (json['records'] as List<dynamic>?)
          ?.map((e) => InviteUserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt(),
      size: (json['size'] as num?)?.toInt(),
      current: (json['current'] as num?)?.toInt(),
      pages: (json['pages'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UserPaginationModelToJson(
  UserPaginationModel instance,
) => <String, dynamic>{
  'records': instance.records,
  'total': instance.total,
  'size': instance.size,
  'current': instance.current,
  'pages': instance.pages,
};

InviteUserModel _$InviteUserModelFromJson(Map<String, dynamic> json) =>
    InviteUserModel(
      id: (json['id'] as num?)?.toInt(),
      account: json['account'] as String?,
      phone: json['phone'] as String?,
      points: (json['points'] as num?)?.toInt(),
      inviteCode: json['inviteCode'] as String?,
      createTime: json['createTime'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$InviteUserModelToJson(InviteUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'account': instance.account,
      'phone': instance.phone,
      'points': instance.points,
      'inviteCode': instance.inviteCode,
      'createTime': instance.createTime,
      'status': instance.status,
    };
