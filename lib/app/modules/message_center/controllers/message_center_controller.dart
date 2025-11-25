import 'package:do_task_project/app/core/base/base_controller.dart';
import 'package:do_task_project/app/core/i18n/i18n_keys.dart';
import 'package:do_task_project/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:do_task_project/app/data/services/home_api_service.dart';
import 'package:do_task_project/app/data/models/home_info_model.dart';
import 'dart:developer';

class MessageCenterController extends BaseController {
  // 消息数据列表 - 确保使用RxList以实现响应式更新
  final RxList<SystemAnnouncementModel> sysAnnouncement =
      <SystemAnnouncementModel>[].obs;
  // Home API服务
  final HomeApiService _homeApiService = HomeApiService();

  @override
  void onInit() {
    super.onInit();
    // 加载系统公告数据
    loadSystemAnnouncements();
  }

  // 加载系统公告数据
  Future<void> loadSystemAnnouncements() async {
    safeApiCall(
      // API调用函数
      () async => await _homeApiService.getHomeInfo(),
      // 成功回调
      (homeInfo) {
        // 更新统计数据 - 确保字段名与接口返回一致，并处理null值
        sysAnnouncement.value = homeInfo.sysAnnouncements ?? [];
        // 保留现有的accountBalance字段，暂时使用accountPoints的值
        setSuccess();
      },
      // 自定义错误消息
      errorMessage: I18nKeys.loadDataFailed.tr,
      // 显示加载状态
      showLoading: true,
    );
  }

  // 切换消息展开/收起状态
  void toggleMessageExpansion(int index) {
    
  }

  // 返回上一页
  void onBackPress() {
    if (Get.key.currentState!.canPop()) {
      Get.back();
    } else {
      Get.offAllNamed(Routes.root);
    }
  }
}
