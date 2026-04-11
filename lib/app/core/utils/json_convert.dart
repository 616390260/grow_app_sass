import 'dart:convert';

/// JSON转换工具类
/// 提供通用的JSON序列化和反序列化功能，支持json_serializable
class JsonConvert {
  /// 单例实例
  static final JsonConvert _instance = JsonConvert._internal();

  /// 工厂构造函数
  factory JsonConvert() => _instance;

  /// 私有构造函数
  JsonConvert._internal();

  /// 将JSON数据转换为指定类型的对象
  /// 支持基本类型、集合类型和自定义模型类型
  static T? fromJsonAsT<T>(dynamic json) {
    if (json == null) return null;

    // 处理基本类型
    if (T == String) {
      return json.toString() as T;
    }
    if (T == int) {
      if (json is int) return json as T;
      if (json is double) return json.toInt() as T;
      if (json is String) return int.tryParse(json) as T;
      return 0 as T;
    }
    if (T == double) {
      if (json is double) return json as T;
      if (json is int) return json.toDouble() as T;
      if (json is String) return double.tryParse(json) as T;
      return 0.0 as T;
    }
    if (T == bool) {
      print('JsonConvert.fromJsonAsT: 转换bool类型, 输入数据: $json, 类型: ${json.runtimeType}');
      if (json is bool) {
        return json as T;
      } else if (json is String) {
        final lowerJson = json.toLowerCase();
        return (lowerJson == 'true' || lowerJson == '1' || lowerJson == 'yes') as T;
      } else if (json is num) {
        return (json != 0) as T;
      }
      // 如果是其他类型，尝试toString后再判断
      final stringValue = json?.toString().toLowerCase();
      if (stringValue != null) {
        return (stringValue == 'true' || stringValue == '1' || stringValue == 'yes') as T;
      }
      return false as T;
    }
    if (T == num) {
      if (json is num) return json as T;
      if (json is String) {
        final intValue = int.tryParse(json);
        if (intValue != null) return intValue as T;
        final doubleValue = double.tryParse(json);
        if (doubleValue != null) return doubleValue as T;
      }
      return 0 as T;
    }

    // 处理集合类型
    if (T == Map<String, dynamic>) {
      if (json is Map) {
        return json.cast<String, dynamic>() as T;
      }
      return <String, dynamic>{} as T;
    }
    if (T == List<dynamic>) {
      if (json is List) return json as T;
      return <dynamic>[] as T;
    }

    // 对于Map类型的JSON数据，直接返回供json_serializable使用
    if (json is Map<String, dynamic>) {
      try {
        return json as T;
      } catch (e) {
        print('JsonConvert.fromJsonAsT 转换失败: $e, 源数据类型: ${json.runtimeType}, 目标类型: $T');
      }
    }
    
    // 对于其他类型，尝试使用强制转换
    try {
      return json as T;
    } catch (e) {
      print('JsonConvert.fromJsonAsT 转换失败: $e, 源数据类型: ${json.runtimeType}, 目标类型: $T');
      return null;
    }
  }

  /// 安全地从Map中获取指定类型的值
  static T? safeGet<T>(Map<String, dynamic> map, String key, {T? defaultValue}) {
    if (!map.containsKey(key)) return defaultValue;
    
    final value = map[key];
    if (value == null) return defaultValue;
    
    try {
      return fromJsonAsT<T>(value) ?? defaultValue;
    } catch (e) {
      print('JsonConvert.safeGet 转换失败: $e, 键: $key, 值: $value');
      return defaultValue;
    }
  }

  /// 安全地从Map中获取嵌套的data字段值
  static T? safeGetData<T>(Map<String, dynamic> map, {T? defaultValue}) {
    return safeGet<T>(map, 'data', defaultValue: defaultValue);
  }
  
  /// 通用模型转换方法 - 适用于各种自定义模型类（特别是使用json_serializable的模型）
  /// 自动处理API响应中可能包含的data字段
  /// [json]: 原始JSON数据或API响应
  /// [fromJsonFunction]: 目标类型的fromJson工厂方法（json_serializable生成的方法）
  static T? modelFromJson<T>(dynamic json, T Function(Map<String, dynamic>) fromJsonFunction) {
    if (json == null) return null;
    
    try {
      // 处理Map类型数据
      if (json is Map<String, dynamic>) {
        // 检查是否已经是模型数据（包含data字段或直接是模型数据）
        if (json.containsKey('data') && json['data'] is Map) {
          // 从data字段提取模型数据
          final modelData = json['data'] as Map<String, dynamic>;
          return fromJsonFunction(modelData);
        } else {
          // 直接使用当前Map作为模型数据
          return fromJsonFunction(json);
        }
      }
      
      // 对于非Map数据，尝试转换（如果可能）
      print('JsonConvert.modelFromJson: 输入不是Map类型，无法转换为模型');
      return null;
    } catch (e) {
      print('JsonConvert.modelFromJson 转换失败: $e, 源数据类型: ${json.runtimeType}');
      return null;
    }
  }

  /// 安全地从List中获取指定类型的值
  static T? safeGetAt<T>(List<dynamic> list, int index, {T? defaultValue}) {
    if (index < 0 || index >= list.length) return defaultValue;
    
    try {
      return fromJsonAsT<T>(list[index]) ?? defaultValue;
    } catch (e) {
      print('JsonConvert.safeGetAt 转换失败: $e, 索引: $index');
      return defaultValue;
    }
  }

  /// 将对象转换为JSON字符串
  static String? toJsonString(Object? object) {
    if (object == null) return null;
    
    try {
      // 如果对象有toJson方法，优先使用
      if (object is Map || object is List) {
        return json.encode(object);
      }
      return object.toString();
    } catch (e) {
      print('JsonConvert.toJsonString 转换失败: $e');
      return null;
    }
  }
}