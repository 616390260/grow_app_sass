/// 宝箱产品数据模型
class BoxProductModel {
  final int? boxId;
  final int? points;
  final bool? isReceived;
  final bool? isCanReceived;

  BoxProductModel({
    this.boxId,
    this.points,
    this.isReceived,
    this.isCanReceived,
  });

  /// 从JSON创建模型，兼容null值
  factory BoxProductModel.fromJson(Map<String, dynamic> json) {
    return BoxProductModel(
      boxId: json['boxId'] as int?,
      points: json['points'] as int?,
      isReceived: json['isReceived'] as bool?,
      isCanReceived: json['isCanReceived'] as bool?,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'boxId': boxId,
      'points': points,
      'isReceived': isReceived,
      'isCanReceived': isCanReceived,
    };
  }

  /// 复制对象
  BoxProductModel copyWith({
    int? boxId,
    int? points,
    bool? isReceived,
    bool? isCanReceived,
  }) {
    return BoxProductModel(
      boxId: boxId ?? this.boxId,
      points: points ?? this.points,
      isReceived: isReceived ?? this.isReceived,
      isCanReceived: isCanReceived ?? this.isCanReceived,
    );
  }

  @override
  String toString() {
    return 'BoxProductModel(boxId: $boxId, points: $points, isReceived: $isReceived, isCanReceived: $isCanReceived)';
  }
}