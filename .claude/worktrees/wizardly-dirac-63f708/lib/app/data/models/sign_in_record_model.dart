import 'dart:convert';

class SignInRecordModel {
  final int userId;
  final int checkInDays;
  final int continuousCheckInDays;
  final int points;
  final List<String> checkInDaysList;

  SignInRecordModel({
    required this.userId,
    required this.checkInDays,
    required this.continuousCheckInDays,
    required this.points,
    required this.checkInDaysList,
  });

  factory SignInRecordModel.fromJson(Map<String, dynamic> json) {
    // 检查是否在data字段中
    if (json.containsKey('data') && json['data'] is Map) {
      json = json['data'];
    }
    
    return SignInRecordModel(
      userId: json['userId'] ?? 0,
      checkInDays: json['checkInDays'] ?? 0,
      continuousCheckInDays: json['continuousCheckInDays'] ?? 0,
      points: json['points'] ?? 0,
      checkInDaysList: List<String>.from(json['checkInDaysList'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'checkInDays': checkInDays,
      'continuousCheckInDays': continuousCheckInDays,
      'points': points,
      'checkInDaysList': checkInDaysList,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}