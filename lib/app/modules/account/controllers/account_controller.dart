import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/i18n/i18n_keys.dart';
import '../../../core/managers/api_call_manager.dart';
import '../../../core/utils/api_result.dart';
import '../../../routes/app_pages.dart';
import '../../../data/services/auth_api_service.dart';
import '../../../data/services/user_credentials_service.dart';

class AccountController extends BaseController {
  // 用户信息
  final userName = 'Alen'.obs;
  final referralCode = 'ILKBWU94'.obs;
  final pointsBalance = 100.obs; // 积分
  final trxBalance = 0.04.obs; // TRX 余额
  final showBalance = true.obs;

  // API调用管理器
  final _apiCallManager = ApiCallManager();
  
  // 认证API服务
  final _authApiService = AuthApiService();
  
  // 用户凭据服务
  final _credentialsService = UserCredentialsService();

  @override
  void onInit() {
    super.onInit();
    loadUserInfo();
  }

  void loadUserInfo() async {
    setLoading(true);
    final result = await _apiCallManager.call<Map<String, dynamic>>(
      apiCall: () async {
        await Future.delayed(const Duration(milliseconds: 500));
        // 模拟返回用户信息
        return ApiResult.success(
          data: {
            'userName': 'Alen',
            'referralCode': 'ILKBWU94',
            'pointsBalance': 100,
            'trxBalance': 0.04,
          },
        );
      },
      showLoading: false,
    );

    if (result.isSuccess) {
      final data = result.data ?? {};
      userName.value = data['userName'] ?? 'Alen';
      referralCode.value = data['referralCode'] ?? 'ILKBWU94';
      pointsBalance.value = data['pointsBalance'] ?? 100;
      trxBalance.value = data['trxBalance'] ?? 0.04;
      setSuccess();
    } else {
      setError(result.message);
    }
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
    showInfoMessage(I18nKeys.accountWithdrawal.tr);
  }

  void onIncomeDetailsTap() {
    showInfoMessage(I18nKeys.incomeDetails.tr);
  }

  void onWithdrawalOrdersTap() {
    showInfoMessage(I18nKeys.withdrawalOrders.tr);
  }

  void onChangePasswordTap() {
    showInfoMessage(I18nKeys.changePassword.tr);
  }

  void onLanguageSettingsTap() {
    Get.toNamed(Routes.LANGUAGE_SETTINGS);
  }

  void onLogoutTap() async {
    // 显示确认对话框
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('确认退出'),
        content: const Text('您确定要退出登录吗？'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('确定'),
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
    final result = await _apiCallManager.call<Map<String, dynamic>>(
      apiCall: () async {
        return await _authApiService.logout();
      },
      showLoading: true,
      loadingMessage: '退出中...',
      showSuccessMessage: true,
      successMessage: '退出成功',
      showErrorMessage: true,
    );

    // 无论API调用成功与否，都执行本地清理操作
    await _clearLocalData();

    if (result.isSuccess) {
      // 退出成功，跳转到登录页
      Get.offAllNamed(Routes.LOGIN);
    } else {
      // 即使API调用失败，也跳转到登录页（因为本地数据已清理）
      showInfoMessage('已清除本地数据，请重新登录');
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  /// 清除本地数据
  Future<void> _clearLocalData() async {
    try {
      // 清除用户凭据
      await _credentialsService.clearCredentials();
      
      // 清除用户信息
      userName.value = '';
      referralCode.value = '';
      pointsBalance.value = 0;
      trxBalance.value = 0.0;
      
      // 可以在这里添加其他需要清除的本地数据
      // 例如：清除缓存、清除其他存储的用户数据等
      
    } catch (e) {
      print('清除本地数据时出错: $e');
    }
  }
}
