/// 推广数据实体类
class PromotionData {
  final int? activeSubordinates;
  final int? activeUsers;
  final String? inviteCode;
  final String? inviteUrl;
  final int? reachTwoStarUsers;
  final double? todayCommission;
  final int? todayNewSubordinates;
  final double? totalCommission;
  final int? twoStarRewardPoints;
  final double? yesterdayCommission;

  const PromotionData({
    this.activeSubordinates,
    this.activeUsers,
    this.inviteCode,
    this.inviteUrl,
    this.reachTwoStarUsers,
    this.todayCommission,
    this.todayNewSubordinates,
    this.totalCommission,
    this.twoStarRewardPoints,
    this.yesterdayCommission,
  });

  /// 从JSON创建PromotionData实例
  factory PromotionData.fromJson(Map<String, dynamic> json) {
    return PromotionData(
      activeSubordinates: json['activeSubordinates'] as int?,
      activeUsers: json['activeUsers'] as int?,
      inviteCode: json['inviteCode'] as String?,
      inviteUrl: json['inviteUrl'] as String?,
      reachTwoStarUsers: json['reachTwoStarUsers'] as int?,
      todayCommission: (json['todayCommission'] as num?)?.toDouble(),
      todayNewSubordinates: json['todayNewSubordinates'] as int?,
      totalCommission: (json['totalCommission'] as num?)?.toDouble(),
      twoStarRewardPoints: json['twoStarRewardPoints'] as int?,
      yesterdayCommission: (json['yesterdayCommission'] as num?)?.toDouble(),
    );
  }

  /// 复制对象并修改指定字段
  PromotionData copyWith({
    int? activeSubordinates,
    int? activeUsers,
    String? inviteCode,
    String? inviteUrl,
    int? reachTwoStarUsers,
    double? todayCommission,
    int? todayNewSubordinates,
    double? totalCommission,
    int? twoStarRewardPoints,
    double? yesterdayCommission,
  }) {
    return PromotionData(
      activeSubordinates: activeSubordinates ?? this.activeSubordinates,
      activeUsers: activeUsers ?? this.activeUsers,
      inviteCode: inviteCode ?? this.inviteCode,
      inviteUrl: inviteUrl ?? this.inviteUrl,
      reachTwoStarUsers: reachTwoStarUsers ?? this.reachTwoStarUsers,
      todayCommission: todayCommission ?? this.todayCommission,
      todayNewSubordinates: todayNewSubordinates ?? this.todayNewSubordinates,
      totalCommission: totalCommission ?? this.totalCommission,
      twoStarRewardPoints: twoStarRewardPoints ?? this.twoStarRewardPoints,
      yesterdayCommission: yesterdayCommission ?? this.yesterdayCommission,
    );
  }

  @override
  String toString() {
    return 'PromotionData(activeSubordinates: $activeSubordinates, activeUsers: $activeUsers, inviteCode: $inviteCode, inviteUrl: $inviteUrl, reachTwoStarUsers: $reachTwoStarUsers, todayCommission: $todayCommission, todayNewSubordinates: $todayNewSubordinates, totalCommission: $totalCommission, twoStarRewardPoints: $twoStarRewardPoints, yesterdayCommission: $yesterdayCommission)';
  }
}