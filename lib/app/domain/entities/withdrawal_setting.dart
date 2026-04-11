class WithdrawalSetting {
  final int? id;
  final int? oneDayNum;
  final int? maxPoints;
  final String? createTime;
  final String? updateTime;

  /// 用户本人或直系下属需发送的最少任务条数，满足才可提款
  final int? sendTaskNum;

  const WithdrawalSetting({
    this.id,
    this.oneDayNum,
    this.maxPoints,
    this.createTime,
    this.updateTime,
    this.sendTaskNum,
  });

  factory WithdrawalSetting.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const WithdrawalSetting();
    }
    return WithdrawalSetting(
      id: json['id'] as int?,
      oneDayNum: json['oneDayNum'] as int?,
      maxPoints: json['maxPoints'] as int?,
      createTime: json['createTime'] as String?,
      updateTime: json['updateTime'] as String?,
      sendTaskNum: json['sendTaskNum'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'oneDayNum': oneDayNum,
      'maxPoints': maxPoints,
      'createTime': createTime,
      'updateTime': updateTime,
      'sendTaskNum': sendTaskNum,
    };
  }
}
