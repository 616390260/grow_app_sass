
/// 积分记录模型类
class PointsRecord {
  final String id;
  final String type;
  final int points;
  final String description;
  final String createTime;

  PointsRecord({
    required this.id,
    required this.type,
    required this.points,
    required this.description,
    required this.createTime,
  });

  factory PointsRecord.fromJson(Map<String, dynamic> json) {
    return PointsRecord(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? '',
      points: json['points'] as int? ?? 0,
      description: json['description'] as String? ?? '',
      createTime: json['createTime'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'points': points,
      'description': description,
      'createTime': createTime,
    };
  }
}