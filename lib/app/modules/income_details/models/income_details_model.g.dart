// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'income_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IncomeDetailsModel _$IncomeDetailsModelFromJson(Map<String, dynamic> json) =>
    IncomeDetailsModel(
      records: (json['records'] as List<dynamic>)
          .map((e) => IncomeRecord.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      size: (json['size'] as num).toInt(),
      current: (json['current'] as num).toInt(),
      pages: (json['pages'] as num).toInt(),
    );

Map<String, dynamic> _$IncomeDetailsModelToJson(IncomeDetailsModel instance) =>
    <String, dynamic>{
      'records': instance.records,
      'total': instance.total,
      'size': instance.size,
      'current': instance.current,
      'pages': instance.pages,
    };

IncomeRecord _$IncomeRecordFromJson(Map<String, dynamic> json) => IncomeRecord(
  createBy: json['createBy'] as String?,
  createTime: json['createTime'] as String,
  updateBy: json['updateBy'] as String?,
  updateTime: json['updateTime'] as String,
  remark: json['remark'] as String?,
  id: (json['id'] as num).toInt(),
  userId: (json['userId'] as num).toInt(),
  inviteCode: json['inviteCode'] as String,
  userName: json['userName'] as String,
  type: json['type'] as String,
  typeName: json['typeName'] as String?,
  points: json['points'] as num,
  changeType: json['changeType'] as String,
  beforePoints: json['beforePoints'] as num,
  afterPoints: json['afterPoints'] as num,
  sourceId: (json['sourceId'] as num?)?.toInt(),
  agentLevel: json['agentLevel'] as String?,
  receiveStatus: json['receiveStatus'] as String,
  receiveTime: json['receiveTime'] as String?,
  boxId: (json['boxId'] as num?)?.toInt(),
  wsNumber: json['wsNumber'] as String?,
);

Map<String, dynamic> _$IncomeRecordToJson(IncomeRecord instance) =>
    <String, dynamic>{
      'createBy': instance.createBy,
      'createTime': instance.createTime,
      'updateBy': instance.updateBy,
      'updateTime': instance.updateTime,
      'remark': instance.remark,
      'id': instance.id,
      'userId': instance.userId,
      'inviteCode': instance.inviteCode,
      'userName': instance.userName,
      'type': instance.type,
      'typeName': instance.typeName,
      'points': instance.points,
      'changeType': instance.changeType,
      'beforePoints': instance.beforePoints,
      'afterPoints': instance.afterPoints,
      'sourceId': instance.sourceId,
      'agentLevel': instance.agentLevel,
      'receiveStatus': instance.receiveStatus,
      'receiveTime': instance.receiveTime,
      'boxId': instance.boxId,
      'wsNumber': instance.wsNumber,
    };
