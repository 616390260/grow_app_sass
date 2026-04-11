import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/utils/midnight_countdown_util.dart';
import '../../../core/i18n/i18n_keys.dart';
import '../../../data/models/activity_model.dart';
import '../../../data/services/activity_api_service.dart';
import '../../../data/services/configuration_api_service.dart';

/// 活动页面控制器
class ActivitiesController extends BaseController {
  final _apiService = ActivityApiService();
  final _configurationApiService = ConfigurationApiService();

  /// 网站使用时区（配置 id=24，`content` 为 IANA 时区名）
  static const int _timezoneConfigurationId = 24;

  /// 全部活动数据
  final Rx<ActivityAllData?> activityData = Rx<ActivityAllData?>(null);

  /// 当前活动页使用的时区字符串，如 Asia/Tokyo；接口失败时为空
  final RxString activityTimezone = ''.obs;

  /// 距「网站时区」下一日 0 点的倒计时 HH:mm:ss
  final RxString midnightCountdownText = '00:00:00'.obs;

  /// 网站时区下的当前时间，如 2026-04-11 19:30:45
  final RxString timezoneCurrentTime = ''.obs;

  Timer? _midnightTimer;

  /// 正在领取中的活动 id（用于按钮 loading 状态）
  final RxInt claimingId = (-1).obs;

  /// 快捷访问各活动分组
  ActivityGroup? get taskActivity => activityData.value?.taskActivity;
  ActivityGroup? get commissionActivity => activityData.value?.commissionActivity;
  ActivityGroup? get subordinateActivity => activityData.value?.subordinateActivity;

  @override
  void onInit() {
    super.onInit();
    _tickMidnight();
    _midnightTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => _tickMidnight());
  }

  @override
  void onClose() {
    _midnightTimer?.cancel();
    super.onClose();
  }

  void _tickMidnight() {
    final tz = activityTimezone.value;
    final d = MidnightCountdownUtil.untilMidnight(tz);
    midnightCountdownText.value = MidnightCountdownUtil.formatHms(d);
    timezoneCurrentTime.value = MidnightCountdownUtil.currentTimeInZone(tz);
    // 每分钟打印一次，确认使用时区正确
    if (d.inSeconds % 60 == 0) {
      debugPrint(
        '[Countdown] tz="$tz"  '
        'currentTime="${timezoneCurrentTime.value}"  '
        'countdown="${midnightCountdownText.value}"',
      );
    }
  }

  @override
  void initData() {
    loadData();
  }

  /// 加载活动数据（并行拉取时区配置 + 活动列表）
  void loadData() {
    safeApiCall<ActivityAllData>(
      () async {
        final cfgFuture =
            _configurationApiService.getById(_timezoneConfigurationId);
        final actFuture = _apiService.getAll();
        try {
          final cfg = await cfgFuture;
          activityTimezone.value = cfg.content?.trim() ?? '';
        } catch (_) {
          activityTimezone.value = '';
        }
        return await actFuture;
      },
      (result) {
        activityData.value = result;
        _tickMidnight();
      },
    );
  }

  /// 领取活动奖励
  Future<void> claim(int activityId) async {
    claimingId.value = activityId;
    await safeApiCall<int>(
      () => _apiService.claim(activityId),
      (earnedPoints) {
        Get.snackbar(
          I18nKeys.success.tr,
          I18nKeys.activityEarnedPoints.tr
              .replaceAll('@points', '$earnedPoints'),
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

  @override
  void refreshData() {
    loadData();
  }
}
