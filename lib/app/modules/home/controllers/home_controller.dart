import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../data/services/home_api_service.dart';
import '../../../data/models/home_info_model.dart';
import '../../../core/i18n/i18n_keys.dart';

class HomeController extends BaseController {
  // 统计数据
  final accountBalance = 0.0.obs;
  final dailyEarnings = 0.0.obs;
  final promotionEarnings = 0.0.obs;
  final vipLevel = ''.obs;
  final accountPoints = 0.0.obs;
  final announcements = <BannerModel>[].obs;
  final recommendTasks = <RecommendTaskModel>[].obs;
  
  final HomeApiService _homeApiService = HomeApiService();
  
  // 底部导航当前索引
  final currentTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // 懒加载：不在这里自动加载数据，等待tab切换时由MainController加载
  }

  // 加载数据
  void loadData() {
    safeApiCall(
      // API调用函数
      () async => await _homeApiService.getHomeInfo(),
      // 成功回调
      (homeInfo) {
        // 更新统计数据 - 确保字段名与接口返回一致，并处理null值
        accountPoints.value = homeInfo.accountPoints ?? 0.0;
        dailyEarnings.value = homeInfo.todayIncome ?? 0.0;
        promotionEarnings.value = homeInfo.todayPromotionIncome ?? 0.0;
        vipLevel.value = homeInfo.vipLevel ?? '';
        announcements.value = homeInfo.announcements ?? [];
        recommendTasks.value = homeInfo.recommendTasks ?? [];
        
        // 保留现有的accountBalance字段，暂时使用accountPoints的值
        accountBalance.value = (homeInfo.accountPoints ?? 0.0).toDouble();
        
        setSuccess();
      },
      // 自定义错误消息
      errorMessage: I18nKeys.loadDataFailed.tr,
      // 显示加载状态
      showLoading: true,
    );
  }

  // 刷新数据
  void refreshData() {
    loadData();
  }

  // 底部导航切换
  void onTabChanged(int index) {
    currentTabIndex.value = index;
  }

  // 幸运转盘点击
  void onLuckyWheelTap() {
    Get.toNamed(Routes.luckyWheel);
  }

  // 签到日历点击
  void onSignInCalendarTap() {
    Get.toNamed(Routes.signInCalendar);
  }

  // 任务卡片点击
  void onTaskCardTap(String taskId) {
    Get.toNamed(Routes.whatsappTask, arguments: taskId);
  }

  // 下载APP按钮点击
  void onDownloadAppTap() {
   Get.toNamed(Routes.inviteFriend);
    // 这里可以添加实际的下载逻辑，例如打开应用商店链接或显示下载二维码
  }

  // VIP详情点击
  void onVipDetailsTap() {
    Get.toNamed(Routes.vipDetails);
  }

  // Banner点击处理
  void onBannerTap(int index) {
    // 确保索引在有效范围内
    if (index >= 0 && index < announcements.length) {
      final banner = announcements[index];
      // 根据banner的hyperLink或iosHyperLink字段打开链接
      // 这里可以添加实际的跳转逻辑，例如打开网页链接
      showSuccessMessage('点击了Banner: ${banner.title}');
    }
  }

  // 推荐任务点击处理
  void onRecommendTaskTap(int index) {
    // 确保索引在有效范围内
    if (index >= 0 && index < recommendTasks.length) {
      final task = recommendTasks[index];
      // 根据task的icon字段显示信息
      // 这里可以添加实际的跳转逻辑，例如打开网页链接
      Get.toNamed(Routes.whatsappTask, arguments: task.id);
    }
  }
}