import 'package:json_annotation/json_annotation.dart';

part 'valid_user_model.g.dart';

/// 有效用户模型
@JsonSerializable()
class ValidUserModel {
  @JsonKey(name: 'phone')
  final String? phone;
  
  @JsonKey(name: 'account')
  final String? account;
  
  @JsonKey(name: 'points')
  final int? points;
  
  @JsonKey(name: 'createTime')
  final String? createTime;
  
  @JsonKey(name: 'sendCount', defaultValue: 0)
  final int sendCount;

  const ValidUserModel({
    this.phone,
    this.account,
    this.points,
    this.createTime,
    this.sendCount = 0,
  });

  factory ValidUserModel.fromJson(Map<String, dynamic> json) =>
      _$ValidUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$ValidUserModelToJson(this);
}