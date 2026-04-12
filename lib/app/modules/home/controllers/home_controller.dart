import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/utils/midnight_countdown_util.dart';
import '../../../routes/app_pages.dart';
import '../../../data/services/home_api_service.dart';
import '../../../data/services/activity_api_service.dart';
import '../../../data/services/configuration_api_service.dart';
import '../../../data/models/home_info_model.dart';
import '../../../data/models/activity_model.dart';
import '../../../core/i18n/i18n_keys.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/constants/app_constants.dart';

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

  final Rxn<PopupAnnouncementModel> popupAnnouncement =
      Rxn<PopupAnnouncementModel>();
  final RxList<SystemAnnouncementModel> sysAnnouncement =
      <SystemAnnouncementModel>[].obs;
  bool _popupShown = false;
  bool _isVersionChecked = false;

  final HomeApiService _homeApiService = HomeApiService();

  // 底部导航当前索引
  final currentTabIndex = 0.obs;


  // 热门活动数据（从活动接口获取）
  final Rx<ActivityAllData?> activityData = Rx<ActivityAllData?>(null);
  final ActivityApiService _activityApiService = ActivityApiService();
  final ConfigurationApiService _configurationApiService = ConfigurationApiService();

  // 活动卡片展开状态
  final RxSet<String> expandedCards = <String>{}.obs;
  final RxInt claimingId = (-1).obs;

  void toggleCard(String key) {
    if (expandedCards.contains(key)) {
      expandedCards.remove(key);
    } else {
      expandedCards.add(key);
    }
  }

  bool isCardExpanded(String key) => expandedCards.contains(key);

  Future<void> claim(int activityId) async {
    claimingId.value = activityId;
    await safeApiCall<int>(
      () => _activityApiService.claim(activityId),
      (earnedPoints) {
        Get.snackbar(
          I18nKeys.success.tr,
          I18nKeys.activityEarnedPoints.tr.replaceAll('@points', '$earnedPoints'),
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF2E7D32),
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
          borderRadius: 12,
          icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
        );
        loadData();
      },
      onError: () {
        Get.snackbar(
          I18nKeys.error.tr,
          I18nKeys.activityClaimFailed.tr,
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFFD32F2F),
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
          borderRadius: 12,
          icon: const Icon(Icons.error_rounded, color: Colors.white),
        );
      },
    );
    claimingId.value = -1;
  }

  // 倒计时
  static const int _timezoneConfigurationId = 24;
  final RxString activityTimezone = ''.obs;
  final RxString midnightCountdownText = '00:00:00'.obs;
  Timer? _midnightTimer;

  @override
  void onInit() {
    super.onInit();
    _tickMidnight();
    _startTimer();
  }

  @override
  void onClose() {
    _stopTimer();
    super.onClose();
  }

  void _startTimer() {
    _midnightTimer ??=
        Timer.periodic(const Duration(seconds: 1), (_) => _tickMidnight());
  }

  void _stopTimer() {
    _midnightTimer?.cancel();
    _midnightTimer = null;
  }

  void _tickMidnight() {
    final d = MidnightCountdownUtil.untilMidnight(activityTimezone.value);
    midnightCountdownText.value = MidnightCountdownUtil.formatHms(d);
  }

  // 加载数据
  void loadData() {
    // 重新加载数据时重置弹窗状态，允许再次显示弹窗
    resetPopupShown();

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

        popupAnnouncement.value = homeInfo.popupAnnouncement;
        sysAnnouncement.value = homeInfo.sysAnnouncements ?? [];

        // 保留现有的accountBalance字段，暂时使用accountPoints的值
        accountBalance.value = homeInfo.accountPoints ?? 0;

        setSuccess();

        // Android端第一次进入首页时检查版本更新
        // if (GetPlatform.isAndroid && !_isVersionChecked) {
        if (GetPlatform.isAndroid) {
          checkVersionUpdate();
        }
      },
      // 自定义错误消息
      errorMessage: I18nKeys.loadDataFailed.tr,
      // 显示加载状态
      showLoading: true,
    );

    // 加载活动数据（同步拉取时区配置）
    safeApiCall<ActivityAllData>(
      () async {
        final cfgFuture =
            _configurationApiService.getById(_timezoneConfigurationId);
        final actFuture = _activityApiService.getAll();
        try {
          final cfg = await cfgFuture;
          activityTimezone.value = cfg.content?.trim() ?? '';
        } catch (_) {
          activityTimezone.value = '';
        }
        _tickMidnight();
        return await actFuture;
      },
      (result) {
        activityData.value = result;
      },
      showLoading: false,
    );
  }

  // 比较语义化版本号，返回true表示新版本大于当前版本
  bool _compareVersions(String newVersion, String currentVersion) {
    try {
      // 将版本号字符串转换为整数列表，如 "1.0.3" -> [1, 0, 3]
      List<int> newVerParts = newVersion
          .split('.')
          .map((part) => int.tryParse(part) ?? 0)
          .toList();
      List<int> currentVerParts = currentVersion
          .split('.')
          .map((part) => int.tryParse(part) ?? 0)
          .toList();

      // 确保两个版本号列表长度相同，不足的补0
      int maxLength = newVerParts.length > currentVerParts.length
          ? newVerParts.length
          : currentVerParts.length;
      while (newVerParts.length < maxLength) {
        newVerParts.add(0);
      }
      while (currentVerParts.length < maxLength) {
        currentVerParts.add(0);
      }

      // 逐位比较版本号
      for (int i = 0; i < maxLength; i++) {
        if (newVerParts[i] > currentVerParts[i]) {
          return true;
        } else if (newVerParts[i] < currentVerParts[i]) {
          return false;
        }
      }

      // 版本号相同
      return false;
    } catch (e) {
      // 解析版本号失败，默认返回false
      return false;
    }
  }

  // 检查版本更新
  void checkVersionUpdate() {
    _isVersionChecked = true;

    safeApiCall(
      () async {
        // 获取当前应用的版本信息
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        // 获取版本更新信息
        VersionUpdateModel versionInfo = await _homeApiService.getNewVersion();
        // 返回包含版本信息和包信息的Map
        return {"versionInfo": versionInfo, "packageInfo": packageInfo};
      },
      (result) {
        VersionUpdateModel versionInfo =
            result["versionInfo"] as VersionUpdateModel;
        PackageInfo packageInfo = result["packageInfo"] as PackageInfo;

        // 获取当前应用的版本号
        String currentVersion = packageInfo.version; // 例如：1.0.0
        try {
          final box = GetStorage();
          box.write(AppConstants.storageKeyAppVersion, currentVersion);
        } catch (_) {}
        // String currentBuildNumber = packageInfo.buildNumber; // 例如：1

        // 使用服务器返回的buildNumber进行版本比较（因为versionNo是null）
        if (versionInfo.buildNumber != null &&
            versionInfo.buildNumber!.isNotEmpty &&
            _compareVersions(versionInfo.buildNumber!, currentVersion)) {
          // 显示版本更新弹窗
          showVersionUpdateDialog(versionInfo);
        }
      },
      errorMessage: '', // 版本检查失败不显示错误提示
      showLoading: false,
    );
  }

  // 下载并安装APK
  Future<void> _downloadAndInstallApk(String downloadUrl) async {
    try {
      // 请求存储权限
      var storageStatus = await Permission.storage.status;
      if (!storageStatus.isGranted) {
        storageStatus = await Permission.storage.request();
        if (!storageStatus.isGranted) {
          Get.snackbar(
            I18nKeys.insufficientPermissions.tr,
            I18nKeys.needStoragePermission.tr,
          );
          return;
        }
      }

      // 请求安装未知来源应用的权限（Android 8.0+）
      var installStatus = await Permission.requestInstallPackages.status;
      if (!installStatus.isGranted) {
        installStatus = await Permission.requestInstallPackages.request();
        if (!installStatus.isGranted) {
          Get.snackbar(
            I18nKeys.insufficientPermissions.tr,
            I18nKeys.needInstallPermission.tr,
          );
          return;
        }
      }

      // 显示下载中提示
      Get.snackbar(
        I18nKeys.downloadStarted.tr,
        I18nKeys.downloadingNewVersion.tr,
        showProgressIndicator: true,
      );

      // 获取下载目录
      Directory? directory = await getExternalStorageDirectory();
      String savePath = '${directory?.path}/app_update.apk';

      // 使用Dio下载APK
      Dio dio = Dio();
      await dio.download(downloadUrl, savePath);

      // 下载完成后安装APK
      Get.snackbar(
        I18nKeys.downloadCompleted.tr,
        I18nKeys.preparingInstallation.tr,
      );

      // 使用OpenFilex打开APK，这会调用系统安装器
      final result = await OpenFilex.open(savePath);
      if (result.type != ResultType.done) {
        Get.snackbar(
          I18nKeys.installationPrompt.tr,
          I18nKeys.completeInstallationInSystem.tr,
        );
      }
    } catch (e) {
      Get.snackbar(I18nKeys.downloadFailed.tr, e.toString());
    }
  }

  // 显示版本更新弹窗
  void showVersionUpdateDialog(VersionUpdateModel versionInfo) {
    Get.defaultDialog(
      title: I18nKeys.versionUpdateFound.tr,
      middleText: versionInfo.description ?? I18nKeys.versionUpdateAvailable.tr,
      textConfirm: I18nKeys.updateNow.tr,
      textCancel: versionInfo.forceUpdate == '1'
          ? null
          : I18nKeys.updateLater.tr,
      confirmTextColor: Colors.white,
      onConfirm: () async {
        if (versionInfo.downloadUrl != null &&
            versionInfo.downloadUrl!.isNotEmpty) {
          // 关闭弹窗
          Get.back();
          // 下载并安装APK
          await _downloadAndInstallApk(versionInfo.downloadUrl!);
        } else {
          Get.back();
          Get.snackbar(
            I18nKeys.downloadFailed.tr,
            I18nKeys.downloadLinkInvalid.tr,
          );
        }
      },
      onCancel: () {
        Get.back();
      },
      barrierDismissible: versionInfo.forceUpdate != '1',
    );
  }

  // 刷新数据
  @override
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

      // Web平台下调用API获取下载链接
      if (GetPlatform.isWeb) {
        final downloadUrl = await safeApiCall(
          () => _homeApiService.getApkDownloadUrl(),
          null,
        );

        if (downloadUrl != null) {
          // 假设API返回格式为 {"url": "下载链接"}
          if (downloadUrl.isNotEmpty) {
            final Uri url = Uri.parse(downloadUrl);
            if (await canLaunchUrl(url)) {
              await launchUrl(url, mode: LaunchMode.externalApplication);
            } else {
              // 下载链接无法打开时的提示
              Get.snackbar(
                I18nKeys.downloadFailed.tr,
                I18nKeys.unableToOpenUrl.tr,
              );
            }
          } else {
            // 下载链接为空时的提示
            Get.snackbar(
              I18nKeys.downloadFailed.tr,
              I18nKeys.downloadLinkEmpty.tr,
            );
          }
        }
      }
    } catch (e) {
      // 错误处理
      Get.snackbar(I18nKeys.downloadFailed.tr, e.toString());
    } finally {
      // 隐藏加载提示
    }
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

  // void onCallCenterTap() async {
  //   if (domainName.value.isNotEmpty) {
  //     try {
  //       final uri = Uri.parse(domainName.value);
  //       if (await canLaunchUrl(uri)) {
  //         await launchUrl(uri, mode: LaunchMode.externalApplication);
  //       } else {
  //         print(I18nKeys.cannotOpenCallLink.tr);
  //       }
  //     } catch (e) {
  //       print('${I18nKeys.callLinkOpenFailed.tr}: $e');
  //     }
  //   } else {
  //     print(I18nKeys.callLinkEmpty.tr);
  //   }
  // }

  // 活动点击处理：任务活动跳任务页，佣金/下属活动跳推广页
  void onActivityTap(ActivityGroup group) {
    if (group == activityData.value?.taskActivity) {
      Get.toNamed(Routes.tasks);
    } else {
      Get.toNamed(Routes.promotion);
    }
  }

  bool get hasPopupShown => _popupShown;
  void markPopupShown() {
    _popupShown = true;
  }

  void markPopupClose() {
    // 不再重置_popupShown状态，确保弹窗只在首次加载或刷新数据时显示
  }

  // 只有在重新加载数据时才重置弹窗状态
  void resetPopupShown() {
    _popupShown = false;
  }
}
