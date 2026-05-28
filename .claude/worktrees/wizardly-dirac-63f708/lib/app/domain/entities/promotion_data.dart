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
  final bool? isReceived;

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
    this.isReceived,
  });

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
      isReceived: json['isReceived'] as bool?,
    );
  }
}
