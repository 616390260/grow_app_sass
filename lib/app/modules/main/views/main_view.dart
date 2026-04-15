import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/base/base_view.dart';
import '../../../core/services/tenant_service.dart';
import '../controllers/main_controller.dart';
import '../../home/views/widgets/bottom_navigation_widget.dart';
import '../../home/views/home_view.dart';
import '../../home/views/workgo_home_view.dart';
import '../../home/views/darkgold_home_view.dart';
import '../../promotion/views/promotion_view.dart';
import '../../tasks/views/tasks_view.dart';
import '../../activities/views/activities_view.dart';
import '../../smart/views/smart_view.dart';
import '../../account/views/account_view.dart';

/// 根据租户配置的 homeTemplateCode 返回对应首页
Widget _buildHomeView() {
  try {
    final code = TenantService.to.homeTemplateCode;
    switch (code) {
      case 'home_classic_blue':
        return const WorkgoHomeView();
      case 'home_dark_gold':
        return const DarkGoldHomeView();
      case 'home_minimal_green':
      default:
        return const HomeView();
    }
  } catch (_) {
    return const HomeView();
  }
}

class MainView extends BaseView<MainController> {
  const MainView({super.key});

  @override
  Widget buildContent(BuildContext context) {
    final showActivities = TenantService.to.activityEnabled;
    return Obx(() => IndexedStack(
          index: controller.currentTabIndex.value,
          children: [
            _buildHomeView(),
            PromotionView(),
            TasksView(),
            if (showActivities) ActivitiesView(),
            SmartView(),
            AccountView(),
          ],
        ));
  }

  @override
  Widget? buildBottomNavigationBar(BuildContext context) {
    final isDarkGold = TenantService.to.homeTemplateCode == 'home_dark_gold';
    return Obx(() {
      if (!isDarkGold) {
        return BottomNavigationWidget(
          currentIndex: controller.currentTabIndex.value,
          onTap: controller.onTabChanged,
        );
      }
      final nav = BottomNavigationWidget(
        currentIndex: controller.currentTabIndex.value,
        onTap: controller.onTabChanged,
        transparent: true,
        activeColor: const Color(0xFFE8C779),
        inactiveIconColor: const Color(0xFF888888),
        inactiveLabelColor: const Color(0xFF999999),
      );
      // 黑金模式：毛玻璃底部导航
      return ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E).withValues(alpha: 0.75),
              border: const Border(
                top: BorderSide(color: Color(0x33E8C779), width: 0.5),
              ),
            ),
            child: nav,
          ),
        ),
      );
    });
  }
}