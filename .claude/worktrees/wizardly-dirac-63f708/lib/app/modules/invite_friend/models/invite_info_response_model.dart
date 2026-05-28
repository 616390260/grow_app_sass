import 'package:json_annotation/json_annotation.dart';

part 'invite_info_response_model.g.dart';

/// 邀请信息响应模型
@JsonSerializable()
class InviteInfoResponseModel {
  @JsonKey(name: 'growth')
  final int? growth;
  
  @JsonKey(name: 'registerDays')
  final int? registerDays;
  
  @JsonKey(name: 'sendCount')
  final int? sendCount;
  
  @JsonKey(name: 'user')
  final UserPaginationModel? user;

  const InviteInfoResponseModel({
    this.growth,
    this.registerDays,
    this.sendCount,
    this.user,
  });

  factory InviteInfoResponseModel.fromJson(Map<String, dynamic> json) =>
      _$InviteInfoResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$InviteInfoResponseModelToJson(this);
}

/// 用户分页数据模型
@JsonSerializable()
class UserPaginationModel {
  @JsonKey(name: 'records')
  final List<InviteUserModel>? records;
  
  @JsonKey(name: 'total')
  final int? total;
  
  @JsonKey(name: 'size')
  final int? size;
  
  @JsonKey(name: 'current')
  final int? current;
  
  @JsonKey(name: 'pages')
  final int? pages;

  const UserPaginationModel({
    this.records,
    this.total,
    this.size,
    this.current,
    this.pages,
  });

  factory UserPaginationModel.fromJson(Map<String, dynamic> json) =>
      _$UserPaginationModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserPaginationModelToJson(this);
}

/// 邀请用户模型
@JsonSerializable()
class InviteUserModel {
  @JsonKey(name: 'id')
  final int? id;
  
  @JsonKey(name: 'account')
  final String? account;
  
  @JsonKey(name: 'phone')
  final String? phone;
  
  @JsonKey(name: 'points')
  final int? points;
  
  @JsonKey(name: 'inviteCode')
  final String? inviteCode;
  
  @JsonKey(name: 'createTime')
  final String? createTime;
  
  @JsonKey(name: 'status')
  final String? status;

  const InviteUserModel({
    this.id,
    this.account,
    this.phone,
    this.points,
    this.inviteCode,
    this.createTime,
    this.status,
  });

  factory InviteUserModel.fromJson(Map<String, dynamic> json) =>
      _$InviteUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$InviteUserModelToJson(this);
}