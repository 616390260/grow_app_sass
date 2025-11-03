import '../../core/services/http_service.dart';
import '../../core/utils/json_convert.dart';
import '../models/user_model.dart';

/// 认证相关 API 服务
class AuthApiService {
  final HttpService _httpService = HttpService.to;

  static const String _registerEndpoint = 'app/register';
  static const String _loginEndpoint = 'app/login';
  static const String _logoutEndpoint = 'app/user/logout';
  static const String _getUserInfoEndpoint = 'app/user/getInfo';

  /// 注册
  /// 返回服务端原始数据 `Map<String, dynamic>`
  /// 注册过程中的错误不会触发自动跳转到登录页
  Future<Map<String, dynamic>> register({
    required String account,
    required String password,
    String? confirmPassword,
    String? inviteCode,
  }) async {
    final data = <String, dynamic>{
      'account': account,
      'password': password,
      if (confirmPassword != null) 'confirmPassword': confirmPassword,
      if (inviteCode != null && inviteCode.isNotEmpty) 'inviteCode': inviteCode,
    };

    // 使用 HttpService 的 postData 方法，直接返回泛型对象
    return await _httpService.postData<Map<String, dynamic>>(
      _registerEndpoint,
      data: data,
    );
  }

  /// 登录
  /// 返回服务端原始数据 `Map<String, dynamic>`
  Future<String> login({
    required String account,
    required String password,
  }) async {
    final queryParameters = <String, dynamic>{
      'account': account,
      'password': password,
    };

    return await _httpService.get<String>(
      _loginEndpoint,
      queryParameters: queryParameters,
    );
  }

  /// 退出登录
  /// 返回服务端原始数据 `Map<String, dynamic>`
  Future<Map<String, dynamic>> logout() async {
    return await _httpService.postData<Map<String, dynamic>>(
      _logoutEndpoint,
    );
  }
  
  /// 获取用户信息
  /// T: 返回类型
  Future<T> getUserInfo<T>() async {
    // 获取原始响应数据（Map<String, dynamic>）
    final responseData = await _httpService.get<Map<String, dynamic>>(
      _getUserInfoEndpoint,
    );
    
    // 特殊处理UserModel类型
    if (T == UserModel) {
      // 直接使用json_serializable生成的fromJson方法
      final userData = (responseData is Map<String, dynamic> && responseData.containsKey('data'))
          ? responseData['data']
          : responseData;
      
      if (userData is Map<String, dynamic>) {
        return UserModel.fromJson(userData) as T;
      }
    }
    
    // 对于其他类型或转换失败的情况，直接返回响应数据
    return responseData as T;
  }
  
  /// 修改密码
  /// 返回服务端原始数据 `Map<String, dynamic>`
  Future<Map<String, dynamic>> updatePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final queryParameters = <String, dynamic>{
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    };

    // 使用 HttpService 的 get 方法，直接返回泛型对象
    return await _httpService.get<Map<String, dynamic>>(
      'app/user/updatePassword',
      queryParameters: queryParameters,
    );
  }
}
