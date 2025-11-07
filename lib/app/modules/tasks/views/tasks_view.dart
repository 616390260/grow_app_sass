import 'package:do_task_project/app/core/constants/image_assets.dart';
import 'package:do_task_project/app/core/theme/app_theme.dart';
import 'package:do_task_project/app/data/models/home_info_model.dart';
import 'package:do_task_project/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../controllers/tasks_controller.dart';
import '../../../core/base/base_view.dart';
import 'package:do_task_project/app/core/i18n/i18n_keys.dart';

class TasksView extends BaseView<TasksController> {
  const TasksView({Key? key}) : super(key: key);

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF477DF2),
      elevation: 0,
      title: Text(
        I18nKeys.taskCenter.tr,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget buildContent(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.2, 0.4, 0.8],
          colors: [Color(0xFF477DF2), Color(0xFF47ABF2), Color(0xFFF9F9F9)],
        ),
      ),
      child: Stack(
        children: [
          // 主内容区域
          Positioned(
            top: 16,
            left: 15,
            right: 15,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // 任务列表
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 标题
                        Padding(
                          padding: const EdgeInsets.only(top: 12, left: 17),
                          child: Text(
                            I18nKeys.whatsapp.tr,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.threeColor,
                            ),
                          ),
                        ),
                        // 任务列表
                        Obx(() {
                          return ListView.builder(
                            padding: EdgeInsets.only(
                              left: 14,
                              right: 14,
                              top: 3,
                              bottom: 19,
                            ),
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: controller.tasks.length,
                            itemBuilder: (context, index) {
                              final task = controller.tasks[index];
                              return TaskCard(
                                titleKey: task.title??I18nKeys.taskTitle,
                                descriptionKey: task.description??I18nKeys.taskDescription,
                                onStartTask: () => _startTask(task),
                              );
                            },
                          );
                        }),
                      ],
                    ),
                  ),

                  // 底部提示文本
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Text(
                      I18nKeys.taskNote.tr,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.threeColor,
                      ),
                      textAlign: TextAlign.left,
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

  void _startTask(RecommendTaskModel task) {
    // 这里可以实现任务开始的逻辑
    Get.toNamed(Routes.whatsappTask, arguments: task.id);
  }
}

// 任务卡片组件
class TaskCard extends StatelessWidget {
  final String titleKey;
  final String descriptionKey;
  final VoidCallback onStartTask;

  const TaskCard({
    Key? key,
    required this.titleKey,
    required this.descriptionKey,
    required this.onStartTask,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.bgColor,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 左侧任务信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 任务图标和标题
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B00),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Image.asset(
                        ImageAssets.homeTask,
                        width: 18,
                        height: 18,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            titleKey.tr,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.threeColor,
                            ),
                          ),
                          Text(
                            descriptionKey.tr,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppTheme.nineColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 11),
                    // 右侧开始任务按钮
                    GestureDetector(
                      onTap: onStartTask,
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          I18nKeys.startTask.tr,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
