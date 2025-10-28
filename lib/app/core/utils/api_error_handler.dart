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
          message: '连接超时，请检查网络连接',
          exception: error,
        );
      
      case DioExceptionType.sendTimeout:
        return ApiResult.networkError(
          message: '请求超时，请稍后重试',
          exception: error,
        );
      
      case DioExceptionType.receiveTimeout:
        return ApiResult.networkError(
          message: '响应超时，请稍后重试',
          exception: error,
        );
      
      case DioExceptionType.badResponse:
        return _handleHttpError<T>(error);
      
      case DioExceptionType.cancel:
        return ApiResult.failure(
          message: '请求已取消',
          exception: error,
        );
      
      case DioExceptionType.connectionError:
        // 检查网络连接状态
        final hasConnection = await _checkNetworkConnection();
        if (!hasConnection) {
          return ApiResult.networkError(
            message: '无网络连接，请检查网络设置',
            exception: error,
          );
        } else {
          return ApiResult.networkError(
            message: '网络连接异常，请稍后重试',
            exception: error,
          );
        }
      
      case DioExceptionType.badCertificate:
        return ApiResult.networkError(
          message: '证书验证失败',
          exception: error,
        );
      
      case DioExceptionType.unknown:
      default:
        return ApiResult.unknownError(
          message: '网络请求失败: ${error.message}',
          exception: error,
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
          message: message.isNotEmpty ? message : '请求参数错误',
        );
      
      case 401:
        return ApiResult.unauthorized(
          message: message.isNotEmpty ? message : '未授权，请重新登录',
        );
      
      case 403:
        return ApiResult.failure(
          message: message.isNotEmpty ? message : '权限不足',
          errorCode: 403,
          exception: error,
        );
      
      case 404:
        return ApiResult.emptyData(
          message: message.isNotEmpty ? message : '请求的资源不存在',
        );
      
      case 422:
        return ApiResult.invalidParams(
          message: message.isNotEmpty ? message : '数据验证失败',
        );
      
      case 429:
        return ApiResult.failure(
          message: message.isNotEmpty ? message : '请求过于频繁，请稍后重试',
          errorCode: 429,
          exception: error,
        );
      
      case 500:
      case 502:
      case 503:
      case 504:
        return ApiResult.serverError(
          message: message.isNotEmpty ? message : '服务器错误，请稍后重试',
          errorCode: statusCode,
          exception: error,
        );
      
      default:
        return ApiResult.failure(
          message: message.isNotEmpty ? message : 'HTTP错误: $statusCode',
          errorCode: statusCode,
          exception: error,
        );
    }
  }

  /// 处理Socket错误
  static ApiResult<T> _handleSocketError<T>(SocketException error) {
    return ApiResult.networkError(
      message: '网络连接失败，请检查网络设置',
      exception: error,
    );
  }

  /// 处理格式化错误
  static ApiResult<T> _handleFormatError<T>(FormatException error) {
    return ApiResult.failure(
      message: '数据格式错误',
      exception: error,
    );
  }

  /// 处理通用错误
  static ApiResult<T> _handleGenericError<T>(Exception error) {
    return ApiResult.unknownError(
      message: '未知错误: ${error.toString()}',
      exception: error,
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
      return ApiResult.success(data: result);
    } catch (e) {
      if (e is Exception) {
        final errorResult = await handleError<T>(e);
        if (errorMessage != null) {
          return ApiResult.failure(
            message: errorMessage,
            errorCode: errorResult.errorCode,
            exception: errorResult.exception,
          );
        }
        return errorResult;
      } else {
        return ApiResult.unknownError(
          message: errorMessage ?? '未知错误: ${e.toString()}',
          exception: Exception(e.toString()),
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
    ApiResult<T> lastResult = ApiResult.failure(message: '未执行');
    
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
        if (lastResult.errorCode == 401 || 
            lastResult.errorCode == 403 || 
            lastResult.errorCode == 400 ||
            lastResult.errorCode == 422) {
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