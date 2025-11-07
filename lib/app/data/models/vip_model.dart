import 'package:json_annotation/json_annotation.dart';

part 'vip_model.g.dart';

/// VIP详情数据模型
@JsonSerializable()
class VipDetailsModel {
  @JsonKey(name: 'vipLevel')
  final String vipLevel;

  @JsonKey(name: 'points')
  final double points;

  @JsonKey(name: 'nextVipLevel')
  final String nextVipLevel;

  @JsonKey(name: 'promotionPoints')
  final int promotionPoints;

  @JsonKey(name: 'currentPullNum')
  final int currentPullNum;

  @JsonKey(name: 'subordinatePullNum')
  final int subordinatePullNum;

  @JsonKey(name: 'vipLevelList')
  final List<VipLevelItemModel> vipLevelList;

  @JsonKey(name: 'vipTodayLevelList')
  final List<VipLevelItemModel> vipTodayLevelList;

  @JsonKey(name: 'currentVipLevel')
  final String currentVipLevel;

  @JsonKey(name: 'totalPromotionPoints')
  final int totalPromotionPoints;

  VipDetailsModel({
    required this.vipLevel,
    required this.points,
    required this.nextVipLevel,
    required this.promotionPoints,
    required this.currentPullNum,
    required this.subordinatePullNum,
    required this.vipLevelList,
    required this.vipTodayLevelList,
    required this.currentVipLevel,
    required this.totalPromotionPoints,
  });

  factory VipDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$VipDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$VipDetailsModelToJson(this);
}

/// VIP等级列表项数据模型
@JsonSerializable()
class VipLevelItemModel {
  @JsonKey(name: 'vipLevel')
  final String? vipLevel;

  @JsonKey(name: 'promotionPoints')
  final int? promotionPoints;

  @JsonKey(name: 'firstRewardPoints')
  final int? firstRewardPoints;

  @JsonKey(name: 'rewardPoints')
  final int? rewardPoints;

  @JsonKey(name: 'isActivated')
  final bool? isActivated;

  @JsonKey(name: 'isReceived')
  final bool? isReceived;

  VipLevelItemModel({
    this.vipLevel,
    this.promotionPoints,
    this.firstRewardPoints,
    this.rewardPoints,
    this.isActivated,
    this.isReceived,
  });

  factory VipLevelItemModel.fromJson(Map<String, dynamic> json) =>
      _$VipLevelItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$VipLevelItemModelToJson(this);
}

