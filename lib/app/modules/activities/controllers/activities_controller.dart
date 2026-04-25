import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/services/tenant_service.dart';
import '../../../core/utils/midnight_countdown_util.dart';
import '../../../core/i18n/i18n_keys.dart';
import '../../../data/models/activity_model.dart';
import '../../../data/models/tenant_brand_model.dart';
import '../../../data/services/activity_api_service.dart';
import '../../main/controllers/main_controller.dart';

/// 活动页面控制器
class ActivitiesController extends BaseController {
  final _apiService = ActivityApiService();

  /// 全部活动数据
  final Rx<ActivityAllData?> activityData = Rx<ActivityAllData?>(null);

  /// 当前活动页使用的时区字符串（来自 `/app/tenant/template` 的 `brand.site_time_zone`），
  /// 形如 `Asia/Tokyo`、`UTC+4`；未配置时为空，回退本机时区。
  final RxString activityTimezone = ''.obs;

  /// 距「网站时区」下一日 0 点的倒计时 HH:mm:ss
  final RxString midnightCountdownText = '00:00:00'.obs;

  /// 网站时区下的当前时间，如 2026-04-11 19:30:45
  final RxString timezoneCurrentTime = ''.obs;

  Timer? _midnightTimer;

  /// Activities 在 IndexedStack 中的 tab 索引
  static const int _activitiesTabIndex = 3;

  /// 正在领取中的活动 id（用于按钮 loading 状态）
  final RxInt claimingId = (-1).obs;

  /// 当前已展开的活动卡片 key 集合（'task' / 'commission' / 'subordinate'）
  final RxSet<String> expandedCards = <String>{}.obs;

  /// 切换卡片展开/收起
  void toggleCard(String key) {
    if (expandedCards.contains(key)) {
      expandedCards.remove(key);
    } else {
      expandedCards.add(key);
    }
  }

  bool isCardExpanded(String key) => expandedCards.contains(key);

  /// 快捷访问各活动分组
  ActivityGroup? get taskActivity => activityData.value?.taskActivity;
  ActivityGroup? get commissionActivity => activityData.value?.commissionActivity;
  ActivityGroup? get subordinateActivity => activityData.value?.subordinateActivity;

  @override
  void onInit() {
    super.onInit();
    _syncTimezoneFromTenant();
    _tickMidnight();
    _startTimer();

    // 租户品牌配置可能在控制器初始化后才到达，监听后同步时区
    ever<TenantBrandModel?>(TenantService.to.brandInfo, (_) {
      _syncTimezoneFromTenant();
      _tickMidnight();
    });

    // 监听主页 tab 变化：离开 Activities tab 时暂停，切回来时恢复
    ever(Get.find<MainController>().currentTabIndex, (int index) {
      if (index == _activitiesTabIndex) {
        _tickMidnight();
        _startTimer();
      } else {
        _stopTimer();
      }
    });
  }

  /// 从 `TenantService` 同步站点时区到本地响应式变量
  void _syncTimezoneFromTenant() {
    activityTimezone.value = TenantService.to.siteTimeZone;
  }

  @override
  void onClose() {
    _stopTimer();
    super.onClose();
  }

  void _startTimer() {
    if (_midnightTimer != null) return;
    _midnightTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => _tickMidnight());
  }

  void _stopTimer() {
    _midnightTimer?.cancel();
    _midnightTimer = null;
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

  /// 加载活动数据
  ///
  /// 时区不再单独请求接口，统一从 `TenantService.siteTimeZone`（即
  /// `/app/tenant/template` 返回的 `brand.site_time_zone`）读取。
  void loadData() {
    _syncTimezoneFromTenant();
    safeApiCall<ActivityAllData>(
      () => _apiService.getAll(),
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
