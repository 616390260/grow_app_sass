import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/i18n/i18n_keys.dart';

class AccountWithdrawalController extends BaseController {
  // 选中的国家
  RxString selectedCountry = 'nigeria'.obs;
  
  // 提现金额
  RxString withdrawAmount = ''.obs;
  
  // 可用余额（模拟数据）
  final double availableBalance = 0.0;
  
  // 提现手续费
  final double withdrawalFee = 200.0;
  
  // 最低提现金额
  final double minWithdrawalAmount = 1000.0;
  
  // 国家列表
  final List<Map<String, String>> countries = [
    {'key': 'nigeria', 'label': 'nigeria'.tr},
    {'key': 'trx', 'label': 'trx'.tr},
    {'key': 'india', 'label': 'india'.tr},
    {'key': 'philippines', 'label': 'philippines'.tr},
    {'key': 'indonesia', 'label': 'indonesia'.tr},
    {'key': 'bangladesh', 'label': 'bangladesh'.tr},
    {'key': 'pakistan', 'label': 'pakistan'.tr},
    {'key': 'southAfrica', 'label': 'southAfrica'.tr},
  ];
  
  @override
  void onInit() {
    super.onInit();
    // 初始化数据加载
    loadAccountData();
  }
  
  // 加载账户数据
  void loadAccountData() async {
    setLoading(true);
    try {
      // 模拟从API获取数据
      // 实际项目中应该调用真实的API
      await Future.delayed(const Duration(seconds: 1));
      setSuccess();
    } catch (e) {
      setError(I18nKeys.errorUnknown.tr);
      showErrorMessage(I18nKeys.errorUnknown.tr);
    }
  }
  
  // 选择国家
  void selectCountry(String country) {
    selectedCountry.value = country;
  }
  
  // 设置提现金额
  void setWithdrawAmount(String amount) {
    withdrawAmount.value = amount;
  }
  
  // 计算实际到账金额
  double calculateActualAmount() {
    try {
      double amount = double.parse(withdrawAmount.value);
      return amount - withdrawalFee;
    } catch (e) {
      return 0.0;
    }
  }
  
  // 验证提现金额
  bool validateWithdrawAmount() {
    try {
      double amount = double.parse(withdrawAmount.value);
      return amount >= minWithdrawalAmount && amount <= availableBalance;
    } catch (e) {
      return false;
    }
  }
  
  // 处理提现请求
  void handleWithdraw() {
    if (!validateWithdrawAmount()) {
      // 显示错误提示
      Get.snackbar(
      I18nKeys.error.tr,
      I18nKeys.pleaseFixErrors.tr,
      snackPosition: SnackPosition.BOTTOM,
    );
      return;
    }
    
    // 模拟提现请求
    setLoading(true);
    
    // 模拟网络延迟
    Future.delayed(const Duration(seconds: 2), () {
      setSuccess();
      
      // 显示成功提示
      Get.snackbar(
        I18nKeys.success.tr,
        I18nKeys.withdrawConfirm.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      
      // 返回上一页
      Get.back();
    });
  }
  
  // 添加地址
  void addAddress() {
    // 这里可以实现添加地址的逻辑
    Get.snackbar(
      I18nKeys.tip.tr,
      I18nKeys.add.tr,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}