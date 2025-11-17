class OnlineNumber {
  final String? id;
  final String? userId;
  final String? userName;
  final String? wsAppNo;
  final String? createTime;
  final String? updateTime;
  final String? connectStatus;
  final String? status;
  final int? infoNum;
  final String? loginType;
  final String? logoutTime;
  final String? lastLoginTime;
  final String? hangUpTime;
  final int? loginNum;
  final double? rating;
  final int? rewardNum;
  final String? deviceHash;
  final int? port;
  final int? isOnline;
  final String? remark;
  final bool canSendMsg;

  OnlineNumber({
    this.id,
    this.userId,
    this.userName,
    this.wsAppNo,
    this.createTime,
    this.updateTime,
    this.connectStatus,
    this.status,
    this.infoNum,
    this.loginType,
    this.logoutTime,
    this.lastLoginTime,
    this.hangUpTime,  
    this.loginNum,
    this.rating,
    this.rewardNum,
    this.deviceHash,
    this.port,
    this.isOnline,
    this.remark,
    this.canSendMsg = false,
  });

  factory OnlineNumber.fromJson(Map<String, dynamic> json) {
    return OnlineNumber(
      id: json['id']?.toString(),
      userId: json['userId']?.toString(),
      userName: json['userName']?.toString(),
      wsAppNo: json['wsAppNo']?.toString(),
      createTime: json['createTime']?.toString(),
      updateTime: json['updateTime']?.toString(),
      connectStatus: json['connectStatus']?.toString(),
      status: json['status']?.toString(),
      infoNum: json['infoNum'] as int?,
      loginType: json['loginType']?.toString(),
      logoutTime: json['logoutTime']?.toString(),
      lastLoginTime: json['lastLoginTime']?.toString(),
      hangUpTime: json['hangUpTime']?.toString(),  
      loginNum: json['loginNum'] as int?,
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      rewardNum: json['rewardNum'] as int?,
      deviceHash: json['deviceHash']?.toString(),
      port: json['port'] as int?,
      isOnline: json['isOnline'] as int?,
      remark: json['remark']?.toString(),
      canSendMsg: json['canSendMsg'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'wsAppNo': wsAppNo,
      'createTime': createTime,
      'updateTime': updateTime,
      'connectStatus': connectStatus,
      'status': status,
      'infoNum': infoNum,
      'loginType': loginType,
      'logoutTime': logoutTime,
      'lastLoginTime': lastLoginTime,
      'hangUpTime': hangUpTime,  
      'loginNum': loginNum,
      'rating': rating,
      'rewardNum': rewardNum,
      'deviceHash': deviceHash,
      'port': port,
      'isOnline': isOnline,
      'remark': remark,
      'canSendMsg': canSendMsg,
    };
  }
}
