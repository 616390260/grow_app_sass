import 'package:do_task_project/app/core/constants/image_assets.dart';
import 'package:do_task_project/app/core/theme/app_theme.dart';
import 'package:do_task_project/app/core/theme/text_styles.dart';
import 'package:do_task_project/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:do_task_project/app/core/base/base_view.dart';
import 'package:do_task_project/app/core/i18n/i18n_keys.dart';
import '../controllers/invite_friend_controller.dart';
import '../components/decorated_title.dart';

class InviteFriendView extends BaseView<InviteFriendController> {
  const InviteFriendView({super.key});

  @override
  Widget buildContent(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.primaryColor, // 20% 位置
            AppTheme.primaryGradientMid, // 60% 位置
            const Color(0xFFF9F9F9), // 100% 位置
          ],
          stops: const [0.0, 0.2, 0.6],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(
            I18nKeys.inviteFriendTitle.tr,
            style: const TextStyle(fontSize: 17, color: Colors.white),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => {
              if (Get.key.currentState!.canPop()) {
                Get.back()
              } else {
                // 刷新后 fallback 到首页
                Get.offAllNamed(Routes.root),
              }
            },
          ),
          // 沉浸式状态栏配置
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 顶部插图
              const SizedBox(height: 88),
              SizedBox(
                height: 217,
                child: Image.asset(
                  ImageAssets.inviteBg,
                  height: 217,
                  fit: BoxFit.cover,
                ),
              ),
              GestureDetector(
                onTap: controller.goToValidUsersPage,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        I18nKeys.inviteValidUsers.tr,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.threeColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SvgPicture.asset(
                        ImageAssets.rightGray,
                        width: 15,
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),

              // 分享卡片（推荐链接 + 邀请码）
              const SizedBox(height: 15),
              _buildShareCard(),

              // 奖励表格
              const SizedBox(height: 30),
              _buildRewardTable(),

              // 参与条件
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: DecoratedTitle(
                        title: I18nKeys.participationConditions.tr,
                        textStyle: TextStyle(
                          fontSize: 14,
                          color: AppTheme.threeColor,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),

                    // const SizedBox(height: 15),
                    
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Text(
                    //       I18nKeys.yourDownlineMustMeet.tr,
                    //       style: TextStyles.smallThreeColorW500,
                    //     ),
                    //     const SizedBox(height: 10),
                    //     _buildConditionItem(I18nKeys.registerTimeOver1Min.tr),
                    //     _buildConditionItem(I18nKeys.sendMessagesOver5.tr),
                    //   ],
                    // ),

                    // 奖励内容
                    const SizedBox(height: 20),
                    Text(
                      I18nKeys.rewardContent.tr,
                      style: TextStyles.smallThreeColorW500,
                    ),
                    // const SizedBox(height: 10),
                    // Text(
                    //   I18nKeys.multipliedRewards.tr,
                    //   style: TextStyles.smallThreeColorW500,
                    // ),
                    // const SizedBox(height: 5),
                    // Text(
                    //   I18nKeys.conditionsCanBeMetMultipleTimes.tr,
                    //   style: TextStyles.smallThreeColorW500,
                    // ),

                    // // 如何操作
                    // const SizedBox(height: 20),
                    // Text(
                    //   I18nKeys.howToOperate.tr,
                    //   style: TextStyles.smallThreeColorW500,
                    // ),
                    // const SizedBox(height: 10),
                    // Text(
                    //   I18nKeys.inviteFriendsAndSendMessage.tr,
                    //   style: TextStyles.smallThreeColorW500,
                    // ),

                    // // 注意事项
                    // const SizedBox(height: 20),
                    // Text(I18nKeys.importantNotes.tr, style: TextStyles.smallThreeColorW500),
                    // const SizedBox(height: 10),
                    // Text(
                    //   I18nKeys.inviteFriendsAndSendMessage.tr,
                    //   style: TextStyles.smallThreeColorW500,
                    // ),
                  ],
                ),
              ),

              // 底部间距
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  /// 分享卡片：推荐链接 + 邀请码 + 邀请收益入口
  Widget _buildShareCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 18, 15, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── 推荐链接行 ──
          Text(
            I18nKeys.referralLink.tr,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.sixColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          _buildCopyRow(
            valueObs: controller.referralLink,
            isCopiedObs: controller.isCopied,
            onCopy: controller.copyReferralLink,
          ),
          const SizedBox(height: 14),

          // ── 邀请码行 ──
          Text(
            I18nKeys.referralCode.tr,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.sixColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          _buildCopyRow(
            valueObs: controller.inviteCode,
            isCopiedObs: controller.isCopiedCode,
            onCopy: controller.copyInviteCode,
          ),
          const SizedBox(height: 16),

          // ── 社交分享图标 ──
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildShareIcon(ImageAssets.inviteTelegram, controller.shareToTelegram),
              const SizedBox(width: 24),
              _buildShareIcon(ImageAssets.inviteWhatsapp, controller.shareToWhatsApp),
              const SizedBox(width: 24),
              _buildShareIcon(ImageAssets.inviteFacebook, controller.shareToFacebook),
            ],
          ),
          const SizedBox(height: 16),

          // ── 邀请收益按钮 ──
          GestureDetector(
            onTap: controller.goToValidUsersPage,
            child: Container(
              width: double.infinity,
              height: 46,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                '✦  ${I18nKeys.inviteEarnings.tr}  ✦',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 带 Copy 胶囊按钮的输入行
  Widget _buildCopyRow({
    required RxString valueObs,
    required RxBool isCopiedObs,
    required VoidCallback onCopy,
  }) {
    return Obx(() => Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              valueObs.value,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.threeColor,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onCopy,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: isCopiedObs.value
                    ? AppTheme.primaryColor.withValues(alpha: 0.6)
                    : AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isCopiedObs.value ? I18nKeys.copied.tr : I18nKeys.copy.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  /// 社交分享图标按钮
  Widget _buildShareIcon(String asset, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(asset, width: 34, height: 34),
    );
  }

  // 构建奖励网格视图
  Widget _buildRewardTable() {
    final rewardList = controller.boxProducts();

    // 奖励网格
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // 4列网格
        crossAxisSpacing: 20,
        mainAxisSpacing: 5,
        childAspectRatio: 0.7, // 控制单元格宽高比
      ),
      itemCount: rewardList.length, // 总行数 * 列数
      itemBuilder: (context, index) {
        return Column(
          children: [
            GestureDetector(
              onTap: rewardList[index].isCanReceived == true
                  ? () => controller.receiveBoxProduct(index)
                  : null,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: rewardList[index].isCanReceived == true
                      ? const Color(0xFFFCEBC7)
                      : const Color(0xFFE9F0FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Image.asset(
                  rewardList[index].isCanReceived == true
                      ? ImageAssets.inviteBoxAble
                      : ImageAssets.inviteBoxUnAble,
                  width: 44,
                  height: 31,
                ),
              ),
            ),

            const SizedBox(height: 7),
            Text(
              '${rewardList[index].points ?? 0}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.threeColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    );
  }

  // 构建条件项
  Widget _buildConditionItem(String text) {
    return Row(
      children: [
        Icon(Icons.check_circle, size: 16, color: Colors.green.shade600),
        const SizedBox(width: 8),
        Text(text, style: TextStyles.smallThreeColorW500),
      ],
    );
  }
}
