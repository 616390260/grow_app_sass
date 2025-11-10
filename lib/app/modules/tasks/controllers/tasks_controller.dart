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
    
    try {
      _isLoading = true;
      
      // 如果是刷新操作，重置分页参数
      if (isRefresh) {
        _page = 1;
        _hasMore = true;
      }
      
      // 如果没有更多数据，直接返回
      if (!_hasMore && !isRefresh) {
        return;
      }
      
      setLoading(true);
      
      // 调用API获取任务列表
      final TaskListResponse response = await _taskApiService.getTaskList(
        page: _page,
        limit: _limit,
      );
      print('加载任务列表：$response');
      // 提取任务数据
      final List<RecommendTaskModel> newTasks = response.records ?? [];
      print('新任务列表：$newTasks');
      // 更新任务列表
      if (isRefresh) {
        tasks.value = newTasks;
      } else {
        tasks.addAll(newTasks);
      }
      print('更新后的任务列表：$tasks.length');
      // 更新分页状态
      if (newTasks.length < _limit) {
        _hasMore = false; // 没有更多数据
      } else {
        _page++; // 准备下一页
      }
      
      setSuccess();
    } catch (e) {
      setError('${I18nKeys.loadTasksFailed.tr}: $e');
      showErrorMessage('${I18nKeys.loadTasksFailed.tr}: $e');
    } finally {
      _isLoading = false;
      setLoading(false);
    }
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