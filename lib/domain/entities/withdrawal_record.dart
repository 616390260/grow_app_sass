/// 提现记录实体类
class WithdrawalRecord {
  final double? amount;
  final String? bankName;
  final String? cardName;
  final String? createTime;
  final double? fee;
  final String? finishTime;
  final int? goldenFlowInfoId;
  final int? id;
  final String? orderNo;
  final String? payCard;
  final String? payChannel;
  final String? payName;
  final double? points;
  final String? remark;
  final String? status;
  final String? thirdOrderNo;
  final String? updateTime;
  final int? userId;
  final String? userName;

  const WithdrawalRecord({
    this.amount,
    this.bankName,
    this.cardName,
    this.createTime,
    this.fee,
    this.finishTime,
    this.goldenFlowInfoId,
    this.id,
    this.orderNo,
    this.payCard,
    this.payChannel,
    this.payName,
    this.points,
    this.remark,
    this.status,
    this.thirdOrderNo,
    this.updateTime,
    this.userId,
    this.userName,
  });

  /// 从JSON创建WithdrawalRecord实例
  factory WithdrawalRecord.fromJson(Map<String, dynamic> json) {
    return WithdrawalRecord(
      amount: json['amount'] as double?,
      bankName: json['bankName'] as String?,
      cardName: json['cardName'] as String?,
      createTime: json['createTime'] as String?,
      fee: json['fee'] as double?,
      finishTime: json['finishTime'] as String?,
      goldenFlowInfoId: json['goldenFlowInfoId'] as int?,
      id: json['id'] as int?,
      orderNo: json['orderNo'] as String?,
      payCard: json['payCard'] as String?,
      payChannel: json['payChannel'] as String?,
      payName: json['payName'] as String?,
      points: json['points'] as double?,
      remark: json['remark'] as String?,
      status: json['status'] as String?,
      thirdOrderNo: json['thirdOrderNo'] as String?,
      updateTime: json['updateTime'] as String?,
      userId: json['userId'] as int?,
      userName: json['userName'] as String?,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'bankName': bankName,
      'cardName': cardName,
      'createTime': createTime,
      'fee': fee,
      'finishTime': finishTime,
      'goldenFlowInfoId': goldenFlowInfoId,
      'id': id,
      'orderNo': orderNo,
      'payCard': payCard,
      'payChannel': payChannel,
      'payName': payName,
      'points': points,
      'remark': remark,
      'status': status,
      'thirdOrderNo': thirdOrderNo,
      'updateTime': updateTime,
      'userId': userId,
      'userName': userName,
    };
  }

  /// 复制对象并修改指定字段
  WithdrawalRecord copyWith({
    double? amount,
    String? bankName,
    String? cardName,
    String? createTime,
    double? fee,
    String? finishTime,
    int? goldenFlowInfoId,
    int? id,
    String? orderNo,
    String? payCard,
    String? payChannel,
    String? payName,
    double? points,
    String? remark,
    String? status,
    String? thirdOrderNo,
    String? updateTime,
    int? userId,
    String? userName,
  }) {
    return WithdrawalRecord(
      amount: amount ?? this.amount,
      bankName: bankName ?? this.bankName,
      cardName: cardName ?? this.cardName,
      createTime: createTime ?? this.createTime,
      fee: fee ?? this.fee,
      finishTime: finishTime ?? this.finishTime,
      goldenFlowInfoId: goldenFlowInfoId ?? this.goldenFlowInfoId,
      id: id ?? this.id,
      orderNo: orderNo ?? this.orderNo,
      payCard: payCard ?? this.payCard,
      payChannel: payChannel ?? this.payChannel,
      payName: payName ?? this.payName,
      points: points ?? this.points,
      remark: remark ?? this.remark,
      status: status ?? this.status,
      thirdOrderNo: thirdOrderNo ?? this.thirdOrderNo,
      updateTime: updateTime ?? this.updateTime,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WithdrawalRecord &&
        other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'WithdrawalRecord(amount: $amount, bankName: $bankName, cardName: $cardName, createTime: $createTime, fee: $fee, finishTime: $finishTime, goldenFlowInfoId: $goldenFlowInfoId, id: $id, orderNo: $orderNo, payCard: $payCard, payChannel: $payChannel, payName: $payName, points: $points, remark: $remark, status: $status, thirdOrderNo: $thirdOrderNo, updateTime: $updateTime, userId: $userId, userName: $userName)';
  }
}