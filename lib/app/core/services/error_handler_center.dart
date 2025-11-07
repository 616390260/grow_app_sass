import 'dart:io';
import 'package:dio/dio.dart';
import 'package:do_task_project/app/core/services/auth_service.dart';
import 'package:get/get.dart';
import '../utils/api_result.dart';
import '../i18n/i18n_keys.dart';
import '../exceptions/api_exception.dart';

/// 统一的错误处理中心
/// 整合所有错误处理逻辑，避免重复代码
class ErrorHandlerCenter {
  static final ErrorHandlerCenter _instance = ErrorHandlerCenter._internal();
  factory ErrorHandlerCenter() => _instance;
  ErrorHandlerCenter._internal();
  
  /// 延迟获取认证服务实例，避免初始化时未注册的问题
  AuthService get _authService => AuthService.to;
  /// 处理错误码
  ApiResult<T> handleErrorCode<T>(
    int? errorCode,
    String? message, {
    bool skipSpecialHandling = false,
  }) {
    // final errorMessage = _getErrorMessage(errorCode, message);
    print('错误码: $errorCode, 错误信息: $message');
    // 特殊错误码处理（可选择跳过）
    if (!skipSpecialHandling) {
      _handleSpecialErrorCode(errorCode);
    }
    return ApiResult.failure(
      msg: message ?? I18nKeys.errorUnknown.tr,
      code: errorCode ?? 400,
    );
  }

  /// 处理错误码 - 直接抛出异常
  ApiException handleErrorCodeException(
    int? errorCode,
    String? message, {
    bool skipSpecialHandling = false,
  }) {
    final errorMessage = _getErrorMessage(errorCode, message);
    final code = errorCode ?? 500;

    // 特殊错误码处理（可选择跳过）
    if (!skipSpecialHandling) {
      _handleSpecialErrorCode(errorCode);
    }

    return ApiException(code: code, message: errorMessage);
  }

  /// 处理异常
  ApiResult<T> handleException<T>(
    Exception exception, {
    String? customMessage,
  }) {
    if (exception is DioException) {
      return _handleDioException<T>(exception);
    } else if (exception is SocketException) {
      return _handleSocketException<T>(exception);
    } else if (exception is FormatException) {
      return _handleFormatException<T>(exception);
    } else {
      return ApiResult.failure(
        msg: customMessage ?? I18nKeys.errorUnknown.tr,
        code: -1,
      );
    }
  }

  /// 处理异常 - 直接抛出异常
  ApiException handleExceptionException(
    Exception exception, {
    String? customMessage,
  }) {
    if (exception is DioException) {
      return _handleDioExceptionException(exception);
    } else if (exception is SocketException) {
      return _handleSocketExceptionException(exception);
    } else if (exception is FormatException) {
      return _handleFormatExceptionException(exception);
    } else {
      return ApiException(
        code: 500,
        message: customMessage ?? I18nKeys.errorUnknown.tr,
      );
    }
  }

  /// 处理Dio异常
  ApiResult<T> _handleDioException<T>(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiResult.failure(msg: I18nKeys.errorTimeout.tr, code: 408);
      case DioExceptionType.badResponse:
        final response = e.response;
        final statusCode = response?.statusCode;
        final data = response?.data;
        String errorMessage = I18nKeys.errorUnknown.tr;

        if (data is Map<String, dynamic>) {
          errorMessage =
              data['msg'] as String? ??
              data['message'] as String? ??
              errorMessage;
        }

        // 处理特定状态码 - 使用ApiException确保错误码和消息正确传递
        return ApiResult.failure(msg: errorMessage, code: statusCode ?? 500);
      case DioExceptionType.cancel:
        return ApiResult.failure(msg: I18nKeys.errorCancel.tr, code: 499);
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
      default:
        return ApiResult.networkError();
    }
  }

  /// 处理Dio异常 - 直接抛出异常
  ApiException _handleDioExceptionException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(code: 408, message: I18nKeys.errorTimeout.tr);

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? e.message;
        return handleErrorCodeException(statusCode, message);

      case DioExceptionType.cancel:
        return ApiException(code: 499, message: I18nKeys.errorCancel.tr);

      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
      default:
        return ApiException(code: -1, message: I18nKeys.errorNetwork.tr);
    }
  }

  /// 处理Socket异常
  ApiResult<T> _handleSocketException<T>(SocketException e) {
    return ApiResult.failure(msg: I18nKeys.errorNetwork.tr, code: -4);
  }

  /// 处理Socket异常 - 直接抛出异常
  ApiException _handleSocketExceptionException(SocketException e) {
    return ApiException(code: -1, message: I18nKeys.errorNetwork.tr);
  }

  /// 处理格式异常
  ApiResult<T> _handleFormatException<T>(FormatException e) {
    return ApiResult.failure(msg: '数据格式错误', code: -5);
  }

  /// 处理格式异常 - 直接抛出异常
  ApiException _handleFormatExceptionException(FormatException e) {
    return ApiException(code: 400, message: I18nKeys.error400.tr);
  }

  /// 获取错误消息
  String _getErrorMessage(int? errorCode, String? message) {
    // 如果有自定义消息且不为空，优先使用
    if (message?.isNotEmpty == true) return message!;

    // 根据错误码返回国际化消息
    switch (errorCode) {
      // HTTP状态码
      case 400:
        return I18nKeys.error400.tr;
      case 401:
        return I18nKeys.error401.tr;
      case 403:
        return I18nKeys.error403.tr;
      case 404:
        return I18nKeys.error404.tr;
      case 405:
        return I18nKeys.error405.tr;
      case 408:
        return I18nKeys.error408.tr;
      case 409:
        return I18nKeys.error409.tr;
      case 422:
        return I18nKeys.error422.tr;
      case 429:
        return I18nKeys.error429.tr;
      case 500:
        return I18nKeys.error500.tr;
      case 502:
        return I18nKeys.error502.tr;
      case 503:
        return I18nKeys.error503.tr;
      case 504:
        return I18nKeys.error504.tr;

      // 业务错误码 1xxx 系列 - 用户相关
      case 1001:
        return I18nKeys.error1001.tr;
      case 1002:
        return I18nKeys.error1002.tr;
      case 1003:
        return I18nKeys.error1003.tr;
      case 1004:
        return I18nKeys.error1004.tr;
      case 1005:
        return I18nKeys.error1005.tr;
      case 1006:
        return I18nKeys.error1006.tr;

      // 业务错误码 2xxx 系列 - 权限相关
      case 2001:
        return I18nKeys.error2001.tr;
      case 2002:
        return I18nKeys.error2002.tr;
      case 2003:
        return I18nKeys.error2003.tr;

      // 业务错误码 3xxx 系列 - 数据相关
      case 3001:
        return I18nKeys.error3001.tr;
      case 3002:
        return I18nKeys.error3002.tr;
      case 3003:
        return I18nKeys.error3003.tr;

      default:
        return I18nKeys.errorUnknown.tr;
    }
  }

  /// 处理特殊错误码
  void _handleSpecialErrorCode(int? errorCode) {
    switch (errorCode) {
      case 401:
        _handleUnauthorized();
        break;
      default:
        break;
    }
  }

  /// 处理未授权错误
  Future<void> _handleUnauthorized() async {
    // 清除用户信息
    // UserService.instance.clearUserInfo();
    await _authService.clearToken();
    // 清除用户凭据
    await _authService.clearCredentials();
    // 跳转到登录页
    Get.offAllNamed('/login');
  }

  // 处理禁止访问错误相关逻辑已移除，由上层统一处理
}
