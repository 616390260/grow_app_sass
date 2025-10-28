import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/tasks_controller.dart';
import '../../../core/base/base_view.dart';
import 'package:do_task_project/app/core/widgets/localized_app_bar.dart';
import 'package:do_task_project/app/core/i18n/i18n_keys.dart';

class TasksView extends BaseView<TasksController> {
  const TasksView({Key? key}) : super(key: key);

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return const LocalizedAppBar(titleKey: I18nKeys.tasks);
  }

  @override
  Widget buildContent(BuildContext context) {
    return Center(
      child: Text(I18nKeys.tasksPage.tr, style: const TextStyle(fontSize: 24)),
    );
  }
}
