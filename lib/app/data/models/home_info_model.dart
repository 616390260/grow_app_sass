import 'package:json_annotation/json_annotation.dart';

part 'home_info_model.g.dart';

/// 首页信息模型
@JsonSerializable()
class HomeInfoModel {
  /// 账户积分
  @JsonKey(name: 'accountPoints')
  final double? accountPoints;

  /// 公告列表（Banner列表）
  @JsonKey(name: 'announcement')
  final List<BannerModel>? announcements;

  /// 推荐任务列表
  @JsonKey(name: 'recommendTask')
  final List<RecommendTaskModel>? recommendTasks;

  /// 今日收入
  @JsonKey(name: 'todayIncome')
  final double? todayIncome;

  /// 今日推广收入
  @JsonKey(name: 'todayPromotionIncome')
  final double? todayPromotionIncome;

  /// VIP等级
  @JsonKey(name: 'vipLevel')
  final String? vipLevel;

  HomeInfoModel({
    this.accountPoints,
    this.announcements,
    this.recommendTasks,
    this.todayIncome,
    this.todayPromotionIncome,
    this.vipLevel,
  });

  factory HomeInfoModel.fromJson(Map<String, dynamic> json) =>
      _$HomeInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomeInfoModelToJson(this);
}

/// Banner模型
@JsonSerializable()
class BannerModel {
  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'title')
  final String? title;

  @JsonKey(name: 'image')
  final String? image;

  @JsonKey(name: 'hyperLink')
  final String? hyperLink;

  @JsonKey(name: 'iosHyperLink')
  final String? iosHyperLink;

  @JsonKey(name: 'sort')
  final int? sort;

  @JsonKey(name: 'status')
  final String? status;

  @JsonKey(name: 'createBy')
  final String? createBy;

  @JsonKey(name: 'createTime')
  final String? createTime;

  @JsonKey(name: 'updateBy')
  final String? updateBy;

  @JsonKey(name: 'updateTime')
  final String? updateTime;

  @JsonKey(name: 'remark')
  final String? remark;

  @JsonKey(name: 'delFlag')
  final String? delFlag;

  @JsonKey(name: 'params')
  final Map<String, dynamic>? params;

  BannerModel({
    this.id,
    this.title,
    this.image,
    this.hyperLink,
    this.iosHyperLink,
    this.sort,
    this.status,
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.remark,
    this.delFlag,
    this.params,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) =>
      _$BannerModelFromJson(json);

  Map<String, dynamic> toJson() => _$BannerModelToJson(this);
}

/// 推荐任务模型
@JsonSerializable()
class RecommendTaskModel {
  @JsonKey(name: 'createBy')
  final String? createBy;

  @JsonKey(name: 'createTime')
  final String? createTime;

  @JsonKey(name: 'delFlag')
  final String? delFlag;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'icon')
  final String? icon;

  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'params')
  final Map<String, dynamic>? params;

  @JsonKey(name: 'recommend')
  final String? recommend;

  @JsonKey(name: 'remark')
  final String? remark;

  @JsonKey(name: 'sort')
  final int? sort;

  @JsonKey(name: 'status')
  final String? status;

  @JsonKey(name: 'title')
  final String? title;

  @JsonKey(name: 'updateBy')
  final String? updateBy;

  @JsonKey(name: 'updateTime')
  final String? updateTime;

  RecommendTaskModel({
    this.createBy,
    this.createTime,
    this.delFlag,
    this.description,
    this.icon,
    this.id,
    this.params,
    this.recommend,
    this.remark,
    this.sort,
    this.status,
    this.title,
    this.updateBy,
    this.updateTime,
  });

  factory RecommendTaskModel.fromJson(Map<String, dynamic> json) =>
      _$RecommendTaskModelFromJson(json);

  Map<String, dynamic> toJson() => _$RecommendTaskModelToJson(this);
}

/// 任务列表响应模型
@JsonSerializable()
class TaskListResponse {
  @JsonKey(name: 'records')
  final List<RecommendTaskModel>? records;

  @JsonKey(name: 'total')
  final int? total;

  @JsonKey(name: 'size')
  final int? size;

  @JsonKey(name: 'current')
  final int? current;

  @JsonKey(name: 'orders')
  final List<dynamic>? orders;

  @JsonKey(name: 'optimizeCountSql')
  final bool? optimizeCountSql;

  @JsonKey(name: 'searchCount')
  final bool? searchCount;

  @JsonKey(name: 'maxLimit')
  final int? maxLimit;

  @JsonKey(name: 'countId')
  final String? countId;

  @JsonKey(name: 'pages')
  final int? pages;

  TaskListResponse({
    this.records,
    this.total,
    this.size,
    this.current,
    this.orders,
    this.optimizeCountSql,
    this.searchCount,
    this.maxLimit,
    this.countId,
    this.pages,
  });

  factory TaskListResponse.fromJson(Map<String, dynamic> json) =>
      _$TaskListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TaskListResponseToJson(this);
}

/// 旧的推荐任务模型（不再使用）
@JsonSerializable()
class OldRecommendTaskModel {
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

  OldRecommendTaskModel({
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

  factory OldRecommendTaskModel.fromJson(Map<String, dynamic> json) =>
      _$OldRecommendTaskModelFromJson(json);

  Map<String, dynamic> toJson() => _$OldRecommendTaskModelToJson(this);
}