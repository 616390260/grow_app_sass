import 'package:do_task_project/app/modules/main/controllers/main_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/i18n/i18n_keys.dart';
import '../../../routes/app_pages.dart';
import '../../../data/services/auth_api_service.dart';
import '../../../data/models/user_model.dart';
import '../../../core/services/auth_service.dart';

class AccountController extends BaseController {
  // 用户信息
  final userName = 'Alen'.obs;
  final avatar = ''.obs;
  final referralCode = 'ILKBWU94'.obs;
  final pointsBalance = 100.obs; // 积分
  final trxBalance = 0.04.obs; // TRX 余额
  final showBalance = true.obs;
  
  // 认证API服务
  final _authApiService = AuthApiService();
  
  // 认证服务（包含用户凭据管理）
  final _authService = AuthService.to;

  @override
  void onInit() {
    super.onInit();
    // 懒加载：不在这里自动加载数据，等待tab切换时由MainController加载
  }

  void loadUserInfo() async {
    await safeApiCall<UserModel>(
      () => _authApiService.getUserInfo<UserModel>(),
      (user) {
        userName.value = user.userName ?? '';
        avatar.value = user.avatar ?? '';
        referralCode.value = user.inviteCode ?? '';
        pointsBalance.value = user.points ?? 0;
        trxBalance.value = user.exchangeRate ?? 0.0;
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
}
