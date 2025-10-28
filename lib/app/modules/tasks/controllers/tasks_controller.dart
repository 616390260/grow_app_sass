import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/managers/api_call_manager.dart';
import '../../../core/utils/api_result.dart';

class TasksController extends BaseController {
  final tasks = <Map<String, dynamic>>[].obs;

  // API调用管理器
  final _apiCallManager = ApiCallManager();

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  void loadTasks() async {
    setLoading(true);
    final result = await _apiCallManager.call<List<Map<String, dynamic>>>(
      apiCall: () async {
        await Future.delayed(const Duration(milliseconds: 500));
        // 模拟任务数据
        final taskData = [
          {
            'id': '1',
            'title': '自动积分任务 NO.1',
            'description': '关联账户广告时间段 80-120 积分',
            'points': '80-120',
            'status': 'available',
          },
          {
            'id': '2',
            'title': '自动积分任务 NO.2',
            'description': '发送推荐链接 30-80 积分',
            'points': '30-80',
            'status': 'available',
          },
        ];
        return ApiResult.success(data: taskData);
      },
      showLoading: false,
    );
    
    if (result.isSuccess) {
      tasks.value = result.data ?? [];
      setSuccess();
    } else {
      setError(result.message);
    }
  }
}