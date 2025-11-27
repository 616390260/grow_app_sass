import 'package:do_task_project/app/core/i18n/i18n_keys.dart';
import 'package:do_task_project/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'dart:async';
import '../../../core/base/base_controller.dart';
import '../../../data/services/vip_api_service.dart';
import '../../../data/models/vip_model.dart';
import '../views/vip_reward_popup.dart';

class VipDetailsController extends BaseController {
  // API服务
  final _vipApiService = VipApiService();
  
  // VIP等级和余额
  final currentVipLevel = 'VIP0'.obs;
  final vipBalance = 0.obs;
  final progressValue = 0.0.obs; // 进度条值 (0.0-1.0)
  final nextVipLevel = 'VIP1'.obs;
  
  // 晋升标准
  final promotionProgress = '0/0'.obs;
  
  // 推广收益
  final promotionIncome = 0.obs;
  final currentPullNum = 0.obs;
  
  // 每日奖励重置时间
  final dailyResetTime = ''.obs;
  
  // VIP奖励列表
  final vipRewards = <VipLevelItemModel>[].obs;
  final vipTodayRewards = <VipLevelItemModel>[].obs;
  
  // 倒计时定时器
  Timer? _countdownTimer;

  @override
  void initData() {
    // 初始化加载数据
    loadVipDetails();
    
    // 启动倒计时
    startCountdown();
  }
  
  @override
  void onClose() {
    super.onClose();
    // 清理定时器
    _stopCountdown();
  }
  
  // 计算距离24点的剩余时间
  Duration _calculateTimeUntilMidnight() {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1, 0, 0, 0);
    return tomorrow.difference(now);
  }
  
  // 更新倒计时显示
  void _updateCountdown() {
    final remainingTime = _calculateTimeUntilMidnight();
    
    final hours = remainingTime.inHours.toString().padLeft(2, '0');
    final minutes = (remainingTime.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (remainingTime.inSeconds % 60).toString().padLeft(2, '0');
    
    dailyResetTime.value = '$hours:$minutes:$seconds';
  }
  
  // 启动倒计时
  void startCountdown() {
    // 立即更新一次
    _updateCountdown();
    
    // 设置定时器每秒更新一次
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateCountdown();
      
      // 检查是否到达00:00:00
      if (dailyResetTime.value == '00:00:00') {
        // 重置数据或执行其他操作
        loadVipDetails();
      }
    });
  }
  
  // 停止倒计时
  void _stopCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
  }

  // 加载VIP详情数据
  void loadVipDetails() async {
    await safeApiCall<VipDetailsModel>(
      () => _vipApiService.getVipInfo(),
      (vipDetails) {
        currentVipLevel.value = vipDetails.currentVipLevel;
        nextVipLevel.value = vipDetails.nextVipLevel;
        vipBalance.value = vipDetails.points;
        promotionIncome.value = vipDetails.promotionPoints;
        currentPullNum.value = vipDetails.currentPullNum;
        promotionProgress.value = '${vipDetails.promotionPoints}/${vipDetails.subordinatePullNum}';
        if (vipDetails.totalPromotionPoints > 0) {
          progressValue.value = vipDetails.promotionPoints / vipDetails.subordinatePullNum;
          if (progressValue.value > 1.0) progressValue.value = 1.0;
          if (progressValue.value < 0.0) progressValue.value = 0.0;
        }
        final rewards = vipDetails.vipLevelList.map((item) {
          return VipLevelItemModel.fromJson(item.toJson());
        }).toList();
        vipRewards.assignAll(rewards);
        final todayRewards = vipDetails.vipTodayLevelList.map((item) {
          return VipLevelItemModel.fromJson(item.toJson());
        }).toList();
        vipTodayRewards.assignAll(todayRewards);
        setSuccess();
      },
      errorMessage: I18nKeys.loadVipDetailsFailed.tr,
      showLoading: true,
      onError: () {
        setError(I18nKeys.loadVipDetailsFailed.tr);
      },
    );
  }

  // 返回上一页
  void onBackPress() {
    if (Get.key.currentState!.canPop()) {
      Get.back();
    } else {
      // 刷新后 fallback 到首页
      Get.offAllNamed(Routes.root);
    }
  }

  // 领取奖励按钮点击
  void onClaimRewardTap() {
    // 显示VIP奖励弹窗
    showVipRewardPopup();
  }

  // 显示VIP奖励弹窗
  void showVipRewardPopup() {
    // 使用GetBuilder来确保弹窗能够接收到响应式变量的更新
    Get.dialog(
      Obx(() => VipRewardPopup(
        resetTime: dailyResetTime.value,
        promotionIncome: promotionIncome.value,
        rewardLevels: vipTodayRewards.toList(),
      )),
    );
  }

  // 领取VIP奖励
  void claimReward(int vipLevel) async {
    await safeApiCall<dynamic>(
      () => _vipApiService.getReward(vipLevel),
      (response) {
        // 重新加载数据以更新UI
        showSuccessMessage(I18nKeys.claimRewardSuccess.tr);
        loadVipDetails();
      },
      errorMessage: I18nKeys.claimRewardFailed.tr,
      showLoading: true,
    );
  }
}
