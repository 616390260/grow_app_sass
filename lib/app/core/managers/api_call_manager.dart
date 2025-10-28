import 'dart:async';
import 'package:get/get.dart';
import '../utils/api_result.dart';
import '../services/error_handler_center.dart';
import '../utils/loading_utils.dart';
import '../utils/message_utils.dart';

/// API调用管理器
/// 提供统一的API调用接口，包含加载状态管理、错误处理和消息显示
class ApiCallManager {
  static final ApiCallManager _instance = ApiCallManager._internal();
  factory ApiCallManager() => _instance;
  ApiCallManager._internal();

  static ApiCallManager get instance => _instance;

  /// 基础API调用方法
  /// 
  /// [apiCall] - API调用函数
  /// [showLoading] - 是否显示加载状态
  /// [loadingMessage] - 加载提示信息
  /// [showSuccessMessage] - 是否显示成功消息
  /// [successMessage] - 成功提示信息
  /// [showErrorMessage] - 是否显示错误消息
  /// [onSuccess] - 成功回调
  /// [onError] - 错误回调
  Future<ApiResult<T>> call<T>({
    required Future<ApiResult<T>> Function() apiCall,
    bool showLoading = true,
    String? loadingMessage,
    bool showSuccessMessage = false,
    String? successMessage,
    bool showErrorMessage = true,
    void Function(T data)? onSuccess,
    void Function(String error)? onError,
  }) async {
    try {
      // 显示加载状态
      if (showLoading) {
        LoadingUtils.showLoading(message: loadingMessage);
      }

      // 执行API调用
      final result = await apiCall();

      // 隐藏加载状态
      if (showLoading) {
        LoadingUtils.hideLoading();
      }

      if (result.isSuccess) {
        // 成功处理
        if (showSuccessMessage && successMessage != null) {
          MessageUtils.showSuccess(successMessage);
        }
        
        if (onSuccess != null && result.data != null) {
          onSuccess(result.data!);
        }
      } else {
        // 错误处理
        if (showErrorMessage) {
          MessageUtils.showError(result.message);
        }
        
        if (onError != null) {
          onError(result.message);
        }
      }

      return result;
    } catch (e) {
      // 隐藏加载状态
      if (showLoading) {
        LoadingUtils.hideLoading();
      }

      // 处理异常
      final errorHandler = ErrorHandlerCenter();
      final errorResult = errorHandler.handleException<T>(
        e is Exception ? e : Exception(e.toString())
      );
      
      if (showErrorMessage) {
        MessageUtils.showError(errorResult.message);
      }
      
      if (onError != null) {
        onError(errorResult.message);
      }

      return errorResult;
    }
  }

  /// 带数据转换的API调用
  /// 
  /// [apiCall] - API调用函数
  /// [transform] - 数据转换函数
  /// [showLoading] - 是否显示加载状态
  /// [loadingMessage] - 加载提示信息
  /// [showSuccessMessage] - 是否显示成功消息
  /// [successMessage] - 成功提示信息
  /// [showErrorMessage] - 是否显示错误消息
  /// [onSuccess] - 成功回调
  /// [onError] - 错误回调
  Future<ApiResult<R>> callWithTransform<T, R>({
    required Future<ApiResult<T>> Function() apiCall,
    required R Function(T data) transform,
    bool showLoading = true,
    String? loadingMessage,
    bool showSuccessMessage = false,
    String? successMessage,
    bool showErrorMessage = true,
    void Function(R data)? onSuccess,
    void Function(String error)? onError,
  }) async {
    final result = await call<T>(
      apiCall: apiCall,
      showLoading: showLoading,
      loadingMessage: loadingMessage,
      showSuccessMessage: false, // 在转换后再显示成功消息
      showErrorMessage: showErrorMessage,
      onError: onError,
    );

    if (result.isSuccess && result.data != null) {
      try {
        final transformedData = transform(result.data!);
        final transformedResult = ApiResult.success(data: transformedData);
        
        if (showSuccessMessage && successMessage != null) {
          MessageUtils.showSuccess(successMessage);
        }
        
        if (onSuccess != null) {
          onSuccess(transformedData);
        }
        
        return transformedResult;
      } catch (e) {
        final errorResult = ApiResult<R>.failure(message: '数据转换失败: ${e.toString()}');
        
        if (showErrorMessage) {
          MessageUtils.showError(errorResult.message);
        }
        
        if (onError != null) {
          onError(errorResult.message);
        }
        
        return errorResult;
      }
    }

    return ApiResult<R>.failure(message: result.message, errorCode: result.errorCode);
  }

  /// 并行API调用
  /// 
  /// [apiCalls] - API调用函数列表
  /// [showLoading] - 是否显示加载状态
  /// [loadingMessage] - 加载提示信息
  /// [showErrorMessage] - 是否显示错误消息
  /// [onSuccess] - 成功回调
  /// [onError] - 错误回调
  Future<List<ApiResult<T>>> callParallel<T>({
    required List<Future<ApiResult<T>> Function()> apiCalls,
    bool showLoading = true,
    String? loadingMessage,
    bool showErrorMessage = true,
    void Function(List<ApiResult<T>> results)? onSuccess,
    void Function(String error)? onError,
  }) async {
    try {
      // 显示加载状态
      if (showLoading) {
        LoadingUtils.showLoading(message: loadingMessage);
      }

      // 并行执行API调用
      final futures = apiCalls.map((call) => call()).toList();
      final results = await Future.wait(futures);

      // 隐藏加载状态
      if (showLoading) {
        LoadingUtils.hideLoading();
      }

      // 检查是否有失败的调用
      final failedResults = results.where((result) => !result.isSuccess).toList();
      
      if (failedResults.isNotEmpty) {
        final errorMessage = '部分请求失败: ${failedResults.map((r) => r.message).join(', ')}';
        
        if (showErrorMessage) {
          MessageUtils.showError(errorMessage);
        }
        
        if (onError != null) {
          onError(errorMessage);
        }
      } else {
        if (onSuccess != null) {
          onSuccess(results);
        }
      }

      return results;
    } catch (e) {
      // 隐藏加载状态
      if (showLoading) {
        LoadingUtils.hideLoading();
      }

      final errorMessage = '并行请求失败: ${e.toString()}';
      
      if (showErrorMessage) {
        MessageUtils.showError(errorMessage);
      }
      
      if (onError != null) {
        onError(errorMessage);
      }

      return [ApiResult<T>.failure(message: errorMessage)];
    }
  }

  /// 带重试的API调用
  /// 
  /// [apiCall] - API调用函数
  /// [maxRetries] - 最大重试次数
  /// [retryDelay] - 重试延迟时间
  /// [showLoading] - 是否显示加载状态
  /// [loadingMessage] - 加载提示信息
  /// [showSuccessMessage] - 是否显示成功消息
  /// [successMessage] - 成功提示信息
  /// [showErrorMessage] - 是否显示错误消息
  /// [onSuccess] - 成功回调
  /// [onError] - 错误回调
  Future<ApiResult<T>> callWithRetry<T>({
    required Future<ApiResult<T>> Function() apiCall,
    int maxRetries = 3,
    Duration retryDelay = const Duration(seconds: 1),
    bool showLoading = true,
    String? loadingMessage,
    bool showSuccessMessage = false,
    String? successMessage,
    bool showErrorMessage = true,
    void Function(T data)? onSuccess,
    void Function(String error)? onError,
  }) async {
    ApiResult<T>? lastResult;
    
    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      final result = await call<T>(
        apiCall: apiCall,
        showLoading: showLoading && attempt == 0, // 只在第一次尝试时显示加载
        loadingMessage: loadingMessage,
        showSuccessMessage: showSuccessMessage,
        successMessage: successMessage,
        showErrorMessage: false, // 在最后失败时才显示错误
        onSuccess: onSuccess,
      );

      if (result.isSuccess) {
        return result;
      }

      lastResult = result;
      
      // 如果不是最后一次尝试，等待后重试
      if (attempt < maxRetries) {
        await Future.delayed(retryDelay);
      }
    }

    // 所有重试都失败了
    if (showErrorMessage && lastResult != null) {
      MessageUtils.showError('重试${maxRetries}次后仍然失败: ${lastResult.message}');
    }
    
    if (onError != null && lastResult != null) {
      onError(lastResult.message);
    }

    return lastResult ?? ApiResult<T>.failure(message: '未知错误');
  }

  /// 带去重的API调用（防止重复请求）
  /// 
  /// [key] - 请求唯一标识
  /// [apiCall] - API调用函数
  /// [showLoading] - 是否显示加载状态
  /// [loadingMessage] - 加载提示信息
  /// [showSuccessMessage] - 是否显示成功消息
  /// [successMessage] - 成功提示信息
  /// [showErrorMessage] - 是否显示错误消息
  /// [onSuccess] - 成功回调
  /// [onError] - 错误回调
  Future<ApiResult<T>> callWithDeduplication<T>({
    required String key,
    required Future<ApiResult<T>> Function() apiCall,
    bool showLoading = true,
    String? loadingMessage,
    bool showSuccessMessage = false,
    String? successMessage,
    bool showErrorMessage = true,
    void Function(T data)? onSuccess,
    void Function(String error)? onError,
  }) async {
    // 检查是否已有相同的请求在进行
    if (_pendingRequests.containsKey(key)) {
      return _pendingRequests[key]! as Future<ApiResult<T>>;
    }

    // 创建新的请求
    final future = call<T>(
      apiCall: apiCall,
      showLoading: showLoading,
      loadingMessage: loadingMessage,
      showSuccessMessage: showSuccessMessage,
      successMessage: successMessage,
      showErrorMessage: showErrorMessage,
      onSuccess: onSuccess,
      onError: onError,
    );

    // 添加到待处理请求中
    _pendingRequests[key] = future;

    // 请求完成后移除
    future.whenComplete(() {
      _pendingRequests.remove(key);
    });

    return future;
  }

  // 待处理的请求映射
  final Map<String, Future<ApiResult<dynamic>>> _pendingRequests = {};

  /// 取消所有待处理的请求
  void cancelAllRequests() {
    _pendingRequests.clear();
    LoadingUtils.hideLoading();
  }

  /// 检查是否有待处理的请求
  bool get hasPendingRequests => _pendingRequests.isNotEmpty;

  /// 获取待处理请求的数量
  int get pendingRequestsCount => _pendingRequests.length;
}