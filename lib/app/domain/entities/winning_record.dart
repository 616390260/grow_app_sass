class WinningRecord {
  final String id;
  final String prizeName;
  final int prizeValue;
  final String? userPhone;
  final DateTime createdAt;
  final String? imageUrl;
  final String? createBy;
  final DateTime? updateTime;
  final String? remark;
  final double? probability;
  final int? stock;
  final String? delFlag;

  WinningRecord({
    required this.id,
    required this.prizeName,
    required this.prizeValue,
    this.userPhone,
    required this.createdAt,
    this.imageUrl,
    this.createBy,
    this.updateTime,
    this.remark,
    this.probability,
    this.stock,
    this.delFlag,
  });

  factory WinningRecord.fromJson(Map<String, dynamic> json) {
    DateTime createdAt;
    try {
      createdAt = json['createTime'] != null ? DateTime.parse(json['createTime'] as String) : DateTime.now();
    } catch (_) {
      createdAt = DateTime.now();
    }

    DateTime? updateTime;
    if (json['updateTime'] != null) {
      try {
        updateTime = DateTime.parse(json['updateTime'] as String);
      } catch (_) {
        updateTime = null;
      }
    }

    return WinningRecord(
      id: json['id']?.toString() ?? '',
      prizeName: json['prizeName']?.toString() ?? '奖品',
      prizeValue: (json['points'] is int)
          ? json['points']
          : (json['points'] is double)
              ? (json['points'] as double).toInt()
              : 0,
      userPhone: json['userPhone']?.toString(),
      createdAt: createdAt,
      imageUrl: json['image']?.toString() ?? json['imageUrl']?.toString(),
      createBy: json['createBy']?.toString(),
      updateTime: updateTime,
      remark: json['remark']?.toString(),
      probability: (json['probability'] is num) ? (json['probability'] as num).toDouble() : 0.0,
      stock: (json['stock'] is int)
          ? json['stock']
          : (json['stock'] is num)
              ? (json['stock'] as num).toInt()
              : 0,
      delFlag: json['delFlag']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prizeName': prizeName,
      'points': prizeValue,
      'userPhone': userPhone,
      'createTime': createdAt.toIso8601String(),
      'imageUrl': imageUrl,
      'createBy': createBy,
      'updateTime': updateTime?.toIso8601String(),
      'remark': remark,
      'probability': probability,
      'stock': stock,
      'delFlag': delFlag,
    };
  }
}
