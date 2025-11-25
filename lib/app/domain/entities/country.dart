import 'package:do_task_project/app/data/models/bank_info_model.dart';

class Country {
  final String id;
  final String name;
  final String? payName;
  final String? status;
  final String? merchantNo;
  final double? minAmount;
  final double? fee;
  final double? exchangeRate;
  final String? delFlag;
  final String? className;
  final String? classNameLang;
  final String? recommend;
  final BankInfo? bankInfo;

  const Country({
    required this.id,
    required this.name,
    this.payName,
    this.status,
    this.merchantNo,
    this.minAmount,
    this.fee,
    this.exchangeRate,
    this.delFlag,
    this.className,
    this.classNameLang,
    this.recommend,
    this.bankInfo,
  });
}
