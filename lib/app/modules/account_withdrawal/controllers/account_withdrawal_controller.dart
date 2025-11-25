import 'package:do_task_project/app/domain/entities/withdrawal_setting.dart';
import 'package:do_task_project/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/i18n/i18n_keys.dart';
import '../../../core/models/base_list_entity.dart';
import '../../../data/services/country_api_service.dart';
import '../../../data/models/country_model.dart';
import '../../../data/services/withdrawal_api_service.dart';
import '../../../data/services/home_api_service.dart';
import '../../../data/models/home_info_model.dart';

// 确保GetX依赖正确导入

class AccountWithdrawalController extends BaseController {
  // 提现金额
  RxString withdrawAmount = ''.obs;
  RxString bankName = ''.obs;
  RxString accountNumber = ''.obs;
  RxString accountName = ''.obs;
  RxString phone = ''.obs;
  RxInt bankCode = 0.obs;
  RxString loginPassword = ''.obs;
  
  // 可用余额（从用户信息获取，响应式变量）
  RxInt availableBalance = 0.obs;
  RxInt maxAmount = 0.obs;

  // 提现手续费
  final int withdrawalFee = 200;

  // 最低提现金额
  RxInt minWithdrawalAmount = 1000.obs;

  // 提现配置（响应式）
  Rx<WithdrawalSetting> withdrawalSetting = WithdrawalSetting().obs;

  // 国家列表（响应式）
  RxList<CountryModel> countries = <CountryModel>[].obs;
  Rx<CountryModel> selectedCountry = CountryModel(id: 0, payName: '', status: '', merchantNo: '', delFlag: '', recommend: '').obs;

  // API服务实例
  final CountryApiService _countryApiService = CountryApiService();
  final WithdrawalApiService _withdrawalApiService = WithdrawalApiService();
  final HomeApiService _homeApiService = HomeApiService();

  @override
  void onInit() {
    super.onInit();
    // 加载用户余额信息
    loadUserBalance();
    // 加载国家列表
    loadCountries();
    // 加载提现配置
    loadWithdrawalSetting();
  }

  // 加载用户余额信息
  void loadUserBalance() {
    safeApiCall(
      // API调用函数
      () async => await _homeApiService.getHomeInfo(),
      // 成功回调
      (HomeInfoModel homeInfo) {
        // 从HomeInfoModel中获取账户积分作为可用余额
        availableBalance.value = (homeInfo.accountPoints?.toInt() ?? 0);
        maxAmount.value = availableBalance.value - (selectedCountry.value.fee?.toInt()??0);
        print('获取用户余额成功: ${availableBalance.value}');
        setSuccess();
      },
      // 自定义错误消息
      errorMessage: I18nKeys.loadUserInfoFailed.tr,
      // 不显示加载状态，避免影响用户体验
      showLoading: false,
      // 错误回调（静默处理，不影响其他功能）
      onError: () {
        print('获取用户余额失败，设置默认值为0');
        availableBalance.value = 0;
      },
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

          final List<CountryModel> countryList = response.records;

          // 更新国家列表
          if (countryList.isNotEmpty) {
            countries.assignAll(countryList);

            // 安全地初始化选中的国家
            if (countryList.isNotEmpty) {
              // 如果当前选中的国家不在新列表中，重置为第一个国家
              final bool isSelectedCountryExists = countryList.any(
                (country) => country.payName == selectedCountry.value.payName,
              );

              if (!isSelectedCountryExists) {
                selectedCountry.value = countryList.first;
                print('重置选中的国家: ${selectedCountry.value}');
              }
            }
          }
        } catch (e) {
          print('处理国家列表时异常: $e');
          // 发生异常时确保有默认国家
          if (countries.isEmpty) {
            countries.assignAll([
              CountryModel(id: 0, payName: I18nKeys.defaultCountry.tr, status: '', merchantNo: '', delFlag: '', recommend: ''),
            ]);
            selectedCountry.value = countries.first;
          }
        }
      },
      // 自定义错误消息
      errorMessage: I18nKeys.loadCountriesFailed.tr,
      // 不显示全局加载状态，避免与其他操作冲突
      showLoading: true,
      // 错误回调（保持静默失败）
      onError: () {
        print(I18nKeys.loadCountriesFailed.tr);
        // 确保有默认数据
        if (countries.isEmpty) {
          countries.assignAll([
            CountryModel(id: 0, payName: I18nKeys.defaultCountry.tr, status: '', merchantNo: '', delFlag: '', recommend: ''),
          ]);
          selectedCountry.value = countries.first;
        }
      },
    );
  }

  // 选择国家
  void selectCountry(CountryModel country) {
    selectedCountry.value = country;
    // 选择国家变化时更新最大提现金额
    maxAmount.value = availableBalance.value - (selectedCountry.value.fee?.toInt()??0);
    minWithdrawalAmount.value = selectedCountry.value.minAmount?.toInt()??0;
    debugPrint('选择国家: ${selectedCountry.value.payName}, 最大提现金额: $maxAmount , min: ${minWithdrawalAmount.value}, fee: ${selectedCountry.value.fee?.toInt()??0}');
    withdrawAmount.value = '';
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
      errorMessage: I18nKeys.getWithdrawalConfigFailed.tr,
      // 不显示加载状态，避免影响用户体验
      showLoading: false,
    );
  }

  // 验证提现金额
  bool validateWithdrawAmount() {
    try {
      double amount = double.parse(withdrawAmount.value);
      // 使用配置中的最大提现金额（如果有），否则使用实际可用余额
      
      return amount >= minWithdrawalAmount.value && amount <= maxAmount.value;
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
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // 验证支付信息是否完整
    if (accountNumber.value.isEmpty ||
        accountName.value.isEmpty ||
        bankName.value.isEmpty ||
        loginPassword.value.isEmpty) {
      Get.snackbar(
        I18nKeys.error.tr,
        I18nKeys.completePaymentInfo.tr,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // 构建提现请求参数
    final requestData = {
      "account": accountNumber.value,
      "bankId": bankCode.value,
      "phone": phone.value,
      "goldenFlowId": selectedCountry.value.id,
      "loginPassword": loginPassword.value,
      "name": accountName.value,
      "points": int.tryParse(withdrawAmount.value) ?? 0,
    };

    print(
      '提现配置信息 - 每日限额: ${withdrawalSetting.value.oneDayNum}, 最大金额: ${withdrawalSetting.value.maxPoints}',
    );

    print('提现请求参数: $requestData');

    // 使用safeApiCall发送真实提现请求
    safeApiCall(
      // API调用函数
      () async => await _withdrawalApiService.submitWithdrawal(requestData),
      // 成功回调
      (response) {
        setSuccess();
        print('提现请求成功响应: $response');

        // 确保在UI线程上执行UI操作
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // 显示成功提示
          Get.snackbar(
            I18nKeys.success.tr,
            I18nKeys.withdrawSuccess.tr,
            snackPosition: SnackPosition.TOP,
          );
          
          // 短暂延迟后返回上一页，确保用户能看到成功提示
          Future.delayed(const Duration(seconds: 1), () {
            if (Get.key.currentState!.canPop()) {
              Get.back();
            } else {
              // 刷新后 fallback 到首页
              Get.offAllNamed(Routes.root);
            }
          });
        });
      },
      // 自定义错误消息
      errorMessage: I18nKeys.withdrawFailed.tr,
      // 显示加载状态
      showLoading: true,
      // 错误回调
      onError: () {
        print(I18nKeys.withdrawFailed.tr);
        // 错误提示已经由safeApiCall处理
      },
    );
  }

  
}
