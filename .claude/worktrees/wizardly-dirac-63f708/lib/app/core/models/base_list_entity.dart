import 'package:json_annotation/json_annotation.dart';

part 'base_list_entity.g.dart';

/// 通用分页响应模型
@JsonSerializable(genericArgumentFactories: true)
class BaseListEntity<T> {
  @JsonKey(name: 'records')
  final List<T> records;
  
  @JsonKey(name: 'total')
  final int total;
  
  @JsonKey(name: 'size')
  final int size;
  
  @JsonKey(name: 'current')
  final int current;
  
  @JsonKey(name: 'pages')
  final int pages;

  BaseListEntity({
    required this.records,
    required this.total,
    required this.size,
    required this.current,
    required this.pages,
  });

  /// 从JSON创建BaseListEntity实例
  factory BaseListEntity.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$BaseListEntityFromJson(json, fromJsonT);

  /// 转换为JSON
  Map<String, dynamic> toJson(
    Object? Function(T value) toJsonT,
  ) => _$BaseListEntityToJson(this, toJsonT);

  /// 安全地从JSON创建BaseListEntity实例，处理空响应或null records的情况
  factory BaseListEntity.fromJsonSafe(
    Map<String, dynamic>? json,
    T Function(Object? json) fromJsonT, {
    List<T>? defaultRecords,
  }) {
    // 如果json为空，返回默认实例
    if (json == null) {
      return BaseListEntity<T>(
        records: defaultRecords ?? <T>[],
        total: 0,
        size: 0,
        current: 1,
        pages: 0,
      );
    }

    // 检查是否存在records字段
    if (!json.containsKey('records')) {
      return BaseListEntity<T>(
        records: defaultRecords ?? <T>[],
        total: 0,
        size: 0,
        current: 1,
        pages: 0,
      );
    }

    // 检查records是否为null
    final recordsData = json['records'];
    if (recordsData == null) {
      return BaseListEntity<T>(
        records: defaultRecords ?? <T>[],
        total: json['total'] is num ? (json['total'] as num).toInt() : 0,
        size: json['size'] is num ? (json['size'] as num).toInt() : 0,
        current: json['current'] is num ? (json['current'] as num).toInt() : 1,
        pages: json['pages'] is num ? (json['pages'] as num).toInt() : 0,
      );
    }

    // 如果records不是List类型，返回默认实例
    if (recordsData is! List) {
      return BaseListEntity<T>(
        records: defaultRecords ?? <T>[],
        total: json['total'] is num ? (json['total'] as num).toInt() : 0,
        size: json['size'] is num ? (json['size'] as num).toInt() : 0,
        current: json['current'] is num ? (json['current'] as num).toInt() : 1,
        pages: json['pages'] is num ? (json['pages'] as num).toInt() : 0,
      );
    }

    // 正常转换
    return BaseListEntity<T>(
      records: recordsData.map(fromJsonT).toList(),
      total: json['total'] is num ? (json['total'] as num).toInt() : 0,
      size: json['size'] is num ? (json['size'] as num).toInt() : 0,
      current: json['current'] is num ? (json['current'] as num).toInt() : 1,
      pages: json['pages'] is num ? (json['pages'] as num).toInt() : 0,
    );
  }

  /// 复制对象并修改指定字段
  BaseListEntity<T> copyWith({
    List<T>? records,
    int? total,
    int? size,
    int? current,
    int? pages,
  }) {
    return BaseListEntity<T>(
      records: records ?? this.records,
      total: total ?? this.total,
      size: size ?? this.size,
      current: current ?? this.current,
      pages: pages ?? this.pages,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BaseListEntity<T> &&
        other.records == records &&
        other.total == total &&
        other.size == size &&
        other.current == current &&
        other.pages == pages;
  }

  @override
  int get hashCode {
    return Object.hash(
      records,
      total,
      size,
      current,
      pages,
    );
  }

  @override
  String toString() {
    return 'PaginatedResponse(records: $records, total: $total, size: $size, current: $current, pages: $pages)';
  }
}