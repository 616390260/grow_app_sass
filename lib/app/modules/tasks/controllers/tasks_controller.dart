import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/i18n/i18n_keys.dart';
import '../../../data/services/task_center_api_service.dart';
import '../../../data/models/home_info_model.dart';
class TasksController extends BaseController {
  final tasks = <RecommendTaskModel>[].obs;
  final TaskCenterApiService _taskApiService = TaskCenterApiService();
  
  // 分页相关
  final int _limit = 20;
  int _page = 1;
  bool _hasMore = true;
  bool _isLoading = false;

  @override
  void onInit() {
    super.onInit();
    // 懒加载：不在这里自动加载数据，等待tab切换时由MainController加载
  }

  /// 加载任务列表（支持分页）
  Future<void> loadTasks({bool isRefresh = false}) async {
    if (_isLoading) return;
    if (isRefresh) {
      _page = 1;
      _hasMore = true;
    }
    if (!_hasMore && !isRefresh) {
      return;
    }
    _isLoading = true;
    await safeApiCall<TaskListResponse>(
      () => _taskApiService.getTaskList(page: _page, limit: _limit),
      (response) {
        final List<RecommendTaskModel> newTasks = response.records ?? [];
        if (isRefresh) {
          tasks.value = newTasks;
        } else {
          tasks.addAll(newTasks);
        }
        if (newTasks.length < _limit) {
          _hasMore = false;
        } else {
          _page++;
        }
        setSuccess();
      },
      errorMessage: I18nKeys.loadTasksFailed.tr,
      onError: () {
        setError(I18nKeys.loadTasksFailed.tr);
      },
      showLoading: true,
    );
    _isLoading = false;
  }
  
  /// 下拉刷新
  Future<void> onRefresh() async {
    await loadTasks(isRefresh: true);
  }
  
  /// 上拉加载更多
  Future<void> onLoadMore() async {
    if (_hasMore && !_isLoading) {
      await loadTasks();
    }
  }
  
  /// 是否还有更多数据
  bool get hasMore => _hasMore;
}
