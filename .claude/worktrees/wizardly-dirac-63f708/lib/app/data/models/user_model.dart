
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

/// 用户数据模型类
/// 用于处理用户信息的序列化和反序列化
@JsonSerializable()
class UserModel {
  @JsonKey(fromJson: _stringFromDynamic)  
  final String? userId;
  final String? userName;
  final String? avatar;
  final String? inviteCode;
  
  @JsonKey(fromJson: _intFromString)
  final int? points;
  
  @JsonKey(fromJson: _doubleFromString)
  final double? exchangeRate;
  
  final String? code;
  
  const UserModel({
    this.userId,
    this.userName,
    this.avatar,
    this.inviteCode,
    this.points,
    this.exchangeRate,
    this.code,
  });

  /// 从JSON创建用户模型
  factory UserModel.fromJson(Map<String, dynamic> json) {
    // 检查是否直接是用户数据（不包含外层的data字段）
    if (json.containsKey('userId') || json.containsKey('userName') || json.containsKey('avatar')) {
      return _$UserModelFromJson(json);
    }
    
    // 否则从data字段中提取用户数据
    final data = json['data'] as Map<String, dynamic>? ?? {};
    return _$UserModelFromJson(data);
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  /// 复制并修改用户信息
  UserModel copyWith({
    String? userId,
    String? userName,
    String? avatar,
    String? inviteCode,
    int? points,
    double? exchangeRate,
    String? code,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      avatar: avatar ?? this.avatar,
      inviteCode: inviteCode ?? this.inviteCode,
      points: points ?? this.points,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      code: code ?? this.code,
    );
  }

  @override
  String toString() {
    return 'UserModel{userId: $userId, userName: $userName, avatar: $avatar, inviteCode: $inviteCode, points: $points, exchangeRate: $exchangeRate, code: $code}';
  }
  
  // 自定义转换器
  static String? _stringFromDynamic(dynamic value) {
    if (value == null) return null;
    return value.toString();
  }
  
  static int? _intFromString(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
  
  static double? _doubleFromString(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}

/// API响应模型类
class ApiResponse<T> {
  final int code;
  final String msg;
  final T? data;

  const ApiResponse({
    required this.code,
    required this.msg,
    this.data,
  });

  bool get isSuccess => code == 200;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return ApiResponse(
      code: json['code'] as int? ?? 0,
      msg: json['msg'] as String? ?? '',
      data: json['data'] != null ? fromJsonT(json) : null,
    );
  }
}