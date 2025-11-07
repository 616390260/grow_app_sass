/// 中奖记录实体
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

  /// 从JSON创建实例，兼容null值
  factory WinningRecord.fromJson(Map<String, dynamic> json) {
    // 处理时间字段，兼容null值
    DateTime createdAt;
    try {
      createdAt = json['createTime'] != null 
          ? DateTime.parse(json['createTime'] as String) 
          : DateTime.now();
    } catch (e) {
      createdAt = DateTime.now();
    }
    
    DateTime? updateTime;
    if (json['updateTime'] != null) {
      try {
        updateTime = DateTime.parse(json['updateTime'] as String);
      } catch (e) {
        updateTime = null;
      }
    }

    return WinningRecord(
      id: json['id']?.toString() ?? '',
      prizeName: json['prizeName']?.toString() ?? '奖品', // 使用更通用的默认名称
      prizeValue: (json['points'] is int) ? json['points'] : (json['points'] is double) ? json['points'].toInt() : 0,
      userPhone: json['userPhone']?.toString(),
      createdAt: createdAt,
      imageUrl: json['image']?.toString() ?? json['imageUrl']?.toString(), // 同时支持image和imageUrl字段
      createBy: json['createBy']?.toString(),
      updateTime: updateTime,
      remark: json['remark']?.toString(),
      probability: (json['probability'] is num) ? json['probability'].toDouble() : 0.0, // 默认值0.0而不是null
      stock: (json['stock'] is int) ? json['stock'] : (json['stock'] is num) ? json['stock'].toInt() : 0, // 默认值0而不是null
      delFlag: json['delFlag']?.toString(),
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prizeName': prizeName,
      'points': prizeValue, // 使用points作为键名以匹配API
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

  /// 创建副本
  WinningRecord copyWith({
    String? id,
    String? prizeName,
    int? prizeValue,
    String? userPhone,
    DateTime? createdAt,
    String? imageUrl,
    String? createBy,
    DateTime? updateTime,
    String? remark,
    double? probability,
    int? stock,
    String? delFlag,
  }) {
    return WinningRecord(
      id: id ?? this.id,
      prizeName: prizeName ?? this.prizeName,
      prizeValue: prizeValue ?? this.prizeValue,
      userPhone: userPhone ?? this.userPhone,
      createdAt: createdAt ?? this.createdAt,
      imageUrl: imageUrl ?? this.imageUrl,
      createBy: createBy ?? this.createBy,
      updateTime: updateTime ?? this.updateTime,
      remark: remark ?? this.remark,
      probability: probability ?? this.probability,
      stock: stock ?? this.stock,
      delFlag: delFlag ?? this.delFlag,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WinningRecord &&
        other.id == id &&
        other.prizeName == prizeName &&
        other.prizeValue == prizeValue &&
        other.userPhone == userPhone &&
        other.createdAt == createdAt &&
        other.imageUrl == imageUrl &&
        other.createBy == createBy &&
        other.updateTime == updateTime &&
        other.remark == remark &&
        other.probability == probability &&
        other.stock == stock &&
        other.delFlag == delFlag;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        prizeName.hashCode ^
        prizeValue.hashCode ^
        userPhone.hashCode ^
        createdAt.hashCode ^
        imageUrl.hashCode ^
        createBy.hashCode ^
        updateTime.hashCode ^
        remark.hashCode ^
        probability.hashCode ^
        stock.hashCode ^
        delFlag.hashCode;
  }

  @override
  String toString() {
    return 'WinningRecord(id: $id, prizeName: $prizeName, prizeValue: $prizeValue, userPhone: $userPhone, createdAt: $createdAt, imageUrl: $imageUrl, createBy: $createBy, updateTime: $updateTime, remark: $remark, probability: $probability, stock: $stock, delFlag: $delFlag)';
  }
}