import 'package:do_task_project/app/core/i18n/i18n_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/loading_style.dart';

/// Loading管理工具类
class LoadingUtils {
  static bool _isLoading = false;

  /// 显示Loading对话框
  static void showLoading({    
    String? message,
    bool barrierDismissible = false,
  }) {
    if (_isLoading) return;
    
    _isLoading = true;
    Get.dialog(
      LoadingDialog(message: message),
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.transparent, // 修改为透明背景
    );
  }

  /// 隐藏Loading对话框
  static void hideLoading() {
    if (_isLoading) {
      _isLoading = false;
      Get.back();
    }
  }

  /// 显示全屏Loading
  static void showFullScreenLoading({
    String? message,
    Color? backgroundColor,
  }) {
    if (_isLoading) return;
    
    _isLoading = true;
    Get.dialog(
      FullScreenLoadingDialog(
        message: message,
        backgroundColor: backgroundColor,
      ),
      barrierDismissible: false,
      barrierColor: Colors.transparent,
    );
  }

  /// 显示带进度的Loading
  static void showProgressLoading({
    required double progress,
    String? message,
    bool barrierDismissible = false,
  }) {
    if (_isLoading) return;
    
    _isLoading = true;
    Get.dialog(
      ProgressLoadingDialog(
        progress: progress,
        message: message,
      ),
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black54,
    );
  }

  /// 更新进度Loading的进度
  static void updateProgress(double progress, {String? message}) {
    if (_isLoading && Get.isDialogOpen == true) {
      // 通过GetX的响应式更新进度
      final controller = Get.find<ProgressLoadingController>();
      controller.updateProgress(progress, message: message);
    }
  }

  /// 检查是否正在Loading
  static bool get isLoading => _isLoading;
}

/// Loading对话框组件
class LoadingDialog extends StatelessWidget {
  final String? message;

  const LoadingDialog({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        // 直接使用loading指示器，去掉容器背景
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LoadingStyle.circularProgressIndicator,
            if (message != null) ...[
              SizedBox(height: LoadingStyle.defaultSpacing),
              Text(
                message!,
                style: Get.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 全屏Loading对话框组件
class FullScreenLoadingDialog extends StatelessWidget {
  final String? message;
  final Color? backgroundColor;

  const FullScreenLoadingDialog({
    super.key,
    this.message,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        // 使用透明容器替代Scaffold
        color: Colors.transparent,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                strokeWidth: 3,
              ),
              if (message != null) ...[
                const SizedBox(height: 24),
                Text(
                  message!,
                  style: Get.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// 进度Loading控制器
class ProgressLoadingController extends GetxController {
  final _progress = 0.0.obs;
  final _message = ''.obs;

  double get progress => _progress.value;
  String get message => _message.value;

  void updateProgress(double progress, {String? message}) {
    _progress.value = progress.clamp(0.0, 1.0);
    if (message != null) {
      _message.value = message;
    }
  }
}

/// 带进度的Loading对话框组件
class ProgressLoadingDialog extends StatelessWidget {
  final double progress;
  final String? message;

  const ProgressLoadingDialog({
    super.key,
    required this.progress,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: LoadingStyle.buildProgressLoadingWidget(
        progress: progress,
        message: message,
      ),
    );
  }
}

/// Loading状态枚举
enum LoadingState {
  idle,
  loading,
  success,
  error,
}

/// Loading状态管理Mixin
mixin LoadingStateMixin on GetxController {
  final _loadingState = LoadingState.idle.obs;
  final _loadingMessage = ''.obs;

  LoadingState get loadingState => _loadingState.value;
  String get loadingMessage => _loadingMessage.value;
  bool get isLoading => _loadingState.value == LoadingState.loading;

  /// 设置Loading状态
  void setLoadingState(LoadingState state, {String? message}) {
    _loadingState.value = state;
    _loadingMessage.value = message ?? '';
  }

  /// 开始Loading
  void startLoading({String? message}) {
    setLoadingState(LoadingState.loading, message: message);
  }

  /// 停止Loading
  void stopLoading() {
    setLoadingState(LoadingState.idle);
  }

  /// 设置成功状态
  void setSuccess({String? message}) {
    setLoadingState(LoadingState.success, message: message);
  }

  /// 设置错误状态
  void setError({String? message}) {
    setLoadingState(LoadingState.error, message: message);
  }
}

/// Loading状态构建器
class LoadingStateBuilder extends StatelessWidget {
  final LoadingStateMixin controller;
  final Widget Function() onIdle;
  final Widget Function()? onLoading;
  final Widget Function()? onSuccess;
  final Widget Function()? onError;

  const LoadingStateBuilder({
    super.key,
    required this.controller,
    required this.onIdle,
    this.onLoading,
    this.onSuccess,
    this.onError,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      switch (controller.loadingState) {
        case LoadingState.loading:
          return onLoading?.call() ?? const Center(
            child: CircularProgressIndicator(),
          );
        case LoadingState.success:
          return onSuccess?.call() ?? onIdle();
        case LoadingState.error:
          return onError?.call() ?? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Get.theme.colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  controller.loadingMessage.isNotEmpty 
                      ? controller.loadingMessage 
                      : I18nKeys.loadingFailed.tr,
                  style: Get.textTheme.bodyMedium,
                ),
              ],
            ),
          );
        default:
          return onIdle();
      }
    });
  }
}