import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../utils/api_result.dart';
import '../i18n/i18n_keys.dart';

/// 统一的错误处理中心
/// 整合所有错误处理逻辑，避免重复代码
class ErrorHandlerCenter {
  static final ErrorHandlerCenter _instance = ErrorHandlerCenter._internal();
  factory ErrorHandlerCenter() => _instance;
  ErrorHandlerCenter._internal();

  /// 处理错误码
  ApiResult<T> handleErrorCode<T>(int? errorCode, String? message, {bool skipSpecialHandling = false}) {
    final errorMessage = _getErrorMessage(errorCode, message);
    
    // 特殊错误码处理（可选择跳过）
    if (!skipSpecialHandling) {
      _handleSpecialErrorCode(errorCode);
    }
    
    return ApiResult.failure(
      msg: errorMessage,
      code: errorCode ?? 400,
    );
  }

  /// 处理错误码 - 直接抛出异常
  Exception handleErrorCodeException(int? errorCode, String? message, {bool skipSpecialHandling = false}) {
    final errorMessage = _getErrorMessage(errorCode, message);
    
    // 特殊错误码处理（可选择跳过）
    if (!skipSpecialHandling) {
      _handleSpecialErrorCode(errorCode);
    }
    
    return Exception(errorMessage);
  }

  /// 处理异常
  ApiResult<T> handleException<T>(Exception exception, {String? customMessage}) {
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
  Exception handleExceptionException(Exception exception, {String? customMessage}) {
    if (exception is DioException) {
      return _handleDioExceptionException(exception);
    } else if (exception is SocketException) {
      return _handleSocketExceptionException(exception);
    } else if (exception is FormatException) {
      return _handleFormatExceptionException(exception);
    } else {
      return Exception(customMessage ?? I18nKeys.errorUnknown.tr);
    }
  }

  /// 处理Dio异常
  ApiResult<T> _handleDioException<T>(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiResult.failure(
          msg: I18nKeys.errorTimeout.tr,
          code: 408,
        );
      
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? e.message;
        return handleErrorCode<T>(statusCode, message);
      
      case DioExceptionType.cancel:
        return ApiResult.failure(
          msg: '请求已取消',
          code: -2,
        );
      
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
      default:
        return ApiResult.failure(
          msg: I18nKeys.errorNetwork.tr,
          code: -3,
        );
    }
  }

  /// 处理Dio异常 - 直接抛出异常
  Exception _handleDioExceptionException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception(I18nKeys.errorTimeout.tr);
      
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? e.message;
        return handleErrorCodeException(statusCode, message);
      
      case DioExceptionType.cancel:
        return Exception('请求已取消');
      
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
      default:
        return Exception(I18nKeys.errorNetwork.tr);
    }
  }

  /// 处理Socket异常
  ApiResult<T> _handleSocketException<T>(SocketException e) {
    return ApiResult.failure(
      msg: I18nKeys.errorNetwork.tr,
      code: -4,
    );
  }

  /// 处理Socket异常 - 直接抛出异常
  Exception _handleSocketExceptionException(SocketException e) {
    return Exception(I18nKeys.errorNetwork.tr);
  }

  /// 处理格式异常
  ApiResult<T> _handleFormatException<T>(FormatException e) {
    return ApiResult.failure(
      msg: '数据格式错误',
      code: -5,
    );
  }

  /// 处理格式异常 - 直接抛出异常
  Exception _handleFormatExceptionException(FormatException e) {
    return Exception('数据格式错误');
  }

  /// 获取错误消息
  String _getErrorMessage(int? errorCode, String? message) {
    // 如果有自定义消息且不为空，优先使用
    if (message?.isNotEmpty == true) return message!;
    
    // 根据错误码返回国际化消息
    switch (errorCode) {
      // HTTP状态码
      case 400: return I18nKeys.error400.tr;
      case 401: return I18nKeys.error401.tr;
      case 403: return I18nKeys.error403.tr;
      case 404: return I18nKeys.error404.tr;
      case 405: return I18nKeys.error405.tr;
      case 408: return I18nKeys.error408.tr;
      case 409: return I18nKeys.error409.tr;
      case 422: return I18nKeys.error422.tr;
      case 429: return I18nKeys.error429.tr;
      case 500: return I18nKeys.error500.tr;
      case 502: return I18nKeys.error502.tr;
      case 503: return I18nKeys.error503.tr;
      case 504: return I18nKeys.error504.tr;
      
      // 业务错误码 1xxx 系列 - 用户相关
      case 1001: return I18nKeys.error1001.tr;
      case 1002: return I18nKeys.error1002.tr;
      case 1003: return I18nKeys.error1003.tr;
      case 1004: return I18nKeys.error1004.tr;
      case 1005: return I18nKeys.error1005.tr;
      case 1006: return I18nKeys.error1006.tr;
      
      // 业务错误码 2xxx 系列 - 权限相关
      case 2001: return I18nKeys.error2001.tr;
      case 2002: return I18nKeys.error2002.tr;
      case 2003: return I18nKeys.error2003.tr;
      
      // 业务错误码 3xxx 系列 - 数据相关
      case 3001: return I18nKeys.error3001.tr;
      case 3002: return I18nKeys.error3002.tr;
      case 3003: return I18nKeys.error3003.tr;
      
      default: return I18nKeys.errorUnknown.tr;
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
  void _handleUnauthorized() {
    // 清除用户信息
    // UserService.instance.clearUserInfo();
    
    // 跳转到登录页
    Get.offAllNamed('/login');
  }

  // 处理禁止访问错误：去除直接弹提示，由上层统一展示
  void _handleForbidden() {
    // 保留方法以兼容旧调用，但不做UI提示，避免重复弹窗
  }
}