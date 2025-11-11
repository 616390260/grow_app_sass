import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/base/base_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../data/services/home_api_service.dart';
import '../../../data/models/home_info_model.dart';
import '../../../core/i18n/i18n_keys.dart';
import '../../../core/utils/message_utils.dart';

class HomeController extends BaseController {
  // 统计数据
  final accountBalance = 0.obs;
  final dailyEarnings = 0.obs;
  final promotionEarnings = 0.obs;
  final vipLevel = ''.obs;
  final accountPoints = 0.obs;
  final announcements = <BannerModel>[].obs;
  final recommendTasks = <RecommendTaskModel>[].obs;
  final domainName = ''.obs;

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
        accountPoints.value = homeInfo.accountPoints ?? 0;
        dailyEarnings.value = homeInfo.todayIncome ?? 0;
        promotionEarnings.value = homeInfo.todayPromotionIncome ?? 0;
        vipLevel.value = homeInfo.vipLevel ?? '';
        domainName.value = homeInfo.domainName ?? '';
        announcements.value = homeInfo.announcements ?? [];
        recommendTasks.value = homeInfo.recommendTasks ?? [];

        // 保留现有的accountBalance字段，暂时使用accountPoints的值
        accountBalance.value = homeInfo.accountPoints ?? 0;

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
  void onDownloadAppTap() async {
    try {
      // 显示加载提示

      // 应用商店链接（根据平台选择）
      String appStoreUrl;
      if (GetPlatform.isAndroid) {
        // Google Play商店链接，使用包名
        appStoreUrl = 'market://details?id=com.example.app';
      } else if (GetPlatform.isIOS) {
        // App Store链接，使用应用ID
        appStoreUrl = 'https://apps.apple.com/app/id123456789';
      } else {
        // 默认使用网页版应用商店
        appStoreUrl =
            'https://play.google.com/store/apps/details?id=com.example.app';
      }

      final Uri url = Uri.parse(appStoreUrl);

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        // 如果无法打开原生应用商店，尝试打开网页版
        String webStoreUrl = GetPlatform.isIOS
            ? 'https://apps.apple.com/app/id123456789'
            : 'https://play.google.com/store/apps/details?id=com.example.app';

        final Uri webUrl = Uri.parse(webStoreUrl);
        if (await canLaunchUrl(webUrl)) {
          await launchUrl(webUrl, mode: LaunchMode.externalApplication);
        } else {}
      }
      // ignore: empty_catches
    } catch (e) {}
  }

  // VIP详情点击
  void onVipDetailsTap() {
    Get.toNamed(Routes.vipDetails);
  }

  // Banner点击处理
  void onBannerTap(int index) async {
    // 确保索引在有效范围内
    if (index >= 0 && index < announcements.length) {
      final banner = announcements[index];
      final url = GetPlatform.isIOS
          ? (banner.iosHyperLink ?? banner.hyperLink)
          : banner.hyperLink;

      if (url != null && url.isNotEmpty) {
        try {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          } else {}
          // ignore: empty_catches
        } catch (e) {}
      }
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

  void onInviteFriendTap() {
    Get.toNamed(Routes.inviteFriend);
  }

  void onCallCenterTap() async {
    if (domainName.value.isNotEmpty) {
      try {
        final uri = Uri.parse(domainName.value);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          print('无法打开拨打电话链接');
        }
      } catch (e) {
        print('拨打电话链接打开失败: $e');
      }
    }else{
       print('拨打电话链接链接为空');
    }
  }
}
