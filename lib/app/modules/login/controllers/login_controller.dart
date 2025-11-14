import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/i18n/i18n_keys.dart';
import '../../../routes/app_pages.dart';
import '../../../data/services/auth_api_service.dart';
import '../../../core/services/auth_service.dart';

class LoginController extends BaseController {
  // 表单控制器
  late final TextEditingController accountController;
  late final TextEditingController passwordController;

  // 不再在此处定义FocusNode，改为在View中管理

  // 响应式变量
  final isPasswordVisible = false.obs;
  final rememberPassword = false.obs;
  final accountError = ''.obs;
  final passwordError = ''.obs;
  bool _isDisposed = false; // 标记控制器是否已被dispose

  // 认证服务（包含用户凭据管理和邀请码管理）
  final _authService = AuthService.to;

  // 认证API服务
  final _authApiService = AuthApiService();

  /// 暴露认证服务给View使用（用于获取邀请码）
  AuthService get authService => _authService;

  @override
  void onInit() {
    super.onInit();
    // 初始化TextEditingController
    accountController = TextEditingController();
    passwordController = TextEditingController();
    _isDisposed = false;
    
    // 加载保存的凭据
    _loadSavedCredentials();

    // 监听输入变化，清除错误信息
    accountController.addListener(() {
      if (!_isDisposed && accountError.value.isNotEmpty) {
        accountError.value = '';
      }
    });

    passwordController.addListener(() {
      if (!_isDisposed && passwordError.value.isNotEmpty) {
        passwordError.value = '';
      }
    });
  }

  @override
  void onClose() {
    // 标记控制器已被dispose
    _isDisposed = true;
    // 只清理TextEditingController，FocusNode已在View中管理
    accountController.dispose();
    passwordController.dispose();
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
        // 检查控制器是否已被dispose
        if (_isDisposed) {
          return;
        }
        
        // 1. 先保存token和凭据，确保所有依赖TextEditingController的操作在控制器dispose前完成
        try {
          // 使用认证服务保存token
          if (token.isNotEmpty) {
            await _authService.saveToken(token);
          }

          // 保存凭据（如果用户选择记住密码）
          await _authService.saveCredentials(
            account: account,
            password: password,
            rememberPassword: rememberPassword.value,
          );
        } catch (_) {
          // 忽略异常，避免影响登录流程
        }
        
        // 再次检查控制器是否已被dispose
        if (_isDisposed) {
          return;
        }
        
        // 2. 设置成功状态和显示成功消息
        setSuccess();
        showSuccessMessage(I18nKeys.loginSuccess.tr);

        // 3. 最后执行页面跳转 - 这会导致控制器被dispose
        // 使用WidgetsBinding来确保在UI帧结束后执行跳转
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!_isDisposed) {
            Get.offAllNamed(Routes.root);
          }
        });
      },
      // 自定义错误消息
      // errorMessage: I18nKeys.loginFailed.tr,
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
    // 直接从URL参数获取邀请码，更简单可靠
    final inviteCode = _getInviteCodeFromUrl();
    
    // 如果有邀请码，传递给注册页面
    if (inviteCode != null && inviteCode.isNotEmpty) {
      Get.toNamed('${Routes.register}?i=$inviteCode');
    } else {
      Get.toNamed(Routes.register);
    }
  }

  /// 从URL参数获取邀请码（跨平台）- 主方法
  String? _getInviteCodeFromUrl() {
    try {
      // 从Get参数中获取邀请码（适用于所有平台）
      final inviteCode = Get.parameters['i'];
      if (inviteCode != null && inviteCode.isNotEmpty) {
        return inviteCode;
      }
    } catch (e) {
      // 捕获可能的错误，避免影响页面正常加载
      debugPrint('获取URL邀请码失败: $e');
    }
    return null;
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
