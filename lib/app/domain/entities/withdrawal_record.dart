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
}
