import 'package:do_task_project/app/core/base/base_view.dart';
import 'package:do_task_project/app/core/constants/image_assets.dart';
import 'package:do_task_project/app/core/i18n/i18n_keys.dart';
import 'package:do_task_project/app/core/theme/app_theme.dart';
import 'package:do_task_project/app/modules/home/controllers/home_controller.dart';
import 'package:do_task_project/app/modules/home/views/widgets/banner_carousel_widget.dart';
import 'package:do_task_project/app/modules/home/views/widgets/feature_card_widget.dart';
import 'package:do_task_project/app/modules/home/views/widgets/task_card_widget.dart';
import 'package:do_task_project/app/modules/vip_details/components/vip_badge.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HomeView extends BaseView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  bool get enableRefresh => true;

  @override
  Color? get backgroundColor => null;

  @override
  Widget buildContent(BuildContext context) {
    // 设置沉浸式状态栏
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF477DF2), // #477DF2
            Color(0xFF47ABF2), // #47ABF2
            Color(0xFFF2F5FA), // #F2F5FA
          ],
          stops: [0.0, 0.2, 0.4],
        ),
      ),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // 添加状态栏高度的间距
            SizedBox(height: MediaQuery.of(context).padding.top),
            _buildHeader(),
            _buildStatisticsCards(),
            // 使用Obx包装BannerCarouselWidget以响应数据变化
            Obx(() {
              return BannerCarouselWidget(
                bannerImages: controller.announcements
                    .map((banner) => banner.image ?? '')
                    .where((image) => image.isNotEmpty)
                    .toList(),
                onBannerTap: (index) {
                  controller.onBannerTap(index);
                },
              );
            }),
            _buildRecommendedTasks(),
            const SizedBox(height: 55),
          ],
        ),
      ),
    );
  }

  /// 构建头部信息
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
      child: Row(
        children: [
          // 应用图标
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(ImageAssets.logo, width: 24, height: 24),
          ),
          const SizedBox(width: 14),
          // 应用名称
          GestureDetector(
            onTap: controller.onVipDetailsTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  I18nKeys.appTitle.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Obx(
                  () => VipBadge(
                    text: controller.vipLevel.value.isEmpty
                        ? 'VIP0'
                        : controller.vipLevel.value,
                    textBackgroundColor: const Color(0xFFA7C3FF),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          if (kIsWeb) ...[
            // 下载APP按钮
            GestureDetector(
              onTap: controller.onDownloadAppTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(ImageAssets.homeDownload, width: 14, height: 14),
                    const SizedBox(width: 2),
                    Text(
                      I18nKeys.downloadApp.tr,
                      style: const TextStyle(
                        color: AppTheme.loginColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        
        ],
      ),
    );
  }

  /// 构建统计卡片
  Widget _buildStatisticsCards() {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
      padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // 顶部三项统计
          Obx(
            () => Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        controller.accountBalance.value.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.threeColor,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        I18nKeys.accountBalance.tr,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.nineColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        controller.dailyEarnings.value.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.threeColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        I18nKeys.todayEarnings.tr,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.nineColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        controller.promotionEarnings.value.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.threeColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        I18nKeys.todayPromotionEarnings.tr,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.nineColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 21),
          // 下方两项快捷功能
          Row(
            children: [
              Expanded(
                child: FeatureCardWidget(
                  title: 'lucky_wheel'.tr,
                  iconPath: ImageAssets.homeWheel,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFCEDEFF), Color(0xFFF0F5FF)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  onTap: controller.onLuckyWheelTap,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: FeatureCardWidget(
                  title: 'sign_in_calendar'.tr,
                  iconPath: ImageAssets.homeSign,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFDFD5), Color(0xFFFFF6F3)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  onTap: controller.onSignInCalendarTap,
                ),
              ),
            ],
          ),
          if (!kIsWeb) ...[
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: FeatureCardWidget(
                    title: I18nKeys.callCenter.tr,
                    iconPath: ImageAssets.homePhone,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFA6EFD1), Color(0xFFE2FAF1)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    onTap: controller.onCallCenterTap,
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: FeatureCardWidget(
                    title: I18nKeys.inviteFriend.tr,
                    iconPath: ImageAssets.homeInvite,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFE4C0), Color(0xFFFFF2E0)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    onTap: controller.onInviteFriendTap,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// 构建推荐任务
  Widget _buildRecommendedTasks() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: EdgeInsets.only(left: 12, top: 17, right: 14, bottom: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            I18nKeys.recommendedTasks.tr,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppTheme.threeColor,
            ),
          ),
          const SizedBox(height: 13),
          // 使用Obx包装ListView以响应数据变化
          Obx(() {
            return ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.recommendTasks.length,
              itemBuilder: (context, index) {
                final task = controller.recommendTasks[index];
                return TaskCardWidget(
                  title: task.title ?? '',
                  description: task.description ?? '',
                  buttonText: I18nKeys.startTask.tr,
                  onTap: () => controller.onRecommendTaskTap(index),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
