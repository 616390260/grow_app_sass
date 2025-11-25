import 'dart:io';
import 'package:dio/dio.dart';
import 'package:do_task_project/app/core/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import '../utils/api_result.dart';
import '../i18n/i18n_keys.dart';
import '../exceptions/api_exception.dart';
import '../utils/message_utils.dart'; // 添加MessageUtils导入
import '../config/environment_config.dart';

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
    if (EnvironmentConfig.instance.enableLogging) {
      print('错误码: $errorCode, 错误信息: $message');
    }
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
    bool showNotification = true,
  }) {
    // 直接使用传入的message
    final errorMessage = message ?? I18nKeys.errorUnknown.tr;
    final code = errorCode ?? 500;
    if (EnvironmentConfig.instance.enableLogging) {
      debugPrint('错误码: $code, 错误信息: $errorMessage');
    }
    // 特殊错误码处理（可选择跳过）- 目前只有401需要特殊处理
    if (!skipSpecialHandling && code == 401) {
      _handleSpecialErrorCode(code);
    } else if (showNotification) {
      // 除401外的其他错误直接显示提示
      if (EnvironmentConfig.instance.enableLogging) {
        debugPrint('showError: 错误信息: $errorMessage');
      }
      MessageUtils.showError(errorMessage);
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
      return ApiResult.failure(msg: I18nKeys.errorNetwork.tr, code: -1);
    } else if (exception is FormatException) {
      return ApiResult.failure(msg: '数据格式错误', code: -5);
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
    bool showNotification = true,  // 添加控制是否显示通知的参数
  }) {
    if (exception is DioException) {
      return _handleDioExceptionException(exception, showNotification: showNotification);
    } else if (exception is SocketException) {
      return _handleSocketExceptionException(exception, showNotification: showNotification);
    } else if (exception is FormatException) {
      return _handleFormatExceptionException(exception, showNotification: showNotification);
    } else {
      if (EnvironmentConfig.instance.enableLogging) {
        print('handleExceptionException未知异常: $customMessage');
      }
      final errorMessage = customMessage ?? I18nKeys.errorUnknown.tr;
      final result = ApiException(code: 500, message: errorMessage);
      
      if (showNotification) {
        MessageUtils.showError(errorMessage); // 改为直接使用MessageUtils.showError显示toast
      }
      
      return result;
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
  ApiException _handleDioExceptionException(
    DioException e, {
    bool showNotification = true,
  }) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        final message = I18nKeys.errorTimeout.tr;
        if (showNotification) {
          MessageUtils.showError(message);
        }
        return ApiException(code: 408, message: message);

      case DioExceptionType.badResponse:
        final responseData = e.response?.data;
        
        // 直接从业务响应中获取错误信息
        String message;
        int? businessCode;
        
        if (responseData is Map<String, dynamic>) {
          // 优先从msg字段获取错误信息（标准API响应格式）
          message = responseData['msg'] as String? ?? 
                   responseData['message'] as String? ?? 
                   e.message ??
                   I18nKeys.errorUnknown.tr;
          // 获取业务错误码
          businessCode = responseData['code'] as int?;
        } else {
          message = e.message ?? I18nKeys.errorUnknown.tr;
        }
        
        final finalErrorCode = businessCode ?? e.response?.statusCode ?? 500;
        
        // 401特殊处理
        if (finalErrorCode == 401) {
          _handleSpecialErrorCode(finalErrorCode);
        } else if (showNotification) {
          MessageUtils.showError(message);
        }
        
        return ApiException(code: finalErrorCode, message: message);

      case DioExceptionType.cancel:
        final message = I18nKeys.errorCancel.tr;
        if (showNotification) {
          MessageUtils.showError(message);
        }
        return ApiException(code: 499, message: message);

      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
      default:
        final message = I18nKeys.errorNetwork.tr;
        if (showNotification) {
          MessageUtils.showError(message);
        }
        return ApiException(code: -1, message: message);
    }
  }

  /// 处理Socket异常 - 直接抛出异常
  ApiException _handleSocketExceptionException(
    SocketException e, {
    bool showNotification = true,
  }) {
    final message = I18nKeys.errorNetwork.tr;
    if (showNotification) {
      MessageUtils.showError(message);
    }
    return ApiException(code: -1, message: message);
  }

  /// 处理格式异常 - 直接抛出异常
  ApiException _handleFormatExceptionException(
    FormatException e, {
    bool showNotification = true,
  }) {
    final message = '数据格式错误';
    if (showNotification) {
      MessageUtils.showError(message);
    }
    return ApiException(code: 400, message: message);
  }



  /// 处理特殊错误码
  void _handleSpecialErrorCode(int? errorCode) {
    if (errorCode == 401) {
      _handleUnauthorized();
    }
  }

  /// 处理未授权错误
  Future<void> _handleUnauthorized() async {
    // 检查当前URL中是否有邀请码，如果有则保存
    final currentInviteCode = _getCurrentInviteCodeFromUrl();
    if (currentInviteCode != null) {
      await _authService.saveInviteCode(currentInviteCode);
    }
    
    // 清除用户信息
    // UserService.instance.clearUserInfo();
    await _authService.clearToken();
    // 清除用户凭据
    await _authService.clearCredentials();
    // 跳转到登录页
    Get.offAllNamed('/login');
  }
  
  /// 从当前URL参数中获取邀请码
  String? _getCurrentInviteCodeFromUrl() {
    // 从Get.parameters中获取邀请码（URL参数中的i参数）
    final inviteCode = Get.parameters['i'] ?? Get.parameters['invite_code'] ?? Get.parameters['referral'];
    return inviteCode?.isNotEmpty == true ? inviteCode : null;
  }

  // 处理禁止访问错误相关逻辑已移除，由上层统一处理
}
