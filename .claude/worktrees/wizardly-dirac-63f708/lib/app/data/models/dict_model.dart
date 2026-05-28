import 'dart:convert';

class DictModel {
  String? createBy;
  String? createTime;
  dynamic updateBy;
  dynamic updateTime;
  String? remark;
  Map<String, dynamic>? params;
  int? dictCode;
  int? dictSort;
  String? dictLabel;
  String? dictValue;
  String? dictType;
  dynamic cssClass;
  String? listClass;
  String? isDefault;
  String? status;
  bool? isDefaultFlag;

  DictModel({
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.remark,
    this.params,
    this.dictCode,
    this.dictSort,
    this.dictLabel,
    this.dictValue,
    this.dictType,
    this.cssClass,
    this.listClass,
    this.isDefault,
    this.status,
    this.isDefaultFlag,
  });

  factory DictModel.fromJson(Map<String, dynamic> json) {
    // 创建一个安全的JSON副本，用于处理类型转换
    final safeJson = json.map((key, value) {
      // 处理数字类型转换为字符串
      if (value is num && (key == 'status' || key == 'dictCode' || key == 'dictSort')) {
        return MapEntry(key, value.toString());
      }
      return MapEntry(key, value);
    });

    return DictModel(
      createBy: safeJson['createBy'] as String?, 
      createTime: safeJson['createTime'] as String?, 
      updateBy: safeJson['updateBy'], 
      updateTime: safeJson['updateTime'], 
      remark: safeJson['remark'] as String?, 
      params: safeJson['params'] as Map<String, dynamic>?, 
      dictCode: safeJson['dictCode'] is num ? safeJson['dictCode'] as int : int.tryParse(safeJson['dictCode']?.toString() ?? ''), 
      dictSort: safeJson['dictSort'] is num ? safeJson['dictSort'] as int : int.tryParse(safeJson['dictSort']?.toString() ?? ''), 
      dictLabel: safeJson['dictLabel'] as String?, 
      dictValue: safeJson['dictValue'] as String?, 
      dictType: safeJson['dictType'] as String?, 
      cssClass: safeJson['cssClass'], 
      listClass: safeJson['listClass'] as String?, 
      isDefault: safeJson['isDefault'] as String?, 
      status: safeJson['status'] as String?, 
      isDefaultFlag: safeJson['default'] as bool? ?? false, 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createBy': createBy,
      'createTime': createTime,
      'updateBy': updateBy,
      'updateTime': updateTime,
      'remark': remark,
      'params': params,
      'dictCode': dictCode,
      'dictSort': dictSort,
      'dictLabel': dictLabel,
      'dictValue': dictValue,
      'dictType': dictType,
      'cssClass': cssClass,
      'listClass': listClass,
      'isDefault': isDefault,
      'status': status,
      'default': isDefaultFlag,
    };
  }

  // 将模型转换为实体类
  DictEntity toEntity() {
    return DictEntity(
      dictLabel: dictLabel ?? '',
      dictValue: dictValue ?? '',
    );
  }
}

// 简单的实体类，用于UI展示
class DictEntity {
  String dictLabel;
  String dictValue;

  DictEntity({required this.dictLabel, required this.dictValue});
}