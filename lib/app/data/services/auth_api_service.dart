import '../../core/services/http_service.dart';
import '../../core/utils/api_result.dart';

/// 认证相关 API 服务
class AuthApiService {
  final HttpService _httpService = HttpService.to;

  static const String _registerEndpoint = 'app/register';
  static const String _loginEndpoint = 'app/login';
  static const String _logoutEndpoint = 'app/user/logout';

  /// 注册
  /// 返回服务端原始数据 `Map<String, dynamic>`，并通过 `ApiResult` 封装成功/失败
  /// 注册过程中的错误不会触发自动跳转到登录页
  Future<ApiResult<Map<String, dynamic>>> register({
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

    // 使用 HttpService 的 post 方法，但后续自定义处理响应
    final response = await _httpService.post<Map<String, dynamic>>(
      _registerEndpoint,
      data: data,
      fromJson: (json) => json is Map<String, dynamic> ? json : <String, dynamic>{},
    );

    // 如果是失败结果且错误码是 401，重新创建一个不会触发跳转的结果
    if (!response.isSuccess && response.errorCode == 401) {
      return ApiResult.failure(
        message: response.message,
        errorCode: response.errorCode,
      );
    }

    return response;
  }

  /// 登录
  /// 返回服务端原始数据 `Map<String, dynamic>`，并通过 `ApiResult` 封装成功/失败
  Future<ApiResult<Map<String, dynamic>>> login({
    required String account,
    required String password,
  }) async {
    final queryParameters = <String, dynamic>{
      'account': account,
      'password': password,
    };

    return await _httpService.get<Map<String, dynamic>>(
      _loginEndpoint,
      queryParameters: queryParameters,
      fromJson: (json) => json is Map<String, dynamic> ? json : <String, dynamic>{},
    );
  }

  /// 退出登录
  /// 返回服务端原始数据 `Map<String, dynamic>`，并通过 `ApiResult` 封装成功/失败
  Future<ApiResult<Map<String, dynamic>>> logout() async {
    return await _httpService.post<Map<String, dynamic>>(
      _logoutEndpoint,
      fromJson: (json) => json is Map<String, dynamic> ? json : <String, dynamic>{},
    );
  }
}
