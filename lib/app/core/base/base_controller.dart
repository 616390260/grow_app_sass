import 'package:do_task_project/app/core/i18n/i18n_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      I18nKeys.success.tr,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Get.theme.colorScheme.primary,
      colorText: Get.theme.colorScheme.onPrimary,
    );
  }

  /// 显示错误消息
  void showErrorMessage(String message) {
    Get.snackbar(
      I18nKeys.error.tr,
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
      I18nKeys.warning.tr,
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
      I18nKeys.tip.tr,
      message,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
    );
  }

  /// 页面初始化方法，子类可重写
  @override
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

  /// 简化的API调用方法 - 支持向后兼容
  Future<T?> safeApiCall<T>(
    Future<T> Function() apiCall,
    Function(T)? onSuccess, {
    Function? onError,
    String? errorMessage,
    bool showLoading = false,
  }) async {
    try {
      // 如果需要显示加载状态
      if (showLoading) {
        setLoading(true);
      }

      final result = await apiCall();
      
      // 执行成功回调
      if (onSuccess != null) {
        final callbackResult = onSuccess(result);
        // 如果是Future，等待完成
        if (callbackResult is Future) {
          await callbackResult;
        }
      }
      
      return result;
    } catch (e) {
      // 不处理错误显示，只捕获异常
      // 错误处理由 HttpService 和 ErrorHandlerCenter 统一处理
      
      // 执行错误回调 - 保持向后兼容
      if (onError != null) {
        onError();
      }
      
      return null;
    } finally {
      // 取消加载状态
      if (showLoading) {
        setLoading(false);
      }
    }
  }

}