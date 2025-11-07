import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../../domain/entities/promotion_data.dart';
import '../../../data/services/promotion_api_service.dart';
import '../../../core/utils/share_utils.dart';

class PromotionController extends BaseController {
  // 推广数据
  final promotionCount = 0.obs;
  final promotionEarnings = 0.0.obs;

  // 新增的推广数据字段
  final activeSubordinates = 0.obs;
  final activeUsers = 0.obs;
  final inviteCode = ''.obs;
  final inviteUrl = ''.obs;
  final reachTwoStarUsers = 0.obs;
  final twoStarRewardPoints = 0.obs;
  final todayNewSubordinates = 0.obs;
  final totalCommission = 0.0.obs;
  final todayCommission = 0.0.obs;
  final yesterdayCommission = 0.0.obs;
  final isReceived = false.obs;

  // API服务
  final _promotionApiService = PromotionApiService();

  @override
  void onInit() {
    super.onInit();
    // 懒加载：不在这里自动加载数据，等待tab切换时由MainController加载
  }

  void loadData() async {
    try {
      // 设置加载状态

      // 调用API获取真实数据
      final PromotionData data = await _promotionApiService.getInviteHome();

      // 更新推广数据
      // 保持原有的字段以确保UI兼容性
      promotionCount.value = data.activeSubordinates ?? 0;
      promotionEarnings.value = data.totalCommission ?? 0.0;

      // 更新新字段
      activeSubordinates.value = data.activeSubordinates ?? 0;
      activeUsers.value = data.activeUsers ?? 0;
      inviteCode.value = data.inviteCode ?? '';
      inviteUrl.value = data.inviteUrl ?? '';
      reachTwoStarUsers.value = data.reachTwoStarUsers ?? 0;
      todayCommission.value = data.todayCommission ?? 0.0;
      todayNewSubordinates.value = data.todayNewSubordinates ?? 0;
      totalCommission.value = data.totalCommission ?? 0.0;
      twoStarRewardPoints.value = data.twoStarRewardPoints ?? 0;
      yesterdayCommission.value = data.yesterdayCommission ?? 0.0;
      isReceived.value = data.isReceived ?? false;

      setSuccess();
    } catch (e) {
      showErrorMessage('加载推广数据失败: $e');
    } finally {
      setLoading(false);
    }
  }

  /// 分享到Telegram
  Future<void> shareToTelegram() async {
    await ShareUtils.shareToTelegram(inviteUrl.value);
  }

  /// 分享到WhatsApp
  Future<void> shareToWhatsApp() async {
    await ShareUtils.shareToWhatsApp(inviteUrl.value);
  }

  /// 分享到Facebook
  Future<void> shareToFacebook() async {
    await ShareUtils.shareToFacebook(inviteUrl.value);
  }

  /// 领取奖励
  Future<void> receiveReward() async {
    try {
      await safeApiCall(() async {
        // 调用API领取奖励
        await _promotionApiService.receiveReward(
          reachTwoStarUsers: reachTwoStarUsers.value,
          twoStarRewardPoints: twoStarRewardPoints.value
        );
      }, 
      (result) => isReceived.value = false);
    } catch (e) {
      showErrorMessage('领取奖励失败: $e');
    }
  }
}
