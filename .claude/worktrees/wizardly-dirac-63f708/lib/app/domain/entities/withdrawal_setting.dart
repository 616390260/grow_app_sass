class WithdrawalSetting {
  final int? id;
  final int? oneDayNum;
  final int? maxPoints;
  final String? createTime;
  final String? updateTime;

  const WithdrawalSetting({
    this.id,
    this.oneDayNum,
    this.maxPoints,
    this.createTime,
    this.updateTime,
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'oneDayNum': oneDayNum,
      'maxPoints': maxPoints,
      'createTime': createTime,
      'updateTime': updateTime,
    };
  }
}
