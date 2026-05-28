import 'package:json_annotation/json_annotation.dart';
import 'package:do_task_project/app/domain/entities/country.dart';
import 'package:do_task_project/app/data/models/bank_info_model.dart';

part 'country_model.g.dart';

/// 国家数据模型
@JsonSerializable()
class CountryModel {
  final int id;
  final String payName;
  final String status;
  final String merchantNo;
  final double? minAmount;
  final double? fee;
  final double? exchangeRate;
  final String delFlag;
  final String? className;
  final String? classNameLang;
  final String? bankData;
  final String? bankInfo;
  final String? singleAmount;
  final String? code;
  final String recommend;
  final String? createBy;
  final String? createTime;
  final String? updateBy;
  final String? updateTime;
  final String? remark;
  final String? appid;
  final String? appcode;
  final String? merchantKey;

  CountryModel({
    required this.id,
    required this.payName,
    required this.status,
    required this.merchantNo,
    this.minAmount,
    this.fee,
    this.exchangeRate,
    required this.delFlag,
    this.className,
    this.classNameLang,
    this.bankData,
    this.bankInfo,
    this.singleAmount,
    this.code,
    required this.recommend,
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.remark,
    this.appid,
    this.appcode,
    this.merchantKey,
  });

  /// 从JSON创建CountryModel实例
  factory CountryModel.fromJson(Map<String, dynamic> json) {
    // 处理类型转换，确保字符串字段的正确解析
    final safeJson = Map<String, dynamic>.from(json);
    
    // 安全地将数字转换为字符串
    if (json.containsKey('status') && json['status'] is num) {
      safeJson['status'] = json['status'].toString();
    }
    if (json.containsKey('delFlag') && json['delFlag'] is num) {
      safeJson['delFlag'] = json['delFlag'].toString();
    }
    if (json.containsKey('recommend') && json['recommend'] is num) {
      safeJson['recommend'] = json['recommend'].toString();
    }
    
    return _$CountryModelFromJson(safeJson);
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() => _$CountryModelToJson(this);

  /// 转换为实体
  Country toEntity() {
    // 解析银行信息
    BankInfo? parsedBankInfo;
    if (bankInfo != null && bankInfo!.isNotEmpty) {
      try {
        parsedBankInfo = BankInfo.fromJsonString(bankInfo!);
      } catch (e) {
        print('Failed to parse bankInfo: $e');
      }
    }

    return Country(
      id: id.toString(),
      name: payName,
      payName: payName,
      status: status,
      merchantNo: merchantNo,
      minAmount: minAmount,
      fee: fee,
      exchangeRate: exchangeRate,
      delFlag: delFlag,
      className: className,
      classNameLang: classNameLang,
      recommend: recommend,
      bankInfo: parsedBankInfo,
    );
  }
}
