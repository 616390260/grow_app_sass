import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../i18n/i18n_keys.dart';

/// 消息工具类
/// 提供统一的消息显示接口
class MessageUtils {
  /// 显示成功消息
  static void showSuccess(String message) {
    Get.snackbar(
      I18nKeys.success.tr,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Get.theme.colorScheme.primary.withValues(alpha: 0.1),
      colorText: Get.theme.colorScheme.primary,
      icon: Icon(
        Icons.check_circle,
        color: Get.theme.colorScheme.primary,
      ),
      duration: const Duration(seconds: 3),
    );
  }

  /// 显示错误消息
  static void showError(String message) {
    Get.snackbar(
      I18nKeys.error.tr,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Get.theme.colorScheme.error.withValues(alpha: 0.1),
      colorText: Get.theme.colorScheme.error,
      icon: Icon(
        Icons.error,
        color: Get.theme.colorScheme.error,
      ),
      duration: const Duration(seconds: 2),
    );
  }

  /// 显示警告消息
  static void showWarning(String message) {
    Get.snackbar(
      I18nKeys.warning.tr,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.orange.withValues(alpha: 0.1),
      colorText: Colors.orange,
      icon: const Icon(
        Icons.warning,
        color: Colors.orange,
      ),
      duration: const Duration(seconds: 2),
    );
  }

  /// 显示信息消息
  static void showInfo(String message) {
    Get.snackbar(
      I18nKeys.tip.tr,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Get.theme.colorScheme.surface,
      colorText: Get.theme.colorScheme.onSurface,
      icon: Icon(
        Icons.info,
        color: Get.theme.colorScheme.primary,
      ),
      duration: const Duration(seconds: 2),
    );
  }

  /// 显示确认对话框
  static Future<bool> showConfirmDialog({
    required String title,
    required String content,
    String? confirmText,
    String? cancelText,
    Color? confirmColor,
  }) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(cancelText ?? I18nKeys.cancel.tr),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: confirmColor != null
                ? TextButton.styleFrom(foregroundColor: confirmColor)
                : null,
            child: Text(confirmText ?? I18nKeys.confirm.tr),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// 显示输入对话框
  static Future<String?> showInputDialog({
    required String title,
    String? hint,
    String? initialValue,
    String? confirmText,
    String? cancelText,
    TextInputType? keyboardType,
    int? maxLength,
    bool obscureText = false,
  }) async {
    final controller = TextEditingController(text: initialValue);
    
    final result = await Get.dialog<String>(
      AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
          ),
          keyboardType: keyboardType,
          maxLength: maxLength,
          obscureText: obscureText,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(cancelText ?? I18nKeys.cancel.tr),
          ),
          TextButton(
            onPressed: () => Get.back(result: controller.text),
            child: Text(confirmText ?? I18nKeys.confirm.tr),
          ),
        ],
      ),
    );
    
    controller.dispose();
    return result;
  }

  /// 显示选择对话框
  static Future<T?> showSelectDialog<T>({
    required String title,
    required List<T> items,
    required String Function(T) itemBuilder,
    T? selectedItem,
  }) async {
    return await Get.dialog<T>(
      AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final isSelected = item == selectedItem;
              
              return ListTile(
                title: Text(itemBuilder(item)),
                trailing: isSelected ? const Icon(Icons.check) : null,
                onTap: () => Get.back(result: item),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(I18nKeys.cancel.tr),
          ),
        ],
      ),
    );
  }

  /// 显示底部弹窗
  static Future<T?> showBottomSheet<T>({
    required Widget child,
    bool isScrollControlled = false,
    bool isDismissible = true,
    bool enableDrag = true,
  }) async {
    return await Get.bottomSheet<T>(
      child,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Get.theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
  }

  /// 显示Toast消息（短时间显示）
  static void showToast(String message) {
    Get.rawSnackbar(
      message: message,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      borderRadius: 8,
      margin: const EdgeInsets.all(16),
    );
  }
}
