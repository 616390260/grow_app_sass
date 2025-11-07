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
    } else if (account.length > 20) {
      _accountError.value = I18nKeys.accountTooLong.tr;
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
    } else if (password.length > 20) {
      _passwordError.value = I18nKeys.passwordTooLong.tr;
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
    // 账号为6-20位数字
    final accountRegex = RegExp(r'^\d{6,20}$');
    return accountRegex.hasMatch(account);
  }

  /// 检查密码格式是否有效
  bool _isValidPassword(String password) {
    // 密码必须为6-20位字母和数字
    final passwordRegex = RegExp(r'^[a-zA-Z0-9]{6,20}$');
    return passwordRegex.hasMatch(password);
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
  void register() {
    // 统一的表单验证错误处理
    if (!_validateFormWithErrorHandling()) {
      return;
    }

    final account = accountController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;
    final inviteCode = inviteCodeController.text.trim();

    safeApiCall(
      // API调用函数
      () async => await _authApiService.register(
        account: account,
        password: password,
        confirmPassword: confirmPassword,
        inviteCode: inviteCode.isNotEmpty ? inviteCode : null,
      ),
      // 成功回调
      (result) {
        setSuccess();
        showSuccessMessage(I18nKeys.registerSuccess.tr);
        // 注册成功后跳转到登录页面
        Get.offNamed(Routes.login);
      },
      // 自定义错误消息
      errorMessage: I18nKeys.registerFailed.tr,
      // 显示加载状态
      showLoading: true,
    );
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
    Get.toNamed(Routes.login);
  }
}
