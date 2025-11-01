import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/i18n/i18n_keys.dart';
import '../../../routes/app_pages.dart';
import '../../../data/services/auth_api_service.dart';
import '../../../data/services/user_credentials_service.dart';
import '../../../core/constants/app_constants.dart';

class LoginController extends BaseController {
  // 表单控制器
  final accountController = TextEditingController();
  final passwordController = TextEditingController();

  // 焦点控制器
  final accountFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  // 响应式变量
  final isPasswordVisible = false.obs;
  final rememberPassword = false.obs;
  final accountError = ''.obs;
  final passwordError = ''.obs;

  // 用户凭据服务
  final _credentialsService = UserCredentialsService();

  // 认证API服务
  final _authApiService = AuthApiService();

  @override
  void onInit() {
    super.onInit();

    // 加载保存的凭据
    _loadSavedCredentials();

    // 监听输入变化，清除错误信息
    accountController.addListener(() {
      if (accountError.value.isNotEmpty) {
        accountError.value = '';
      }
    });

    passwordController.addListener(() {
      if (passwordError.value.isNotEmpty) {
        passwordError.value = '';
      }
    });
  }

  @override
  void onClose() {
    accountController.dispose();
    passwordController.dispose();
    accountFocusNode.dispose();
    passwordFocusNode.dispose();
    super.onClose();
  }

  // 切换密码可见性
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // 切换记住密码
  void toggleRememberPassword() {
    rememberPassword.value = !rememberPassword.value;
  }

  // 加载保存的凭据
  void _loadSavedCredentials() {
    if (_credentialsService.hasCredentials()) {
      final credentials = _credentialsService.getCredentials();
      accountController.text = credentials['account'] ?? '';
      passwordController.text = credentials['password'] ?? '';
      rememberPassword.value = credentials['rememberPassword'] ?? false;
    }
  }

  // 验证账号
  bool _validateAccount() {
    final account = accountController.text.trim();
    if (account.isEmpty) {
      accountError.value = I18nKeys.accountRequired.tr;
      return false;
    }
    if (account.length < 3) {
      accountError.value = I18nKeys.accountTooShort.tr;
      return false;
    }
    accountError.value = '';
    return true;
  }

  // 验证密码
  bool _validatePassword() {
    final password = passwordController.text;
    if (password.isEmpty) {
      passwordError.value = I18nKeys.passwordRequired.tr;
      return false;
    }
    if (password.length < 6) {
      passwordError.value = I18nKeys.passwordTooShort.tr;
      return false;
    }
    passwordError.value = '';
    return true;
  }

  // 验证表单
  bool validateForm() {
    final isAccountValid = _validateAccount();
    final isPasswordValid = _validatePassword();
    return isAccountValid && isPasswordValid;
  }

  // 登录
  Future<void> login() async {
    if (!validateForm()) {
      return;
    }

    final account = accountController.text.trim();
    final password = passwordController.text;

    try {
      setLoading(true);
      // 直接调用AuthApiService的login方法
      final token = await _authApiService.login(
        account: account,
        password: password,
      );

      setSuccess();
      showSuccessMessage(I18nKeys.loginSuccess.tr);
      // 解析并保存token到本地（data字段为token字符串）
      try {
        print(token);
        if (token.isNotEmpty) {
          final storage = GetStorage();
          await storage.write(AppConstants.storageKeyUserToken, token);
        }
      } catch (_) {
        // 忽略token解析异常，避免影响登录流程
      }

      // 保存凭据（如果用户选择记住密码）
      await _credentialsService.saveCredentials(
        account: account,
        password: password,
        rememberPassword: rememberPassword.value,
      );

      // 登录成功后跳转到主页
      Get.offAllNamed(Routes.MAIN);
    } catch (e) {
      setError('登录失败: $e');
      showErrorMessage('登录失败: $e');
    } finally {
      setLoading(false);
    }
  }

  // 跳转到注册页
  void goToRegister() {
    Get.toNamed(Routes.REGISTER);
  }

  // 忘记密码
  void forgotPassword() {
    showInfoMessage(I18nKeys.forgotPasswordTip.tr);
  }

  // 清除记住的密码
  Future<void> clearRememberedPassword() async {
    await _credentialsService.clearCredentials();
    accountController.clear();
    passwordController.clear();
    rememberPassword.value = false;
    showSuccessMessage('已清除记住的密码');
  }
}
