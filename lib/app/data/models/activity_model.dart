/// 单个活动档位数据模型
class ActivityItem {
  final int id;
  final String type;

  /// 需要达到的目标值
  final int needCount;

  /// 达标后可领取的积分
  final int rewardPoints;

  /// 仅下属活动有值：下属当日发信 >= 此数才算活跃
  final int? activeMessageCount;

  /// 用户当前进度值
  final int currentCount;

  /// 该档位今日是否已领取
  final bool claimed;

  /// 是否可领取（达到条件且未领取）
  final bool canClaim;

  /// 排序值
  final int sort;

  const ActivityItem({
    required this.id,
    required this.type,
    required this.needCount,
    required this.rewardPoints,
    this.activeMessageCount,
    required this.currentCount,
    required this.claimed,
    required this.canClaim,
    required this.sort,
  });

  factory ActivityItem.fromJson(Map<String, dynamic> json) {
    return ActivityItem(
      id: json['id'] as int,
      type: json['type'] as String,
      needCount: json['needCount'] as int,
      rewardPoints: json['rewardPoints'] as int,
      activeMessageCount: json['activeMessageCount'] as int?,
      currentCount: json['currentCount'] as int,
      claimed: json['claimed'] as bool,
      canClaim: json['canClaim'] as bool,
      sort: json['sort'] as int? ?? 0,
    );
  }

  /// 进度比例 0.0 ~ 1.0
  double get progress =>
      needCount > 0 ? (currentCount / needCount).clamp(0.0, 1.0) : 0.0;
}

/// 同类型活动分组（包含多个里程碑档位）
class ActivityGroup {
  final String type;

  /// 奖励类型
  /// - "0"：每个档位独立进度+领取按钮，可多次领取
  /// - "1"：整体一条进度条，只能领取一次
  final String rewardType;

  /// 用户当前该类型的总进度
  final int currentCount;

  /// 各档位里程碑列表（按 sort 升序）
  final List<ActivityItem> items;

  const ActivityGroup({
    required this.type,
    required this.rewardType,
    required this.currentCount,
    required this.items,
  });

  /// 是否为整体单次领取模式
  bool get isSingleClaim => rewardType == '1';

  /// rewardType=1 时：找到可领取的最高档位 id（让用户拿最大奖励）
  int? get bestClaimableId {
    if (!isSingleClaim) return null;
    ActivityItem? best;
    for (final item in items) {
      if (item.canClaim) {
        if (best == null || item.needCount > best.needCount) best = item;
      }
    }
    return best?.id;
  }

  /// rewardType=1 时：是否整组已领取
  bool get isGroupClaimed => items.any((e) => e.claimed);

  /// 整体进度条比例（取最高档位的 needCount 为满值）
  double get overallProgress {
    if (items.isEmpty) return 0.0;
    final maxNeed = items.map((e) => e.needCount).reduce((a, b) => a > b ? a : b);
    return maxNeed > 0 ? (currentCount / maxNeed).clamp(0.0, 1.0) : 0.0;
  }

  factory ActivityGroup.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? [];
    final items = rawItems
        .map((e) => ActivityItem.fromJson(e as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => a.sort.compareTo(b.sort));
    return ActivityGroup(
      type: json['type'] as String,
      rewardType: json['rewardType']?.toString() ?? '0',
      currentCount: json['currentCount'] as int? ?? 0,
      items: items,
    );
  }
}

/// /app/activity/all 接口响应的完整数据
class ActivityAllData {
  final ActivityGroup? taskActivity;
  final ActivityGroup? commissionActivity;
  final ActivityGroup? subordinateActivity;

  const ActivityAllData({
    this.taskActivity,
    this.commissionActivity,
    this.subordinateActivity,
  });

  factory ActivityAllData.fromJson(Map<String, dynamic> json) {
    return ActivityAllData(
      taskActivity: json['taskActivity'] != null
          ? ActivityGroup.fromJson(
              json['taskActivity'] as Map<String, dynamic>)
          : null,
      commissionActivity: json['commissionActivity'] != null
          ? ActivityGroup.fromJson(
              json['commissionActivity'] as Map<String, dynamic>)
          : null,
      subordinateActivity: json['subordinateActivity'] != null
          ? ActivityGroup.fromJson(
              json['subordinateActivity'] as Map<String, dynamic>)
          : null,
    );
  }
}
