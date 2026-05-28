// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vip_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VipDetailsModel _$VipDetailsModelFromJson(Map<String, dynamic> json) =>
    VipDetailsModel(
      vipLevel: json['vipLevel'] as String,
      points: (json['points'] as num).toInt(),
      nextVipLevel: json['nextVipLevel'] as String,
      promotionPoints: (json['promotionPoints'] as num).toInt(),
      currentPullNum: (json['currentPullNum'] as num).toInt(),
      subordinatePullNum: (json['subordinatePullNum'] as num).toInt(),
      vipLevelList: (json['vipLevelList'] as List<dynamic>)
          .map((e) => VipLevelItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      vipTodayLevelList: (json['vipTodayLevelList'] as List<dynamic>)
          .map((e) => VipLevelItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentVipLevel: json['currentVipLevel'] as String,
      totalPromotionPoints: (json['totalPromotionPoints'] as num).toInt(),
    );

Map<String, dynamic> _$VipDetailsModelToJson(VipDetailsModel instance) =>
    <String, dynamic>{
      'vipLevel': instance.vipLevel,
      'points': instance.points,
      'nextVipLevel': instance.nextVipLevel,
      'promotionPoints': instance.promotionPoints,
      'currentPullNum': instance.currentPullNum,
      'subordinatePullNum': instance.subordinatePullNum,
      'vipLevelList': instance.vipLevelList,
      'vipTodayLevelList': instance.vipTodayLevelList,
      'currentVipLevel': instance.currentVipLevel,
      'totalPromotionPoints': instance.totalPromotionPoints,
    };

VipLevelItemModel _$VipLevelItemModelFromJson(Map<String, dynamic> json) =>
    VipLevelItemModel(
      id: (json['id'] as num?)?.toInt(),
      vipLevel: json['vipLevel'] as String?,
      promotionPoints: (json['promotionPoints'] as num?)?.toInt(),
      firstRewardPoints: (json['firstRewardPoints'] as num?)?.toInt(),
      rewardPoints: (json['rewardPoints'] as num?)?.toInt(),
      isActivated: json['isActivated'] as bool?,
      isReceived: json['isReceived'] as bool?,
    );

Map<String, dynamic> _$VipLevelItemModelToJson(VipLevelItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vipLevel': instance.vipLevel,
      'promotionPoints': instance.promotionPoints,
      'firstRewardPoints': instance.firstRewardPoints,
      'rewardPoints': instance.rewardPoints,
      'isActivated': instance.isActivated,
      'isReceived': instance.isReceived,
    };
