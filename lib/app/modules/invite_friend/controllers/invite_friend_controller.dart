import 'package:do_task_project/app/core/base/base_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:do_task_project/app/core/i18n/i18n_keys.dart';
import 'package:do_task_project/app/core/utils/message_utils.dart';
import 'package:do_task_project/app/core/utils/share_utils.dart';
import 'package:do_task_project/app/data/services/invite_friend_api_service.dart';
import 'package:do_task_project/app/routes/app_pages.dart';
import 'package:do_task_project/app/modules/invite_friend/models/box_product_model.dart';
import 'dart:async';

class InviteFriendController extends BaseController {
  // 推荐链接
  final referralLink = ''.obs;
  
  // 复制状态
  final isCopied = false.obs;
  
  // 宝箱产品列表
  final boxProducts = <BoxProductModel>[].obs;
  
  // 邀请好友API服务
  final InviteFriendApiService _inviteFriendApiService = InviteFriendApiService();
  
  // 轮询定时器
  Timer? _pollingTimer;

  @override
  void onClose() {
    // 停止轮询定时器
    stopPolling();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    // 初始化时从API获取真实的推荐链接
    fetchReferralLink();
    // 初始化时获取宝箱产品列表
    fetchBoxProductList();
    // 启动轮询定时器，每5秒刷新一次宝箱产品列表
    startPolling();
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
      MessageUtils.showError(I18nKeys.failedToCopyLink.tr);
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
      MessageUtils.showError(I18nKeys.failedToShareLink.tr);
    }
  }

  /// 从API获取推荐链接
  Future<void> fetchReferralLink() async {
    await safeApiCall<String>(
      () => _inviteFriendApiService.getReferralLink(),
      (link) {
        referralLink.value = link;
        setSuccess();
      },
      errorMessage: I18nKeys.processingFailed.tr,
      showLoading: true,
      onError: () {
        setError(I18nKeys.processingFailed.tr);
      },
    );
  }


  /// 从API获取宝箱产品列表
  Future<void> fetchBoxProductList() async {
    await safeApiCall<List<BoxProductModel>>(
      () => _inviteFriendApiService.getBoxProductList(),
      (products) {
        boxProducts.assignAll(products);
        setSuccess();
      },
      errorMessage: I18nKeys.processingFailed.tr,
      onError: () {
        setError(I18nKeys.processingFailed.tr);
      },
    );
  }

  /// 分享到Telegram
  Future<void> shareToTelegram() async {
    await ShareUtils.shareToTelegram(referralLink.value);
  }

  /// 分享到WhatsApp
  Future<void> shareToWhatsApp() async {
    await ShareUtils.shareToWhatsApp(referralLink.value);
  }

  /// 分享到Facebook
  Future<void> shareToFacebook() async {
    await ShareUtils.shareToFacebook(referralLink.value);
  }

  /// 跳转到有效用户页面
  void goToValidUsersPage() {
    Get.toNamed(Routes.validUsers);
  }

  void receiveBoxProduct(int index) async {
    if (index < 0 || index >= boxProducts.length) {
      showWarningMessage(I18nKeys.invalidBoxIndex.tr);
      return;
    }

    final boxProduct = boxProducts[index];
    if (boxProduct.boxId == null) {
      showWarningMessage(I18nKeys.invalidBoxId.tr);
      return;
    }

    if (boxProduct.isReceived == true) {
      showWarningMessage(I18nKeys.boxAlreadyClaimed.tr);
      return;
    }

    if (boxProduct.isCanReceived != true) {
      showWarningMessage(I18nKeys.boxNotAvailable.tr);
      return;
    }

    safeApiCall<Map<String, dynamic>>(
      // API调用函数
      () async => await _inviteFriendApiService.receiveBox(boxProduct.boxId!),
      // 成功回调
      (response) async {
        // 更新宝箱状态
        boxProducts[index] = boxProduct.copyWith(
          isReceived: true,
        );
        
        // 显示成功消息
        final message = response['message'] ?? I18nKeys.boxClaimSuccess.tr;
        showSuccessMessage(message);
        
        // 刷新宝箱列表
        await fetchBoxProductList();
      },
      // 自定义错误消息
      errorMessage: I18nKeys.boxClaimFailed.tr,
      // 显示加载状态
      showLoading: true,
    );
  }

  /// 停止轮询定时器
  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  /// 启动轮询定时器
  void startPolling() {
    // 先停止之前的定时器
    stopPolling();
    
    // 创建新的定时器，每5秒执行一次
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      // 轮询获取宝箱产品列表
      fetchBoxProductList();
    });
  }
}
