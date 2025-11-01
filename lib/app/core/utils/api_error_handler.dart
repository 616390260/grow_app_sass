import 'dart:io';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'api_result.dart';

/// API错误处理工具类
class ApiErrorHandler {
  /// 处理异常并返回ApiResult
  static Future<ApiResult<T>> handleError<T>(Exception exception) async {
    if (exception is DioException) {
      return _handleDioError<T>(exception);
    } else if (exception is SocketException) {
      return _handleSocketError<T>(exception);
    } else if (exception is FormatException) {
      return _handleFormatError<T>(exception);
    } else {
      return _handleGenericError<T>(exception);
    }
  }

  /// 处理Dio网络错误
  static Future<ApiResult<T>> _handleDioError<T>(DioException error) async {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ApiResult.networkError(
          msg: '连接超时，请检查网络连接',
        );
      
      case DioExceptionType.sendTimeout:
        return ApiResult.networkError(
          msg: '请求超时，请稍后重试',
        );
      
      case DioExceptionType.receiveTimeout:
        return ApiResult.networkError(
          msg: '响应超时，请稍后重试',
        );
      
      case DioExceptionType.badResponse:
        return _handleHttpError<T>(error);
      
      case DioExceptionType.cancel:
        return ApiResult.failure(
          msg: '请求已取消',
          code: -2,
        );
      
      case DioExceptionType.connectionError:
        // 检查网络连接状态
        final hasConnection = await _checkNetworkConnection();
        if (!hasConnection) {
          return ApiResult.networkError(
            msg: '无网络连接，请检查网络设置',
          );
        } else {
          return ApiResult.networkError(
            msg: '网络连接异常，请稍后重试',
          );
        }
      
      case DioExceptionType.badCertificate:
        return ApiResult.networkError(
          msg: '证书验证失败',
        );
      
      case DioExceptionType.unknown:
      default:
        return ApiResult.unknownError(
          msg: '网络请求失败: ${error.message}',
        );
    }
  }

  /// 处理HTTP状态码错误
  static ApiResult<T> _handleHttpError<T>(DioException error) {
    final statusCode = error.response?.statusCode;
    final responseData = error.response?.data;
    
    String message = '请求失败';
    
    // 尝试从响应中获取错误信息
    if (responseData is Map<String, dynamic>) {
      message = responseData['message'] ?? 
                responseData['error'] ?? 
                responseData['msg'] ?? 
                message;
    }

    switch (statusCode) {
      case 400:
        return ApiResult.invalidParams(
          msg: message.isNotEmpty ? message : '请求参数错误',
        );
      
      case 401:
        return ApiResult.unauthorized(
          msg: message.isNotEmpty ? message : '未授权，请重新登录',
        );
      
      case 403:
        return ApiResult.failure(
          msg: message.isNotEmpty ? message : '权限不足',
          code: 403,
        );
      
      case 404:
        return ApiResult.emptyData(
          msg: message.isNotEmpty ? message : '请求的资源不存在',
        );
      
      case 422:
        return ApiResult.invalidParams(
          msg: message.isNotEmpty ? message : '数据验证失败',
        );
      
      case 429:
        return ApiResult.failure(
          msg: message.isNotEmpty ? message : '请求过于频繁，请稍后重试',
          code: 429,
        );
      
      case 500:
      case 502:
      case 503:
      case 504:
        return ApiResult.serverError(
          msg: message.isNotEmpty ? message : '服务器错误，请稍后重试',
          code: statusCode ?? 500,
        );
      
      default:
        return ApiResult.failure(
          msg: message.isNotEmpty ? message : 'HTTP错误: $statusCode',
          code: statusCode ?? 500,
        );
    }
  }

  /// 处理Socket错误
  static ApiResult<T> _handleSocketError<T>(SocketException error) {
    return ApiResult.networkError(
      msg: '网络连接失败，请检查网络设置',
    );
  }

  /// 处理格式化错误
  static ApiResult<T> _handleFormatError<T>(FormatException error) {
    return ApiResult.failure(
      msg: '数据格式错误',
      code: -5,
    );
  }

  /// 处理通用错误
  static ApiResult<T> _handleGenericError<T>(Exception error) {
    return ApiResult.unknownError(
      msg: '未知错误: ${error.toString()}',
    );
  }

  /// 检查网络连接状态
  static Future<bool> _checkNetworkConnection() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      return false;
    }
  }

  /// 安全执行API调用
  static Future<ApiResult<T>> safeApiCall<T>(
    Future<T> Function() apiCall, {
    String? errorMessage,
  }) async {
    try {
      final result = await apiCall();
      return ApiResult.success(data: result, msg: '操作成功');
    } catch (e) {
      if (e is Exception) {
        final errorResult = await handleError<T>(e);
        if (errorMessage != null) {
          return ApiResult.failure(
          msg: errorMessage,
          code: errorResult.code,
        );
        }
        return errorResult;
      } else {
        return ApiResult.unknownError(
          msg: errorMessage ?? '未知错误: ${e.toString()}',
        );
      }
    }
  }

  /// 重试机制
  static Future<ApiResult<T>> retryApiCall<T>(
    Future<ApiResult<T>> Function() apiCall, {
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 1),
    bool Function(ApiResult<T> result)? shouldRetry,
  }) async {
    ApiResult<T> lastResult = ApiResult.failure(msg: '未执行', code: -1);
    
    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        lastResult = await apiCall();
        
        if (lastResult.isSuccess) {
          return lastResult;
        }
        
        // 检查是否应该重试
        if (shouldRetry != null && !shouldRetry(lastResult)) {
          break;
        }
        
        // 某些错误不应该重试
        if (lastResult.code == 401 || 
            lastResult.code == 403 || 
            lastResult.code == 400 ||
            lastResult.code == 422) {
          break;
        }
        
        // 如果不是最后一次尝试，则等待后重试
        if (attempt < maxRetries) {
          await Future.delayed(delay * (attempt + 1));
        }
      } catch (e) {
        lastResult = await handleError<T>(
          e is Exception ? e : Exception(e.toString())
        );
        
        if (attempt < maxRetries) {
          await Future.delayed(delay * (attempt + 1));
        }
      }
    }
    
    return lastResult;
  }
}