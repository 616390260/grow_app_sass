import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/i18n/i18n_keys.dart';

class SmartController extends BaseController {
  @override
  void onInit() {
    super.onInit();
  }

  // 立即咨询按钮点击事件
  void onConsultNow() {
    // 这里可以实现立即咨询的逻辑
    Get.snackbar(
      I18nKeys.consultNow.tr,
      '正在连接客服...',
      backgroundColor: Colors.white,
      colorText: Colors.black,
    );
  }

  // 加入Telegram群组按钮点击事件
  void onJoinTelegram() {
    // 跳转到Telegram群组链接
    final Uri url = Uri.parse('https://t.me/+your_group_id');
    _launchUrl(url);
  }

  // 平台指南按钮点击事件
  void onPlatformGuide() {
    // 跳转到平台指南页面或打开相关链接
    Get.snackbar(
      I18nKeys.platformGuide.tr,
      '正在打开平台指南...',
      backgroundColor: Colors.white,
      colorText: Colors.black,
    );
  }

  // 打开URL的通用方法
  Future<void> _launchUrl(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        I18nKeys.error.tr,
        '无法打开链接',
        backgroundColor: Colors.white,
        colorText: Colors.red,
      );
    }
  }
}