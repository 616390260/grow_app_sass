import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/base/base_view.dart';
import '../controllers/main_controller.dart';
import '../../home/views/widgets/bottom_navigation_widget.dart';
import '../../home/views/home_view.dart';
import '../../promotion/views/promotion_view.dart';
import '../../tasks/views/tasks_view.dart';
import '../../smart/views/smart_view.dart';
import '../../account/views/account_view.dart';

class MainView extends BaseView<MainController> {
  const MainView({super.key});

  @override
  Widget buildContent(BuildContext context) {
    return Obx(() => IndexedStack(
          index: controller.currentTabIndex.value,
          children: [
            HomeView(),
            PromotionView(),
            TasksView(),
            SmartView(),
            AccountView(),
          ],
        ));
  }

  @override
  Widget? buildBottomNavigationBar(BuildContext context) {
    return Obx(() => BottomNavigationWidget(
          currentIndex: controller.currentTabIndex.value,
          onTap: controller.onTabChanged,
        ));
  }
}