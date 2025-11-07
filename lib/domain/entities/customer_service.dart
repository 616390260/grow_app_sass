/// 客服列表实体类
class CustomerService {
  final String? createTime;
  final String? delFlag;
  final String? description;
  final String? icon;
  final int? id;
  final String? keyType;
  final String? link;
  final String? name;
  final String? title;
  final String? type;
  final String? updateTime;

  const CustomerService({
    this.createTime,
    this.delFlag,
    this.description,
    this.icon,
    this.id,
    this.keyType,
    this.link,
    this.name,
    this.title,
    this.type,
    this.updateTime,
  });

  /// 从JSON创建CustomerService实例
  factory CustomerService.fromJson(Map<String, dynamic> json) {
    return CustomerService(
      createTime: json['createTime'] as String?,
      delFlag: json['delFlag'] as String?,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      id: json['id'] as int?,
      keyType: json['keyType'] as String?,
      link: json['link'] as String?,
      name: json['name'] as String?,
      title: json['title'] as String?,
      type: json['type'] as String?,
      updateTime: json['updateTime'] as String?,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'createTime': createTime,
      'delFlag': delFlag,
      'description': description,
      'icon': icon,
      'id': id,
      'keyType': keyType,
      'link': link,
      'name': name,
      'title': title,
      'type': type,
      'updateTime': updateTime,
    };
  }

  /// 复制对象并修改指定字段
  CustomerService copyWith({
    String? createTime,
    String? delFlag,
    String? description,
    String? icon,
    int? id,
    String? keyType,
    String? link,
    String? name,
    String? title,
    String? type,
    String? updateTime,
  }) {
    return CustomerService(
      createTime: createTime ?? this.createTime,
      delFlag: delFlag ?? this.delFlag,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      id: id ?? this.id,
      keyType: keyType ?? this.keyType,
      link: link ?? this.link,
      name: name ?? this.name,
      title: title ?? this.title,
      type: type ?? this.type,
      updateTime: updateTime ?? this.updateTime,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CustomerService &&
        other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'CustomerService(createTime: $createTime, delFlag: $delFlag, description: $description, icon: $icon, id: $id, keyType: $keyType, link: $link, name: $name, title: $title, type: $type, updateTime: $updateTime)';
  }
}