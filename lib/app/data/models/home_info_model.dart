import 'package:do_task_project/app/core/models/base_list_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'home_info_model.g.dart';

/// 首页信息模型
@JsonSerializable()
class HomeInfoModel {
  /// 拨打电话
  @JsonKey(name: 'domainName')
  final String? domainName;
  /// 账户积分
  @JsonKey(name: 'accountPoints')
  final int? accountPoints;

  /// 公告列表（Banner列表）
  @JsonKey(name: 'announcement')
  final List<BannerModel>? announcements;

  /// 推荐任务列表
  @JsonKey(name: 'recommendTask')
  final List<RecommendTaskModel>? recommendTasks;

  /// 今日收入
  @JsonKey(name: 'todayIncome')
  final int? todayIncome;

  /// 今日推广收入
  @JsonKey(name: 'todayPromotionIncome')
  final int? todayPromotionIncome;

  /// VIP等级
  @JsonKey(name: 'vipLevel')
  final String? vipLevel;

  HomeInfoModel({
    this.domainName,
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
class TaskListResponse extends BaseListEntity<RecommendTaskModel> {
  final List<dynamic>? orders;
  final bool? optimizeCountSql;
  final bool? searchCount;
  final int? maxLimit;
  final String? countId;

  TaskListResponse({
    required super.records,
    required super.total,
    required super.size,
    required super.current,
    required super.pages,
    this.orders,
    this.optimizeCountSql,
    this.searchCount,
    this.maxLimit,
    this.countId,
  });

  factory TaskListResponse.fromJson(Map<String, dynamic> json) {
    // 根据API响应格式，可能需要从data字段中获取数据
    final data = json.containsKey('data') && json['data'] is Map<String, dynamic>
        ? json['data']
        : json;

    return TaskListResponse(
      records: (data['records'] as List<dynamic>?)?.map((record) => RecommendTaskModel.fromJson(record as Map<String, dynamic>)).toList() ?? [],
      total: data['total'] as int? ?? 0,
      size: data['size'] as int? ?? 20,
      current: data['current'] as int? ?? 1,
      pages: data['pages'] as int? ?? 0,
      orders: data['orders'] as List<dynamic>?,
      optimizeCountSql: data['optimizeCountSql'] as bool?,
      searchCount: data['searchCount'] as bool?,
      maxLimit: data['maxLimit'] as int?,
      countId: data['countId'] as String?,
    );
  }



  @override
  TaskListResponse copyWith({
    List<RecommendTaskModel>? records,
    int? total,
    int? size,
    int? current,
    int? pages,
    List<dynamic>? orders,
    bool? optimizeCountSql,
    bool? searchCount,
    int? maxLimit,
    String? countId,
  }) {
    return TaskListResponse(
      records: records ?? this.records,
      total: total ?? this.total,
      size: size ?? this.size,
      current: current ?? this.current,
      pages: pages ?? this.pages,
      orders: orders ?? this.orders,
      optimizeCountSql: optimizeCountSql ?? this.optimizeCountSql,
      searchCount: searchCount ?? this.searchCount,
      maxLimit: maxLimit ?? this.maxLimit,
      countId: countId ?? this.countId,
    );
  }
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