import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../core/constants/app_constants.dart';

/// 认证服务类
/// 整合认证状态管理和用户凭据管理
class AuthService extends GetxService {
  static AuthService get to => Get.find();
  
  final GetStorage _storage = GetStorage();
  
  // ===== 认证状态管理 =====
  
  /// 检查用户是否已登录（token是否存在且有效）
  bool get isLoggedIn {
    final token = _storage.read<String>(AppConstants.storageKeyUserToken);
    return token != null && token.isNotEmpty;
  }
  
  /// 获取用户token
  String? get token {
    return _storage.read<String>(AppConstants.storageKeyUserToken);
  }
  
  /// 保存用户token
  Future<void> saveToken(String token) async {
    await _storage.write(AppConstants.storageKeyUserToken, token);
  }
  
  /// 清除用户token（退出登录）
  Future<void> clearToken() async {
    await _storage.remove(AppConstants.storageKeyUserToken);
  }
  
  // ===== 邀请码管理 =====
  
  static const String _inviteCodeKey = 'pending_invite_code';
  
  /// 保存邀请码
  Future<void> saveInviteCode(String inviteCode) async {
    await _storage.write(_inviteCodeKey, inviteCode);
  }
  
  /// 获取待处理的邀请码
  String? getPendingInviteCode() {
    return _storage.read<String>(_inviteCodeKey);
  }
  
  /// 清除待处理的邀请码
  Future<void> clearPendingInviteCode() async {
    await _storage.remove(_inviteCodeKey);
  }
  
  /// 检查是否有待处理的邀请码
  bool hasPendingInviteCode() {
    final code = getPendingInviteCode();
    return code != null && code.isNotEmpty;
  }
  
  /// 验证token是否有效
  bool isTokenValid(String? token) {
    if (token == null || token.isEmpty) {
      return false;
    }
    return true;
  }
  
  /// 检查是否需要跳转到登录页面
  bool get needLogin {
    return !isLoggedIn;
  }
  
  // ===== 用户凭据管理 =====
  
  static const String _accountKey = 'remembered_account';
  static const String _passwordKey = 'remembered_password';
  static const String _rememberPasswordKey = 'remember_password_enabled';
  
  /// 保存用户凭据（记住密码功能）
  Future<void> saveCredentials({
    required String account,
    required String password,
    required bool rememberPassword,
  }) async {
    if (rememberPassword) {
      await _storage.write(_accountKey, account);
      await _storage.write(_passwordKey, password);
      await _storage.write(_rememberPasswordKey, true);
    } else {
      await clearCredentials();
    }
  }
  
  /// 获取保存的账号
  String? getSavedAccount() {
    if (!isRememberPasswordEnabled()) return null;
    return _storage.read<String>(_accountKey);
  }
  
  /// 获取保存的密码
  String? getSavedPassword() {
    if (!isRememberPasswordEnabled()) return null;
    return _storage.read<String>(_passwordKey);
  }
  
  /// 检查是否启用了记住密码功能
  bool isRememberPasswordEnabled() {
    return _storage.read<bool>(_rememberPasswordKey) ?? false;
  }
  
  /// 清除所有保存的凭据
  Future<void> clearCredentials() async {
    await _storage.remove(_accountKey);
    await _storage.remove(_passwordKey);
    await _storage.remove(_rememberPasswordKey);
  }
  
  /// 检查是否有保存的凭据
  bool hasCredentials() {
    return isRememberPasswordEnabled() && 
           getSavedAccount()?.isNotEmpty == true && 
           getSavedPassword()?.isNotEmpty == true;
  }
  
  /// 获取完整的凭据信息
  Map<String, dynamic> getCredentials() {
    return {
      'account': getSavedAccount() ?? '',
      'password': getSavedPassword() ?? '',
      'rememberPassword': isRememberPasswordEnabled(),
    };
  }
  
  // ===== 统一退出登录 =====
  
  /// 完整的退出登录流程
  Future<void> logout() async {
    // 清除token
    await clearToken();
    // 清除凭据
    await clearCredentials();
  }
}