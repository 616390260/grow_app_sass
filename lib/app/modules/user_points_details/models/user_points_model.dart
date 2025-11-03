import 'dart:convert';

/// 用户积分详情模型类
class UserPointsModel {
  final List<PointsRecord> records;
  final int total;
  final int size;
  final int current;
  final int pages;

  UserPointsModel({
    required this.records,
    required this.total,
    required this.size,
    required this.current,
    required this.pages,
  });

  factory UserPointsModel.fromJson(Map<String, dynamic> json) {
    // 根据API响应格式，可能需要从data字段中获取数据
    final data = json.containsKey('data') && json['data'] is Map<String, dynamic>
        ? json['data']
        : json;

    return UserPointsModel(
      records: (data['records'] as List<dynamic>?)?.map((record) => PointsRecord.fromJson(record as Map<String, dynamic>)).toList() ?? [],
      total: data['total'] as int? ?? 0,
      size: data['size'] as int? ?? 20,
      current: data['current'] as int? ?? 1,
      pages: data['pages'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'records': records.map((record) => record.toJson()).toList(),
      'total': total,
      'size': size,
      'current': current,
      'pages': pages,
    };
  }
}

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