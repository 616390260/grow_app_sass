import 'package:get/get.dart';
import 'package:do_task_project/app/core/theme/app_theme.dart';
import 'package:do_task_project/app/core/config/currency_config.dart';
import 'package:do_task_project/app/core/i18n/i18n_keys.dart';
import 'package:do_task_project/app/data/models/user_model.dart';
import 'package:do_task_project/app/data/models/country_model.dart';
import 'package:do_task_project/app/core/models/base_list_entity.dart';
import 'package:do_task_project/app/data/services/auth_api_service.dart';
import 'package:do_task_project/app/data/services/country_api_service.dart';
import 'package:do_task_project/app/core/services/auth_service.dart';
import 'package:do_task_project/app/modules/main/controllers/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../core/base/base_controller.dart';
import '../../../routes/app_pages.dart';

class AccountController extends BaseController {
  // 用户信息
  final userName = 'Alen'.obs;
  final avatar = ''.obs;
  final code = ''.obs;
  final referralCode = 'ILKBWU94'.obs;
  /// 推荐码是否可见，默认隐藏
  final isReferralCodeVisible = false.obs;

  /// 应用版本号
  final appVersion = ''.obs;

  /// 切换推荐码显示/隐藏
  void toggleReferralCodeVisibility() {
    isReferralCodeVisible.value = !isReferralCodeVisible.value;
  }

  final pointsBalance = 100.obs; // 积分
  final trxBalance = 0.0.obs; // TRX 余额
  final showBalance = true.obs;
  final isConvertedDisplay = false.obs; // 是否显示换算后的余额
  // 国家列表（响应式）
  RxList<CountryModel> countries = <CountryModel>[].obs;
  // 认证API服务
  final _authApiService = AuthApiService();
  RxInt selectedCurrencyIndex = (-1).obs; // 默认不选中任何货币
  // 认证服务（包含用户凭据管理）
  final _authService = AuthService.to;
  final CountryApiService _countryApiService = CountryApiService();

  /// 计算属性：当前积分换算的金额
  double get currentConvertedAmount {
    if (countries.isEmpty || selectedCurrencyIndex.value < 0 || selectedCurrencyIndex.value >= countries.length) {
      return 0.0;
    }
    
    final selectedCountry = countries[selectedCurrencyIndex.value];
    return CurrencyConfig.calculateAmount(
      pointsBalance.value.toDouble(), 
      selectedCountry.exchangeRate
    );
  }


  /// 计算属性：当前选中货币的代码
  String get currentCurrencyCode {
    if (countries.isEmpty || selectedCurrencyIndex.value < 0 || selectedCurrencyIndex.value >= countries.length) {
      return '';
    }
    
    final selectedCountry = countries[selectedCurrencyIndex.value];
    return selectedCountry.code ?? '';
  }

  /// 计算属性：当前选中货币的格式化金额字符串
  String get formattedCurrentAmount {
    if (currentCurrencyCode.isEmpty) {
      return '0.00';
    }
    
    return CurrencyConfig.formatAmount(
      currentConvertedAmount, 
      currentCurrencyCode
    );
  }

  @override
  void onInit() {
    super.onInit();
    loadCountries();
    _loadAppVersion();
    // 懒加载：不在这里自动加载数据，等待tab切换时由MainController加载
  }

  /// 加载应用版本号
  Future<void> _loadAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    appVersion.value = 'v${info.version}';
  }

  void loadUserInfo() async {
    await safeApiCall<UserModel>(
      () => _authApiService.getUserInfo<UserModel>(),
      (user) {
        userName.value = user.userName ?? '';
        avatar.value = user.avatar ?? '';
        code.value = user.code ?? '';
        referralCode.value = user.inviteCode ?? '';
        pointsBalance.value = user.points ?? 0;
        trxBalance.value = (user.points ?? 0) * (user.exchangeRate ?? 0.0);
        setSuccess();
      },
      errorMessage: I18nKeys.loadUserInfoFailed.tr,
      showLoading: true,
      onError: () {
        setError(I18nKeys.loadUserInfoFailed.tr);
      },
    );
  }

  // 显隐余额
  void toggleBalanceVisibility() {
    showBalance.value = !showBalance.value;
  }

  // 复制推荐码
  Future<void> copyReferral() async {
    await Clipboard.setData(ClipboardData(text: referralCode.value));
    showInfoMessage(I18nKeys.copiedToClipboard.tr);
  }

  // 交互入口
  void onWithdrawTap() {
    Get.toNamed(Routes.accountWithdrawal);
  }

  // 收益明细点击事件
  void onIncomeDetailsTap() {
    Get.toNamed(Routes.incomeDetails);
  }

  void onWithdrawalOrdersTap() {
    // Navigate to withdrawal orders page
    Get.toNamed(Routes.withdrawalOrders);
  }

  void onChangePasswordTap() {
    Get.toNamed(Routes.changePassword);
  }

  void onLanguageSettingsTap() {
    Get.toNamed(Routes.languageSettings);
  }

  void onLogoutTap() async {
    // 显示确认对话框
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: Text(I18nKeys.confirmExit.tr),
        content: Text(I18nKeys.confirmExitMessage.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(I18nKeys.cancel.tr),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(I18nKeys.confirmExit.tr),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // 执行退出登录
    await _performLogout();
  }

  /// 执行退出登录操作
  Future<void> _performLogout() async {
    // 在退出登录前保存邀请码（如果有）
    await _saveCurrentInviteCode();
    
    await safeApiCall<Map<String, dynamic>>(
      () => _authApiService.logout(),
      (_) async {
        await _clearLocalData();
        showSuccessMessage(I18nKeys.logoutSuccess.tr);
        Get.offAllNamed(Routes.login);
      },
      errorMessage: I18nKeys.logoutFailedClearData.tr,
      showLoading: true,
      onError: () async {
        await _clearLocalData();
        showInfoMessage(I18nKeys.logoutFailedClearData.tr);
        Get.offAllNamed(Routes.login);
      },
    );
  }

  /// 保存当前URL中的邀请码
  Future<void> _saveCurrentInviteCode() async {
    try {
      // 从URL参数中获取邀请码
      final inviteCode = Get.parameters['i'] ?? Get.parameters['invite_code'] ?? Get.parameters['referral'];
      if (inviteCode?.isNotEmpty == true) {
        await _authService.saveInviteCode(inviteCode!);
      }
    } catch (e) {
      debugPrint('保存邀请码时出错: $e');
    }
  }

  /// 清除本地数据
  Future<void> _clearLocalData() async {
    try {
      // 清除用户凭据
      await _authService.clearCredentials();
      await _authService.clearToken();
      
      // 清除用户信息
      userName.value = '';
      referralCode.value = '';
      pointsBalance.value = 0;
      trxBalance.value = 0.0;
      
      // 可以在这里添加其他需要清除的本地数据
      // 例如：清除缓存、清除其他存储的用户数据等
      
    } catch (e) {
      debugPrint('清除本地数据时出错: $e');
    }
  }

  /// 切换到群客服tab
  void switchToServiceTab() {
    // 获取MainController并切换到群客服tab（索引3）
    final mainController = Get.find<MainController>();
    mainController.onTabChanged(3);
  }

   // 加载国家列表
  void loadCountries() {
    safeApiCall(
      // API调用函数
      () async => await _countryApiService.getCountryList(),
      // 成功回调
      (BaseListEntity<CountryModel> response) {
        try {
          // 获取到国家列表数量: ${response.records.length}

          final List<CountryModel> countryList = response.records;

          // 更新国家列表
          if (countryList.isNotEmpty) {
            countries.assignAll(countryList);
          }
        } catch (e) {
          // 处理国家列表时异常: $e
        }
      },
      // 自定义错误消息
      errorMessage: I18nKeys.loadCountriesFailed.tr,
      // 不显示全局加载状态，避免与其他操作冲突
      showLoading: false,
      // 错误回调（保持静默失败）
      onError: () {
        // I18nKeys.loadCountriesFailed.tr
      },
    );
  }

  // 显示兑换弹窗
  void showExchangePop() {
    // 确保有数据
    if (countries.isEmpty) {
      loadCountries();
      // 给数据加载一点时间
      Future.delayed(const Duration(milliseconds: 2000), () {
        _showModal();
      });
    } else {
      _showModal();
    }
  }
  
  // 显示底部弹窗的私有方法
  void _showModal() {
    showModalBottomSheet(
      context: Get.context!,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 标题和关闭按钮行
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    I18nKeys.selectCurrency.tr,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.threeColor,
                    ),
                  ),
                  InkWell(
                    onTap: () => Get.back(),
                    child: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // 货币列表
              Obx(() {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: List.generate(countries.length, (index) {
                    final country = countries[index];
                    final isSelected = selectedCurrencyIndex.value == index;
                    final pointsAmount = 100;
                    final exchangeAmount = pointsAmount * (country.exchangeRate ?? 0);
                    
                    return InkWell(
                      onTap: () {
                        selectedCurrencyIndex.value = index;
                        isConvertedDisplay.value = true; // 切换到换算显示模式
                        Get.back();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: AppTheme.nineColor,
                              width: 0.5,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '$pointsAmount${I18nKeys.points.tr} = ${exchangeAmount.toStringAsFixed(2)} ${country.code}',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.threeColor,
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check,
                                color: AppTheme.primaryColor,
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
