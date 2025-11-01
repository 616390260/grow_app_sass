// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeInfoModel _$HomeInfoModelFromJson(Map<String, dynamic> json) =>
    HomeInfoModel(
      accountPoints: (json['accountPoints'] as num).toDouble(),
      announcements: (json['announcement'] as List<dynamic>)
          .map((e) => AnnouncementModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      recommendTasks: (json['recommendTask'] as List<dynamic>)
          .map((e) => RecommendTaskModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      todayIncome: (json['todayIncome'] as num).toDouble(),
      todayPromotionIncome: (json['todayPromotionIncome'] as num).toDouble(),
      vipLevel: json['vipLevel'] as String,
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

AnnouncementModel _$AnnouncementModelFromJson(Map<String, dynamic> json) =>
    AnnouncementModel(
      content: json['content'] as String,
      createBy: json['createBy'] as String,
      createTime: json['createTime'] as String,
      delFlag: json['delFlag'] as String,
      hyperLink: json['hyperLink'] as String,
      id: (json['id'] as num).toInt(),
      image: json['image'] as String,
      iosHyperLink: json['iosHyperLink'] as String,
      params: json['params'] as Map<String, dynamic>,
      remark: json['remark'] as String,
      sort: (json['sort'] as num).toInt(),
      status: json['status'] as String,
      title: json['title'] as String,
      type: json['type'] as String,
      updateBy: json['updateBy'] as String,
      updateTime: json['updateTime'] as String,
    );

Map<String, dynamic> _$AnnouncementModelToJson(AnnouncementModel instance) =>
    <String, dynamic>{
      'content': instance.content,
      'createBy': instance.createBy,
      'createTime': instance.createTime,
      'delFlag': instance.delFlag,
      'hyperLink': instance.hyperLink,
      'id': instance.id,
      'image': instance.image,
      'iosHyperLink': instance.iosHyperLink,
      'params': instance.params,
      'remark': instance.remark,
      'sort': instance.sort,
      'status': instance.status,
      'title': instance.title,
      'type': instance.type,
      'updateBy': instance.updateBy,
      'updateTime': instance.updateTime,
    };

RecommendTaskModel _$RecommendTaskModelFromJson(Map<String, dynamic> json) =>
    RecommendTaskModel(
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
