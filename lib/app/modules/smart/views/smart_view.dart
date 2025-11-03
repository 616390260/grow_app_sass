import 'package:do_task_project/app/core/constants/image_assets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/smart_controller.dart';
import '../../../core/base/base_view.dart';
import 'package:do_task_project/app/core/widgets/localized_app_bar.dart';
import 'package:do_task_project/app/core/i18n/i18n_keys.dart';
import 'package:do_task_project/app/core/theme/app_theme.dart';

class SmartView extends BaseView<SmartController> {
  const SmartView({Key? key}) : super(key: key);

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return LocalizedAppBar(
      titleKey: I18nKeys.customerServiceTitle,
      backgroundColor: AppTheme.primaryColor,
      foregroundColor: Colors.white,
    );
  }

  @override
  Widget buildContent(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppTheme.primaryColor, Color(0xFF47ABF2), Color(0xFFF9F9F9)],
          stops: const [0.2, 0.4, 0.8],
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 顶部客服部分
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(ImageAssets.serviceBg, width: 200, height: 162),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 18),
                    Text(
                      I18nKeys.onlineServiceGreeting.tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 11),
                    Text(
                      I18nKeys.contactCustomerService.tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: controller.onConsultNow,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppTheme.primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 17,
                          vertical: 6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        I18nKeys.consultNow.tr,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // 底部功能区
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 17, right: 13, top: 11),
                child: Column(
                  children: [
                    // Telegram群组按钮
                    _buildServiceButton(
                      imagePath: ImageAssets.inviteTelegram,
                      title: I18nKeys.telegramGroup.tr,
                      onPressed: controller.onJoinTelegram,
                    ),
                    const SizedBox(height: 15),
                    _buildServiceButton(
                      imagePath: ImageAssets.inviteTelegram,
                      title: I18nKeys.telegramGroup.tr,
                      onPressed: controller.onJoinTelegram,
                    ),
                    const SizedBox(height: 15),
                    _buildServiceButton(
                      imagePath: ImageAssets.serviceGuide,
                      title: I18nKeys.platformGuide.tr,
                      onPressed: controller.onPlatformGuide,
                      isGuide: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceButton({
    required String imagePath,
    required String title,
    required VoidCallback onPressed,
    bool isGuide = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.all(16),
          alignment: Alignment.centerLeft,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(imagePath, width: 30, height: 30),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.threeColor,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: onPressed,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Text(
                  isGuide ? I18nKeys.clickHere.tr : I18nKeys.joinNow.tr,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
