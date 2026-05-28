// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_list_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseListEntity<T> _$BaseListEntityFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => BaseListEntity<T>(
  records: (json['records'] as List<dynamic>).map(fromJsonT).toList(),
  total: (json['total'] as num).toInt(),
  size: (json['size'] as num).toInt(),
  current: (json['current'] as num).toInt(),
  pages: (json['pages'] as num).toInt(),
);

Map<String, dynamic> _$BaseListEntityToJson<T>(
  BaseListEntity<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'records': instance.records.map(toJsonT).toList(),
  'total': instance.total,
  'size': instance.size,
  'current': instance.current,
  'pages': instance.pages,
};
