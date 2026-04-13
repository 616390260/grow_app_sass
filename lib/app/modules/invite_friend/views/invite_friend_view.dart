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
            const Color(0xFF4CAF50),
            const Color(0xFF81C784),
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

              // 推荐链接部分
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      I18nKeys.referralLink.tr,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.threeColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppTheme.primaryColor,
                          width: 0.5,
                        ),
                        color: AppTheme.f9f9f9Color,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 15,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              controller.referralLink.value,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.threeColor,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Obx(
                            () => InkWell(
                              onTap: controller.copyReferralLink,
                              child: Text(
                                controller.isCopied.value
                                    ? I18nKeys.copied.tr
                                    : I18nKeys.copy.tr,
                                style: TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 分享说明
                    const SizedBox(height: 17),
                    Center(
                      child: Text(
                        I18nKeys.shareToSocialApps.tr,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.sixColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    // 社交媒体分享按钮
                    const SizedBox(height: 17),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () => controller.shareToTelegram(),
                          child: Image.asset(
                            ImageAssets.inviteTelegram,
                            width: 30,
                            height: 30,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => controller.shareToWhatsApp(),
                          child: Image.asset(
                            ImageAssets.inviteWhatsapp,
                            width: 30,
                            height: 30,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => controller.shareToFacebook(),
                          child: Image.asset(
                            ImageAssets.inviteFacebook,
                            width: 30,
                            height: 30,
                          ),
                        ),
                        // 可以添加更多分享按钮
                      ],
                    ),
                  ],
                ),
              ),

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
                      : const Color(0xFFE8F5E9),
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
