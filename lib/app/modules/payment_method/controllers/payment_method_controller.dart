import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/i18n/i18n_keys.dart';
import '../../../data/services/bank_api_service.dart';
import 'package:flutter/foundation.dart';

// 银行模型类
class BankModel {
  final int id;
  final String code;
  final String name;

  BankModel({required this.id, required this.code, required this.name});

  factory BankModel.fromJson(Map<String, dynamic> json) {
    return BankModel(
      id: json['id'] ?? 0,
      code: json['code'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class PaymentMethodController extends BaseController {
  // API服务
  final BankApiService _apiService = BankApiService();
  
  // 银行名称
  RxString bankName = ''.obs;
  
  // 银行代码
  RxInt bankCode = 0.obs;
  
  // 收款账号
  RxString accountNumber = ''.obs;
  
  // 收款姓名
  RxString accountName = ''.obs;
  
  // 登录密码
  RxString loginPassword = ''.obs;
  
  // 手机号
  RxString phone = ''.obs;
  
  // 国家/地区（从上个页面传递）
  String country = Get.arguments?['country'] ?? 'nigeria';
  
  // 银行列表
  RxList<BankModel> bankList = <BankModel>[].obs;
  
  // 加载银行列表
  Future<void> loadBankList() async {
    safeApiCall(
      // 真实API调用函数
      () async => await _apiService.getBankList(),
      // 成功回调
      (List<BankModel> bankDataList) {
        bankList.value = bankDataList;
        debugPrint('成功加载银行列表，共${bankDataList.length}条数据');
      },
      // 自定义错误消息
      errorMessage: I18nKeys.getBankListFailed.tr,
      // 不显示加载状态
      showLoading: false,
    );
  }
  
  // 设置选中的银行
  void setSelectedBank(String bankName, int bankCode) {
    this.bankName.value = bankName;
    this.bankCode.value = bankCode;
  }
  
  @override
  void onInit() {
    super.onInit();
    // 初始化数据
    loadPaymentData();
  }
  
  // 加载支付信息
  void loadPaymentData() async {
    setLoading(true);
    try {
      // 模拟从API获取数据
      await Future.delayed(const Duration(seconds: 1));
      setSuccess();
    } catch (e) {
      setError(I18nKeys.errorUnknown.tr);
      showErrorMessage(I18nKeys.errorUnknown.tr);
    }
  }
  
  // 设置银行名称
  void setBankName(String name) {
    bankName.value = name;
  }
  
  // 设置收款账号
  void setAccountNumber(String number) {
    accountNumber.value = number;
  }
  
  // 设置收款姓名
  void setAccountName(String name) {
    accountName.value = name;
  }
  
  // 设置登录密码
  void setLoginPassword(String password) {
    loginPassword.value = password;
  }
  
  // 设置手机号
  void setPhone(String number) {
    phone.value = number;
  }
  
  // 验证表单
  bool validateForm() {
    if (bankName.value.isEmpty) {
      showErrorMessage(I18nKeys.pleaseSelectBankPlaceholder.tr);
      return false;
    }
    if (accountNumber.value.isEmpty) {
      showErrorMessage(I18nKeys.pleaseEnterAccountNumberPlaceholder.tr);
      return false;
    }
    if (accountName.value.isEmpty) {
      showErrorMessage(I18nKeys.pleaseEnterAccountNamePlaceholder.tr);
      return false;
    }
    if (loginPassword.value.isEmpty) {
      showErrorMessage(I18nKeys.pleaseEnterLoginPasswordPlaceholder.tr);
      return false;
    }
    return true;
  }
  
  // 提交收款信息
  void submitPaymentInfo() {
    if (!validateForm()) {
      return;
    }
    // 先执行返回操作，确保导航正常
    Get.back(result: {
      'bankName': bankName.value,
      'bankCode': bankCode.value,
      'phone': phone.value,
      'accountNumber': accountNumber.value,
      'accountName': accountName.value,
      'loginPassword': loginPassword.value,
    });
    
    
    // 如果需要显示成功消息，可以在返回后通过其他方式显示，或者使用定时器延迟显示
    // 注意：这里不再调用showSuccessMessage，因为它可能会影响导航
  }
}
