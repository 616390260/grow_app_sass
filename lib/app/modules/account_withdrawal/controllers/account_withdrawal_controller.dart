import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/i18n/i18n_keys.dart';
import '../../../core/models/base_list_entity.dart';
import '../../../data/services/country_api_service.dart';
import '../../../data/models/country_model.dart';
import '../../../data/services/withdrawal_api_service.dart';
import '../../../../domain/entities/withdrawal_setting.dart';
class AccountWithdrawalController extends BaseController {
  // 选中的国家
  RxString selectedCountry = ''.obs;
  
  // 提现金额
  RxString withdrawAmount = ''.obs;
  RxString bankName = ''.obs;
  RxString accountNumber = ''.obs;
  RxString accountName = ''.obs;
  RxString bankCode = ''.obs;
  RxString loginPassword = ''.obs;
  // 可用余额（模拟数据）
  final double availableBalance = 10000.0;
  
  // 提现手续费
  final double withdrawalFee = 200.0;
  
  // 最低提现金额
  final double minWithdrawalAmount = 1000.0;
  
  // 提现配置（响应式）
  Rx<WithdrawalSetting> withdrawalSetting = WithdrawalSetting().obs;

  
  
  // 国家列表（响应式）
  RxList<Map<String, String>> countries = <Map<String, String>>[].obs;
  
  // API服务实例
  final CountryApiService _countryApiService = CountryApiService();
  final WithdrawalApiService _withdrawalApiService = WithdrawalApiService();
  
  @override
  void onInit() {
    super.onInit();
    // 初始化数据加载
    loadAccountData();
    // 加载国家列表
    loadCountries();
    // 加载提现配置
    loadWithdrawalSetting();
  }
  
  // 加载账户数据
  void loadAccountData() {
    safeApiCall(
      // API调用函数（模拟）
      () async {
        // 模拟从API获取数据
        // 实际项目中应该调用真实的API
        await Future.delayed(const Duration(seconds: 1));
        return true; // 返回一个简单的成功标志
      },
      // 成功回调
      (result) {
        setSuccess();
      },
      // 自定义错误消息
      errorMessage: I18nKeys.loadAccountDataFailed.tr,
      // 显示加载状态
      showLoading: true,
    );
  }
  
  // 加载国家列表
  void loadCountries() {
    safeApiCall(
      // API调用函数
      () async => await _countryApiService.getCountryList(),
      // 成功回调
      (BaseListEntity<CountryModel> response) {
        try {
          print('获取到国家列表数量: ${response.records.length}');
          
          // 将CountryModel转换为Map<String, String>格式
          final List<Map<String, String>> countryList = response.records
              .where((model) => model.id != null && model.payName != null)
              .map((model) => {
                'key': model.id.toString(),
                'label': model.payName
              })
              .toList();
          
          // 更新国家列表
          if (countryList.isNotEmpty) {
            countries.assignAll(countryList);
            
            // 安全地初始化选中的国家
            if (countryList.isNotEmpty && 
                countryList.first.containsKey('key') && 
                countryList.first['key'] != null &&
                countryList.first['key']!.isNotEmpty) {
              // 如果当前选中的国家不在新列表中，重置为第一个国家
              final bool isSelectedCountryExists = countryList.any(
                (country) => country['label'] == selectedCountry.value
              );
              
              if (!isSelectedCountryExists) {
                selectedCountry.value = countryList.first['label']!;
                print('重置选中的国家: ${selectedCountry.value}');
              }
            }
          }
        } catch (e) {
          print('处理国家列表时异常: $e');
          // 发生异常时确保有默认国家
          if (countries.isEmpty) {
            countries.assignAll([{'key': 'default', 'label': '默认国家'}]);
            selectedCountry.value = 'default';
          }
        }
      },
      // 自定义错误消息
      errorMessage: I18nKeys.loadCountriesFailed.tr,
      // 不显示全局加载状态，避免与其他操作冲突
      showLoading: false,
      // 错误回调（保持静默失败）
      onError: () {
        print('加载国家列表失败');
        // 确保有默认数据
        if (countries.isEmpty) {
          countries.assignAll([{'key': 'default', 'label': '默认国家'}]);
          selectedCountry.value = 'default';
        }
      },
    );
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
  
  // 加载提现配置
  void loadWithdrawalSetting() {
    safeApiCall(
      // API调用函数
      () async => await _withdrawalApiService.getWithdrawalSetting(),
      // 成功回调
      (WithdrawalSetting setting) {
        withdrawalSetting.value = setting;
        print('获取到提现配置: ${setting.toString()}');
        setSuccess();
      },
      // 自定义错误消息
      errorMessage: '获取提现配置失败',
      // 不显示加载状态，避免影响用户体验
      showLoading: false,
    );
  }
  
  // 验证提现金额
  bool validateWithdrawAmount() {
    try {
      double amount = double.parse(withdrawAmount.value);
      // 使用配置中的最大提现金额（如果有），否则使用默认值
      double maxAmount = withdrawalSetting.value.maxPoints?.toDouble() ?? availableBalance;
      return amount >= minWithdrawalAmount && amount <= maxAmount;
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
    
    // 验证支付信息是否完整
    if (accountNumber.value.isEmpty || accountName.value.isEmpty || 
        bankName.value.isEmpty || loginPassword.value.isEmpty) {
      Get.snackbar(
        I18nKeys.error.tr,
        '请完善支付信息',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    // 构建提现请求参数
    final requestData = {
      "account": accountNumber.value,
      "bankId": int.tryParse(bankCode.value) ?? 0,
      "goldenFlowId": int.tryParse(selectedCountry.value) ?? 0,
      "loginPassword": loginPassword.value,
      "name": accountName.value,
      "points": int.tryParse(withdrawAmount.value) ?? 0
    };
    
    print('提现配置信息 - 每日限额: ${withdrawalSetting.value.oneDayNum}, 最大金额: ${withdrawalSetting.value.maxPoints}');
    
    print('提现请求参数: $requestData');
    
    // 使用safeApiCall发送真实提现请求
    safeApiCall(
      // API调用函数
      () async => await _withdrawalApiService.submitWithdrawal(requestData),
      // 成功回调
      (response) {
        setSuccess();
        print('提现请求成功响应: $response');
        
        // 显示成功提示
        Get.snackbar(
          I18nKeys.success.tr,
          I18nKeys.withdrawConfirm.tr,
          snackPosition: SnackPosition.BOTTOM,
        );
        
        // 返回上一页
        Get.back();
      },
      // 自定义错误消息
      errorMessage: I18nKeys.withdrawFailed.tr,
      // 显示加载状态
      showLoading: true,
      // 错误回调
      onError: () {
        print('提现请求失败');
        // 错误提示已经由safeApiCall处理
      },
    );
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