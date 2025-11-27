import 'package:do_task_project/app/core/constants/image_assets.dart';
import 'package:do_task_project/app/data/models/vip_model.dart';
import 'package:do_task_project/app/modules/vip_details/components/vip_badge.dart';
import 'package:do_task_project/app/modules/vip_details/controllers/vip_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:do_task_project/app/core/i18n/i18n_keys.dart';
import 'package:do_task_project/app/core/theme/app_theme.dart';

class VipRewardPopup extends StatelessWidget {
  final String resetTime;
  final int promotionIncome;
  final List<VipLevelItemModel> rewardLevels;


  VipRewardPopup({
    Key? key,
    required this.resetTime,
    required this.rewardLevels,
    required this.promotionIncome,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final VipDetailsController controller = Get.find<VipDetailsController>();
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 12,top: 16,  bottom: 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Header with close button
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '${I18nKeys.vipDailyRewardTime.tr}$resetTime',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.threeColor,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () => Get.back(),
                  child: Image.asset(ImageAssets.iconClose, width: 18, height: 18),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Table headers
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    I18nKeys.vipGrowthValue.tr,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.threeColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(width: 29),
                Expanded(
                  flex: 3,
                  child: Text(
                    I18nKeys.vipPromotionCommission.tr,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.threeColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    I18nKeys.vipReward.tr,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.threeColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    I18nKeys.vipOperation.tr,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.threeColor,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),

            // Reward levels
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: rewardLevels.length,
              itemBuilder: (context, index) {
                final reward = rewardLevels[index];
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
                            '${promotionIncome.toString()}/${reward.promotionPoints.toString()}',
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
                          child: reward.isReceived == true 
                            ? Container(
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
                                  I18nKeys.alreadyReceived.tr,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : reward.isActivated == true 
                              ? GestureDetector(
                                  onTap: () {
                                    controller.claimReward(reward.id ?? 0);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(right: 4),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF8E6A),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Text(
                                      I18nKeys.claimReward.tr,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
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
                                    I18nKeys.vipNotActivated.tr,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    // if (reward.firstRewardPoints > 0)
                      // Column(
                      //   children: [
                      //     const SizedBox(height: 8),
                          // Align(
                          //   alignment: Alignment.center,
                          //   child: Container(
                          //     padding: const EdgeInsets.symmetric(
                          //       horizontal: 35,
                          //       vertical: 4,
                          //     ),
                          //     decoration: BoxDecoration(
                          //       color: AppTheme.eeeColor,
                          //       borderRadius: BorderRadius.circular(5),
                          //     ),
                          //     child: Text(
                          //       '${I18nKeys.firstActivation.tr} ${reward.firstRewardPoints} ${I18nKeys.points.tr}',
                          //       style: TextStyle(
                          //         fontSize: 11,
                          //         color: AppTheme.nineColor,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          
                      //   ],
                      // ),
                  ],
                );
              },
            ),
            SizedBox(height: 16),

            // Description
            Text(
              I18nKeys.vipRewardDescription.tr,
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.nineColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
