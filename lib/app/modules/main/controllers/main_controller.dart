import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import '../../../core/base/base_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../promotion/controllers/promotion_controller.dart';
import '../../tasks/controllers/tasks_controller.dart';
import '../../smart/controllers/smart_controller.dart';
import '../../account/controllers/account_controller.dart';

class MainController extends BaseController {
  final currentTabIndex = 0.obs;
  final inviteCode = ''.obs; // 存储邀请码

  // 标记是否已经加载过各个tab的数据
  final _hasLoaded = <int, bool>{
    0: false, // home
    1: false, // promotion
    2: false, // tasks
    3: false, // smart
    4: false, // account
  };

  @override
  void onInit() {
    super.onInit();
    setSuccess();

    // 从URL参数获取邀请码（跨平台）
    _getInviteCodeFromUrl();

    // 首页默认加载
    _loadTabData(0);
  }

  void onTabChanged(int index) {
    currentTabIndex.value = index;
    // 切换tab时加载数据（如果还没加载过）
    _loadTabData(index);
  }

  void _loadTabData(int index) {
    if (_hasLoaded[index] == true) return;

    switch (index) {
      case 0:
        final homeController = Get.find<HomeController>();
        homeController.loadData();
        break;
      case 1:
        final promotionController = Get.find<PromotionController>();
        promotionController.loadData();
        break;
      case 2:
        final tasksController = Get.find<TasksController>();
        tasksController.loadTasks();
        break;
      case 3:
        final smartController = Get.find<SmartController>();
        // smart controller 目前没有加载数据的方法
        smartController.loadCustomerServices();
        break;
      case 4:
        final accountController = Get.find<AccountController>();
        accountController.loadUserInfo();
        break;
    }

    // 标记为已加载
    _hasLoaded[index] = true;
  }

  @override
  void refreshData() {
    // 刷新当前tab的数据
    _hasLoaded[currentTabIndex.value] = false;
    _loadTabData(currentTabIndex.value);
  }

  /// 从URL参数获取邀请码（跨平台）
  void _getInviteCodeFromUrl() {
    try {
      // 从Get参数中获取邀请码（适用于所有平台）
      final code = Get.parameters['i'];
      if (code != null && code.isNotEmpty) {
        inviteCode.value = code;
        debugPrint('MainController获取到邀请码: $code');
      }
    } catch (e) {
      // 捕获可能的错误，避免影响页面正常加载
      debugPrint('获取URL邀请码失败: $e');
    }
  }

  /// 获取邀请码提供给其他页面使用
  String? getInviteCode() {
    return inviteCode.value.isNotEmpty ? inviteCode.value : null;
  }

  /// 清除邀请码
  void clearInviteCode() {
    inviteCode.value = '';
  }
}
