/// 收益记录模型类
class IncomeRecord {
  final String? createBy;
  final String createTime;
  final String? updateBy;
  final String updateTime;
  final String? remark;
  final int id;
  final int userId;
  final String inviteCode;
  final String userName;
  final String type;
  final String? typeName;
  final num points;
  final String changeType;
  final num beforePoints;
  final num afterPoints;
  final int? sourceId;
  final String? agentLevel;
  final String receiveStatus;
  final String? receiveTime;
  final int? boxId;
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

  factory IncomeRecord.fromJson(Map<String, dynamic> json) {
    return IncomeRecord(
      createBy: json['createBy']?.toString(),
      createTime: json['createTime']?.toString() ?? '',
      updateBy: json['updateBy']?.toString(),
      updateTime: json['updateTime']?.toString() ?? '',
      remark: json['remark']?.toString(),
      id: json['id'] is num ? (json['id'] as num).toInt() : 0,
      userId: json['userId'] is num ? (json['userId'] as num).toInt() : 0,
      inviteCode: json['inviteCode']?.toString() ?? '',
      userName: json['userName']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      typeName: json['typeName']?.toString(),
      points: json['points'] is num ? (json['points'] as num) : 0,
      changeType: json['changeType']?.toString() ?? '',
      beforePoints: json['beforePoints'] is num ? (json['beforePoints'] as num) : 0,
      afterPoints: json['afterPoints'] is num ? (json['afterPoints'] as num) : 0,
      sourceId: json['sourceId'] is num ? (json['sourceId'] as num).toInt() : null,
      agentLevel: json['agentLevel']?.toString(),
      receiveStatus: json['receiveStatus']?.toString() ?? '',
      receiveTime: json['receiveTime']?.toString(),
      boxId: json['boxId'] is num ? (json['boxId'] as num).toInt() : null,
      wsNumber: json['wsNumber']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createBy': createBy,
      'createTime': createTime,
      'updateBy': updateBy,
      'updateTime': updateTime,
      'remark': remark,
      'id': id,
      'userId': userId,
      'inviteCode': inviteCode,
      'userName': userName,
      'type': type,
      'typeName': typeName,
      'points': points,
      'changeType': changeType,
      'beforePoints': beforePoints,
      'afterPoints': afterPoints,
      'sourceId': sourceId,
      'agentLevel': agentLevel,
      'receiveStatus': receiveStatus,
      'receiveTime': receiveTime,
      'boxId': boxId,
      'wsNumber': wsNumber,
    };
  }

}