import 'package:do_task_project/app/core/constants/image_assets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/smart_controller.dart';
import '../../../core/base/base_view.dart';
import 'package:do_task_project/app/core/widgets/localized_app_bar.dart';
import 'package:do_task_project/app/core/i18n/i18n_keys.dart';
import 'package:do_task_project/app/core/theme/app_theme.dart';
import 'package:do_task_project/app/domain/entities/customer_service.dart';

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
            Expanded(
              child: Container(
                    padding: const EdgeInsets.only(left: 17, right: 13, top: 11),
                    child: ListView.builder(
                      itemCount: controller.customerServices.length,
                      itemBuilder: (context, index) {
                        final service = controller.customerServices[index];
                        return _buildServiceButton(
                          imagePath: service.icon ?? '',
                          title: service.name ?? '',
                          onPressed: () {
                            // 这里可以添加点击客服项的处理逻辑
                            // 例如打开链接或显示详细信息
                            if (service.link != null &&
                                service.link!.isNotEmpty) {
                              // 可以使用url_launcher打开链接
                              // launchUrl(Uri.parse(service.link!));
                              controller.onJoinTelegram(service.link??'');
                            }
                          },
                        );
                      },
                    ),
                  )
            ),
            // 底部功能区
            // Expanded(
            //   child: Container(
            //     padding: const EdgeInsets.only(left: 17, right: 13, top: 11),
            //     child: Column(
            //       children: [
            // Telegram群组按钮
            // _buildServiceButton(
            //   imagePath: ImageAssets.inviteTelegram,
            //   title: I18nKeys.telegramGroup.tr,
            //   onPressed: controller.onJoinTelegram,
            // ),
            // const SizedBox(height: 15),
            // _buildServiceButton(
            //   imagePath: ImageAssets.serviceGuide,
            //   title: I18nKeys.platformGuide.tr,
            //   onPressed: controller.onPlatformGuide,
            //   isGuide: true,
            // ),
            // const SizedBox(height: 15),
            // 客服列表标题
            // Align(
            //   alignment: Alignment.centerLeft,
            //   child: Text(
            //     I18nKeys.customerServiceListTitle.tr,
            //     style: const TextStyle(
            //       fontSize: 16,
            //       fontWeight: FontWeight.bold,
            //       color: AppTheme.threeColor,
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 10),
            // 客服列表

            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  /// 构建客服卡片
  Widget _buildServiceCard(CustomerService service) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题
            if (service.title != null && service.title!.isNotEmpty)
              Text(
                service.title!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (service.title != null && service.title!.isNotEmpty)
              const SizedBox(height: 8),

            // 描述
            if (service.description != null && service.description!.isNotEmpty)
              Text(
                service.description!,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            if (service.description != null && service.description!.isNotEmpty)
              const SizedBox(height: 12),

            // 联系方式
            Row(
              children: [
                Icon(Icons.link, size: 16, color: AppTheme.primaryColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    service.link ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.primaryColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 类型
            if (service.type != null && service.type!.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  service.type!,
                  style: TextStyle(fontSize: 12, color: AppTheme.primaryColor),
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
                Image.network(imagePath, width: 30, height: 30,errorBuilder: (context, error, stackTrace) => Image.asset(ImageAssets.inviteTelegram, width: 30, height: 30),),
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
