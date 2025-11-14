import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../i18n/i18n_keys.dart';

/// Loading 样式统一配置类
class LoadingStyle {
  LoadingStyle._();

  // ==================== 基础配置 ====================
  
  /// CircularProgressIndicator 统一配置
  static const double circularStrokeWidth = 4.0;
  static const double circularSize = 40.0;
  
  /// 间距配置
  static const double defaultSpacing = 16.0;
  static const double largeSpacing = 24.0;
  
  /// 圆角配置
  static const double borderRadius = 12.0;
  
  /// 阴影配置
  static List<BoxShadow> get defaultShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];

  // ==================== 组件样式 ====================

  /// 标准 CircularProgressIndicator
  static Widget get circularProgressIndicator => CircularProgressIndicator(
    strokeWidth: circularStrokeWidth,
    valueColor: AlwaysStoppedAnimation<Color>(
      Get.theme.colorScheme.primary,
    ),
  );

  /// 小尺寸 CircularProgressIndicator
  static Widget get smallCircularProgressIndicator => SizedBox(
    width: 24,
    height: 24,
    child: CircularProgressIndicator(
      strokeWidth: 2.0,
      valueColor: AlwaysStoppedAnimation<Color>(
        Get.theme.colorScheme.primary,
      ),
    ),
  );

  /// 标准 LinearProgressIndicator
  static Widget linearProgressIndicator({double? value}) => LinearProgressIndicator(
    value: value,
    backgroundColor: Get.theme.colorScheme.outline.withOpacity(0.3),
    valueColor: AlwaysStoppedAnimation<Color>(
      Get.theme.colorScheme.primary,
    ),
  );

  /// 带圆角的 LinearProgressIndicator
  static Widget roundedLinearProgressIndicator({
    double? value,
    double height = 4.0,
  }) => ClipRRect(
    borderRadius: BorderRadius.circular(height / 2),
    child: SizedBox(
      height: height,
      child: LinearProgressIndicator(
        value: value,
        backgroundColor: Get.theme.colorScheme.outline.withOpacity(0.3),
        valueColor: AlwaysStoppedAnimation<Color>(
          Get.theme.colorScheme.primary,
        ),
      ),
    ),
  );

  // ==================== 容器样式 ====================

  /// 标准 Loading 对话框容器装饰
  static BoxDecoration get dialogDecoration => BoxDecoration(
    color: Get.theme.dialogBackgroundColor,
    borderRadius: BorderRadius.circular(borderRadius),
    boxShadow: defaultShadow,
  );

  /// 卡片式容器装饰
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: Get.theme.cardColor,
    borderRadius: BorderRadius.circular(borderRadius),
    boxShadow: defaultShadow,
  );

  // ==================== 预制组件 ====================

  /// 标准 Loading 组件（带文本）
  static Widget buildLoadingWidget({
    String? message,
    bool showMessage = true,
  }) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          circularProgressIndicator,
          if (showMessage) ...[
            SizedBox(height: defaultSpacing),
            Text(
              message ?? I18nKeys.loadingPleaseWait.tr,
              style: Get.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  /// 对话框式 Loading 组件
  static Widget buildDialogLoadingWidget({    
    String? message,
    EdgeInsets? padding,
  }) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          circularProgressIndicator,
          if (message != null) ...[
            SizedBox(height: defaultSpacing),
            Text(
              message,
              style: Get.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  /// 全屏 Loading 组件
  static Widget buildFullScreenLoadingWidget({    
    String? message,
    Color? backgroundColor,
  }) {
    return Container(
      color: Colors.transparent,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            circularProgressIndicator,
            if (message != null) ...[
              SizedBox(height: largeSpacing),
              Text(
                message,
                style: Get.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 进度 Loading 组件
  static Widget buildProgressLoadingWidget({    
    required double progress,
    String? message,
    EdgeInsets? padding,
    EdgeInsets? margin,
  }) {
    return Center(
      child: Container(
        padding: padding ?? const EdgeInsets.all(24),
        margin: margin ?? const EdgeInsets.symmetric(horizontal: 40),
        decoration: dialogDecoration.copyWith(
          color: Colors.transparent,
          boxShadow: [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            linearProgressIndicator(value: progress),
            SizedBox(height: defaultSpacing),
            Text(
              '${(progress * 100).toInt()}%',
              style: Get.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (message != null && message.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                message,
                style: Get.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 错误状态组件
  static Widget buildErrorWidget({
    String? message,
    VoidCallback? onRetry,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Get.theme.colorScheme.error,
          ),
          SizedBox(height: defaultSpacing),
          Text(
            message?.isNotEmpty == true ? message! : I18nKeys.loadingFailed.tr,
            style: Get.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            SizedBox(height: defaultSpacing),
            ElevatedButton(
              onPressed: onRetry,
              child: Text(I18nKeys.retry.tr),
            ),
          ],
        ],
      ),
    );
  }

  /// 空数据状态组件
  static Widget buildEmptyWidget({
    String? message,
    VoidCallback? onRefresh,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: Get.theme.colorScheme.outline,
          ),
          SizedBox(height: defaultSpacing),
          Text(
            message ?? I18nKeys.noContent.tr,
            style: Get.textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            message ?? I18nKeys.statusEmpty.tr,
            style: Get.textTheme.bodyMedium,
          ),
          if (onRefresh != null) ...[
            SizedBox(height: largeSpacing),
            ElevatedButton(
              onPressed: onRefresh,
              child: Text(I18nKeys.refresh.tr),
            ),
          ],
        ],
      ),
    );
  }

  // ==================== 主题适配 ====================

  /// 获取当前主题下的 Loading 颜色
  static Color get loadingColor => Get.theme.colorScheme.primary;
  
  /// 获取当前主题下的背景颜色
  static Color get backgroundColor => Get.theme.colorScheme.outline.withOpacity(0.3);
  
  /// 获取当前主题下的文本颜色
  static Color get textColor => Get.theme.colorScheme.onSurface;
}