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
    return const LocalizedAppBar(
      titleKey: '现金奖励',
      backgroundColor: Color(0xFF477DF2),
      foregroundColor: Colors.white,
    );
  }

  @override
  Widget buildContent(BuildContext context) {
    // 加载推广数据
    controller.loadData();
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
          const Text(
            '每邀请一个新用户成功后，即可获得',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            '现金奖励',
            style: TextStyle(
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
          const Text(
            '推荐链接',
            style: TextStyle(
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
                        child: Text(
                          'https://www.blank.com',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppTheme.threeColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () async {
                          await Clipboard.setData(
                            const ClipboardData(text: 'https://www.blank.com'),
                          );
                          Get.snackbar('提示', '链接已复制');
                        },
                        child: const Text(
                          '复制',
                          style: TextStyle(
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
          const Text(
            '推荐码',
            style: TextStyle(
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
                        child: Text(
                          'NHA45TPH',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppTheme.threeColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () async {
                          await Clipboard.setData(
                            const ClipboardData(text: 'https://www.blank.com'),
                          );
                          Get.snackbar('提示', '链接已复制');
                        },
                        child: const Text(
                          '复制',
                          style: TextStyle(
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
        padding: const EdgeInsets.all(8),
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
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Color(0xFF666666),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 20),
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
          const DecoratedTitle(
           title:  '邀请收益',
          ),
          const SizedBox(height: 22),

          // 收益统计 - 三个一列
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatisticItem(
                '累计佣金',
                Obx(
                  () => Text(
                    controller.promotionCount.toString(),
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
                '今日佣金',
                const Text(
                  '0',
                  style: const TextStyle(
                      color: AppTheme.threeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                ),
              ),
              const SizedBox(width: 15),
              _buildStatisticItem(
                '当日收益',
                Obx(
                  () => Text(
                    '\$${controller.promotionEarnings.toStringAsFixed(2)}',
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
                '活跃人数',
                const Text(
                  '0',
                  style: const TextStyle(
                    color: AppTheme.threeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              _buildStatisticItem(
                '今日新增',
                const Text(
                  '0',
                  style: const TextStyle(
                    color: AppTheme.threeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              _buildStatisticItem(
                '直接活跃人数',
                const Text(
                  '0',
                  style: const TextStyle(
                    color: AppTheme.threeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
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
          const Text(
            '邀请直属下级达到2级用户，可奖励积分',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
            ],
          ),  
          const SizedBox(height: 17),
          const Text(
            '当前已有0个下级达到2级，可奖励300-500积分',
            style: TextStyle(fontSize: 12, color:AppTheme.threeColor),
          ),
          const SizedBox(height: 17),
          Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                Get.snackbar('提示', '暂无可领取的奖励');
              },
              child: Container(
                alignment: Alignment.center,
                height: 40,
                width: 170,
                margin: EdgeInsets.only(bottom: 5),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF477DF2), Color(0xFF47B9F2)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('领取', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),),
              ),
            ),
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
          DecoratedTitle(title: '分享赚钱'),
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
    return Image.asset(imagePath, width: 30, height: 30,);
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
            child: DecoratedTitle(title: '活动规则'),
          ),
          const SizedBox(height: 20),

          // 邀请步骤
          const HighlightText(text: '邀请步骤',),
          const SizedBox(height: 17),
          _buildRuleItem('1.点击"复制"按钮，复制推荐链接或复制分享方式。'),
          _buildRuleItem('2.将复制好的链接发送，并邀请合作伙伴分享给你的链接。'),
          _buildRuleItem('3.你的朋友通过完整任务获得额外奖励。'),

          const SizedBox(height: 30),

          // 奖励计算方式
          const HighlightText(text: '返佣计算方式',),
          const SizedBox(height: 17),
          _buildRuleItem('一、直接邀请：您的直接邀请码注册用户称为"直属下线"，完成指定任务后，您将获得100-300积分。'),
          _buildRuleItem('二、二级邀请：您的直属下线邀请的用户称为"二级下线"，完成指定任务后，您将获得50-150积分。'),
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
