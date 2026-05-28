import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/i18n/i18n_keys.dart';
import 'package:do_task_project/app/data/services/customer_service_api_service.dart';
import 'package:do_task_project/app/domain/entities/customer_service.dart';

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
    Get.snackbar(
      I18nKeys.consultNow.tr,
      I18nKeys.connectingCustomerService.tr,
      backgroundColor: Colors.white,
      colorText: Colors.black,
    );
  }
  
  /// 加载客服列表数据
  Future<void> loadCustomerServices() async {
    await safeApiCall<List<CustomerService>>(
      () => _apiService.getCustomerServiceList(),
      (result) {
        customerServices.assignAll(result);
        update();
      },
      errorMessage: I18nKeys.loadingCustomerServiceFailed.tr,
      onError: () {
        update();
      },
    );
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
      I18nKeys.openingPlatformGuide.tr,
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
        I18nKeys.cannotOpenLink.tr,
        backgroundColor: Colors.white,
        colorText: Colors.red,
      );
    }
  }
}
