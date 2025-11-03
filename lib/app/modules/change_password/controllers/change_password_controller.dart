import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/i18n/i18n_keys.dart';
import '../../../data/services/auth_api_service.dart';

class ChangePasswordController extends BaseController {
  // 表单控制器
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();

  // 焦点控制器
  final oldPasswordFocus = FocusNode();
  final newPasswordFocus = FocusNode();

  // 响应式变量
  final oldPasswordError = ''.obs;
  final newPasswordError = ''.obs;
  final isOldPasswordVisible = false.obs;
  final isNewPasswordVisible = false.obs;

  // API服务
  final _authApiService = AuthApiService();

  @override
  void onInit() {
    super.onInit();
    // 设置监听器，当输入变化时清除错误信息
    oldPasswordController.addListener(() {
      if (oldPasswordError.value.isNotEmpty) {
        oldPasswordError.value = '';
      }
    });
    newPasswordController.addListener(() {
      if (newPasswordError.value.isNotEmpty) {
        newPasswordError.value = '';
      }
    });
  }

  @override
  void onClose() {
    // 清理资源
    oldPasswordController.dispose();
    newPasswordController.dispose();
    oldPasswordFocus.dispose();
    newPasswordFocus.dispose();
    super.onClose();
  }

  // 切换密码可见性
  void toggleOldPasswordVisibility() {
    isOldPasswordVisible.value = !isOldPasswordVisible.value;
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  // 验证旧密码
  bool _validateOldPassword() {
    final password = oldPasswordController.text;
    if (password.isEmpty) {
      oldPasswordError.value = I18nKeys.passwordRequired.tr;
      return false;
    }
    if (password.length < 6) {
      oldPasswordError.value = I18nKeys.passwordTooShort.tr;
      return false;
    }
    oldPasswordError.value = '';
    return true;
  }

  // 验证新密码
  bool _validateNewPassword() {
    final password = newPasswordController.text;
    if (password.isEmpty) {
      newPasswordError.value = I18nKeys.passwordRequired.tr;
      return false;
    }
    if (password.length < 6) {
      newPasswordError.value = I18nKeys.passwordTooShort.tr;
      return false;
    }
    if (!_isValidPassword(password)) {
      newPasswordError.value = I18nKeys.passwordInvalid.tr;
      return false;
    }
    newPasswordError.value = '';
    return true;
  }

  // 检查密码格式是否有效
  bool _isValidPassword(String password) {
    // 密码必须包含字母和数字
    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(password);
    final hasDigit = RegExp(r'\d').hasMatch(password);
    return hasLetter && hasDigit;
  }

  // 验证整个表单
  bool _validateForm() {
    final isOldPasswordValid = _validateOldPassword();
    final isNewPasswordValid = _validateNewPassword();
    return isOldPasswordValid && isNewPasswordValid;
  }

  // 处理修改密码
  Future<void> changePassword() async {
    if (!_validateForm()) {
      return;
    }

    try {
      setLoading(true);
      
      // 调用修改密码的API
      await _authApiService.updatePassword(
        oldPassword: oldPasswordController.text,
        newPassword: newPasswordController.text,
      );
      
      showSuccessMessage('密码修改成功');
      
      // 返回到上一页
      Future.delayed(const Duration(seconds: 1), () {
        Get.back();
      });
      
      setSuccess();
    } catch (e) {
      print('修改密码失败: $e');
      showErrorMessage('修改密码失败，请稍后重试');
    } finally {
      setLoading(false);
    }
  }
}