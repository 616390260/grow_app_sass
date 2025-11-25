/// 银行信息模型
class BankInfo {
  final Map<String, String> banks;

  BankInfo({required this.banks});

  /// 从JSON字符串创建BankInfo实例
  factory BankInfo.fromJsonString(String jsonString) {
    try {
      // 简单解析，实际项目中可能需要使用json.decode
      // 这里假设jsonString格式为 {"BKASH": "BKASH", "NAGAD": "NAGAD"}
      final cleanString = jsonString.replaceAll(RegExp(r'[{}]'), '');
      final pairs = cleanString.split(', ');
      final bankMap = <String, String>{};

      for (final pair in pairs) {
        final parts = pair.split(': ');
        if (parts.length == 2) {
          // 移除引号
          final key = parts[0].replaceAll('"', '');
          final value = parts[1].replaceAll('"', '');
          bankMap[key] = value;
        }
      }

      return BankInfo(banks: bankMap);
    } catch (e) {
      return BankInfo(banks: {});
    }
  }

  /// 转换为Map
  Map<String, String> toMap() => banks;
  
  /// 转换为JSON格式的Map（与toMap功能相同，但保持API一致性）
  Map<String, String> toJson() => toMap();
}
