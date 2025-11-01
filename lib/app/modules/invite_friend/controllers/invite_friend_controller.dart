import 'package:do_task_project/app/core/base/base_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:do_task_project/app/core/i18n/i18n_keys.dart';
import 'package:do_task_project/app/core/utils/message_utils.dart';
import 'package:do_task_project/app/data/services/invite_friend_api_service.dart';

class InviteFriendController extends BaseController {
  // 推荐链接
  final referralLink = 'https://www.baidu.com'.obs;
  
  // 复制状态
  final isCopied = false.obs;
  
  // 邀请好友API服务
  final InviteFriendApiService _inviteFriendApiService = InviteFriendApiService();

  @override
  void onInit() {
    super.onInit();
    // 初始化时从API获取真实的推荐链接
    fetchReferralLink();
  }

  /// 复制推荐链接到剪贴板
  Future<void> copyReferralLink() async {
    try {
      await Clipboard.setData(ClipboardData(text: referralLink.value));
      isCopied.value = true;
      MessageUtils.showSuccess(I18nKeys.copiedToClipboard.tr);
      
      // 2秒后重置复制状态
      Future.delayed(const Duration(seconds: 2), () {
        isCopied.value = false;
      });
    } catch (e) {
      MessageUtils.showError('Failed to copy link');
    }
  }

  /// 分享推荐链接到社交媒体
  Future<void> shareReferralLink() async {
    try {
      await Share.share(
        '${I18nKeys.inviteValidUsers.tr}: ${referralLink.value}',
        subject: I18nKeys.inviteFriendTitle.tr,
      );
    } catch (e) {
      MessageUtils.showError('Failed to share link');
    }
  }

  /// 从API获取推荐链接
  Future<void> fetchReferralLink() async {
    try {
      // 显示加载状态
      
      // 调用API获取推荐链接
      final link = await _inviteFriendApiService.getReferralLink();
      referralLink.value = link;
      
      // 设置成功状态
      setSuccess();
    } catch (e) {
      // 使用BaseController的错误处理方法
      handleErrorCode(-1, e.toString());
      // 确保加载状态被正确关闭
      setLoading(false);
    }
  }

  /// 获取奖励金额列表
  List<int> getRewardList() {
    // 根据UI设计，返回奖励金额的二维数组
    return [
      300,
      300,
      300,
      300,
      300,
      300,
      1000,
      1000,
      2000,
      300,
      300,
    ];
  }
}