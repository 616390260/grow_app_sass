import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/i18n/i18n_keys.dart';
import '../../../routes/app_pages.dart';
import '../../../data/services/auth_api_service.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/auth_service.dart';

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

  // 认证服务（包含用户凭据管理）
  final _authService = AuthService.to;

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
    if (_authService.hasCredentials()) {
      final credentials = _authService.getCredentials();
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
    if (account.length < 6) {
      accountError.value = I18nKeys.accountTooShort.tr;
      return false;
    }
    if (account.length > 20) {
      accountError.value = I18nKeys.accountTooLong.tr;
      return false;
    }
    if (!_isValidAccount(account)) {
      accountError.value = I18nKeys.accountInvalid.tr;
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
    if (password.length > 20) {
      passwordError.value = I18nKeys.passwordTooLong.tr;
      return false;
    }
    if (!_isValidPassword(password)) {
      passwordError.value = I18nKeys.passwordInvalid.tr;
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
  void login() {
    if (!validateForm()) {
      return;
    }

    final account = accountController.text.trim();
    final password = passwordController.text;

    safeApiCall(
      // API调用函数
      () async => await _authApiService.login(
        account: account,
        password: password,
      ),
      // 成功回调
      (token) async {
        setSuccess();
        showSuccessMessage(I18nKeys.loginSuccess.tr);
        
        // 使用认证服务保存token
        try {
          if (token.isNotEmpty) {
            await _authService.saveToken(token);
          }
        } catch (_) {
          // 忽略token解析异常，避免影响登录流程
        }

        // 保存凭据（如果用户选择记住密码）
        await _authService.saveCredentials(
          account: account,
          password: password,
          rememberPassword: rememberPassword.value,
        );

        // 登录成功后跳转到主页
        Get.offAllNamed(Routes.main);
      },
      // 自定义错误消息
      errorMessage: I18nKeys.loginFailed.tr,
      // 显示加载状态
      showLoading: true,
    );
  }

  // 检查账号格式是否有效
  bool _isValidAccount(String account) {
    // 账号为6-20位数字
    final accountRegex = RegExp(r'^\d{6,20}$');
    return accountRegex.hasMatch(account);
  }

  // 检查密码格式是否有效
  bool _isValidPassword(String password) {
    // 密码必须为6-20位字母和数字
    final passwordRegex = RegExp(r'^[a-zA-Z0-9]{6,20}$');
    return passwordRegex.hasMatch(password);
  }

  // 跳转到注册页
  void goToRegister() {
    Get.toNamed(Routes.register);
  }

  // 忘记密码
  void forgotPassword() {
    showInfoMessage(I18nKeys.forgotPasswordTip.tr);
  }

  // 清除记住的密码
  Future<void> clearRememberedPassword() async {
    await _authService.clearCredentials();
    accountController.clear();
    passwordController.clear();
    rememberPassword.value = false;
    showSuccessMessage(I18nKeys.passwordClearedSuccess.tr);
  }
}
