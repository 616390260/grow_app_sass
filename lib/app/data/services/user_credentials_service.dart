import 'package:get_storage/get_storage.dart';

/// 用户凭据存储服务
/// 用于保存和读取记住的账号密码信息
class UserCredentialsService {
  static const String _storageKey = 'user_credentials';
  static const String _accountKey = 'remembered_account';
  static const String _passwordKey = 'remembered_password';
  static const String _rememberPasswordKey = 'remember_password_enabled';
  
  final GetStorage _storage = GetStorage();

  /// 保存用户凭据
  /// [account] 账号
  /// [password] 密码
  /// [rememberPassword] 是否记住密码
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
      // 如果不记住密码，清除已保存的凭据
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
}