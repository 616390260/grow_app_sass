import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'widgets/lucky_wheel_widget.dart';
import 'widgets/sign_in_calendar_widget.dart';
import 'widgets/promotion_banner_widget.dart';
import 'widgets/task_card_widget.dart';
import '../../../core/base/base_view.dart';
import 'package:do_task_project/app/core/i18n/i18n_keys.dart';

class HomeView extends BaseView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  bool get enableRefresh => true;

  @override
  Color? get backgroundColor => null;

  @override
  Widget buildContent(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF4A90E2),
            Color(0xFF7BB3F0),
            Color(0xFFF5F7FA),
          ],
          stops: [0.0, 0.3, 1.0],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildHeader(),
              _buildStatisticsCards(),
              const PromotionBannerWidget(),
              _buildRecommendedTasks(),
              const SizedBox(height: 100), // 为底部导航留空间
            ],
          ),
        ),
      ),
    );
  }

  // 移除页面内的底部导航，改由 MainView 统一提供
  @override
  Widget? buildBottomNavigationBar(BuildContext context) => null;

  /// 构建头部
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          // 应用图标
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.apps,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          // 应用名称
          Text(
            I18nKeys.appTitle.tr,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          // 下载APP按钮
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.download,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  I18nKeys.downloadApp.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 统计 + 快捷功能（与参考图一致合并为同一白卡）
  Widget _buildStatisticsCards() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // 顶部三项统计
          Obx(() => Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          controller.accountBalance.value.toString(),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          I18nKeys.accountBalance.tr,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF7F8C8D),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 28,
                    color: const Color(0xFFE5E7EB),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          controller.dailyEarnings.value.toString(),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          I18nKeys.todayEarnings.tr,
                          style: const TextStyle(
                            fontSize: 12,
                            color: const Color(0xFF7F8C8D),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 28,
                    color: const Color(0xFFE5E7EB),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          controller.promotionEarnings.value.toString(),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          I18nKeys.todayPromotionEarnings.tr,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF7F8C8D),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
          const SizedBox(height: 16),
          // 下方两项快捷功能
          Row(
            children: [
              Expanded(child: LuckyWheelWidget(onTap: controller.onLuckyWheelTap)),
               const SizedBox(width: 12),
              Expanded(child: SignInCalendarWidget(onTap: controller.onSignInCalendarTap)),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建推荐任务
  Widget _buildRecommendedTasks() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            I18nKeys.recommendedTasks.tr,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          TaskCardWidget(
            title: I18nKeys.autoPointsTaskNo1.tr,
            description: I18nKeys.taskDesc1.tr,
            buttonText: I18nKeys.startTask.tr,
            onTap: () => controller.onTaskCardTap('task_1'),
          ),
          TaskCardWidget(
            title: I18nKeys.autoPointsTaskNo1.tr,
            description: I18nKeys.taskDesc1.tr,
            buttonText: I18nKeys.startTask.tr,
            onTap: () => controller.onTaskCardTap('task_2'),
          ),
        ],
      ),
    );
  }

}