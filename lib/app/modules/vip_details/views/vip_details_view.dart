import 'package:do_task_project/app/core/theme/app_theme.dart';
import 'package:do_task_project/app/modules/vip_details/components/vip_badge.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/base/base_view.dart';
import '../../../core/i18n/i18n_keys.dart';
import '../controllers/vip_details_controller.dart';

class VipDetailsView extends ScrollableBaseView<VipDetailsController> {
  const VipDetailsView({Key? key}) : super(key: key);

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.primaryColor,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: controller.onBackPress,
      ),
      title: Text(
        I18nKeys.vipDetails.tr,
        style: TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Widget buildScrollableContent(BuildContext context) {
    return Stack(
      children: [
        // 36-40行在同一个布局（下层）
        Container(
          height: 280, // 设置高度
          decoration: BoxDecoration(color: AppTheme.primaryColor), // 设置背景色
          child: Column(
            children: [_buildVipInfoCard(), _buildPromotionSection()],
          ),
        ),

        // 42-43行单独一个布局在上层
        Column(
          children: [
            SizedBox(height: 242), // 调整高度以避免与下层重叠
            _buildVipRewardsSection(),
          ],
        ),
      ],
    );
  }

  // 构建VIP信息卡片
  Widget _buildVipInfoCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lineColor,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(left: 15, right: 15, top: 12),
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          // VIP等级和余额
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                VipBadge(text: controller.currentVipLevel.value.toString()),
                const SizedBox(width: 9),
                Text(
                  '${I18nKeys.vipBalance.tr}: ${controller.vipBalance.value}',
                  style: TextStyle(
                    color: AppTheme.threeColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // 进度条
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Obx(
                  () => LinearProgressIndicator(
                    value: controller.progressValue.value.clamp(0.0, 1.0),
                    backgroundColor: const Color(0xFFD0DFFF),
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    minHeight: 4,
                    stopIndicatorRadius: 8,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Obx(() => VipBadge(text: controller.currentVipLevel.value.toString())),
            ],
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  // 构建晋升标准和每日重置时间
  Widget _buildPromotionSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppTheme.primaryColor),
      child: Column(
        children: [
          // 晋升标准
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '${I18nKeys.promotionStandard.tr}:',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              const SizedBox(width: 10),
              Obx(
                () => Text(
                  controller.promotionProgress.value,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: controller.onClaimRewardTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF8E6A),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Text(
                    I18nKeys.claimReward.tr,
                    style: TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 推广收益
          Row(
            children: [
              Text(
                '${I18nKeys.promotionIncome.tr}: ',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              Text(
                controller.promotionIncome.value.toString(),
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 每日奖励重置时间
          Row(
            children: [
              Text(
                '${I18nKeys.dailyResetTime.tr} UTC: ',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              Text(
                controller.dailyResetTime.value.toString(),
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 构建VIP奖励列表
  Widget _buildVipRewardsSection() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // 标题
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left: 2, top: 4),
            child: Text(
              I18nKeys.vipRewards.tr,
              style: TextStyle(
                color: AppTheme.threeColor,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // 表头
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    I18nKeys.growthValue.tr,
                    style: const TextStyle(
                      color: AppTheme.threeColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(width: 29),
                Expanded(
                  flex: 3,
                  child: Text(
                    I18nKeys.promotionCommission.tr,
                    style: const TextStyle(
                      color: AppTheme.threeColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    I18nKeys.reward.tr,
                    style: const TextStyle(
                      color: AppTheme.threeColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    I18nKeys.operation.tr,
                    style: const TextStyle(
                      color: AppTheme.threeColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 17),
          // 奖励列表
          Obx(
            () => ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: controller.vipRewards.length,
              itemBuilder: (context, index) {
                final reward = controller.vipRewards[index];
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: VipBadge(text: reward.vipLevel.toString()),
                        ),
                        const SizedBox(width: 29),
                        Expanded(
                          flex: 3,
                          child: Text(
                            reward.promotionPoints.toString(),
                            style: TextStyle(
                              color: AppTheme.threeColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            reward.rewardPoints.toString(),
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(right: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.dddColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              I18nKeys.activated.tr,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 35,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.eeeColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          '${I18nKeys.firstActivation.tr} ${reward.firstRewardPoints} ${I18nKeys.points.tr}',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppTheme.nineColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 11),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
