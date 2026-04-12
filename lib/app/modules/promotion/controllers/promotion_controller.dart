import 'package:do_task_project/app/core/i18n/i18n_keys.dart';
import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import 'package:do_task_project/app/domain/entities/promotion_data.dart';
import '../../../data/services/promotion_api_service.dart';
import '../../../core/utils/share_utils.dart';
import '../../../core/utils/app_utils.dart';

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

  void loadData() async {
    await safeApiCall<PromotionData>(
      () => _promotionApiService.getInviteHome(),
      (data) {
        promotionCount.value = data.activeSubordinates ?? 0;
        promotionEarnings.value = data.totalCommission ?? 0.0;
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
      },
      errorMessage: I18nKeys.loadPromotionDataFailed.tr,
      onError: () {},
      showLoading: true,
    );
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
          twoStarRewardPoints: twoStarRewardPoints.value,
        );
      }, (result) => isReceived.value = false);
    } catch (e) {
      showErrorMessage('${I18nKeys.claimRewardFailed.tr}: $e');
    }
  }

  /// 复制邀请链接
  Future<void> copyInviteLink() async {
    try {
      await AppUtils.copyToClipboard(inviteUrl.value);
    } catch (e) {}
  }

  /// 复制邀请码
  Future<void> copyInviteCode() async {
    try {
      await AppUtils.copyToClipboard(inviteCode.value);
    } catch (e) {}
  }
}
