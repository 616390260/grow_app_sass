
/// 社交媒体链接实体类
class SocialLink {
  final int id;
  final dynamic keyType;
  final dynamic title;
  final dynamic description;
  final String icon;
  final String link;
  final String name;
  final String type;
  final String createTime;
  final String updateTime;
  final String delFlag;

  SocialLink({
    required this.id,
    required this.keyType,
    required this.title,
    required this.description,
    required this.icon,
    required this.link,
    required this.name,
    required this.type,
    required this.createTime,
    required this.updateTime,
    required this.delFlag,
  });

  /// 从JSON映射创建SocialLink实例
  factory SocialLink.fromJson(Map<String, dynamic> json) {
    return SocialLink(
      id: json['id'] as int,
      keyType: json['keyType'],
      title: json['title'],
      description: json['description'],
      icon: json['icon'] as String,
      link: json['link'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      createTime: json['createTime'] as String,
      updateTime: json['updateTime'] as String,
      delFlag: json['delFlag'] as String,
    );
  }

  /// 将SocialLink实例转换为JSON映射
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'keyType': keyType,
      'title': title,
      'description': description,
      'icon': icon,
      'link': link,
      'name': name,
      'type': type,
      'createTime': createTime,
      'updateTime': updateTime,
      'delFlag': delFlag,
    };
  }

  @override
  String toString() {
    return 'SocialLink{id: $id, name: $name, link: $link, type: $type}';
  }
}

/// 社交媒体链接响应类
class SocialLinkResponse {
  final SocialLink data;

  SocialLinkResponse({required this.data});

  factory SocialLinkResponse.fromJson(Map<String, dynamic> json) {
    return SocialLinkResponse(
      data: SocialLink.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.toJson(),
    };
  }
}