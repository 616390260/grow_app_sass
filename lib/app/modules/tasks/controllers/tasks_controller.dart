import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/i18n/i18n_keys.dart';

class TasksController extends BaseController {
  final tasks = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    // 懒加载：不在这里自动加载数据，等待tab切换时由MainController加载
  }

  void loadTasks() async {
    try {
      setLoading(true);
      
      await Future.delayed(const Duration(milliseconds: 500));
      // 模拟任务数据
      final taskData = [
        {
          'id': '1',
          'titleKey': I18nKeys.autoPointsTaskNo1Title,
          'descriptionKey': I18nKeys.taskNo1Description,
          'points': '80-120',
          'status': 'available',
        },
        {
          'id': '2',
          'titleKey': I18nKeys.autoPointsTaskNo2Title,
          'descriptionKey': I18nKeys.taskNo2Description,
          'points': '30-80',
          'status': 'available',
        },
      ];
      
      tasks.value = taskData;
      setSuccess();
    } catch (e) {
      setError('加载任务失败: $e');
      showErrorMessage('加载任务失败: $e');
    } finally {
      setLoading(false);
    }
  }
}