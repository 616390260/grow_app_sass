import 'package:do_task_project/app/core/constants/image_assets.dart';
import 'package:do_task_project/app/core/theme/app_theme.dart';
import 'package:do_task_project/app/modules/vip_details/components/vip_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'widgets/lucky_wheel_widget.dart';
import 'widgets/sign_in_calendar_widget.dart';
import 'widgets/task_card_widget.dart';
import 'widgets/banner_carousel_widget.dart';
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
            BannerCarouselWidget(
              bannerImages: [
                ImageAssets.homeBanner,
                ImageAssets.homeBanner,
                ImageAssets.homeBanner,
              ],
              onBannerTap: (index) {
                controller.onBannerTap(index);
              },
            ),
            _buildRecommendedTasks(),
            const SizedBox(height: 55),
          ],
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
            child: const Icon(Icons.apps, color: Colors.white, size: 24),
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
              Row(
                children: [
                  Obx(() => VipBadge(text: controller.vipLevel.value.isEmpty ? 'Vip0' : controller.vipLevel.value)),
                  const SizedBox(width: 2),
                  Text(
                    'VIP详情 >',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          ),
          const Spacer(),
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
      ),
    );
  }

  /// 统计 + 快捷功能（与参考图一致合并为同一白卡）
  Widget _buildStatisticsCards() {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
      padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 17),
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
                child: LuckyWheelWidget(onTap: controller.onLuckyWheelTap),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: SignInCalendarWidget(
                  onTap: controller.onSignInCalendarTap,
                ),
              ),
            ],
          ),
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
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _getTaskList().length,
            itemBuilder: (context, index) {
              final task = _getTaskList()[index];
              return TaskCardWidget(
                title: task['title'],
                description: task['description'],
                buttonText: task['buttonText'],
                onTap: () => controller.onTaskCardTap(task['id']),
              );
            },
          ),
        ],
      ),
    );
  }

  /// 获取任务列表数据
  List<Map<String, dynamic>> _getTaskList() {
    return [
      {
        'id': 'task_1',
        'title': I18nKeys.autoPointsTaskNo1.tr,
        'description': I18nKeys.taskDesc1.tr,
        'buttonText': I18nKeys.startTask.tr,
      },
      {
        'id': 'task_2',
        'title': I18nKeys.autoPointsTaskNo1.tr,
        'description': I18nKeys.taskDesc1.tr,
        'buttonText': I18nKeys.startTask.tr,
      },
    ];
  }
}
