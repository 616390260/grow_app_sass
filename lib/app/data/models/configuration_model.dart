/// `/app/configuration/getById` 单条配置
class ConfigurationItem {
  final int id;
  final String? title;
  /// 时区等配置值（id=24 时为 IANA 时区，如 Asia/Tokyo）
  final String? content;

  const ConfigurationItem({
    required this.id,
    this.title,
    this.content,
  });

  factory ConfigurationItem.fromJson(Map<String, dynamic> json) {
    return ConfigurationItem(
      id: json['id'] as int,
      title: json['title'] as String?,
      content: json['content'] as String?,
    );
  }
}
