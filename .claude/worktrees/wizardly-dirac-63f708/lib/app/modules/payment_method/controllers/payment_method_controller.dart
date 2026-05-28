import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/i18n/i18n_keys.dart';
import '../../../data/services/bank_api_service.dart';
import 'package:flutter/foundation.dart';
import '../../../data/models/bank_info_model.dart';

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

  // TRX 钱包地址（字段名 payCard）
  RxString payCard = ''.obs;
  
  // 国家/地区（从上个页面传递）
  String country = Get.arguments?['country'] ?? '';
  int countryId = Get.arguments?['countryId'] ?? 0;
  // 银行信息对象
  BankInfo? bankInfo = Get.arguments?['bankInfo'];

  /// 是否为TRX支付方式
  bool get isTrx => country.toUpperCase() == 'TRX';
  
  // 银行列表
  RxList<BankModel> bankList = <BankModel>[].obs;
  // 过滤后的银行列表
  RxList<BankModel> filteredBankList = <BankModel>[].obs;
  // 选中的银行
  var selectedBank = Rxn<BankModel>();
  // 搜索关键字
  var searchKeyword = ''.obs;
  
  // 加载银行列表
  Future<void> loadBankList() async {
    safeApiCall(
      // 真实API调用函数
      () async => await _apiService.getBankList(countryId: countryId),
      // 成功回调
      (List<BankModel> bankDataList) {
        bankList.value = bankDataList;
        filteredBankList.value = bankDataList; // 初始化过滤列表
        debugPrint('成功加载银行列表，共${bankDataList.length}条数据，国家ID: $countryId');
      },
      // 自定义错误消息
      errorMessage: I18nKeys.getBankListFailed.tr,
      // 不显示加载状态
      showLoading: false,
    );
  }

  // 搜索银行
  void searchBanks(String keyword) {
    searchKeyword.value = keyword.toLowerCase();
    if (keyword.isEmpty) {
      filteredBankList.value = bankList;
    } else {
      filteredBankList.value = bankList.where((bank) =>
        bank.name.toLowerCase().contains(searchKeyword.value)
      ).toList();
    }
    print('搜索银行 - 关键词: $keyword, 结果数量: ${filteredBankList.length}');
  }
  
  // 清除搜索
  void clearSearch() {
    searchKeyword.value = '';
    filteredBankList.value = bankList;
  }
  
  // 设置选中的银行
  void setSelectedBank(String bankName, int bankCode) {
    this.bankName.value = bankName;
    this.bankCode.value = bankCode;
  }
  
  @override
  void onInit() {
    super.onInit();
    // 打印接收到的bankInfo信息
    if (bankInfo != null) {
      print('成功接收到bankInfo: ${bankInfo}');
    } else {
      print('未接收到bankInfo');
    }
    // 打印接收到的国家ID
    print('接收到的国家ID: $countryId');
    print('接收到的国家名称: $country');
    // 初始化数据
    loadBankList();
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

  /// 设置TRX钱包地址
  void setPayCard(String address) {
    payCard.value = address;
  }
  
  // 验证表单
  bool validateForm() {
    if (isTrx) {
      // TRX 模式：只需验证钱包地址和登录密码
      if (payCard.value.isEmpty) {
        showErrorMessage(I18nKeys.pleaseEnterWalletAddressPlaceholder.tr);
        return false;
      }
    } else {
      // 普通模式：验证银行、账号、姓名
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
      'payCard': payCard.value,
    });
    
    
    // 如果需要显示成功消息，可以在返回后通过其他方式显示，或者使用定时器延迟显示
    // 注意：这里不再调用showSuccessMessage，因为它可能会影响导航
  }
}
