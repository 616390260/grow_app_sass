import 'package:do_task_project/app/core/constants/image_assets.dart';
import 'package:do_task_project/app/core/theme/app_theme.dart';
import 'package:do_task_project/app/modules/invite_friend/components/decorated_title.dart';
import 'package:do_task_project/app/modules/promotion/components/highlight_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/promotion_controller.dart';
import '../../../core/base/base_view.dart';
import 'package:do_task_project/app/core/widgets/localized_app_bar.dart';
import 'package:do_task_project/app/core/i18n/i18n_keys.dart';
import 'package:flutter/services.dart';

class PromotionView extends BaseView<PromotionController> {
  const PromotionView({Key? key}) : super(key: key);

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return LocalizedAppBar(
      titleKey: I18nKeys.cashReward,
      backgroundColor: Color(0xFF477DF2),
      foregroundColor: Colors.white,
    );
  }

  @override
  Widget buildContent(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.2, 0.3],
            colors: [Color(0xFF477DF2), Color(0xFF47ABF2), Color(0xFFF9F9F9)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 现金奖励横幅
            _buildCashRewardBanner(),

            // 推荐链接和推荐码部分
            _buildReferralSection(),
            const SizedBox(height: 15),
            // 邀请收益统计部分
            _buildIncomeStatistics(),

            // 奖励领取部分
            _buildRewardClaim(),

            // 分享链接部分
            _buildShareLinks(),
const SizedBox(height: 15),
            // 活动规则部分
            _buildActivityRules(),

            // 底部间距
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // 现金奖励横幅
  Widget _buildCashRewardBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 18),
      child: Column(
        children: [
          Text(
            I18nKeys.inviteNewUserGetReward.tr,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            I18nKeys.cashRewardTitle.tr,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w800,
            ),
          ),

          Align(
            alignment: Alignment.centerRight,
            child: Image.asset(ImageAssets.rewardBg, width: 265, height: 199),
          ),
        ],
      ),
    );
  }

  // 推荐链接和推荐码部分
  Widget _buildReferralSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 推荐链接
          Text(
            I18nKeys.referralLink.tr,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.threeColor,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.f9f9f9Color,
                    border: Border.all(
                      color: AppTheme.primaryColor,
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => Text(
                            controller.inviteUrl.value,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppTheme.threeColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () async {
                          await Clipboard.setData(
                            ClipboardData(text: controller.inviteUrl.value),
                          );
                          Get.snackbar(I18nKeys.tip.tr, I18nKeys.copiedToClipboard.tr);
                        },
                        child: Text(
                          I18nKeys.copy.tr,
                          style: const TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 推荐码
          Text(
            I18nKeys.referralCode.tr,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.threeColor,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.f9f9f9Color,
                    border: Border.all(
                      color: AppTheme.primaryColor,
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => Text(
                            controller.inviteCode.value,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppTheme.threeColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () async {
                          await Clipboard.setData(
                            ClipboardData(text: controller.inviteCode.value),
                          );
                          Get.snackbar(I18nKeys.tip.tr, I18nKeys.copiedToClipboard.tr);
                        },
                        child: Text(
                          I18nKeys.copy.tr,
                          style: const TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
        ],
      ),
    );
  }

  // 邀请收益统计部分
  Widget _buildStatisticItem(String title, Widget value) {
    return Expanded(
      child: Container(
        height: 76,
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppTheme.e3e3e3Color,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
               Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF666666),
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
            value,
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeStatistics() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 4),
          DecoratedTitle(
           title:  I18nKeys.inviteEarnings.tr,
          ),
          const SizedBox(height: 22),

          // 收益统计 - 三个一列
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatisticItem(
                I18nKeys.totalCommission.tr,
                Obx(
                  () => Text(
                    controller.totalCommission.value.toStringAsFixed(0),
                    style: const TextStyle(
                      color: AppTheme.threeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              _buildStatisticItem(
                I18nKeys.todayCommission.tr,
                Obx(
                  () => Text(
                    controller.todayCommission.value.toStringAsFixed(0),
                    style: const TextStyle(
                      color: AppTheme.threeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              _buildStatisticItem(
                I18nKeys.yesterdayCommission.tr,
                Obx(
                  () => Text(
                    controller.yesterdayCommission.value.toStringAsFixed(0),
                    style: const TextStyle(
                      color: AppTheme.threeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

          // 活跃人数统计 - 三个一列
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatisticItem(
                I18nKeys.activeUsers.tr,
                Obx(
                  () => Text(
                    controller.activeUsers.value.toString(),
                    style: const TextStyle(
                      color: AppTheme.threeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              _buildStatisticItem(
                I18nKeys.todayNewSubordinates.tr,
                Obx(
                  () => Text(
                    controller.todayNewSubordinates.value.toString(),
                    style: const TextStyle(
                      color: AppTheme.threeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              _buildStatisticItem(
                I18nKeys.directActiveUsers.tr,
                Obx(
                  () => Text(
                    controller.activeSubordinates.value.toString(),
                    style: const TextStyle(
                      color: AppTheme.threeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 奖励领取部分
  Widget _buildRewardClaim() {
    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
            width: 3,
            height: 13,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            I18nKeys.inviteSubordinatesReachLevel2Reward.tr,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
            ],
          ),  
          const SizedBox(height: 17),
          Obx(
            () => Text(
              I18nKeys.currentReachLevel2RewardPoints.tr.replaceFirst('%s', controller.reachTwoStarUsers.value.toString()).replaceFirst('%s', controller.twoStarRewardPoints.value.toString()),
              style: const TextStyle(fontSize: 12, color:AppTheme.threeColor),
            ),
          ),
          const SizedBox(height: 17),
          Align(
            alignment: Alignment.center,
            child: Obx(() {
              bool hasReceived = controller.isReceived.value;
              
              return GestureDetector(
                onTap: hasReceived ? () {
                  // TODO: 实现领取奖励的逻辑
                  controller.receiveReward();
                } : null,
                child: Container(
                  alignment: Alignment.center,
                  height: 40,
                  width: 170,
                  margin: EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                    gradient: hasReceived ? LinearGradient(
                      colors: [Color(0xFF477DF2), Color(0xFF47B9F2)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ) : null,
                    color: !hasReceived ? Color(0xFFE0E0E0) : null,
                    borderRadius: BorderRadius.circular(20),
                  ),
                child: Text(
                    I18nKeys.claim.tr ,
                    style: TextStyle(
                      color:  Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ),
            );
            }),
          ),

        ],
      ),
    );
  }

  // 分享链接部分
  Widget _buildShareLinks() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DecoratedTitle(title: I18nKeys.shareToEarn.tr),
          const SizedBox(height: 25),

          // 社交分享按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSocialButton(ImageAssets.inviteTelegram),
              _buildSocialButton(ImageAssets.inviteWhatsapp),
              _buildSocialButton(ImageAssets.inviteFacebook),
            ],
          ),
        ],
      ),
    );
  }

  // 社交分享按钮
  Widget _buildSocialButton(String imagePath) {
    return GestureDetector(
      onTap: () {
        // 根据图片路径判断是哪个社交平台
        if (imagePath == ImageAssets.inviteTelegram) {
          controller.shareToTelegram();
        } else if (imagePath == ImageAssets.inviteWhatsapp) {
          controller.shareToWhatsApp();
        } else if (imagePath == ImageAssets.inviteFacebook) {
          controller.shareToFacebook();
        }
      },
      child: Image.asset(imagePath, width: 30, height: 30,),
    );
  }

  // 活动规则部分
  Widget _buildActivityRules() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 活动规则标题
          Center(
            child: DecoratedTitle(title: I18nKeys.activityRules.tr),
          ),
          const SizedBox(height: 20),

          // 邀请步骤
          HighlightText(text: I18nKeys.invitationSteps.tr,),
          const SizedBox(height: 17),
          _buildRuleItem(I18nKeys.invitationStep1.tr),
          _buildRuleItem(I18nKeys.invitationStep2.tr),
          _buildRuleItem(I18nKeys.invitationStep3.tr),

          const SizedBox(height: 30),

          // 奖励计算方式
          HighlightText(text: I18nKeys.commissionCalculationMethod.tr,),
          const SizedBox(height: 17),
          _buildRuleItem(I18nKeys.directInvitationRule.tr),
          _buildRuleItem(I18nKeys.secondaryInvitationRule.tr),
        ],
      ),
    );
  }

  // 规则项
  Widget _buildRuleItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: AppTheme.sixColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
