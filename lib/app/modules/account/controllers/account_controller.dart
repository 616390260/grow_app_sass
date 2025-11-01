import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/i18n/i18n_keys.dart';
import '../../../routes/app_pages.dart';
import '../../../data/services/auth_api_service.dart';
import '../../../data/services/user_credentials_service.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/user_model.dart';

class AccountController extends BaseController {
  // 用户信息
  final userName = 'Alen'.obs;
  final avatar = ''.obs;
  final referralCode = 'ILKBWU94'.obs;
  final pointsBalance = 100.0.obs; // 积分
  final trxBalance = 0.04.obs; // TRX 余额
  final showBalance = true.obs;
  
  // 认证API服务
  final _authApiService = AuthApiService();
  
  // 用户凭据服务
  final _credentialsService = UserCredentialsService();

  @override
  void onInit() {
    super.onInit();
    // 懒加载：不在这里自动加载数据，等待tab切换时由MainController加载
  }

  void loadUserInfo() async {
    try {
      setLoading(true);
      // 直接使用AuthApiService返回的UserModel对象
      final user = await _authApiService.getUserInfo<UserModel>();

      userName.value = user.userName ?? '';
      avatar.value = user.avatar ?? '';
      referralCode.value = user.inviteCode ?? '';
      pointsBalance.value = user.points ?? 0.0;
      trxBalance.value = user.exchangeRate?? 0.0;
          // 注意：UserModel中没有trxBalance字段，暂时保留默认值
      setSuccess();
    } catch (e) {
      debugPrint('加载用户信息失败: $e');
      setSuccess(); // 确保即使出错也设置为成功状态
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
    Get.toNamed(Routes.ACCOUNT_WITHDRAWAL);
  }

  void onIncomeDetailsTap() {
    showInfoMessage(I18nKeys.incomeDetails.tr);
  }

  void onWithdrawalOrdersTap() {
    // Navigate to withdrawal orders page
    Get.toNamed(Routes.WITHDRAWAL_ORDERS);
  }

  void onChangePasswordTap() {
    Get.toNamed(Routes.CHANGE_PASSWORD);
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
    try {
      setLoading(true);
      // 直接调用AuthApiService的logout方法
      await _authApiService.logout();
      
      // 无论API调用成功与否，都执行本地清理操作
      await _clearLocalData();
      
      showSuccessMessage('退出成功');
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      debugPrint('退出登录失败: $e');
      // 即使API调用失败，也执行本地清理操作
      await _clearLocalData();
      showInfoMessage('已清除本地数据，请重新登录');
      Get.offAllNamed(Routes.LOGIN);
    } finally {
      setLoading(false);
    }
  }

  /// 清除本地数据
  Future<void> _clearLocalData() async {
    try {
      // 清除用户凭据
      await _credentialsService.clearCredentials();
      // 清除本地token
      await GetStorage().remove(AppConstants.storageKeyUserToken);
      
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
