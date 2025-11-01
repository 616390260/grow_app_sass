import 'package:do_task_project/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/i18n/i18n_keys.dart';
import '../../../data/services/auth_api_service.dart';

class RegisterController extends BaseController {
  // 表单控制器
  final accountController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final inviteCodeController = TextEditingController();

  // 表单焦点
  final accountFocus = FocusNode();
  final passwordFocus = FocusNode();
  final confirmPasswordFocus = FocusNode();
  final inviteCodeFocus = FocusNode();

  // 密码可见性
  final _isPasswordVisible = false.obs;
  bool get isPasswordVisible => _isPasswordVisible.value;

  final _isConfirmPasswordVisible = false.obs;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible.value;

  // 表单验证状态
  final _accountError = ''.obs;
  String get accountError => _accountError.value;
  RxString get accountErrorRx => _accountError;

  final _passwordError = ''.obs;
  String get passwordError => _passwordError.value;
  RxString get passwordErrorRx => _passwordError;

  final _confirmPasswordError = ''.obs;
  String get confirmPasswordError => _confirmPasswordError.value;
  RxString get confirmPasswordErrorRx => _confirmPasswordError;

  final _inviteCodeError = ''.obs;
  String get inviteCodeError => _inviteCodeError.value;
  RxString get inviteCodeErrorRx => _inviteCodeError;

  // 认证API服务
  final _authApiService = AuthApiService();

  @override
  void onInit() {
    super.onInit();
    _setupListeners();
  }

  @override
  void onClose() {
    accountController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    inviteCodeController.dispose();
    accountFocus.dispose();
    passwordFocus.dispose();
    confirmPasswordFocus.dispose();
    inviteCodeFocus.dispose();
    super.onClose();
  }

  /// 设置监听器
  void _setupListeners() {
    accountController.addListener(_validateAccount);
    passwordController.addListener(_validatePassword);
    confirmPasswordController.addListener(_validateConfirmPassword);
    inviteCodeController.addListener(_validateInviteCode);
  }

  /// 切换密码可见性
  void togglePasswordVisibility() {
    _isPasswordVisible.value = !_isPasswordVisible.value;
  }

  /// 切换确认密码可见性
  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible.value = !_isConfirmPasswordVisible.value;
  }

  /// 验证账号
  void _validateAccount() {
    final account = accountController.text.trim();
    if (account.isEmpty) {
      _accountError.value = I18nKeys.accountRequired.tr;
    } else if (account.length < 6) {
      _accountError.value = I18nKeys.accountTooShort.tr;
    } else if (!_isValidAccount(account)) {
      _accountError.value = I18nKeys.accountInvalid.tr;
    } else {
      _accountError.value = '';
    }
  }

  /// 验证密码
  void _validatePassword() {
    final password = passwordController.text;
    if (password.isEmpty) {
      _passwordError.value = I18nKeys.passwordRequired.tr;
    } else if (password.length < 6) {
      _passwordError.value = I18nKeys.passwordTooShort.tr;
    } else if (!_isValidPassword(password)) {
      _passwordError.value = I18nKeys.passwordInvalid.tr;
    } else {
      _passwordError.value = '';
    }
    // 如果确认密码已输入，重新验证确认密码
    if (confirmPasswordController.text.isNotEmpty) {
      _validateConfirmPassword();
    }
  }

  /// 验证确认密码
  void _validateConfirmPassword() {
    final confirmPassword = confirmPasswordController.text;
    final password = passwordController.text;
    if (confirmPassword.isEmpty) {
      _confirmPasswordError.value = I18nKeys.confirmPasswordRequired.tr;
    } else if (confirmPassword != password) {
      _confirmPasswordError.value = I18nKeys.passwordMismatch.tr;
    } else {
      _confirmPasswordError.value = '';
    }
  }

  /// 验证邀请码
  void _validateInviteCode() {
    final inviteCode = inviteCodeController.text.trim();
    if (inviteCode.isNotEmpty && inviteCode.length < 4) {
      _inviteCodeError.value = I18nKeys.inviteCodeInvalid.tr;
    } else {
      _inviteCodeError.value = '';
    }
  }

  /// 检查账号格式是否有效
  bool _isValidAccount(String account) {
    // 支持手机号或邮箱
    final phoneRegex = RegExp(r'^1[3-9]\d{9}$');
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return phoneRegex.hasMatch(account) || emailRegex.hasMatch(account);
  }

  /// 检查密码格式是否有效
  bool _isValidPassword(String password) {
    // 密码必须包含字母和数字
    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(password);
    final hasDigit = RegExp(r'\d').hasMatch(password);
    return hasLetter && hasDigit;
  }

  /// 验证整个表单
  bool _validateForm() {
    _validateAccount();
    _validatePassword();
    _validateConfirmPassword();
    _validateInviteCode();

    return accountError.isEmpty &&
        passwordError.isEmpty &&
        confirmPasswordError.isEmpty &&
        inviteCodeError.isEmpty;
  }

  /// 注册
  Future<void> register() async {
    // 统一的表单验证错误处理
    if (!_validateFormWithErrorHandling()) {
      return;
    }

    final account = accountController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;
    final inviteCode = inviteCodeController.text.trim();

    try {
      setLoading(true);
      // 直接调用AuthApiService的register方法
      await _authApiService.register(
        account: account,
        password: password,
        confirmPassword: confirmPassword,
        inviteCode: inviteCode.isNotEmpty ? inviteCode : null,
      );
      
      setSuccess();
      showSuccessMessage('注册成功');
      // 注册成功后跳转到登录页面
      Get.offNamed(Routes.LOGIN);
    } catch (e) {
      setError('注册失败: $e');
      showErrorMessage('注册失败: $e');
    } finally {
      setLoading(false);
    }
  }

  /// 统一的表单验证错误处理
  bool _validateFormWithErrorHandling() {
    _validateAccount();
    _validatePassword();
    _validateConfirmPassword();
    _validateInviteCode();

    final hasErrors =
        accountError.isNotEmpty ||
        passwordError.isNotEmpty ||
        confirmPasswordError.isNotEmpty ||
        inviteCodeError.isNotEmpty;

    if (hasErrors) {
      // 收集所有错误信息
      final errors = <String>[];
      if (accountError.isNotEmpty) errors.add(accountError);
      if (passwordError.isNotEmpty) errors.add(passwordError);
      if (confirmPasswordError.isNotEmpty) errors.add(confirmPasswordError);
      if (inviteCodeError.isNotEmpty) errors.add(inviteCodeError);

      // 显示第一个错误或通用错误信息
      final errorMessage = errors.isNotEmpty
          ? errors.first
          : I18nKeys.pleaseFixErrors.tr;

      showErrorMessage(errorMessage);
      return false;
    }

    return true;
  }

  /// 跳转到登录页面
  void goToLogin() {
    Get.toNamed(Routes.LOGIN);
  }
}
