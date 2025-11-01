import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../data/services/home_api_service.dart';
import '../../../data/models/home_info_model.dart';

class HomeController extends BaseController {
  // 统计数据
  final accountBalance = 0.0.obs;
  final dailyEarnings = 0.0.obs;
  final promotionEarnings = 0.0.obs;
  final vipLevel = ''.obs;
  final accountPoints = 0.0.obs;
  final announcements = <AnnouncementModel>[].obs;
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
  void loadData() async {
    try {
      // 设置加载状态
      setLoading(true);
      
      // 调用API获取首页数据
      final homeInfo = await _homeApiService.getHomeInfo();
      
      // 更新统计数据 - 确保字段名与接口返回一致
      accountPoints.value = homeInfo.accountPoints;
      dailyEarnings.value = homeInfo.todayIncome;
      promotionEarnings.value = homeInfo.todayPromotionIncome;
      vipLevel.value = homeInfo.vipLevel;
      announcements.value = homeInfo.announcements;
      recommendTasks.value = homeInfo.recommendTasks;
      
      // 保留现有的accountBalance字段，暂时使用accountPoints的值
      accountBalance.value = homeInfo.accountPoints.toDouble();
      
      setSuccess();
    } catch (e) {
      // setError('加载数据失败: $e');
      showErrorMessage('加载数据失败: $e');
      // 移除错误提示框，避免顶部显示不消失的提示
    } finally {
      setLoading(false);
    }
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
    Get.toNamed(Routes.LUCKY_WHEEL);
  }

  // 签到日历点击
  void onSignInCalendarTap() {
    Get.toNamed(Routes.SIGN_IN_CALENDAR);
  }

  // 任务卡片点击
  void onTaskCardTap(String taskId) {
    Get.toNamed(Routes.WHATSAPP_TASK, arguments: taskId);
  }

  // 下载APP按钮点击
  void onDownloadAppTap() {
   Get.toNamed(Routes.INVITE_FRIEND);
    // 这里可以添加实际的下载逻辑，例如打开应用商店链接或显示下载二维码
  }
  
  // VIP详情点击
  void onVipDetailsTap() {
    Get.toNamed(Routes.VIP_DETAILS);
  }

  void onBannerTap(int index) {
    // 根据不同的banner索引执行不同的操作
    switch (index) {
      case 0:
        // 第一个banner的点击事件
        showSuccessMessage('点击了第一个banner');
        break;
      case 1:
        // 第二个banner的点击事件
        showSuccessMessage('点击了第二个banner');
        break;
      case 2:
        // 第三个banner的点击事件
        showSuccessMessage('点击了第三个banner');
        break;
    }
  }
}