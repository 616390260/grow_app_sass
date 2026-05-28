// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  userId: UserModel._stringFromDynamic(json['userId']),
  userName: json['userName'] as String?,
  avatar: json['avatar'] as String?,
  inviteCode: json['inviteCode'] as String?,
  points: UserModel._intFromString(json['points']),
  exchangeRate: UserModel._doubleFromString(json['exchangeRate']),
  code: json['code'] as String?,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'userId': instance.userId,
  'userName': instance.userName,
  'avatar': instance.avatar,
  'inviteCode': instance.inviteCode,
  'points': instance.points,
  'exchangeRate': instance.exchangeRate,
  'code': instance.code,
};
