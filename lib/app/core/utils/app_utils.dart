import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:do_task_project/app/core/i18n/i18n_keys.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

/// 应用工具类
class AppUtils {
  /// 格式化日期
  static String formatDate(DateTime date, {String? format}) {
    final formatter = DateFormat(format ?? AppConstants.dateFormat);
    return formatter.format(date);
  }

  /// 格式化时间
  static String formatTime(DateTime time, {String? format}) {
    final formatter = DateFormat(format ?? AppConstants.timeFormat);
    return formatter.format(time);
  }

  /// 格式化日期时间
  static String formatDateTime(DateTime dateTime, {String? format}) {
    final formatter = DateFormat(format ?? AppConstants.dateTimeFormat);
    return formatter.format(dateTime);
  }

  /// 解析日期字符串
  static DateTime? parseDate(String dateString, {String? format}) {
    try {
      final formatter = DateFormat(format ?? AppConstants.dateFormat);
      return formatter.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// 获取相对时间描述
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}天前';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}小时前';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}分钟前';
    } else {
      return '刚刚';
    }
  }

  /// 验证邮箱格式
  static bool isValidEmail(String email) {
    return RegExp(AppConstants.emailRegex).hasMatch(email);
  }

  /// 验证手机号格式
  static bool isValidPhone(String phone) {
    return RegExp(AppConstants.phoneRegex).hasMatch(phone);
  }

  /// 验证密码强度
  static bool isValidPassword(String password) {
    return RegExp(AppConstants.passwordRegex).hasMatch(password);
  }

  /// 生成随机字符串
  static String generateRandomString(int length) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  /// 生成UUID
  static String generateUUID() {
    final random = Random();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));

    // 设置版本号和变体
    bytes[6] = (bytes[6] & 0x0f) | 0x40; // 版本4
    bytes[8] = (bytes[8] & 0x3f) | 0x80; // 变体10

    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20, 32)}';
  }

  /// 格式化文件大小
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  /// 获取文件扩展名
  static String getFileExtension(String fileName) {
    final lastDotIndex = fileName.lastIndexOf('.');
    if (lastDotIndex == -1) return '';
    return fileName.substring(lastDotIndex + 1).toLowerCase();
  }

  /// 检查是否为图片文件
  static bool isImageFile(String fileName) {
    final extension = getFileExtension(fileName);
    return AppConstants.imageExtensions.contains(extension);
  }

  /// 检查是否为文档文件
  static bool isDocumentFile(String fileName) {
    final extension = getFileExtension(fileName);
    return AppConstants.documentExtensions.contains(extension);
  }

  /// 检查是否为视频文件
  static bool isVideoFile(String fileName) {
    final extension = getFileExtension(fileName);
    return AppConstants.videoExtensions.contains(extension);
  }

  /// 检查是否为音频文件
  static bool isAudioFile(String fileName) {
    final extension = getFileExtension(fileName);
    return AppConstants.audioExtensions.contains(extension);
  }

  /// 复制文本到剪贴板（增强版，支持Web端）
  static Future<void> copyToClipboard(String text) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
      Get.snackbar(
        I18nKeys.tip.tr,
        I18nKeys.copiedToClipboard.tr,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      // Web端剪贴板操作可能需要用户交互，尝试备用方案
      if (kIsWeb) {
        // Web端使用备用方案：显示文本供用户手动复制
        Get.snackbar(
          I18nKeys.tip.tr,
          '请手动复制：$text',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 5),
          mainButton: TextButton(
            onPressed: () {
              Get.back(); // 关闭snackbar
            },
            child: Text(I18nKeys.sure.tr, style: TextStyle(color: Colors.white)),
          ),
        );
      } else {
        // 非Web端直接显示错误
        Get.snackbar(
          I18nKeys.error.tr,
          '${I18nKeys.copyFailed.tr}：$e',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    }
  }

  /// 从剪贴板获取文本
  static Future<String?> getFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    return data?.text;
  }

  /// 震动反馈
  static void vibrate({int duration = 50}) {
    HapticFeedback.lightImpact();
  }

  /// 强震动反馈
  static void vibrateHeavy() {
    HapticFeedback.heavyImpact();
  }

  /// 选择反馈
  static void vibrateSelection() {
    HapticFeedback.selectionClick();
  }

  /// 隐藏键盘
  static void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
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
            child: Text(cancelText ?? AppConstants.cancel),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: confirmColor != null
                ? TextButton.styleFrom(foregroundColor: confirmColor)
                : null,
            child: Text(confirmText ?? AppConstants.buttonConfirm),
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
            child: Text(cancelText ?? AppConstants.cancel),
          ),
          TextButton(
            onPressed: () => Get.back(result: controller.text),
            child: Text(confirmText ?? AppConstants.buttonConfirm),
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
            child: const Text(AppConstants.cancel),
          ),
        ],
      ),
    );
  }

  /// 显示底部选择器
  static Future<T?> showBottomPicker<T>({
    required String title,
    required List<T> items,
    required String Function(T) itemBuilder,
    T? selectedItem,
  }) async {
    return await Get.bottomSheet<T>(
      Container(
        decoration: BoxDecoration(
          color: Get.theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Get.theme.dividerColor, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(title, style: Get.textTheme.titleMedium),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Flexible(
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
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  /// 获取设备信息
  static Map<String, dynamic> getDeviceInfo() {
    return {
      'platform': Platform.operatingSystem,
      'version': Platform.operatingSystemVersion,
      'locale': Get.locale?.toString(),
      'screenSize': Get.size,
      'pixelRatio': Get.pixelRatio,
      'textScaleFactor': Get.textScaleFactor,
    };
  }

  /// 检查是否为深色模式
  static bool isDarkMode() {
    return Get.isDarkMode;
  }

  /// 获取状态栏高度
  static double getStatusBarHeight() {
    return Get.mediaQuery.padding.top;
  }

  /// 获取底部安全区域高度
  static double getBottomSafeAreaHeight() {
    return Get.mediaQuery.padding.bottom;
  }

  /// 获取键盘高度
  static double getKeyboardHeight() {
    return Get.mediaQuery.viewInsets.bottom;
  }

  /// 延迟执行
  static Future<void> delay(int milliseconds) {
    return Future.delayed(Duration(milliseconds: milliseconds));
  }

  /// 防抖函数
  static Function debounce(Function func, Duration delay) {
    Timer? timer;
    return () {
      timer?.cancel();
      timer = Timer(delay, () => func());
    };
  }

  /// 节流函数
  static Function throttle(Function func, Duration duration) {
    bool isThrottled = false;
    return () {
      if (!isThrottled) {
        func();
        isThrottled = true;
        Timer(duration, () => isThrottled = false);
      }
    };
  }

  /// 计算两点之间的距离
  static double calculateDistance(Offset point1, Offset point2) {
    return sqrt(pow(point2.dx - point1.dx, 2) + pow(point2.dy - point1.dy, 2));
  }

  /// 将颜色转换为十六进制字符串
  static String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
  }

  /// 将十六进制字符串转换为颜色
  static Color? hexToColor(String hex) {
    try {
      hex = hex.replaceAll('#', '');
      if (hex.length == 6) {
        hex = 'FF$hex';
      }
      return Color(int.parse(hex, radix: 16));
    } catch (e) {
      return null;
    }
  }

  /// 获取对比色
  static Color getContrastColor(Color color) {
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}

/// 定时器工具类
class AppTimer {
  static Timer? _timer;

  static void periodic(Duration duration, void Function() callback) {
    _timer?.cancel();
    _timer = Timer.periodic(duration, (_) => callback());
  }

  static void once(Duration duration, void Function() callback) {
    _timer?.cancel();
    _timer = Timer(duration, callback);
  }

  static void cancel() {
    _timer?.cancel();
    _timer = null;
  }
}
