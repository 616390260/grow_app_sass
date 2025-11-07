import 'package:do_task_project/app/core/i18n/i18n_keys.dart';
import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../data/services/vip_api_service.dart';
import '../../../data/models/vip_model.dart';

class VipDetailsController extends BaseController {
  // API服务
  final _vipApiService = VipApiService();
  
  // VIP等级和余额
  final currentVipLevel = 'VIP0'.obs;
  final vipBalance = 0.0.obs;
  final progressValue = 0.0.obs; // 进度条值 (0.0-1.0)
  final nextVipLevel = 'VIP1'.obs;
  
  // 晋升标准
  final promotionProgress = '0/0'.obs;
  
  // 推广收益
  final promotionIncome = 0.obs;
  
  // 每日奖励重置时间
  final dailyResetTime = '00:00:00'.obs;
  
  // VIP奖励列表
  final vipRewards = <VipLevelItemModel>[].obs;

  @override
  void initData() {
    // 初始化加载数据
    loadVipDetails();
  }

  // 加载VIP详情数据
  void loadVipDetails() async {
    try {
      setLoading(true);
      
      // 调用API获取VIP详情
      final vipDetails = await _vipApiService.getVipInfo();
      
      // 更新VIP等级信息
      currentVipLevel.value = vipDetails.currentVipLevel;
      nextVipLevel.value = vipDetails.nextVipLevel;
      vipBalance.value = vipDetails.points;
      
      // 更新推广数据
      promotionIncome.value = vipDetails.promotionPoints;
      promotionProgress.value = '${vipDetails.promotionPoints}/${vipDetails.totalPromotionPoints}';
      
      // 计算进度条值 (根据实际需求调整计算逻辑)
      if (vipDetails.totalPromotionPoints > 0) {
        progressValue.value = vipDetails.promotionPoints / vipDetails.totalPromotionPoints;
        // 确保进度值在0-1范围内
        if (progressValue.value > 1.0) progressValue.value = 1.0;
        if (progressValue.value < 0.0) progressValue.value = 0.0;
      }
      
      // 转换VIP等级列表数据
      final rewards = vipDetails.vipLevelList.map((item) {
        return VipLevelItemModel.fromJson(item.toJson());
      }).toList();
      
      vipRewards.assignAll(rewards);
      
      setSuccess();
    } catch (e) {
      setError('加载VIP详情失败');
      showErrorMessage('加载VIP详情失败: $e');
    } finally {
      setLoading(false);
    }
  }

  // 返回上一页
  void onBackPress() {
    Get.back();
  }

  // 领取奖励按钮点击
  void onClaimRewardTap() {
    showInfoMessage(I18nKeys.rewardClaimComingSoon.tr);
  }
}