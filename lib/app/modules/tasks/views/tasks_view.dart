import 'package:do_task_project/app/core/constants/image_assets.dart';
import 'package:do_task_project/app/core/theme/app_theme.dart';
import 'package:do_task_project/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../controllers/tasks_controller.dart';
import '../../../core/base/base_view.dart';
import 'package:do_task_project/app/core/i18n/i18n_keys.dart';

class TasksView extends BaseView<TasksController> {
  TasksView({Key? key}) : super(key: key);

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF477DF2),
      elevation: 0,
      title: Text(
        '任务中心',
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
    // 加载任务数据
    if (controller.tasks.isEmpty) {
      controller.loadTasks();
    }

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.2, 0.4, 0.8],
          colors: [Color(0xFF477DF2), Color(0xFF47ABF2), Color(0xFFF9F9F9)],
        ),
      ),
      padding: const EdgeInsets.only(top: 16, left: 15, right: 15, bottom: 20),
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
                      '任务列表',
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
                          title: task.title ?? '',
                          description: task.description ?? '',
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
    );
  }



  void _startTask(dynamic task) {
    // 这里可以实现任务开始的逻辑
    Get.toNamed(Routes.WHATSAPP_TASK, arguments: task.id);
  }
}

// 任务卡片组件
class TaskCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onStartTask;

  const TaskCard({
    Key? key,
    required this.title,
    required this.description,
    required this.onStartTask,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppTheme.bgColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 任务图标
          Container(
            width: 32,
            height: 32,
            padding: const EdgeInsets.all(6),
            margin: const EdgeInsets.only(left: 13, top: 11),
            decoration: BoxDecoration(
              color: const Color(0xFFFF8E6A),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Image.asset(ImageAssets.homeTask, width: 14, height: 14),
          ),
          const SizedBox(width: 14),
          // 任务信息
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.threeColor,
                    ),
                  ),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.nineColor,
                    ),
                  ),
                ],
              ),
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
                '开始任务',
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
    );
  }
}
