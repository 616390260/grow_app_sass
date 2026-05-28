import 'winning_record.dart';

class WheelData {
  final List<WinningRecord> winningSettings;
  final int availablePoints;
  final int points;

  WheelData({
    required this.winningSettings,
    required this.availablePoints,
    required this.points,
  });

  factory WheelData.fromJson(Map<String, dynamic> json) {
    final List<WinningRecord> winningSettingsList = [];
    Map<String, dynamic> data = json;
    if (json.containsKey('data') && json['data'] is Map<String, dynamic>) {
      data = json['data'] as Map<String, dynamic>;
    }
    if (data.containsKey('winningSettings') && data['winningSettings'] is List) {
      final List<dynamic> records = data['winningSettings'];
      winningSettingsList.addAll(
        records.map((item) => WinningRecord.fromJson(item as Map<String, dynamic>)).toList(),
      );
    }
    final int availablePoints = (data['availablePoints'] is int) ? data['availablePoints'] : 0;
    final int points = (data['points'] is int) ? data['points'] : 10;
    return WheelData(
      winningSettings: winningSettingsList,
      availablePoints: availablePoints,
      points: points,
    );
  }
}
