import 'package:json_annotation/json_annotation.dart';

part 'home_info_model.g.dart';

/// 首页信息模型
@JsonSerializable()
class HomeInfoModel {
  /// 账户积分
  @JsonKey(name: 'accountPoints')
  final double accountPoints;

  /// 公告列表
  @JsonKey(name: 'announcement')
  final List<AnnouncementModel> announcements;

  /// 推荐任务列表
  @JsonKey(name: 'recommendTask')
  final List<RecommendTaskModel> recommendTasks;

  /// 今日收入
  @JsonKey(name: 'todayIncome')
  final double todayIncome;

  /// 今日推广收入
  @JsonKey(name: 'todayPromotionIncome')
  final double todayPromotionIncome;

  /// VIP等级
  @JsonKey(name: 'vipLevel')
  final String vipLevel;

  HomeInfoModel({
    required this.accountPoints,
    required this.announcements,
    required this.recommendTasks,
    required this.todayIncome,
    required this.todayPromotionIncome,
    required this.vipLevel,
  });

  factory HomeInfoModel.fromJson(Map<String, dynamic> json) =>
      _$HomeInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomeInfoModelToJson(this);
}

/// 公告模型
@JsonSerializable()
class AnnouncementModel {
  @JsonKey(name: 'content')
  final String content;

  @JsonKey(name: 'createBy')
  final String createBy;

  @JsonKey(name: 'createTime')
  final String createTime;

  @JsonKey(name: 'delFlag')
  final String delFlag;

  @JsonKey(name: 'hyperLink')
  final String hyperLink;

  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'image')
  final String image;

  @JsonKey(name: 'iosHyperLink')
  final String iosHyperLink;

  @JsonKey(name: 'params')
  final Map<String, dynamic> params;

  @JsonKey(name: 'remark')
  final String remark;

  @JsonKey(name: 'sort')
  final int sort;

  @JsonKey(name: 'status')
  final String status;

  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'type')
  final String type;

  @JsonKey(name: 'updateBy')
  final String updateBy;

  @JsonKey(name: 'updateTime')
  final String updateTime;

  AnnouncementModel({
    required this.content,
    required this.createBy,
    required this.createTime,
    required this.delFlag,
    required this.hyperLink,
    required this.id,
    required this.image,
    required this.iosHyperLink,
    required this.params,
    required this.remark,
    required this.sort,
    required this.status,
    required this.title,
    required this.type,
    required this.updateBy,
    required this.updateTime,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementModelFromJson(json);

  Map<String, dynamic> toJson() => _$AnnouncementModelToJson(this);
}

/// 推荐任务模型
@JsonSerializable()
class RecommendTaskModel {
  @JsonKey(name: 'createBy')
  final String createBy;

  @JsonKey(name: 'createTime')
  final String createTime;

  @JsonKey(name: 'delFlag')
  final String delFlag;

  @JsonKey(name: 'description')
  final String description;

  @JsonKey(name: 'icon')
  final String icon;

  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'params')
  final Map<String, dynamic> params;

  @JsonKey(name: 'recommend')
  final String recommend;

  @JsonKey(name: 'remark')
  final String remark;

  @JsonKey(name: 'sort')
  final int sort;

  @JsonKey(name: 'status')
  final String status;

  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'updateBy')
  final String updateBy;

  @JsonKey(name: 'updateTime')
  final String updateTime;

  RecommendTaskModel({
    required this.createBy,
    required this.createTime,
    required this.delFlag,
    required this.description,
    required this.icon,
    required this.id,
    required this.params,
    required this.recommend,
    required this.remark,
    required this.sort,
    required this.status,
    required this.title,
    required this.updateBy,
    required this.updateTime,
  });

  factory RecommendTaskModel.fromJson(Map<String, dynamic> json) =>
      _$RecommendTaskModelFromJson(json);

  Map<String, dynamic> toJson() => _$RecommendTaskModelToJson(this);
}