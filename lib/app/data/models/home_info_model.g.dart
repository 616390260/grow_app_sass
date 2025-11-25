// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeInfoModel _$HomeInfoModelFromJson(Map<String, dynamic> json) =>
    HomeInfoModel(
      domainName: json['domainName'] as String?,
      accountPoints: (json['accountPoints'] as num?)?.toInt(),
      announcements: (json['announcement'] as List<dynamic>?)
          ?.map((e) => BannerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      sysAnnouncements: (json['sysAnnouncement'] as List<dynamic>?)
          ?.map(
            (e) => SystemAnnouncementModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(), 
      recommendTasks: (json['recommendTask'] as List<dynamic>?)
          ?.map((e) => RecommendTaskModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      todayIncome: (json['todayIncome'] as num?)?.toInt(),
      todayPromotionIncome: (json['todayPromotionIncome'] as num?)?.toInt(),
      vipLevel: json['vipLevel'] as String?,
      popupAnnouncement: json['popupAnnouncement'] == null
          ? null
          : PopupAnnouncementModel.fromJson(
              json['popupAnnouncement'] as Map<String, dynamic>,
            ),
     
    );

Map<String, dynamic> _$HomeInfoModelToJson(HomeInfoModel instance) =>
    <String, dynamic>{
      'domainName': instance.domainName,
      'accountPoints': instance.accountPoints,
      'announcement': instance.announcements,
      'recommendTask': instance.recommendTasks,
      'todayIncome': instance.todayIncome,
      'todayPromotionIncome': instance.todayPromotionIncome,
      'vipLevel': instance.vipLevel,
      'popupAnnouncement': instance.popupAnnouncement,
      'sysAnnouncement': instance.sysAnnouncements,
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

PopupAnnouncementModel _$PopupAnnouncementModelFromJson(
  Map<String, dynamic> json,
) => PopupAnnouncementModel(
  createBy: json['createBy'] as String?,
  createTime: json['createTime'] as String?,
  updateBy: json['updateBy'] as String?,
  updateTime: json['updateTime'] as String?,
  remark: json['remark'] as String?,
  id: (json['id'] as num?)?.toInt(),
  titleIsRichText: json['titleIsRichText'] as String?,
  contentIsRichText: json['contentIsRichText'] as String?,
  title: json['title'] as String?,
  content: json['content'] as String?,
  sort: (json['sort'] as num?)?.toInt(),
  status: json['status'] as String?,
  delFlag: json['delFlag'] as String?,
  type: json['type'] as String?,
  hyperLink: json['hyperLink'] as String?,
  iosHyperLink: json['iosHyperLink'] as String?,
  image: json['image'] as String?,
);

Map<String, dynamic> _$PopupAnnouncementModelToJson(
  PopupAnnouncementModel instance,
) => <String, dynamic>{
  'createBy': instance.createBy,
  'createTime': instance.createTime,
  'updateBy': instance.updateBy,
  'updateTime': instance.updateTime,
  'remark': instance.remark,
  'id': instance.id,
  'titleIsRichText': instance.titleIsRichText,
  'contentIsRichText': instance.contentIsRichText,
  'title': instance.title,
  'content': instance.content,
  'sort': instance.sort,
  'status': instance.status,
  'delFlag': instance.delFlag,
  'type': instance.type,
  'hyperLink': instance.hyperLink,
  'iosHyperLink': instance.iosHyperLink,
  'image': instance.image,
};

SystemAnnouncementModel _$SystemAnnouncementModelFromJson(
  Map<String, dynamic> json,
) => SystemAnnouncementModel(
  createBy: json['createBy'] as String?,
  createTime: json['createTime'] as String?,
  updateBy: json['updateBy'] as String?,
  updateTime: json['updateTime'] as String?,
  remark: json['remark'] as String?,
  id: (json['id'] as num?)?.toInt(),
  title: json['title'] as String?,
  content: json['content'] as String?,
  titleIsRichText: json['titleIsRichText'] as String?,
  contentIsRichText: json['contentIsRichText'] as String?,
  sort: (json['sort'] as num?)?.toInt(),
  status: json['status'] as String?,
  delFlag: json['delFlag'] as String?,
  type: json['type'] as String?,
  hyperLink: json['hyperLink'] as String?,
  iosHyperLink: json['iosHyperLink'] as String?,
  image: json['image'] as String?,
);

Map<String, dynamic> _$SystemAnnouncementModelToJson(
  SystemAnnouncementModel instance,
) => <String, dynamic>{
  'createBy': instance.createBy,
  'createTime': instance.createTime,
  'updateBy': instance.updateBy,
  'updateTime': instance.updateTime,
  'remark': instance.remark,
  'id': instance.id,
  'title': instance.title,
  'content': instance.content,
  'titleIsRichText': instance.titleIsRichText,
  'contentIsRichText': instance.contentIsRichText,
  'sort': instance.sort,
  'status': instance.status,
  'delFlag': instance.delFlag,
  'type': instance.type,
  'hyperLink': instance.hyperLink,
  'iosHyperLink': instance.iosHyperLink,
  'image': instance.image,
};
