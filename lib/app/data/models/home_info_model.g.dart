// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeInfoModel _$HomeInfoModelFromJson(Map<String, dynamic> json) =>
    HomeInfoModel(
      accountPoints: (json['accountPoints'] as num?)?.toDouble(),
      announcements: (json['announcement'] as List<dynamic>?)
          ?.map((e) => BannerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      recommendTasks: (json['recommendTask'] as List<dynamic>?)
          ?.map((e) => RecommendTaskModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      todayIncome: (json['todayIncome'] as num?)?.toDouble(),
      todayPromotionIncome: (json['todayPromotionIncome'] as num?)?.toDouble(),
      vipLevel: json['vipLevel'] as String?,
    );

Map<String, dynamic> _$HomeInfoModelToJson(HomeInfoModel instance) =>
    <String, dynamic>{
      'accountPoints': instance.accountPoints,
      'announcement': instance.announcements,
      'recommendTask': instance.recommendTasks,
      'todayIncome': instance.todayIncome,
      'todayPromotionIncome': instance.todayPromotionIncome,
      'vipLevel': instance.vipLevel,
    };

BannerModel _$BannerModelFromJson(Map<String, dynamic> json) => BannerModel(
  id: (json['id'] as num?)?.toInt(),
  title: json['title'] as String?,
  image: json['image'] as String?,
  hyperLink: json['hyperLink'] as String?,
  iosHyperLink: json['iosHyperLink'] as String?,
  sort: (json['sort'] as num?)?.toInt(),
  status: json['status'] as String?,
  createBy: json['createBy'] as String?,
  createTime: json['createTime'] as String?,
  updateBy: json['updateBy'] as String?,
  updateTime: json['updateTime'] as String?,
  remark: json['remark'] as String?,
  delFlag: json['delFlag'] as String?,
  params: json['params'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$BannerModelToJson(BannerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'image': instance.image,
      'hyperLink': instance.hyperLink,
      'iosHyperLink': instance.iosHyperLink,
      'sort': instance.sort,
      'status': instance.status,
      'createBy': instance.createBy,
      'createTime': instance.createTime,
      'updateBy': instance.updateBy,
      'updateTime': instance.updateTime,
      'remark': instance.remark,
      'delFlag': instance.delFlag,
      'params': instance.params,
    };

RecommendTaskModel _$RecommendTaskModelFromJson(Map<String, dynamic> json) =>
    RecommendTaskModel(
      createBy: json['createBy'] as String?,
      createTime: json['createTime'] as String?,
      delFlag: json['delFlag'] as String?,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      id: (json['id'] as num?)?.toInt(),
      params: json['params'] as Map<String, dynamic>?,
      recommend: json['recommend'] as String?,
      remark: json['remark'] as String?,
      sort: (json['sort'] as num?)?.toInt(),
      status: json['status'] as String?,
      title: json['title'] as String?,
      updateBy: json['updateBy'] as String?,
      updateTime: json['updateTime'] as String?,
    );

Map<String, dynamic> _$RecommendTaskModelToJson(RecommendTaskModel instance) =>
    <String, dynamic>{
      'createBy': instance.createBy,
      'createTime': instance.createTime,
      'delFlag': instance.delFlag,
      'description': instance.description,
      'icon': instance.icon,
      'id': instance.id,
      'params': instance.params,
      'recommend': instance.recommend,
      'remark': instance.remark,
      'sort': instance.sort,
      'status': instance.status,
      'title': instance.title,
      'updateBy': instance.updateBy,
      'updateTime': instance.updateTime,
    };

TaskListResponse _$TaskListResponseFromJson(Map<String, dynamic> json) =>
    TaskListResponse(
      records: (json['records'] as List<dynamic>?)
          ?.map((e) => RecommendTaskModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt(),
      size: (json['size'] as num?)?.toInt(),
      current: (json['current'] as num?)?.toInt(),
      orders: json['orders'] as List<dynamic>?,
      optimizeCountSql: json['optimizeCountSql'] as bool?,
      searchCount: json['searchCount'] as bool?,
      maxLimit: (json['maxLimit'] as num?)?.toInt(),
      countId: json['countId'] as String?,
      pages: (json['pages'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TaskListResponseToJson(TaskListResponse instance) =>
    <String, dynamic>{
      'records': instance.records,
      'total': instance.total,
      'size': instance.size,
      'current': instance.current,
      'orders': instance.orders,
      'optimizeCountSql': instance.optimizeCountSql,
      'searchCount': instance.searchCount,
      'maxLimit': instance.maxLimit,
      'countId': instance.countId,
      'pages': instance.pages,
    };

OldRecommendTaskModel _$OldRecommendTaskModelFromJson(
  Map<String, dynamic> json,
) => OldRecommendTaskModel(
  createBy: json['createBy'] as String,
  createTime: json['createTime'] as String,
  delFlag: json['delFlag'] as String,
  description: json['description'] as String,
  icon: json['icon'] as String,
  id: (json['id'] as num).toInt(),
  params: json['params'] as Map<String, dynamic>,
  recommend: json['recommend'] as String,
  remark: json['remark'] as String,
  sort: (json['sort'] as num).toInt(),
  status: json['status'] as String,
  title: json['title'] as String,
  updateBy: json['updateBy'] as String,
  updateTime: json['updateTime'] as String,
);

Map<String, dynamic> _$OldRecommendTaskModelToJson(
  OldRecommendTaskModel instance,
) => <String, dynamic>{
  'createBy': instance.createBy,
  'createTime': instance.createTime,
  'delFlag': instance.delFlag,
  'description': instance.description,
  'icon': instance.icon,
  'id': instance.id,
  'params': instance.params,
  'recommend': instance.recommend,
  'remark': instance.remark,
  'sort': instance.sort,
  'status': instance.status,
  'title': instance.title,
  'updateBy': instance.updateBy,
  'updateTime': instance.updateTime,
};
