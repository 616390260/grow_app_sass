import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/i18n/i18n_keys.dart';
import 'package:do_task_project/app/data/services/customer_service_api_service.dart';
import 'package:do_task_project/domain/entities/customer_service.dart';

class SmartController extends BaseController {
  final CustomerServiceApiService _apiService = CustomerServiceApiService();
  
  // 客服列表数据
  final RxList<CustomerService> customerServices = <CustomerService>[].obs;
  
  // 加载状态
  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

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
  
  /// 加载客服列表数据
  Future<void> loadCustomerServices() async {
    try {
      _isLoading.value = true;
      update(); // 更新UI状态

      final result = await _apiService.getCustomerServiceList();
      customerServices.assignAll(result);

      update(); // 更新UI
    } catch (e) {
      showErrorMessage('加载客服列表失败: ${e.toString()}');
    } finally {
      _isLoading.value = false;
      update(); // 更新UI状态
    }
  }

  // 加入Telegram群组按钮点击事件
  void onJoinTelegram(String url) {
    // 跳转到Telegram群组链接
    final Uri telegramUrl = Uri.parse(url);
    _launchUrl(telegramUrl);
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