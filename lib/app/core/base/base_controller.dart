import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../i18n/i18n_keys.dart';
import '../exceptions/api_exception.dart';
import 'package:do_task_project/app/core/services/error_handler_center.dart';

/// 页面状态枚举
enum PageState {
  initial,
  loading,
  success,
  error,
  empty,
}

/// 基础控制器类，封装通用状态管理
abstract class BaseController extends GetxController {
  /// 页面状态
  final _pageState = PageState.initial.obs;
  PageState get pageState => _pageState.value;

  /// 是否正在加载
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  /// 错误信息
  final _errorMessage = ''.obs;
  String get errorMessage => _errorMessage.value;

  /// 是否为空数据
  final _isEmpty = false.obs;
  bool get isEmpty => _isEmpty.value;

  /// 设置加载状态
  void setLoading(bool loading) {
    _isLoading.value = loading;
    if (loading) {
      _pageState.value = PageState.loading;
    } else {
      _pageState.value = PageState.initial;
    }
  }

  /// 设置成功状态
  void setSuccess() {
    _isLoading.value = false;
    _pageState.value = PageState.success;
    _errorMessage.value = '';
  }

  /// 设置错误状态
  void setError(String message) {
    _isLoading.value = false;
    _pageState.value = PageState.error;
    _errorMessage.value = message;
  }

  /// 设置空数据状态
  void setEmpty() {
    _isLoading.value = false;
    _pageState.value = PageState.empty;
    _isEmpty.value = true;
  }

  /// 重置状态
  void resetState() {
    _isLoading.value = false;
    _pageState.value = PageState.initial;
    _errorMessage.value = '';
    _isEmpty.value = false;
  }

  /// 显示成功消息
  void showSuccessMessage(String message) {
    Get.snackbar(
      '成功',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Get.theme.colorScheme.primary,
      colorText: Get.theme.colorScheme.onPrimary,
    );
  }

  /// 显示错误消息
  void showErrorMessage(String message) {
    Get.snackbar(
      '错误',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Get.theme.colorScheme.onError,
      duration: const Duration(seconds: 2),
    );
  }

  /// 显示警告消息
  void showWarningMessage(String message) {
    Get.snackbar(
      '警告',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Get.theme.colorScheme.secondary,
      colorText: Get.theme.colorScheme.onSecondary,
      duration: const Duration(seconds: 2),
    );
  }

  /// 显示信息消息
  void showInfoMessage(String message) {
    Get.snackbar(
      '提示',
      message,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
    );
  }

  /// 根据错误码统一处理错误消息
  void handleErrorCode(int? errorCode, String? message) {
    print('Error code: $errorCode, Message: $message');
    String errorMessage = message ?? I18nKeys.errorUnknown.tr;
    
    switch (errorCode) {
      // 客户端错误 4xx
      case 400:
        errorMessage = message ?? I18nKeys.error400.tr;
        showErrorMessage(errorMessage);
        break;
      
      case 401:
        errorMessage = message ?? I18nKeys.error401.tr;
        showErrorMessage(errorMessage);
        // 可以在这里添加跳转到登录页面的逻辑
        _handleUnauthorized();
        break;
      
      case 403:
        errorMessage = message ?? I18nKeys.error403.tr;
        showErrorMessage(errorMessage);
        break;
      
      case 404:
        errorMessage = message ?? I18nKeys.error404.tr;
        showErrorMessage(errorMessage);
        break;
      
      case 405:
        errorMessage = message ?? I18nKeys.error405.tr;
        showErrorMessage(errorMessage);
        break;
      
      case 408:
        errorMessage = message ?? I18nKeys.error408.tr;
        showErrorMessage(errorMessage);
        break;
      
      case 409:
        errorMessage = message ?? I18nKeys.error409.tr;
        showErrorMessage(errorMessage);
        break;
      
      case 422:
        errorMessage = message ?? I18nKeys.error422.tr;
        showErrorMessage(errorMessage);
        break;
      
      case 429:
        errorMessage = message ?? I18nKeys.error429.tr;
        showWarningMessage(errorMessage);
        break;
      
      // 服务器错误 5xx
      case 500:
        errorMessage = message ?? I18nKeys.error500.tr;
        showErrorMessage(errorMessage);
        break;
      
      case 502:
        errorMessage = message ?? I18nKeys.error502.tr;
        showErrorMessage(errorMessage);
        break;
      
      case 503:
        errorMessage = message ?? I18nKeys.error503.tr;
        showErrorMessage(errorMessage);
        break;
      
      case 504:
        errorMessage = message ?? I18nKeys.error504.tr;
        showErrorMessage(errorMessage);
        break;
      
      // 业务自定义错误码
      case 1001:
        errorMessage = message ?? I18nKeys.error1001.tr;
        showErrorMessage(errorMessage);
        break;
      
      case 1002:
        errorMessage = message ?? I18nKeys.error1002.tr;
        showErrorMessage(errorMessage);
        break;
      
      case 1003:
        errorMessage = message ?? I18nKeys.error1003.tr;
        showErrorMessage(errorMessage);
        break;
      
      case 1004:
        errorMessage = message ?? I18nKeys.error1004.tr;
        showErrorMessage(errorMessage);
        break;
      
      case 1005:
        errorMessage = message ?? I18nKeys.error1005.tr;
        showErrorMessage(errorMessage);
        break;
      
      case 1006:
        errorMessage = message ?? I18nKeys.error1006.tr;
        showErrorMessage(errorMessage);
        break;
      
      case 2001:
        errorMessage = message ?? I18nKeys.error2001.tr;
        showErrorMessage(errorMessage);
        break;
      
      case 2002:
        errorMessage = message ?? I18nKeys.error2002.tr;
        showErrorMessage(errorMessage);
        break;
      
      case 2003:
        errorMessage = message ?? I18nKeys.error2003.tr;
        showErrorMessage(errorMessage);
        break;
      
      case 3001:
        errorMessage = message ?? I18nKeys.error3001.tr;
        showErrorMessage(errorMessage);
        break;
      
      case 3002:
        errorMessage = message ?? I18nKeys.error3002.tr;
        showErrorMessage(errorMessage);
        break;
      
      case 3003:
        errorMessage = message ?? I18nKeys.error3003.tr;
        showErrorMessage(errorMessage);
        break;
      
      default:
        showErrorMessage(errorMessage);
        break;
    }
  }

  /// 直接处理ApiException异常
  void handleApiException(ApiException exception) {
    // 直接调用已有的handleErrorCode方法进行统一处理
    handleErrorCode(exception.code, exception.message);
  }

  /// 通用API调用方法，统一处理异常
  /// [apiCall] 需要执行的API调用函数
  /// [onSuccess] 成功回调
  /// [errorMessage] 自定义错误消息
  /// [showLoading] 是否显示加载状态
  /// [onError] 错误回调，用于在发生错误时执行特定操作
  Future<void> safeApiCall<T>(
    Future<T> Function() apiCall,
    void Function(T result) onSuccess,
    {String errorMessage = '', bool showLoading = false, void Function()? onError}
  ) async {
    if (showLoading) {
      setLoading(true);
    }

    try {
      final result = await apiCall();
      onSuccess(result);
    } catch (e) {
      // 执行错误回调
      if (onError != null) {
        onError();
      }
      
      if (e is ApiException) {
        handleApiException(e);
      } else {
        final msg = errorMessage.isNotEmpty ? errorMessage : '${I18nKeys.errorUnknown.tr}: $e';
        setError(msg);
        showErrorMessage(msg);
      }
    } finally {
      if (showLoading) {
        setLoading(false);
      }
    }
  }

  /// 处理未授权错误
  void _handleUnauthorized() {
    // 可以在这里添加清除用户信息、跳转到登录页面等逻辑
    // 例如：Get.offAllNamed('/login');
  }



  /// 页面初始化方法，子类可重写
  void onInit() {
    super.onInit();
    initData();
  }

  /// 初始化数据，子类实现
  void initData() {}

  /// 刷新数据，子类实现
  void refreshData() {}

  /// 加载更多数据，子类实现
  void loadMoreData() {}



}