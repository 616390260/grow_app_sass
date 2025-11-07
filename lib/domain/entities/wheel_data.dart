import 'package:do_task_project/domain/entities/winning_record.dart';

/// 转盘数据实体，包含奖品列表和用户积分信息
class WheelData {
  final List<WinningRecord> winningSettings;
  final int availablePoints;
  final int points;

  WheelData({
    required this.winningSettings,
    required this.availablePoints,
    required this.points,
  });

  /// 从JSON创建实例
  factory WheelData.fromJson(Map<String, dynamic> json) {
    final List<WinningRecord> winningSettingsList = [];
    
    // 处理可能嵌套在data字段中的数据
    Map<String, dynamic> data = json;
    if (json.containsKey('data') && json['data'] is Map<String, dynamic>) {
      data = json['data'] as Map<String, dynamic>;
    }
    
    // 解析奖品列表 - 直接使用winningSettings字段
    if (data.containsKey('winningSettings') && data['winningSettings'] is List) {
      final List<dynamic> records = data['winningSettings'];
      winningSettingsList.addAll(
        records.map((item) => WinningRecord.fromJson(item as Map<String, dynamic>)).toList(),
      );
    }
    
    // 获取积分信息 - 直接使用availablePoints和points字段
    final int availablePoints = (data['availablePoints'] is int) ? data['availablePoints'] : 0;
    final int points = (data['points'] is int) ? data['points'] : 10; // 默认10

    return WheelData(
      winningSettings: winningSettingsList,
      availablePoints: availablePoints,
      points: points,
    );
  }
}