/// 提现配置实体类
class WithdrawalSetting {
  final int? id;
  final int? oneDayNum;
  final int? maxPoints;
  final String? createTime;
  final String? updateTime;

  /// 构造函数，所有字段都可为空
  const WithdrawalSetting({
    this.id,
    this.oneDayNum,
    this.maxPoints,
    this.createTime,
    this.updateTime,
  });

  /// 从JSON创建WithdrawalSetting实例，兼容空值
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

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'oneDayNum': oneDayNum,
      'maxPoints': maxPoints,
      'createTime': createTime,
      'updateTime': updateTime,
    };
  }

  @override
  String toString() {
    return 'WithdrawalSetting{id: $id, oneDayNum: $oneDayNum, maxPoints: $maxPoints, createTime: $createTime, updateTime: $updateTime}';
  }
}