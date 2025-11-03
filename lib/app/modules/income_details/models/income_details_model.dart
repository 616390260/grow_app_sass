import 'package:json_annotation/json_annotation.dart';

part 'income_details_model.g.dart';

/// 收益明细模型类
@JsonSerializable()
class IncomeDetailsModel {
  @JsonKey(name: 'records')
  final List<IncomeRecord> records;
  
  @JsonKey(name: 'total')
  final int total;
  
  @JsonKey(name: 'size')
  final int size;
  
  @JsonKey(name: 'current')
  final int current;
  
  @JsonKey(name: 'pages')
  final int pages;

  IncomeDetailsModel({
    required this.records,
    required this.total,
    required this.size,
    required this.current,
    required this.pages,
  });

  factory IncomeDetailsModel.fromJson(Map<String, dynamic> json) => _$IncomeDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$IncomeDetailsModelToJson(this);
}

/// 收益记录模型类
@JsonSerializable()
class IncomeRecord {
  @JsonKey(name: 'createBy')
  final String? createBy;
  
  @JsonKey(name: 'createTime')
  final String createTime;
  
  @JsonKey(name: 'updateBy')
  final String? updateBy;
  
  @JsonKey(name: 'updateTime')
  final String updateTime;
  
  @JsonKey(name: 'remark')
  final String? remark;
  
  @JsonKey(name: 'id')
  final int id;
  
  @JsonKey(name: 'userId')
  final int userId;
  
  @JsonKey(name: 'inviteCode')
  final String inviteCode;
  
  @JsonKey(name: 'userName')
  final String userName;
  
  @JsonKey(name: 'type')
  final String type;
  
  @JsonKey(name: 'typeName')
  final String? typeName;
  
  @JsonKey(name: 'points')
  final num points;
  
  @JsonKey(name: 'changeType')
  final String changeType;
  
  @JsonKey(name: 'beforePoints')
  final num beforePoints;
  
  @JsonKey(name: 'afterPoints')
  final num afterPoints;
  
  @JsonKey(name: 'sourceId')
  final int? sourceId;
  
  @JsonKey(name: 'agentLevel')
  final String? agentLevel;
  
  @JsonKey(name: 'receiveStatus')
  final String receiveStatus;
  
  @JsonKey(name: 'receiveTime')
  final String? receiveTime;
  
  @JsonKey(name: 'boxId')
  final int? boxId;
  
  @JsonKey(name: 'wsNumber')
  final String? wsNumber;

  IncomeRecord({
    this.createBy,
    required this.createTime,
    this.updateBy,
    required this.updateTime,
    this.remark,
    required this.id,
    required this.userId,
    required this.inviteCode,
    required this.userName,
    required this.type,
    this.typeName,
    required this.points,
    required this.changeType,
    required this.beforePoints,
    required this.afterPoints,
    this.sourceId,
    this.agentLevel,
    required this.receiveStatus,
    this.receiveTime,
    this.boxId,
    this.wsNumber,
  });

  factory IncomeRecord.fromJson(Map<String, dynamic> json) => _$IncomeRecordFromJson(json);

  Map<String, dynamic> toJson() => _$IncomeRecordToJson(this);
}